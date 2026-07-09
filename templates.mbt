///|
pub fn standard_burn_rules() -> Array[BurnRule] {
  [
    BurnRule::new("fast-5m", Page, 1400),
    BurnRule::new("fast-1h", Page, 600),
    BurnRule::new("slow-6h", Ticket, 300),
    BurnRule::new("slow-24h", Ticket, 100),
  ]
}

///|
pub fn standard_window_names() -> Array[String] {
  ["5m", "1h", "6h", "24h"]
}

///|
pub fn standard_window_minutes() -> Array[Int] {
  [5, 60, 360, 1440]
}
