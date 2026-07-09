///|
pub(all) struct TrafficSample {
  minute : Int
  total : Int
  good : Int
} derive(Eq, Debug)

///|
pub fn TrafficSample::new(minute : Int, total : Int, good : Int) -> TrafficSample {
  {
    minute,
    total: if total > 0 { total } else { 0 },
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
pub fn aggregate_samples(
  name : String,
  window_minutes : Int,
  samples : Array[TrafficSample],
) -> RequestWindow {
  let mut total = 0
  let mut good = 0
  for sample in samples {
    total = total + sample.total
    good = good + sample.good
  }
  RequestWindow::new(name, window_minutes, total, good)
}

///|
pub fn aggregate_recent_samples(
  name : String,
  now_minute : Int,
  window_minutes : Int,
  samples : Array[TrafficSample],
) -> RequestWindow {
  let mut total = 0
  let mut good = 0
  let start = now_minute - window_minutes + 1
  for sample in samples {
    if sample.minute >= start && sample.minute <= now_minute {
      total = total + sample.total
      good = good + sample.good
    }
  }
  RequestWindow::new(name, window_minutes, total, good)
}
