///|
pub(all) struct BudgetReport {
  target : SloTarget
  window : RequestWindow
  allowed_bad : Int
  actual_bad : Int
  consumed_bp : Int
  remaining_bad : Int
} derive(Eq, Debug)

///|
pub fn evaluate_budget(
  target : SloTarget,
  window : RequestWindow,
) -> BudgetReport {
  let allowed = window.total * target.allowed_error_bp() / 10000
  let actual = window.bad()
  {
    target,
    window,
    allowed_bad: allowed,
    actual_bad: actual,
    consumed_bp: if allowed <= 0 {
      if actual > 0 {
        10000
      } else {
        0
      }
    } else {
      actual * 10000 / allowed
    },
    remaining_bad: allowed - actual,
  }
}

///|
pub fn BudgetReport::healthy(self : BudgetReport) -> Bool {
  self.actual_bad <= self.allowed_bad
}
