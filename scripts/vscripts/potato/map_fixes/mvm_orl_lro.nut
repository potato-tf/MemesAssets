// mvm_orl_lro.bsp
function RunOnce() {
	for (local e; e = Entities.FindByClassname(e, "env_fog_controller");)
		NetProps.SetPropFloat(e, "m_fog.farz", -1.0)
}

Events <- {
	function OnGameEvent_recalculate_holidays(_) {
		if (GetRoundState() != Constants.ERoundState.GR_STATE_PREROUND) return
		RegisterFix("Fixed FarZ clip plane void being visible through fog.")
	}
}
