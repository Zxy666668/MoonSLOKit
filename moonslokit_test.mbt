///|
test "slo target clamps basis points" {
  let target = SloTarget::new("api", 9990, 30 * 24 * 60)
  assert_eq(target.target_bp, 9990)
  assert_eq(target.allowed_error_bp(), 10)
}

///|
test "request window computes availability" {
  let window = RequestWindow::new("5m", 5, 1000, 998)
  assert_eq(window.bad(), 2)
  assert_eq(window.availability_bp(), 9980)
  assert_eq(window.error_bp(), 20)
}

///|
test "budget report measures consumed error budget" {
  let target = SloTarget::new("checkout", 9900, 30)
  let window = RequestWindow::new("30m", 30, 10000, 9950)
  let report = evaluate_budget(target, window)
  assert_eq(report.allowed_bad, 100)
  assert_eq(report.actual_bad, 50)
  assert_eq(report.consumed_bp, 5000)
  assert_true(report.healthy())
}

///|
test "burn rate compares observed and allowed error" {
  let target = SloTarget::new("search", 9900, 30)
  let window = RequestWindow::new("5m", 5, 1000, 980)
  let report = calculate_burn_rate(target, window)
  assert_eq(report.allowed_error_bp, 100)
  assert_eq(report.observed_error_bp, 200)
  assert_eq(report.burn_rate_x100, 200)
  assert_eq(report.rate_label(), "2.00x")
}

///|
test "burn rule turns high burn rate into alert decision" {
  let target = SloTarget::new("api", 9900, 30)
  let report = calculate_burn_rate(
    target,
    RequestWindow::new("5m", 5, 1000, 980),
  )
  let decision = evaluate_burn_rule(
    report,
    BurnRule::new("fast-burn", Page, 150),
  )
  assert_true(decision.is_alert())
  assert_eq(decision.reason, "threshold_exceeded")
}

///|
test "multi window report keeps highest alert level" {
  let target = SloTarget::new("api", 9900, 30)
  let report = evaluate_multi_window(
    target,
    [
      RequestWindow::new("5m", 5, 1000, 980),
      RequestWindow::new("1h", 60, 10000, 9985),
    ],
    [BurnRule::new("fast", Page, 150), BurnRule::new("slow", Ticket, 100)],
  )
  assert_eq(report.decisions.length(), 2)
  assert_true(report.highest_level() == Page)
}

///|
test "json exports budget and alert decisions" {
  let target = SloTarget::new("api", 9900, 30)
  let budget = evaluate_budget(
    target,
    RequestWindow::new("30m", 30, 10000, 9950),
  )
  let alert = evaluate_burn_rule(
    calculate_burn_rate(target, RequestWindow::new("5m", 5, 1000, 980)),
    BurnRule::new("fast", Page, 150),
  )
  assert_true(budget.to_json().contains("\"consumed_bp\":5000"))
  assert_true(alert.to_json().contains("\"level\":\"page\""))
}

///|
test "alert level names are stable" {
  let alert = AlertDecision::{
    level: Ticket,
    rule_name: "slow",
    burn_rate_x100: 120,
    reason: "threshold_exceeded",
  }
  assert_eq(alert.level_name(), "ticket")
}

///|
test "traffic samples aggregate into request windows" {
  let window = aggregate_samples("10m", 10, [
    TrafficSample::new(1, 100, 99),
    TrafficSample::new(2, 200, 190),
    TrafficSample::new(3, 50, 50),
  ])
  assert_eq(window.total, 350)
  assert_eq(window.good, 339)
  assert_eq(window.bad(), 11)
}

///|
test "recent sample aggregation filters by minute" {
  let window = aggregate_recent_samples("5m", 10, 5, [
    TrafficSample::new(1, 100, 50),
    TrafficSample::new(6, 100, 99),
    TrafficSample::new(10, 100, 95),
  ])
  assert_eq(window.total, 200)
  assert_eq(window.good, 194)
}

///|
test "standard burn templates expose four windows" {
  assert_eq(standard_burn_rules().length(), 4)
  assert_eq(standard_window_names()[0], "5m")
  assert_eq(standard_window_minutes()[3], 1440)
}

///|
test "budget forecast estimates exhaustion time" {
  let target = SloTarget::new("api", 9900, 60)
  let forecast = forecast_budget(
    target,
    RequestWindow::new("30m", 30, 10000, 9950),
    30,
  )
  assert_eq(forecast.report.remaining_bad, 50)
  assert_eq(forecast.bad_per_hour_x100, 10000)
  assert_eq(forecast.minutes_to_exhaustion, 30)
  assert_eq(forecast.state, "critical")
}

///|
test "budget forecast marks exhausted budget" {
  let forecast = forecast_budget(
    SloTarget::new("api", 9900, 60),
    RequestWindow::new("30m", 30, 10000, 9800),
    30,
  )
  assert_true(forecast.exhausted())
}

///|
test "release gate blocks active page alerts" {
  let target = SloTarget::new("api", 9900, 60)
  let budget = evaluate_budget(
    target,
    RequestWindow::new("1h", 60, 10000, 9950),
  )
  let multi = evaluate_multi_window(
    target,
    [RequestWindow::new("5m", 5, 1000, 970)],
    [BurnRule::new("fast", Page, 200)],
  )
  let decision = evaluate_release_gate(
    ReleaseGate::new("prod", 8000, true),
    budget,
    multi,
  )
  assert_false(decision.allowed)
  assert_eq(decision.reason, "page_alert_active")
}

///|
test "release gate blocks high budget consumption" {
  let target = SloTarget::new("api", 9900, 60)
  let budget = evaluate_budget(
    target,
    RequestWindow::new("1h", 60, 10000, 9900),
  )
  let multi = evaluate_multi_window(target, [], [])
  let decision = evaluate_release_gate(
    ReleaseGate::new("prod", 5000, true),
    budget,
    multi,
  )
  assert_false(decision.allowed)
  assert_eq(decision.reason, "budget_consumed_too_high")
}

///|
test "service objective evaluates budget burn and gate together" {
  let objective = ServiceObjective::new(
    "checkout",
    SloTarget::new("availability", 9900, 30),
    [BurnRule::new("fast", Page, 500)],
  )
  let result = evaluate_service_objective(
    objective,
    RequestWindow::new("30m", 30, 10000, 9990),
    [RequestWindow::new("5m", 5, 1000, 999)],
    ReleaseGate::new("prod", 8000, true),
  )
  assert_eq(result.service, "checkout")
  assert_true(result.healthy())
}

///|
test "annotated windows select events inside window range" {
  let annotated = annotate_window(RequestWindow::new("5m", 5, 1000, 990), 10, [
    SloAnnotation::new(9, "deploy", "before"),
    SloAnnotation::new(12, "incident", "database errors"),
    SloAnnotation::new(20, "deploy", "after"),
  ])
  assert_eq(annotated.annotations.length(), 1)
  assert_true(annotated.has_kind("incident"))
  assert_false(annotated.has_kind("deploy"))
}

///|
test "extended json exports include forecast gate service and annotation" {
  let target = SloTarget::new("api", 9900, 60)
  let forecast = forecast_budget(
    target,
    RequestWindow::new("30m", 30, 10000, 9950),
    30,
  )
  let objective = ServiceObjective::new("api", target, [
    BurnRule::new("fast", Page, 500),
  ])
  let service = evaluate_service_objective(
    objective,
    RequestWindow::new("30m", 30, 10000, 9990),
    [RequestWindow::new("5m", 5, 1000, 999)],
    ReleaseGate::new("prod", 8000, true),
  )
  assert_true(forecast.to_json().contains("\"state\":\"critical\""))
  assert_true(service.to_json().contains("\"service\":\"api\""))
  assert_true(
    SloAnnotation::new(10, "deploy", "v2")
    .to_json()
    .contains("\"kind\":\"deploy\""),
  )
}
