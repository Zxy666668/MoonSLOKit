///|
pub(all) struct RequestWindow {
  name : String
  minutes : Int
  total : Int
  good : Int
} derive(Eq, Debug)

///|
pub fn RequestWindow::new(
  name : String,
  minutes : Int,
  total : Int,
  good : Int,
) -> RequestWindow {
  {
    name,
    minutes: if minutes > 0 {
      minutes
    } else {
      1
    },
    total: if total > 0 {
      total
    } else {
      0
    },
    good: if good < 0 {
      0
    } else if good > total {
      total
    } else {
      good
    },
  }
}

///|
pub fn RequestWindow::bad(self : RequestWindow) -> Int {
  self.total - self.good
}

///|
pub fn RequestWindow::availability_bp(self : RequestWindow) -> Int {
  if self.total <= 0 {
    10000
  } else {
    self.good * 10000 / self.total
  }
}

///|
pub fn RequestWindow::error_bp(self : RequestWindow) -> Int {
  10000 - self.availability_bp()
}
