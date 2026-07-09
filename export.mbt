///|
pub fn AlertDecision::level_name(self : AlertDecision) -> String {
  self.level.name()
}

///|
pub fn AlertLevel::name(self : AlertLevel) -> String {
  match self {
    Ok => "ok"
    Page => "page"
    Ticket => "ticket"
  }
}

///|
pub fn BudgetReport::to_json(self : BudgetReport) -> String {
  "{\"target\":\"\{escape_json(self.target.name)}\",\"window\":\"\{escape_json(self.window.name)}\",\"allowed_bad\":\{self.allowed_bad},\"actual_bad\":\{self.actual_bad},\"consumed_bp\":\{self.consumed_bp},\"remaining_bad\":\{self.remaining_bad}}"
}

///|
pub fn AlertDecision::to_json(self : AlertDecision) -> String {
  "{\"level\":\"\{self.level_name()}\",\"rule\":\"\{escape_json(self.rule_name)}\",\"burn_rate_x100\":\{self.burn_rate_x100},\"reason\":\"\{escape_json(self.reason)}\"}"
}

///|
pub fn BudgetForecast::to_json(self : BudgetForecast) -> String {
  "{\"target\":\"\{escape_json(self.report.target.name)}\",\"window\":\"\{escape_json(self.report.window.name)}\",\"bad_per_hour_x100\":\{self.bad_per_hour_x100},\"minutes_to_exhaustion\":\{self.minutes_to_exhaustion},\"state\":\"\{escape_json(self.state)}\"}"
}

///|
pub fn GateDecision::to_json(self : GateDecision) -> String {
  "{\"gate\":\"\{escape_json(self.gate_name)}\",\"allowed\":\{self.allowed},\"reason\":\"\{escape_json(self.reason)}\",\"consumed_bp\":\{self.consumed_bp},\"level\":\"\{self.highest_level.name()}\"}"
}

///|
pub fn ServiceEvaluation::to_json(self : ServiceEvaluation) -> String {
  "{\"service\":\"\{escape_json(self.service)}\",\"target\":\"\{escape_json(self.target_name)}\",\"healthy\":\{self.healthy()},\"gate\":\{self.gate.to_json()}}"
}

///|
pub fn SloAnnotation::to_json(self : SloAnnotation) -> String {
  "{\"minute\":\{self.minute},\"kind\":\"\{escape_json(self.kind)}\",\"message\":\"\{escape_json(self.message)}\"}"
}

///|
fn escape_json(text : String) -> String {
  let buf = StringBuilder(size_hint=text.length() + 8)
  for i = 0; i < text.length(); i = i + 1 {
    let ch = text[i]
    if ch == '"' {
      buf.write_string("\\\"")
    } else if ch == '\\' {
      buf.write_string("\\\\")
    } else {
      buf.write_string(text[i:i + 1].to_owned())
    }
  }
  buf.to_string()
}
