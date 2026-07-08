///|
pub(all) struct MultiWindowReport {
  target : SloTarget
  reports : Array[BurnReport]
  decisions : Array[AlertDecision]
} derive(Eq, Debug)

///|
pub fn evaluate_multi_window(
  target : SloTarget,
  windows : Array[RequestWindow],
  rules : Array[BurnRule],
) -> MultiWindowReport {
  let reports : Array[BurnReport] = []
  let decisions : Array[AlertDecision] = []
  let count = min_int(windows.length(), rules.length())
  for i = 0; i < count; i = i + 1 {
    let report = calculate_burn_rate(target, windows[i])
    reports.push(report)
    decisions.push(evaluate_burn_rule(report, rules[i]))
  }
  { target, reports, decisions }
}

///|
pub fn MultiWindowReport::highest_level(self : MultiWindowReport) -> AlertLevel {
  let mut level = Ok
  for i = 0; i < self.decisions.length(); i = i + 1 {
    if alert_rank(self.decisions[i].level) > alert_rank(level) {
      level = self.decisions[i].level
    }
  }
  level
}

///|
fn alert_rank(level : AlertLevel) -> Int {
  match level {
    Ok => 0
    Ticket => 1
    Page => 2
  }
}

///|
fn min_int(a : Int, b : Int) -> Int {
  if a < b {
    a
  } else {
    b
  }
}
