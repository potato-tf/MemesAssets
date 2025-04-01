local activeBusters = {}
local reusableBusterFrustrationTimer = 0
-- 2 minutes 15 seconds
local reusableBusterFrustrationLimit = 9000
-- 1 minute 45 seconds
local reusableBusterFrustrationMsgTime = 7000
local reusableBusterFrustrated = false
math.randomseed(os.time())

function OnWaveReset(wave)
    for index, bot in pairs(activeBusters) do
        activeBusters[index] = nil
    end
end

function OnGameTick()
    -- Buster targets are math_remap entities
    for _, target in pairs(ents.FindAllByClass("math_remap")) do
        if target.updateToBuilderLocationPerTick == true then
            target:SetAbsOrigin(target.builder:GetAbsOrigin())
        end
    end
    for _, bot in pairs(activeBusters) do
        GuideBusterAi(bot)
	end
end

AddEventCallback('player_builtobject', function(event)
    for _, sentry in pairs(ents.FindAllByClass("obj_sentrygun")) do
		local sentryOwner = sentry.m_hBuilder
        
		if (not sentryOwner) or tostring(sentryOwner) == "Invalid entity handle id: -1" then
			goto continue
		end

		if sentryOwner ~= ents.GetPlayerByUserId(event.userid) then
            goto continue
        end

        -- player_dropobject also triggers player_builtobject, so this check is necessary
        if sentryOwner.isNotCarryingBuilding ~= true and sentryOwner.isNotCarryingBuilding ~= nil  then
            -- print("Sentry was redeployed and not built")
            goto continue
        end

        local sentryIndex = tostring(sentry:GetHandleIndex())

        local newBusterTarget = ents.CreateWithKeys("math_remap", {
            targetname = "bustertarget" .. tostring(sentryIndex),
            origin = sentry:GetAbsOrigin()
        }, true, true)

        -- print("Built sentry found. Target made. Sentry index:" .. sentryIndex)

        newBusterTarget:SetAbsOrigin(sentry:GetAbsOrigin())

        newBusterTarget.updateToBuilderLocationPerTick = false
        newBusterTarget.builder = sentryOwner
        
        sentry:AddCallback(ON_REMOVE, function(ent)
            -- print("Sentry destroyed. Target killed")
            sentryOwner.isNotCarryingBuilding = true
            newBusterTarget:Remove()
            ---- print("Callbacked")
        end)

		::continue::
	end
end)

function GuideBusterAi(bot)
    if bot.sentryTarget ~= nil and bot.sentryTarget:IsValid() == false then
        bot:BotCommand("stop interrupt action")
    end
    if bot.sentryTarget == nil or bot.sentryTarget:IsValid() == false then
        local potentialTargetList = ents.FindAllByClass("math_remap")
        local randomlySelectedTarget = potentialTargetList[math.random(#potentialTargetList)]

        if #potentialTargetList == 0 then
            -- Buster will stand still in spawn if no potential targets, that's fine
            goto skiptarget
        end
        bot.sentryTarget = randomlySelectedTarget
        timer.Simple(0.15, function()
            bot:BotCommand("interrupt_action -posent " .. bot.sentryTarget:GetName() .. " -lookposent " .. bot.sentryTarget:GetName() .. " -duration 696969")
            -- print("Action interrupted with a target: " .. bot.sentryTarget:GetName())
        end)
        ::skiptarget::
    end

    if bot.sentryTarget ~= nil then
        if bot.sentryTarget:IsValid() ~= true then
            goto skipDistanceCheck
        end
    
        local distanceToTarget = bot:GetAbsOrigin():Distance(bot.sentryTarget:GetAbsOrigin())
        if distanceToTarget > 96 then
            goto skipDistanceCheck
        end
    
        if bot.isReusableBuster == 0 or bot.isReusableBuster == nil then
            -- Setting buster hp to 1 forces it to start detonation sequence, reusable buster uses a different logic
            bot.m_iHealth = 1
        else
            if bot.isExploding == 1 then
                goto skipReusableExplode
            end
            ReusableBusterExplode(1, bot)
            ::skipReusableExplode::
        end
    
        ::skipDistanceCheck::
    end

    if bot.isReusableBuster ~= 1 then
        goto skipTickReusableBusterFrustrationTimer
    end

    reusableBusterFrustrationTimer = reusableBusterFrustrationTimer + 1

    if reusableBusterFrustrationTimer >= reusableBusterFrustrationMsgTime then
        reusableBusterFrustrationMsgTime = 999999
        local frustrationSound = ents.FindByName("reusablebuster_tts_frustration")
        frustrationSound:AcceptInput("Trigger")
    end

    if reusableBusterFrustrationTimer >= reusableBusterFrustrationLimit then
        RevertReusableBusterAi("0", bot)
        if reusableBusterFrustrated == false then
            bot:Suicide()
            reusableBusterFrustrated = true
        end
        local frustrationEndSound = ents.FindByName("reusablebuster_tts_frustrationend")
        frustrationEndSound:AcceptInput("Trigger")
        local normalEndSound = ents.FindByName("reusablebuster_tts_end")
        normalEndSound:AcceptInput("CancelPending")
        
    end

    ::skipTickReusableBusterFrustrationTimer::
end

function CheckIfBusterIsIdling(bot, delay)
    -- print("Testing for buster idle in " .. delay .. " seconds: " .. bot:GetHandleIndex())
    timer.Simple(delay, function()
        -- print("Now testing for buster " .. bot:GetHandleIndex() .. " if idling...")
        -- local idleCheckTrigger = ents.FindByName("buster_idle_check_trigger")
        -- bot:AddHealth(500, true)
        -- idleCheckTrigger:AcceptInput("TouchTest","0",bot)
        local busterpos = bot:GetAbsOrigin()
        -- print("Buster Y pos: " .. busterpos[2])
        
        -- Y = 4232 is where bots drop down from main spawn
        if busterpos[2] > 4232 then
            RefreshBusterAi(bot)
        end
    end)
end

function RefreshBusterAi(bot)
    -- print("Buster " .. bot:GetHandleIndex() .. "is detected idling. Refreshing...")
    -- bot:AddHealth(1250, true)
    CheckIfBusterIsIdling(bot, 7)
    bot.sentryTarget = nil
end

local function chatMessage(string)
	local allPlayers = ents.GetAllPlayers()
	for _, player in pairs(allPlayers) do
		player:AcceptInput("$DisplayTextChat", string)
	end

end

function ReusableBusterTtsIntro(param)
    chatMessage("{4e9058}Reusable Buster: {9affa9} Did you know that cleaning up remains of detonated Sentry Busters cost Mann Co. about 400 million dollars annually?")
    timer.Simple(7.57, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} Introducing the Reusable Sentry Buster (that's me)!")
    end)
    timer.Simple(11.5, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} Unlike those other sentry busters I do not explode into pieces of metal scrap.")
    end)
    timer.Simple(16.2, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} Saving you the costs of cleaning the field after a robot invasion.")
    end)
    timer.Simple(20.45, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} Just hire me for 20 thousand dollars a day and I will be the one cleanly busting your sentries instead of those inferior dirty busters.")
    end)
    timer.Simple(28.45, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} This free trial is brought to you by the robots.")
    end)
end

function ReusableBusterTtsEnd(param)
    chatMessage("{4e9058}Reusable Buster: {9affa9} Your free trial of reusable buster has expired.")
    timer.Simple(3.6, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} If you enjoyed this very clean sentry busting experience don't hesitate to hire me again at the upgrade station.")
    end)
    timer.Simple(10.5, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} I will leave absolutely no remains of myself after performing my sentry busting.")
    end)
end

function ReusableBusterTtsFrustration(param)
    chatMessage("{4e9058}Reusable Buster: {9affa9} What the heck are you doing with your sentries?")
    timer.Simple(3, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} This is supposed to be an advertisement for a cleaner, greener way of busting sentries.")
    end)
    timer.Simple(8.37, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} Do you know how much methane your usual sentry buster emits every time it explodes?")
    end)
    timer.Simple(13.91, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} Do you like getting lung cancer?")
    end)
end

function ReusableBusterTtsFrustrationEnd(param)
    chatMessage("{4e9058}Reusable Buster: {9affa9} Screw you guys this was supposed to be a demonstration of how clean sentry busting is the future.")
    timer.Simple(6.3, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} Oh but I guess you mercenaries just love bleeding your lungs out.")
    end)
    timer.Simple(10.21, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} See you in hell.")
    end)
end
function ReusableBusterTtsWave6(param)
    chatMessage("{4e9058}Reusable Buster: {9affa9} Hello again mercenaries I see that you are not yet convinced of the power of clean sentry busting.")
    timer.Simple(6.26, function()
        chatMessage("{4e9058}Reusable Buster: {9affa9} The robots have brought you another free trial to ensure that")
    end)
    timer.Simple(10, function()
        chatMessage('{4e9058}Reusable Buster: {9affa9} "You are thoroughly informed of how important it is to not litter the battlefield with non-recycleable materials"')
    end)
    timer.Simple(16, function()
        chatMessage('{4e9058}Reusable Buster: {9affa9} and not because of "We just need more sentry busters out on the field"')
    end)
end


AddEventCallback('player_carryobject', function(event) 
    for _, sentry in pairs(ents.FindAllByClass("obj_sentrygun")) do

		local sentryOwner = sentry.m_hBuilder
        sentryOwner.isNotCarryingBuilding = false

		if (not sentryOwner) or tostring(sentryOwner) == "Invalid entity handle id: -1" then
			goto continue
		end

		if sentryOwner ~= ents.GetPlayerByUserId(event.userid) then
            goto continue
        end
        
        local sentryIndex = tostring(sentry:GetHandleIndex())
        -- print("Now carrying sentry no: " .. sentryIndex)
        for i, target in pairs(ents.FindAllByName("bustertarget" .. sentryIndex)) do
            target.updateToBuilderLocationPerTick = true
        end

		::continue::
	end
end)

AddEventCallback('player_dropobject', function(event) 
    for _, sentry in pairs(ents.FindAllByClass("obj_sentrygun")) do

		local sentryOwner = sentry.m_hBuilder

        timer.Simple(0.03, function()
            sentryOwner.isNotCarryingBuilding = true
        end)

		if (not sentryOwner) or tostring(sentryOwner) == "Invalid entity handle id: -1" then
			goto continue
		end

		if sentryOwner ~= ents.GetPlayerByUserId(event.userid) then
            goto continue
        end

        local sentryIndex = tostring(sentry:GetHandleIndex())
        -- print("Sentry redeployed:" .. sentryIndex)
        for i, target in pairs(ents.FindAllByName("bustertarget" .. sentryIndex)) do
            target.updateToBuilderLocationPerTick = false
            target:SetAbsOrigin(sentry:GetAbsOrigin())
        end

		::continue::
	end
end)


function OnWaveSpawnBot(bot, wave, tags)
    for _, tag in pairs(tags) do
        if tag == "specialbuster" then
            activeBusters[bot:GetHandleIndex()] = bot
            -- print("buster found!!")
            local case = ents.FindByName("announcer_sentrybusterwarning_random")
            case:AcceptInput("PickRandom")
            bot.isBuster = 1
            CheckIfBusterIsIdling(bot, 7)
        end
        if tag == "reusablebuster" then
            activeBusters[bot:GetHandleIndex()] = bot
            -- print("reusable buster found!!")
            local case = ents.FindAllByName("announcer_sentrybusterwarning_random")
            for _, caseent in pairs(case) do
                caseent:AcceptInput("PickRandom")
            end
            bot.isReusableBuster = 1
            CheckIfBusterIsIdling(bot, 6)
        end
    end

    bot:AcceptInput("SetDamageFilter", "filter_nodmgfilter")
end

AddEventCallback('player_death', function(event)
    player = ents.GetPlayerByUserId(event.userid)
    if player.m_iTeamNum ~= 3 then
        -- print("Dead player was not blue")
        goto continue
    end
    if player.isBuster ~= 1 and player.isReusableBuster ~= 1 then
        goto continue
    end
    -- print("dead buster found!!")
    player.isBuster = 0
    player.isReusableBuster = 0
    player:BotCommand("stop interrupt action")
    activeBusters[player:GetHandleIndex()] = nil
    ::continue::
end)

function RevertReusableBusterAi(param, player)
    player.isBuster = 0
    player.isReusableBuster = 0
    reusableBusterFrustrationTimer = 0
    reusableBusterFrustrationLimit = 999999
    player:BotCommand("stop interrupt action")
    activeBusters[player:GetHandleIndex()] = nil
end

--Upgrade station naturally reverts max canteen limit to 3, so this is necessary
AddEventCallback('player_upgraded', function(event)
    for _, player in pairs(ents.GetAllPlayers()) do
        if player.m_iTeamNum ~= 2 then
            goto continue
        end
		local canteen = player:GetPlayerItemBySlot(9)
        canteen:SetAttributeValue("powerup max charges", 6)
		::continue::
	end
end)

--====================================
--REGULAR BUSTER EXPLOSION FUNCTIONS
--====================================

function fireTraceBetweenTwoEntities(pos1, pos2)
    DefaultTraceInfo = {
        start = pos1, -- Start position vector. Can also be set to entity, in this case the trace will start from entity eyes position
        endpos = pos2, -- End position vector. If nil, the trace will be fired in `angles` direction with `distance` length
        mask = MASK_SOLID, -- Solid type mask, see MASK_* globals
        collisiongroup = COLLISION_GROUP_PLAYER, -- Pretend the trace to be fired by an entity belonging to this group. See COLLISION_GROUP_* globals
        filter = nil -- Entity to ignore. If nil, filters start entity. Can be a single entity, table of entities, or a function with a single entity parameter that returns true if trace should hit the entity, false otherwise.
    }
    trace = util.Trace(DefaultTraceInfo)
    return trace.Entity
end

function getAllPlayersInBusterExplosion(blastCenter, blastRadius)

    local entsInBlastRadius = ents.FindInSphere(blastCenter, blastRadius)
    local playersCaughtInBlast = {}

    for _, blastVictim in pairs(entsInBlastRadius) do

        if blastVictim:IsPlayer() == false then
            goto continue
        end
        
        if blastVictim:IsAlive() == false then
            goto continue
        end
        
        -- Jank af, didnt use

        -- local hitEntityFromBlast = fireTraceBetweenTwoEntities(blastCenter, blastVictim)
        -- -- -- print("Hit a: " .. hitEntityFromBlast:GetClassname())
        -- if hitEntityFromBlast:GetClassname() ~= "player" then
        --     -- print("Blast victim was behind cover!")
        --     goto continue
        -- end

        playersCaughtInBlast[#playersCaughtInBlast+1] = blastVictim

        ::continue::
    end

    return playersCaughtInBlast
end

function getAllSentriesInBusterExplosion(blastCenter, blastRadius)

    local entsInBlastRadius = ents.FindInSphere(blastCenter, blastRadius)
    local sentriesCaughtInBlast = {}

    for _, blastVictim in pairs(entsInBlastRadius) do

        if blastVictim:GetClassname() ~= "obj_sentrygun" then
            goto continue
        end

        sentriesCaughtInBlast[#sentriesCaughtInBlast+1] = blastVictim

        ::continue::
    end

    return sentriesCaughtInBlast
end

--====================================
--SPECIAL BUSTER EXPLOSION FUNCTIONS
--====================================

function DefaultBusterExplode(param, buster)
    for _, blastVictim in pairs(getAllPlayersInBusterExplosion(buster:GetAbsOrigin(), 208)) do
        BusterTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 9999,
            DamageType = DMG_BLAST, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,0), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }

        if blastVictim:GetAttributeValue("not solid to players") == 1 then
            blastVictim:TakeDamage(BusterTakeDamage)
            goto continue
        end
        
        --Attribute exclusive to w1 Captain Punch, we want him to take quite a bit from busters
        if blastVictim:GetAttributeValue("rage giving scale") == 2 then
            BusterTakeDamage.Damage = 20000
            blastVictim:TakeDamage(BusterTakeDamage)
            goto continue
        end

        if blastVictim.m_bIsMiniBoss == 1 then
            BusterTakeDamage.Damage = 600
            blastVictim:TakeDamage(BusterTakeDamage)
            goto continue
        end
        
        blastVictim:TakeDamage(BusterTakeDamage)

        ::continue::
    end

    for _, blastVictim in pairs(getAllSentriesInBusterExplosion(buster:GetAbsOrigin(), 208)) do
        BusterTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 9999,
            DamageType = DMG_BLAST, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,0), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }
        blastVictim:TakeDamage(BusterTakeDamage)

        ::continue::
    end
end

function HealBusterExplode(param, buster)
    for _, blastVictim in pairs(getAllPlayersInBusterExplosion(buster:GetAbsOrigin(), 256)) do
        if blastVictim:IsBot() then
            -- "not solid to players" is an attribute exclusive to sentry busters and will only be used on them.
            -- We do not want sentry busters to be healed; What we want to do may differ from buster per buster
            if blastVictim:GetAttributeValue("not solid to players") == 1 then
                goto continue
            end
            
            if blastVictim.m_bIsMiniBoss == 1 then
                blastVictim:AddHealth(1000, true)
                goto continue
            end
            
            blastVictim:AddHealth(300, true)
        end

        if blastVictim:IsRealPlayer() then
            blastVictim:AddHealth(6000, true)
        end

        ::continue::
    end
end

function AntiGravityBusterExplode(param, buster)
    for _, blastVictim in pairs(getAllPlayersInBusterExplosion(buster:GetAbsOrigin(), 320)) do
        if blastVictim:GetAttributeValue("not solid to players") == 1 then
            goto continue
        end
        blastVictim:AddCond(65,4.5)
        blastVictim:Teleport(blastVictim:GetAbsOrigin() + Vector(0,0,32))
        ::continue::
    end
end

function InfernoBusterExplode(param, buster)
    for _, blastVictim in pairs(getAllPlayersInBusterExplosion(buster:GetAbsOrigin(), 208)) do
        BusterTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 9999,
            DamageType = DMG_BLAST|DMG_BURN, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,0), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }

        if blastVictim:GetAttributeValue("not solid to players") == 1 then
            blastVictim:TakeDamage(BusterTakeDamage)
            goto continue
        end
        
        if blastVictim.m_bIsMiniBoss == 1 then
            BusterTakeDamage.Damage = 600
            blastVictim:TakeDamage(BusterTakeDamage)
            goto continue
        end
        
        blastVictim:TakeDamage(BusterTakeDamage)

        ::continue::
    end

    for _, blastVictim in pairs(getAllSentriesInBusterExplosion(buster:GetAbsOrigin(), 208)) do
        BusterTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 9999,
            DamageType = DMG_BLAST|DMG_BURN, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,0), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }
        blastVictim:TakeDamage(BusterTakeDamage)

        ::continue::
    end
end

function ReusableBusterExplode(param, buster)
    buster:BotCommand("taunt")

    --15 seconds to frustration limit whenever it explodes
    reusableBusterFrustrationLimit = reusableBusterFrustrationLimit + 1000
    reusableBusterFrustrationMsgTime = reusableBusterFrustrationMsgTime + 1000

    local detonatelogic = ents.FindByName("reusablebuster_detonate")
    detonatelogic:AcceptInput("Trigger")
    buster.isExploding = 1
    -- print("BUSTER NOW DETONATING")

    timer.Simple(2, function() 
        timer.Simple(1.5, function()
            buster.isExploding = 0
        end)
        
        -- print("BUSTER NO LONGER DETONATING")
        for _, blastVictim in pairs(getAllPlayersInBusterExplosion(buster:GetAbsOrigin(), 208)) do
            BusterTakeDamage = {
                Attacker = buster, -- Attacker
                Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
                Weapon = buster:GetPlayerItemBySlot(2),
                Damage = 10000,
                DamageType = DMG_BLAST, -- Damage type, see DMG_* globals. Can be combined with | operator
                DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
                DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
                DamageForce = Vector(0,0,-100), -- Knockback force of the attack
                ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
            }

            --We want the reusable buster to have its own special case of takedamage
            if blastVictim:GetAttributeValue("ubercharge rate penalty") == 269 then
                goto continue
            end

            if blastVictim:GetAttributeValue("not solid to players") == 1 then
                blastVictim:TakeDamage(BusterTakeDamage)
                goto continue
            end

            if blastVictim.m_bIsMiniBoss == 1 then
                BusterTakeDamage.Damage = 600
                blastVictim:TakeDamage(BusterTakeDamage)
                goto continue
            end
            
            blastVictim:TakeDamage(BusterTakeDamage)

            ::continue::
        end

        for _, blastVictim in pairs(getAllSentriesInBusterExplosion(buster:GetAbsOrigin(), 208)) do
            BusterTakeDamage = {
                Attacker = buster, -- Attacker
                Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
                Weapon = buster:GetPlayerItemBySlot(2),
                Damage = 9999,
                DamageType = DMG_BLAST, -- Damage type, see DMG_* globals. Can be combined with | operator
                DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
                DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
                DamageForce = Vector(0,0,0), -- Knockback force of the attack
                ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
            }
            blastVictim:TakeDamage(BusterTakeDamage)

            ::continue::
        end

        SelfTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 20000,
            DamageType = DMG_BLAST, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,-100), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }

        buster:TakeDamage(BusterTakeDamage)
        -- print("TOOK SELF DAMAGE")
    end)
end

function FlashBusterExplode(param, buster)
    for _, blastVictim in pairs(getAllPlayersInBusterExplosion(buster:GetAbsOrigin(), 208)) do
        BusterTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 9999,
            DamageType = DMG_BLAST|DMG_SHOCK, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,0), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }

        if blastVictim:GetAttributeValue("not solid to players") == 1 then
            blastVictim:TakeDamage(BusterTakeDamage)
            goto continue
        end
        
        if blastVictim.m_bIsMiniBoss == 1 then
            BusterTakeDamage.Damage = 1200
            blastVictim:AddCond(71, 10)
            blastVictim:TakeDamage(BusterTakeDamage)
            goto continue
        end
        
        blastVictim:TakeDamage(BusterTakeDamage)

        ::continue::
    end

    for _, blastVictim in pairs(getAllSentriesInBusterExplosion(buster:GetAbsOrigin(), 208)) do
        BusterTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 9999,
            DamageType = DMG_BLAST|DMG_SHOCK, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,0), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }
        blastVictim:TakeDamage(BusterTakeDamage)

        ::continue::
    end
end

function SkunkfaceBusterExplode(param, buster)
    for _, blastVictim in pairs(getAllPlayersInBusterExplosion(buster:GetAbsOrigin(), 224)) do
        BusterTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 9999,
            DamageType = DMG_BLAST, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,0), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }

        if blastVictim:IsBot() then
            timer.Simple(1, function()
                blastVictim:IgnitePlayerDuration(5, buster)
            end)
            timer.Simple(2, function()
                blastVictim:TakeDamage(BusterTakeDamage)
            end)
        end

        blastVictim:AddCond(123,10)
        

        ::continue::
    end

    for _, blastVictim in pairs(getAllSentriesInBusterExplosion(buster:GetAbsOrigin(), 224)) do
        BusterTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 300,
            DamageType = DMG_BLAST, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,0), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }
        blastVictim:TakeDamage(BusterTakeDamage)

        ::continue::
    end
end

function DoomsdayBusterExplode(param, buster)
    for _, blastVictim in pairs(getAllPlayersInBusterExplosion(buster:GetAbsOrigin(), 16384)) do
        BusterTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 999999,
            DamageType = DMG_BLAST, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,0), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }
        
        blastVictim:TakeDamage(BusterTakeDamage)

    end

    for _, blastVictim in pairs(getAllSentriesInBusterExplosion(buster:GetAbsOrigin(), 16384)) do
        BusterTakeDamage = {
            Attacker = buster, -- Attacker
            Inflictor = buster:GetPlayerItemBySlot(2), -- Direct cause of damage, usually a projectile
            Weapon = buster:GetPlayerItemBySlot(2),
            Damage = 999999,
            DamageType = DMG_BLAST, -- Damage type, see DMG_* globals. Can be combined with | operator
            DamageCustom = TF_DMG_CUSTOM_AIR_STICKY_BURST, -- Custom damage type, see TF_DMG_* globals
            DamagePosition = buster:GetAbsOrigin(), -- Where the target was hit at
            DamageForce = Vector(0,0,0), -- Knockback force of the attack
            ReportedPosition = buster:GetAbsOrigin() -- Where the attacker attacked from
        }
        blastVictim:TakeDamage(BusterTakeDamage)

        ::continue::
    end
end