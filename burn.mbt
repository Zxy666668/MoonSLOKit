///|
pub(all) struct BurnReport {
  window : RequestWindow
  allowed_error_bp : Int
  observed_error_bp : Int
  burn_rate_x100 : Int
} derive(Eq, Debug)

///|
pub fn calculate_burn_rate(
  target : SloTarget,
  window : RequestWindow,
) -> BurnReport {
  let allowed = target.allowed_error_bp()
  let observed = window.error_bp()
  {
    window,
    allowed_error_bp: allowed,
    observed_error_bp: observed,
    burn_rate_x100: if allowed <= 0 {
      if observed > 0 {
        1_000_000
      } else {
        0
      }
    } else {
      observed * 100 / allowed
    },
  }
}

///|
pub fn BurnReport::rate_label(self : BurnReport) -> String {
  "\{self.burn_rate_x100 / 100}.\{two_digits(self.burn_rate_x100 % 100)}x"
}

///|
fn two_digits(value : Int) -> String {
  if value < 10 {
    "0\{value}"
  } else {
    value.to_string()
  }
}
