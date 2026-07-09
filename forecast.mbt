///|
pub(all) struct BudgetForecast {
  report : BudgetReport
  lookback_minutes : Int
  bad_per_hour_x100 : Int
  minutes_to_exhaustion : Int
  state : String
} derive(Eq, Debug)

///|
pub fn forecast_budget(
  target : SloTarget,
  window : RequestWindow,
  lookback_minutes : Int,
) -> BudgetForecast {
  let report = evaluate_budget(target, window)
  let lookback = if lookback_minutes > 0 { lookback_minutes } else { window.minutes }
  let bad_per_hour_x100 = if lookback <= 0 {
    0
  } else {
    report.actual_bad * 60 * 100 / lookback
  }
  let minutes_to_exhaustion = if report.remaining_bad <= 0 {
    0
  } else if bad_per_hour_x100 <= 0 {
    2147483647
  } else {
    report.remaining_bad * 60 * 100 / bad_per_hour_x100
  }
  {
    report,
    lookback_minutes: lookback,
    bad_per_hour_x100,
    minutes_to_exhaustion,
    state: if report.remaining_bad < 0 {
      "exhausted"
    } else if minutes_to_exhaustion <= 60 {
      "critical"
    } else {
      "tracking"
    },
  }
}

///|
pub fn BudgetForecast::exhausted(self : BudgetForecast) -> Bool {
  self.state == "exhausted"
}
