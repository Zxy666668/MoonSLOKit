///|
pub fn AlertDecision::level_name(self : AlertDecision) -> String {
  match self.level {
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
