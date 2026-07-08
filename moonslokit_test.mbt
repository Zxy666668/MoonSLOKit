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
