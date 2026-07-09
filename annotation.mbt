///|
pub(all) struct SloAnnotation {
  minute : Int
  kind : String
  message : String
} derive(Eq, Debug)

///|
pub fn SloAnnotation::new(
  minute : Int,
  kind : String,
  message : String,
) -> SloAnnotation {
  { minute, kind, message }
}

///|
pub(all) struct AnnotatedWindow {
  window : RequestWindow
  annotations : Array[SloAnnotation]
} derive(Eq, Debug)

///|
pub fn annotate_window(
  window : RequestWindow,
  start_minute : Int,
  annotations : Array[SloAnnotation],
) -> AnnotatedWindow {
  let selected : Array[SloAnnotation] = []
  let end_minute = start_minute + window.minutes - 1
  for annotation in annotations {
    if annotation.minute >= start_minute && annotation.minute <= end_minute {
      selected.push(annotation)
    }
  }
  { window, annotations: selected }
}

///|
pub fn AnnotatedWindow::has_kind(self : AnnotatedWindow, kind : String) -> Bool {
  for annotation in self.annotations {
    if annotation.kind == kind {
      return true
    }
  }
  false
}
