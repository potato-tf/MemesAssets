// Enables the unused cash expiration sound, mvm/mvm_money_vanish.wav.
if ("CashExpireSoundEvents" in getroottable()) return

const TF_POWERUP_LIFETIME = 30.0

::CashExpireSoundEvents <-  {
	worldspawn = Entities.First()

	function OnGameEvent_player_death(event) {
		if (!GetPlayerFromUserID(event.userid).IsBotOfType(Constants.EBotType.TF_BOT_TYPE))
			return

		for (local cash, scope; cash = Entities.FindByClassname(cash, "item_currencypack_custom");) {
			// Checking for scope like this is probably faster with many cash drops instead
			//  of always validating.
			scope = cash.GetScriptScope()
			if (scope && "CashExpireSound" in scope)
				// Can't be this pack that just dropped since it has already been marked.
				continue

			cash.ValidateScriptScope()
			scope = cash.GetScriptScope()

			scope.CashExpireStorePos <- function() {
				CashExpireStoredPos = self.GetOrigin()
			}
			scope.CashExpireStoredPos <- null

			scope.CashExpireSound <- function() {
				// EmitSoundOn/EmitSound doesn't work as cash is killed at this time.
				EmitSoundEx({
					sound_name = "MVM.MoneyVanish"
					origin = CashExpireStoredPos
				})
			}

			if (NetProps.GetPropBool(cash, "m_bDistributed"))
				// Don't play sound for red money.
				return

			// Store cash pos to play sound at on death.
			EntFireByHandle(cash,
				"CallScriptFunction", "CashExpireStorePos",
			5.0, null, null)

			EntFireByHandle(cash,
				"CallScriptFunction", "CashExpireSound",
			TF_POWERUP_LIFETIME, null, null)
			return
		}
	}

	function OnGameEvent_npc_hurt(event) {
		if (event.health - event.damageamount > 0) return
		local npc = EntIndexToHScript(event.entindex)
		if (npc.GetClassname() != "tank_boss") return

		// Need to delay as packs have not spawned yet.
		EntFireByHandle(worldspawn,
			"CallScriptFunction", "CashExpireTankDead",
		-1.0, null, null)
	}
}
::CashExpireTankDead <- function() {
	for (local cash, scope; cash = Entities.FindByClassname(cash, "item_currencypack_custom");) {
		// Assume there are many packs that have not been marked after tank death.
		cash.ValidateScriptScope()
		scope = cash.GetScriptScope()
		if ("CashExpireSound" in scope) continue
		scope.CashExpireSound <- function() {
			self.EmitSound("MVM.MoneyVanish")
			self.Kill()
		}

		// Can't get this to fire as the pack dies for tanks so we
		//  just kill them 0.1s earlier lol.
		EntFireByHandle(cash,
			"CallScriptFunction", "CashExpireSound",
		TF_POWERUP_LIFETIME - 0.1, null, null)
		// No early return as tanks drop many packs.
	}
}
__CollectGameEventCallbacks(::CashExpireSoundEvents)

// Game already precaches this.
//PrecacheSoundScript("MVM.MoneyVanish")
