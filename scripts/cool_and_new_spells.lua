local randomSpellTable = {
					"fireball",
					"fireball",
					"fireball",
					"fireball",
					"spawnhorde",
					"spawnhorde",
					"spawnboss",
					"spawnboss",
					"bats", --annoying,
					"meteorshower",  --overpowered.
}
					
function RandomSpells(_,activator)
	
	local spellToGive = randomSpellTable[math.random(#randomSpellTable)]
	local weapon = activator:GetPlayerItemBySlot(1)
	
	weapon:SetAttributeValue("override projectile type extra", "spell"..spellToGive)
end			  
-- detect when fireballs spawned and check if the caster is using a custom spell
-- if they are, that means this fireball should be overriden with the custom spell's effect
ents.AddCreateCallback("tf_projectile_spellfireball", function(entity)
	timer.Simple(0, function()
		local owner = entity.m_hOwnerEntity

		if not owner or owner.m_iTeamNum ~= 3 then -- not blue, then it doesn't matter.
			return
		end

		local properties = {
			Origin = entity:GetAbsOrigin(),
			Angles = entity:GetAbsAngles()
		}
		CastCustomSpell(owner, entity, properties)
	end)
end)

local starParticleList = { "utaunt_snowflakesaura_parent" , "utaunt_spirits_blue_parent" , "utaunt_snowring_icy_parent" , "utaunt_spirits_purple_parent" }

function CastCustomSpell(bot, spell, properties)
	if bot:GetAttributeValue("cannot giftwrap") == 1 then	-- Starlight Sorcerer
		StarlightSpell(bot,properties)
		spell:Remove()
	end
	if bot:GetAttributeValue("throwable fire speed") == 1 then -- Gun Wizard
		GiveGun(bot)
		spell:Remove()
	end
	if bot:GetAttributeValue("throwable fire speed") == 2 then -- Gun Wizard 2
		YeetRocket(bot,properties)
		spell:Remove()
	end
	if bot:GetAttributeValue("throwable damage") == 1 then -- Visibility Enchanter
		BecomeVisible(bot)
		spell:Remove()
	end
end

function StarlightSpell(bot,properties)
	local starParticle = ents.CreateWithKeys("info_particle_system", {
		effect_name = starParticleList[math.random(#starParticleList)],
		start_active = 1,
		flag_as_weather = 0,
	}, true, true)
	
	starParticle:SetAbsOrigin(properties.Origin)
	starParticle:Start()
	timer.Simple(4, function()
		starParticle:Remove()
	end)
end

function GiveGun(bot)
	local attribTable = {}
	attribTable["damage bonus"] = 1.25
	bot:GiveItem("Upgradeable TF_WEAPON_MINIGUN", attribTable)
end

local function weaponMimic(properties)
	local mimic = Entity("tf_point_weapon_mimic")
	mimic:SetAbsOrigin(properties.Origin)
	mimic:SetAbsAngles(properties.Angles)

	return mimic
end

function YeetRocket(bot, projectileProperties)
	local mimic = ents.FindByName("rocket_throw_mimic")
	mimic:AcceptInput("FireOnce")
end

function BecomeVisible(bot)
	bot:RemoveCond(66)
end