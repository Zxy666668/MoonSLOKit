///|
pub(all) enum AlertLevel {
  Ok
  Page
  Ticket
} derive(Eq, Debug)

///|
pub(all) struct BurnRule {
  name : String
  level : AlertLevel
  threshold_x100 : Int
} derive(Eq, Debug)

///|
pub fn BurnRule::new(
  name : String,
  level : AlertLevel,
  threshold_x100 : Int,
) -> BurnRule {
  {
    name,
    level,
    threshold_x100: if threshold_x100 > 0 {
      threshold_x100
    } else {
      1
    },
  }
}

///|
pub(all) struct AlertDecision {
  level : AlertLevel
  rule_name : String
  burn_rate_x100 : Int
  reason : String
} derive(Eq, Debug)

///|
pub fn evaluate_burn_rule(
  report : BurnReport,
  rule : BurnRule,
) -> AlertDecision {
  if report.burn_rate_x100 >= rule.threshold_x100 {
    {
      level: rule.level,
      rule_name: rule.name,
      burn_rate_x100: report.burn_rate_x100,
      reason: "threshold_exceeded",
    }
  } else {
    {
      level: Ok,
      rule_name: rule.name,
      burn_rate_x100: report.burn_rate_x100,
      reason: "within_budget",
    }
  }
}

///|
pub fn AlertDecision::is_alert(self : AlertDecision) -> Bool {
  match self.level {
    Ok => false
    _ => true
  }
}
