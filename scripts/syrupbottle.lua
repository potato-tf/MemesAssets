local classIndices_Internal = {
	[1] = "Scout",
	[3] = "Soldier",
	[7] = "Pyro",
	[4] = "Demo", --was "demoman"
	[6] = "Heavy",
	[9] = "Engineer",
	[5] = "Medic",
	[2] = "Sniper",
	[8] = "Spy",
}

local CUSTOM_WEAPONS_INDICES = { "Gambler", "Thumper" }

local callbacks = {}
for _, weaponIndex in pairs(CUSTOM_WEAPONS_INDICES) do
	callbacks[weaponIndex] = {}
end

function ClearCallbacks(index, activator, handle)
	handle = handle or activator:GetHandleIndex()

	local weaponCallbacks = callbacks[index][handle]

	if not weaponCallbacks then
		return
	end

	if activator and IsValid(activator) then
		for _, callbackId in pairs(weaponCallbacks) do
			activator:RemoveCallback(callbackId)
		end
	end

	callbacks[index][handle] = nil
end

local banners = {
	[1] = "The Buff Banner",
	[2] = "The Battalion's Backup",
	[3] = "The Concheror",
}
local bannerShort = {
	[1] = "Buff",
	[2] = "Backup",
	[3] = "Conch",
}
function RandomBannerBot(_, activator)
	local randomClass = classIndices_Internal[math.random(#classIndices_Internal)]
	local randomBanner = math.random(1,3)
	activator:SwitchClassInPlace(randomClass)
	timer.Simple(0.1, function ()
		--Give random banner, idc about attribs, ignore existing item in slot, ignore class diff
		activator:GiveItem(banners[randomBanner])
		activator.m_flRageMeter = 100 --Sets rage to 100% just in case
		--Icon, name, and proper robot model
		activator.m_iszClassIcon = "soldier_banner_trio"
		activator.m_szNetname = bannerShort[randomBanner].." "..randomClass
		activator:SetCustomModelWithClassAnimations("models/bots/"..randomClass.."/bot_"..randomClass..".mdl")
	end)
end

---------------
-- Taunt wave--
---------------
function ScoutRandNoise(tankName, activator)
	local scoot = ents.FindByName(tankName)
	local scootTable = { "07" , "08" , "09" , "10", "12" , "18" , "19" , "21" , "23" , "31" , "32" , "33" , "34" , "35" }
	scoot:PlaySound("=85|vo/taunts/scout/scout_motorcycle_"..scootTable[math.random(#scootTable)]..".wav")
end

function EngieRandNoise(tankName, activator)
	local engie = ents.FindByName(tankName)
	local engieTable = { "cheers01", "cheers02", "cheers07", "battlecry05", "battlecry06", "battlecry07", }
	engie:PlaySound("=85|vo/engineer_"..engieTable[math.random(#engieTable)]..".mp3")
end

function SpyRandNoise(tankName, activator)
	local theSpy = ents.FindByName(tankName)
	local spyTable = { "01", "02", "07", "09", "12", "13" }
	theSpy:PlaySound("=85|vo/taunts/spy/spy_taunt_flip_fun_"..spyTable[math.random(#spyTable)]..".mp3")
end

function DemoRandNoise(tankName, activator)
	local demo = ents.FindByName(tankName)
	local demoTable = { "long01", "long02", "happy01", "happy02", "evil02" }
	demo:PlaySound("=85|vo/demoman_laugh"..demoTable[math.random(#demoTable)]..".mp3")
end

function SoldierRandNoise(tankName, activator)
	local solly = ents.FindByName(tankName)
	local sollyTable = { "04", "06" , "08" }
	solly:PlaySound("=85|vo/taunts/soldier_taunt_flip_fun_"..sollyTable[math.random(#sollyTable)]..".mp3")
end

function CannonSmoke(_, activator)
	util.ParticleEffect("muzzle_grenadelauncher", nil, Vector(90, 0, 0), activator) --Has to look down
end

------------------
--Incorrect wave--
------------------
function PogOnKill(_, activator)
	activator:RunScriptCode("Say(self,`pog champ`,false)")
end


-----------------
--Infinity wave--
-----------------

local wavebar = ents.FindByClass("tf_objective_resource")

function RandomWaveBar()
	local randomAmt = math.random(999) --max = 999
	local randomWave = math.random(69) --max = 69
	local randomMaxWave = randomWave + math.random(69) --max = 138
	wavebar:SetFakeSendProp("m_nMannVsMachineWaveClassCounts$0", randomAmt)
	wavebar:SetFakeSendProp("m_nMannVsMachineWaveEnemyCount", randomAmt + 19)
	
	timer.Simple(0.4, function()
		wavebar:SetFakeSendProp("m_nMannVsMachineWaveCount", randomWave)
	end)
	
	timer.Simple(0.8, function()
		wavebar:SetFakeSendProp("m_nMannVsMachineMaxWaveCount", randomMaxWave)
	end)
end

function ResetWaveBar(enemyCount)
	timer.Simple(0.9, function()
		wavebar:SetFakeSendProp("m_nMannVsMachineWaveEnemyCount", enemyCount)
		wavebar:SetFakeSendProp("m_nMannVsMachineWaveCount", 1)
		wavebar:SetFakeSendProp("m_nMannVsMachineMaxWaveCount", 0)
	end)
end

--Copy of rollback + chat message function from Dover
local rollbacks = {}

local CLASSES = {"player", "obj_*"}

local function storeRollback()
	rollbacks = {}

	for _, class in pairs(CLASSES) do
		for _, ent in pairs(ents.FindAllByClass(class)) do
			if not ent:IsCombatCharacter() then
				goto continue
			end

			if ent.m_iTeamNum ~= 2 then
				goto continue
			end

			rollbacks[ent] = {
				Origin = ent:GetAbsOrigin(), --+ Vector(0, 0, 0),
				Angles = ent:GetAbsAngles(),
				IsPlayer = class == "player" and true
			}

			::continue::
		end
	end
end

local function playSoundToAll(sound)
	for _, player in pairs(ents.GetAllPlayers()) do
		player:PlaySoundToSelf(sound)
	end
end

local function fade()
	local fadeEnt = Entity("env_fade", true)
	local properties = {
		holdtime = 1,
		duration = 0.5,
		rendercolor = "240, 80, 80",
		renderamt = 255
	}

	for name, value in pairs(properties) do
		fadeEnt:AcceptInput("$SetKey$"..name, value)
	end

	fadeEnt.Fade(fadeEnt)

	timer.Simple(1, function ()
		fadeEnt:Remove()
	end)
end

local function revertRollback()
	playSoundToAll("=35|replay/enterperformancemode.wav")
	
	fade()
	
	timer.Simple(0.6, function ()
		for _, player in pairs(ents.GetAllPlayers()) do
			if not player:IsRealPlayer() then
				goto continue
			end

			player:ForceRespawn()

			::continue::
		end

		for ent, data in pairs(rollbacks) do
			if not IsValid(ent) or not ent:IsAlive() then
				goto continue
			end
			
			if data.IsPlayer then
				ent:SetAbsOrigin(data.Origin)

				ent:SnapEyeAngles(data.Angles)
			else
				ent:Teleport(data.Origin, data.Angles)
			end
			
			::continue::
		end
		
		for _, door in pairs(ents.FindAllByClass("func_door")) do --Prevent players from getting stuck in doors
			door.Open()
		end
	end)
	timer.Simple(1, function()
		playSoundToAll("=35|replay/exitperformancemode.wav")
	end)	
end

local function chatMessage(string)
	local message = "{blue}"
	.. "Time-Unconstraint{reset} : "
	.. string

	local allPlayers = ents.GetAllPlayers()
	for _, player in pairs(allPlayers) do
		player:AcceptInput("$DisplayTextChat", message)
	end

end

function InitialWaveTalk()
	chatMessage("Ah, time-bound mercenaries.")
	timer.Simple(1.5, function()
		chatMessage("You look like fun things to play with.")
	end)
	timer.Simple(3, function()
		chatMessage("...not particularly strong, though. Oh well.")
	end)
end

function WaveStart()
	storeRollback()
	chatMessage("I'll just grab a few bots from the past. They'll deal with you nicely.")
end

local function WaveBarSpammer()
	wavebar:SetFakeSendProp("m_nMannVsMachineWaveEnemyCount", 1)
	wavebar:SetFakeSendProp("m_nMannVsMachineWaveClassCounts$0", 1)
	wavebar:SetFakeSendProp("m_szMannVsMachineWaveClassFlags$0", 9)
	wavebar:SetFakeSendProp("m_szMannVsMachineWaveClassNames$0", "soldier_spammer")
end

function Spammer1()
	chatMessage("Interesting.")
	timer.Simple(1.5, function()
		chatMessage("You might actually have some fight left in you, eh?")
	end)
	timer.Simple(3, function()
		chatMessage("Let's roll it back with something new.")
		revertRollback()
	end)
	timer.Simple(4, function()
		WaveBarSpammer()
	end)
end
function Spammer2()
	chatMessage("Encore! What a boss, truly!")
	timer.Simple(2.5, function()
		chatMessage("So, how about a phase 2?")
		revertRollback()
	end)
	timer.Simple(3.5, function()
		WaveBarSpammer()
	end)
end
function Spammer3()
	chatMessage("It's even better the second time!")
	timer.Simple(2.5, function()
		chatMessage("Let's do it thrice for good measure.")
		revertRollback()
	end)
	timer.Simple(3.5, function()
		WaveBarSpammer()
	end)
end
function Unconstraint()
	chatMessage("What a pity! You've really punched a hole in my boundless sack of foes.")
	timer.Simple(2.5, function()
		chatMessage("I suppose I'll just send YOU back in time for a bit.")
	end)
	timer.Simple(4.5, function()
		chatMessage("I'm sure you all recall this old classic, from 1999...")
	end)
end


------------------
--Half-Life wave--
------------------
local HLWaveActive = nil

function OnWaveInit(wave)		
	wavebar:ResetFakeSendProp("m_nMannVsMachineWaveEnemyCount")
	wavebar:ResetFakeSendProp("m_nMannVsMachineWaveClassCounts$0")
	wavebar:ResetFakeSendProp("m_szMannVsMachineWaveClassFlags$0")
	wavebar:ResetFakeSendProp("m_nMannVsMachineWaveCount")
	wavebar:ResetFakeSendProp("m_nMannVsMachineMaxWaveCount")
	if wave ~= 5 then
		HLWaveActive = nil
	else 
		HLWaveActive = true
	end
end

callbacks.HL = {}
			
local invalidClasses = {
	[4] = "Demo", --was "demoman"
	[6] = "Heavy",
	[5] = "Medic",
	[8] = "Spy",
}
local validClasses = {
	"Scout",
	"Soldier",
	"Pyro",
	"Engineer",
	"Sniper",
}
local numToClassId = {
	[1] = "Scout",
	[3] = "Soldier",
	[7] = "Pyro",
	[9] = "Engineer",
	[2] = "Sniper",
}

function StartHLWave()
	local allPlayers = ents.GetAllPlayers()
	for _,player in pairs(allPlayers) do
		
		if player.m_iTeamNum == 2 then
			local handle = player:GetHandleIndex()
			
			callbacks.HL[handle] = {}
			
			local HLWeaponCallbacks = callbacks.HL[handle]
			
			HLWeaponCallbacks.spawned = player:AddCallback(ON_SPAWN, function()
				if HLWaveActive then
					PlayerSpawnHLWave(player)
				else
					player:ResetExtraItems()
					ClearCallbacks("HL", player, handle)
				end
			end)
			
			HLWeaponCallbacks.removed = player:AddCallback(ON_REMOVE, function()
				ClearCallbacks("HL", player, handle)
			end)
			
			player:ForceRespawn()
		end
	end
	
end

function PlayerSpawnHLWave(player)
	for classNum,class in pairs(invalidClasses) do
		if player.m_iClass == classNum then
			player:SwitchClassInPlace(validClasses[math.random(#validClasses)])
			break
		end
	end
	timer.Simple(0.5, function()
		
		local playerClass = player.m_iClass
		if classIndices_Internal[playerClass] == "Scout" then
			player:AwardExtraItem("Overcharged Magnum")
			player:GiveItem("Overcharged Magnum")
			
			player:AwardExtraItem("Overcharged Gamma Gazer")
			player:GiveItem("Overcharged Gamma Gazer")
			
		elseif classIndices_Internal[playerClass] == "Soldier" then
			player:AwardExtraItem("Overcharged RPG")
			player:GiveItem("Overcharged RPG")
			
			player:AwardExtraItem("Overcharged Thumper")
			player:GiveItem("Overcharged Thumper")
			
		elseif classIndices_Internal[playerClass] == "Pyro" then
			player:AwardExtraItem("Overcharged Gluon Gun")
			player:GiveItem("Overcharged Gluon Gun")
			
			player:AwardExtraItem("Overcharged Thumper")
			player:GiveItem("Overcharged Thumper")
			
		elseif classIndices_Internal[playerClass] == "Engineer" then
			player:AwardExtraItem("Overcharged Thumper")
			player:GiveItem("Overcharged Thumper")
			
			player:AwardExtraItem("Overcharged Magnum")
			player:GiveItem("Overcharged Magnum")
			
			player:WeaponStripSlot(3)
			player:WeaponStripSlot(4)
			
		elseif classIndices_Internal[playerClass] == "Sniper" then
			player:WeaponStripSlot(0)
			player:WeaponSwitchSlot(1)
			
			player:AwardExtraItem("Overcharged SAW")
			player:GiveItem("Overcharged SAW")
		end
		
		player:AwardExtraItem("Overcharged Crate Smasher")
		player:GiveItem("Overcharged Crate Smasher")
	end)
end

------------------
--Objective wave--
------------------
local cap_tp_cooldown = nil
local cap_chief_bot = nil
local unuber = nil

function OnWaveSpawnBot(bot, _, tags)
	for _, tag in pairs(tags) do
		if tag == "bot_capchief" then
			cap_chief_bot = bot
			playSoundToAll("vo/mvm/demoman_mvm_specialcompleted05")
		end
	end
end

function TeleportBot(bot, target)
	bot:TeleportToEntity(target)
	bot:PlaySound("mvm/mvm_tele_deliver.wav")
	util.ParticleEffect("teleported_blue", bot:GetAbsOrigin(), Vector(0, 0, 0))
	util.ParticleEffect("teleportedin_blue", target:GetAbsOrigin(), Vector(0, 0, 0))
end

function CapChiefTeleport(_, caparea)
	if cap_tp_cooldown then
		return
	end
	
	cap_tp_cooldown = true
	
	timer.Simple(20, function()
		cap_tp_cooldown = nil
	end)
	
	TeleportBot(cap_chief_bot, caparea)
end

local pointsCapped = 0
function CapChiefPhase2()
	pointsCapped = pointsCapped + 1
	util.PrintToChatAll("test for phase 2!")
	unuber = ents.FindByName("cap_unuber_relay")
	if pointsCapped > 1 then
		local capC = ents.FindByName("cap_areaC")
		TeleportBot(cap_chief_bot, capC)
		cap_chief_bot:ChangeAttributes("Flags")
		
		unuber:AcceptInput("FireUser1")
		
		playSoundToAll("vo/mvm/demoman_mvm_specialcompleted05")
		
		util.PrintToChatAll("Phase 2 activated!")
	end
end

function CapChiefPhase3()
	local capD = ents.FindByName("cap_areaD")
	local workerSpawn = ents.FindByName("spawnbot_workers")
	workerSpawn:Enable()
	TeleportBot(cap_chief_bot, capD)
	cap_chief_bot:ChangeAttributes("Australium")
	cap_chief_bot:RemoveCond(52)
	unuber:AcceptInput("FireUser2")
	
	playSoundToAll("vo/mvm/demoman_mvm_helpmedefend0"..math.random(1,2))
	util.PrintToChatAll("Phase 3 activated!")
end

----------------
-- Error wave --
----------------
local function SetOverlay(overlay)
	local allPlayers = ents.GetAllPlayers()
	for _,player in pairs(allPlayers) do
		player:SetScriptOverlayMaterial(overlay)
	end
	timer.Simple(1, function()
		player:SetScriptOverlayMaterial("")
	end)
end

local bossModels = {
	"scout",
	"soldier",
	"pyro",
	"demo",
	"heavy",
}

function ErrorBoss(_, boss)
	boss:AddCallback(ON_DAMAGE_RECEIVED_POST, function(entity, damageinfo, prevHealth)
		if (boss.m_iHealth % 4444) > (prevHealth % 4444) then
			local randomBossClass = bossModels[math.random(#bossModels)]
			boss:SetCustomModelWithClassAnimations("models/bots/"..randomBossClass.."_boss/bot_"..randomBossClass.."_boss.mdl")
		end
	end)
end


-------------------
-- Custom weapons--
-------------------
function GamblerEquip(_, activator)
	
	local handle = activator:GetHandleIndex()
	callbacks.Gambler[handle] = {}
	local gamblerCallbacks = callbacks.Gambler[handle]
	local secondary = activator:GetPlayerItemBySlot(1)
	local secondaryHandle = secondary:GetHandleIndex()
	
	gamblerCallbacks.onFire = secondary:AddCallback(ON_FIRE_WEAPON_PRE, function()
		--1.01x to 12.5x damage bonus, 8.08 to 100
		local randomDamageMult = math.random(101, 1250) / 100
		secondary:SetAttributeValue("damage bonus", randomDamageMult)
	end)
	
	local function unequip()
		if IsValid(activator) then
			ClearCallbacks("Gambler", activator, handle)
		end
	end

	gamblerCallbacks.onDeath = activator:AddCallback(ON_DEATH, function()
		if secondary:GetItemNameForDisplay() ~= "Gambler's Gambit" then
			unequip()
		end
	end)

	gamblerCallbacks.onSpawn = activator:AddCallback(ON_SPAWN, function()
		if secondary:GetItemNameForDisplay() ~= "Gambler's Gambit" then
			unequip()
		end
	end)
end
