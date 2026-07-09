///|
pub(all) struct ServiceObjective {
  service : String
  target : SloTarget
  burn_rules : Array[BurnRule]
} derive(Eq, Debug)

///|
pub fn ServiceObjective::new(
  service : String,
  target : SloTarget,
  burn_rules : Array[BurnRule],
) -> ServiceObjective {
  { service, target, burn_rules }
}

///|
pub(all) struct ServiceEvaluation {
  service : String
  target_name : String
  budget : BudgetReport
  multi_window : MultiWindowReport
  gate : GateDecision
} derive(Eq, Debug)

///|
pub fn evaluate_service_objective(
  objective : ServiceObjective,
  budget_window : RequestWindow,
  burn_windows : Array[RequestWindow],
  gate : ReleaseGate,
) -> ServiceEvaluation {
  let budget = evaluate_budget(objective.target, budget_window)
  let multi = evaluate_multi_window(
    objective.target,
    burn_windows,
    objective.burn_rules,
  )
  {
    service: objective.service,
    target_name: objective.target.name,
    budget,
    multi_window: multi,
    gate: evaluate_release_gate(gate, budget, multi),
  }
}

///|
pub fn ServiceEvaluation::healthy(self : ServiceEvaluation) -> Bool {
  self.gate.allowed && self.multi_window.highest_level() == Ok && self.budget.healthy()
}
