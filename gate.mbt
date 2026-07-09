///|
pub(all) struct ReleaseGate {
  name : String
  max_consumed_bp : Int
  allow_ticket : Bool
} derive(Eq, Debug)

///|
pub fn ReleaseGate::new(
  name : String,
  max_consumed_bp : Int,
  allow_ticket : Bool,
) -> ReleaseGate {
  { name, max_consumed_bp: clamp_gate_bp(max_consumed_bp), allow_ticket }
}

///|
pub(all) struct GateDecision {
  gate_name : String
  allowed : Bool
  reason : String
  consumed_bp : Int
  highest_level : AlertLevel
} derive(Eq, Debug)

///|
pub fn evaluate_release_gate(
  gate : ReleaseGate,
  budget : BudgetReport,
  report : MultiWindowReport,
) -> GateDecision {
  let level = report.highest_level()
  if budget.consumed_bp > gate.max_consumed_bp {
    {
      gate_name: gate.name,
      allowed: false,
      reason: "budget_consumed_too_high",
      consumed_bp: budget.consumed_bp,
      highest_level: level,
    }
  } else if level == Page {
    {
      gate_name: gate.name,
      allowed: false,
      reason: "page_alert_active",
      consumed_bp: budget.consumed_bp,
      highest_level: level,
    }
  } else if level == Ticket && !gate.allow_ticket {
    {
      gate_name: gate.name,
      allowed: false,
      reason: "ticket_alert_blocked",
      consumed_bp: budget.consumed_bp,
      highest_level: level,
    }
  } else {
    {
      gate_name: gate.name,
      allowed: true,
      reason: "release_allowed",
      consumed_bp: budget.consumed_bp,
      highest_level: level,
    }
  }
}

///|
fn clamp_gate_bp(value : Int) -> Int {
  if value < 0 {
    0
  } else if value > 10000 {
    10000
  } else {
    value
  }
}
