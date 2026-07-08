///|
pub(all) struct SloTarget {
  name : String
  target_bp : Int
  period_minutes : Int
} derive(Eq, Debug)

///|
pub fn SloTarget::new(
  name : String,
  target_bp : Int,
  period_minutes : Int,
) -> SloTarget {
  {
    name,
    target_bp: clamp_bp(target_bp),
    period_minutes: if period_minutes > 0 {
      period_minutes
    } else {
      1
    },
  }
}

///|
pub fn SloTarget::allowed_error_bp(self : SloTarget) -> Int {
  10000 - self.target_bp
}

///|
fn clamp_bp(value : Int) -> Int {
  if value < 0 {
    0
  } else if value > 10000 {
    10000
  } else {
    value
  }
}
