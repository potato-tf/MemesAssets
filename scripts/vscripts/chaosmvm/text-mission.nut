::MOD_ITEM <-			"\x07FFFF00[►] "
::MOD_SPEED <-			"\x01Super Speed"
::MOD_SCALE <-			"\x01Reduced Scale"
::MOD_BULLETRES <-		"\x01Bullet \x07FF883FResistance"
::MOD_BLASTRES <-		"\x01Blast \x07FF883FResistance"
::MOD_FIRERES <-		"\x01Fire \x07FF883FResistance"
::MOD_MELEEIMMUNE <- 	"\x01Melee \x07FF3F3FImmunity"
::MOD_WETIMMUNE <-		"\x01Wet Debuff \x07FF3F3FImmunity"
::MOD_BURNIMMUNE <-		"\x01Afterburn \x07FF3F3FImmunity"
::MOD_CRITIMMUNE <-		"\x01Crit & Mini-Crit \x07FF3F3FImmunity"
::MOD_TANKSPAWN <-		"\x01Tanks Start Halfway"
::MOD_RANGEDMELEE <-	"\x01Unlimited Melee Range"
::MOD_SUPERREGEN <-		"\x01Enhanced Lifesteal on hit"
::MOD_RANDOMUBERS <-	"\x01Chance to proc \x07FF3F3FUber \x01on damage"
::MOD_CLASSMASTERY <-	"\x01x10 Damage vs. Matching Classes"

function mission_bonus_triggered()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff A bonus wave has been triggered.")
}
function mission_bonus_mode1()
{
    ClientPrint(null, 3 , "\x0744ff44[BONUS]\x0788ff99 Kill as many spy bots as you can to earn credits. Successful destruction of green tanks will net a significant bonus.\nYou have 5 minutes.")
}
function mission_bonus_mode2()
{
    ClientPrint(null, 3 , "\x0744ff44[BONUS]\x0788ff99 Kill as many spy bots as you can to earn credits. Successful destruction of green tanks will net a significant bonus.\nYou have 4 minutes.")
}
function mission_bonus_mode3()
{
    ClientPrint(null, 3 , "\x0744ff44[BONUS]\x0788ff99 Kill as many spy bots as you can to earn credits. Giant Soldier bots will net a significant bonus.\nYou have 5 minutes.")
}
function mission_bonus_mode4()
{
    ClientPrint(null, 3 , "\x0744ff44[BONUS]\x0788ff99 Kill as many spy bots as you can to earn credits. Successful destruction of green tanks and giant bots will net a significant bonus.\nYou have 4 minutes.")
}
function mission_bonus_mode5()
{
    ClientPrint(null, 3 , "\x0744ff44[BONUS]\x0788ff99 Defeat as many enemies as possible to earn credits. Successful destruction of green tanks net a significant bonus.\nYou have 5 minutes.")
}


function mission_decoy_heavydead()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ff4545 A Decoy Heavy was killed!")
}
function mission_decoy_redtanks()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: ESCORT]\x07ffffff\nProtect RED Tanks while they leave the area.\nThe bomb is not in play. This wave only fails if a RED Tank is destroyed.")
}
function mission_decoy_redtank1()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff RED Tank 1/3 | Health: 65,000")
}
function mission_decoy_redtank2()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff RED Tank 2/3 | Health: 80,000")
}
function mission_decoy_redtank3()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff RED Tank 3/3 | Health: 100,000")
}
function mission_redstone_redtank1()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff RED Tank 1/3 | Health: 55,000")
}
function mission_redstone_redtank2()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff RED Tank 2/3 | Health: 90,000")
}
function mission_redstone_redtank3()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff RED Tank 3/3 | Health: 125,000")
}
function mission_redstone_modifiers()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_CRITIMMUNE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_SUPERREGEN)
    ClientPrint(null, 3 , MOD_ITEM + MOD_RANGEDMELEE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_TANKSPAWN)
}
function mission_coaltown_intro()
{
    ClientPrint(null, 3 , "\x07FFFF00[MISSION: MODIFIERS]\x01\nEach wave will apply one or more \x07FF3F3Fmodifiers \x01to all enemies, granting special abilities or resistances.")
    ClientPrint(null, 3 , "\x01Modifiers are indicated by the support icons. Make sure to plan accordingly!")
}
function mission_coaltown_wave2()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_SPEED)
}
function mission_coaltown_wave3()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_SCALE)
}
function mission_coaltown_wave4()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_MELEEIMMUNE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_BLASTRES)
}
function mission_coaltown_wave5()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_TANKSPAWN)
    ClientPrint(null, 3 , MOD_ITEM + MOD_FIRERES)
}
function mission_coaltown_wave6()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_CRITIMMUNE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_BULLETRES)
}
function mission_coaltown_wave7()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_BLASTRES)
    ClientPrint(null, 3 , MOD_ITEM + MOD_RANGEDMELEE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_BURNIMMUNE)
}
function mission_coaltown_wave8()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_SUPERREGEN)
    ClientPrint(null, 3 , MOD_ITEM + MOD_RANDOMUBERS)
    ClientPrint(null, 3 , MOD_ITEM + MOD_MELEEIMMUNE)
}
function mission_coaltown_wave9()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_SPEED)
    ClientPrint(null, 3 , MOD_ITEM + MOD_SCALE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_WETIMMUNE)
}
function mission_coaltown_wave10()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_TANKSPAWN)
    ClientPrint(null, 3 , MOD_ITEM + MOD_BURNIMMUNE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_WETIMMUNE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_CLASSMASTERY)
}
function mission_coaltown_wave11()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_BULLETRES)
    ClientPrint(null, 3 , MOD_ITEM + MOD_SUPERREGEN)
    ClientPrint(null, 3 , MOD_ITEM + MOD_RANGEDMELEE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_BURNIMMUNE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_CRITIMMUNE)
}
function mission_coaltown_wave12()
{
    ClientPrint(null, 3 , "\x07FFFF00[WAVE MODIFIERS]")
    ClientPrint(null, 3 , MOD_ITEM + MOD_TANKSPAWN)
    ClientPrint(null, 3 , MOD_ITEM + MOD_SUPERREGEN)
    ClientPrint(null, 3 , MOD_ITEM + MOD_RANDOMUBERS)
    ClientPrint(null, 3 , MOD_ITEM + MOD_BURNIMMUNE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_WETIMMUNE)
    ClientPrint(null, 3 , MOD_ITEM + MOD_CLASSMASTERY)
}
function mission_titan_redtanks()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: ESCORT]\x07ffffff\nProtect RED Tanks while they travel to Gate 2.\nAn alternative respawn room has been temporarily enabled, alongside a 'Triple Banner' buff which can be accessed from inside.")
    ClientPrint(null, 3 , "\x07ffffffThe bomb is not in play. This wave only fails if a RED Tank is destroyed.")
}
function mission_titan_redtank1()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff RED Tank 1/3 | Health: 35,000")
}
function mission_titan_redtank2()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff RED Tank 2/3 | Health: 80,000")
}
function mission_titan_redtank3()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff RED Tank 3/3 | Health: 135,000")
}
function mission_redtank_success()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x0765ff65 RED Tank escaped.")
}
function mission_redtank_fail()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ff4545 RED Tank destroyed - Wave failed!")
}


function mission_survival()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: SURVIVAL]\x07ffffff\nThe kill quota has been replaced with a time quota.\nDefend the hatch until the timer reaches zero!")
}
function mission_survival_randomizer()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: RANDOM SURVIVAL]\x07ffffff\nAll robot types can spawn for the next 5 minutes.\nDefend the hatch until the timer reaches zero!")
}
function mission_mannpower_intro()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: POWERUPS]\x07ffffff\nDropped powerups disappear after 30 seconds.\nYou may discard unwanted powerups with your \x07ffff00dropitem \x07ffffffkey \x07858585(Default 'L') \x07ffffffto pick up another one.")
    ClientPrint(null, 3 , "\x07ffffffPowerups dropped in this manner can be picked up again by your team.\nBe careful though... \x07ff4545Your current powerup will be lost on death!")
}
function mission_mannpower_final_wave()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: TANK BOSS RUSH]\x07ffffff\nNo more enemies will use powerups, but will all drop a random powerup on death if the killer is not already equipped with one.")
    ClientPrint(null, 3 , "\x07ffffffEach tank is \x07ffff00invulnerable \x07ffffffuntil the associated boss bot is destroyed.")
}
function mission_speedrun_intro()
{
    ClientPrint(null, 3 , "\x07ff4545[MISSION: SPEEDRUN MODE]\x07ffffff\nEliminate all enemies before the timer reaches zero!")
}
function mission_speedrun_5m()
{
    ClientPrint(null, 3 , "\x07ff4545[MISSION]\x07ffffff Time expires in 5 minutes.")
}
function mission_speedrun_2m()
{
    ClientPrint(null, 3 , "\x07ff4545[MISSION]\x07ffffff Time expires in 2 minutes.")
}
function mission_speedrun_60s()
{
    ClientPrint(null, 3 , "\x07ff4545[MISSION]\x07ffffff Time expires in 60 seconds.")
}
function mission_speedrun_30s()
{
    ClientPrint(null, 3 , "\x07ff4545[MISSION]\x07ffffff Time expires in 30 seconds.")
}
function mission_speedrun_10s()
{
    ClientPrint(null, 3 , "\x07ff4545[MISSION]\x07ffffff Time expires in 10 seconds!")
}


function mission_dice_black()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: BLACK DICE]\n\x07ffffffSelecting random miniboss...")
}
function mission_dice_black_notfake()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: BLACK DICE]\n\x07ffffffSelecting random miniboss...\n\x07a5a5a5(For real this time)")
}
function mission_dice_red()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: RED DICE]\n\x07ffffffSelecting random Chaos group...")
}
function mission_dice_green()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: GREEN DICE]\n\x07ffffffSelecting random Cursed group...")
}
function mission_dice_purple()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: PURPLE DICE]\n\x07ffffffSelecting random Shadow group...")
}
function mission_dice_rainbow()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: RAINBOW DICE]\n\x07ffffffSelecting 100 random enemies...")
}
function mission_dice_blue()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: BLUE DICE]\n\x07ffffffSelecting random Tank starting position...")
}
function mission_dice_gold()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: GOLD DICE]\n\x07ffffffSelecting random element...")
}


function mission_titan_intro()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff WELCOME TO TITAN\nA set of unique temporary buffs are available at spawn, either for yourself or your whole team.")
    ClientPrint(null, 3 , "\x07ffffffThe pre-built teleporter at spawn has a 20-second cooldown and becomes unavailable once the bomb has passed the first tunnel.")
}
function mission_titan_lasergun()
{
    ClientPrint(null, 3 , "\x07ff4545[WARNING]\x07ffffff DEPLOYING EXPERIMENTAL SUPERWEAPON\nPLEASE STAND CLEAR...")
}
function mission_titan_vault1()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x0765ff65 The vault door beneath the hatch has unlocked.")
}
function mission_titan_vault2()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x0765ff65 A vault door revealed by the destruction has also unlocked.")
}
function mission_titan_vault3()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Commencing 2-minute breaktime.")
}
function mission_titan_finale()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: FINALE]\x07ffffff\nAll players must enter the \x07b455ffportal \x07ffffffto proceed...")
}

function mission_endless()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: ENDLESS]\x07ffffff\nNo objective. Survive for as long as you can with increasing difficulty. Kill count is tracked via credits.")
}
function mission_infinity_intro()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION: INFINITY]\x07ffffff\nA 60-minute timer has started.\nKill as many enemies as possible to earn a score.\n ")
    ClientPrint(null, 3 , "\x07ffffffTOP SCORE: \x0765ff65$7,090\n\x07ffffffAchieved by: \x07FF3F3FFlorida Man\x07ffffff, \x07FF3F3Famogus\x07ffffff, \x07FF3F3FKonail\x07ffffff, \x07FF3F3Fowner of spycrab force\x07ffffff, \x07FF3F3FShadowBolt")
}
function mission_infinity_5m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 5m")
}
function mission_infinity_10m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 10m")
}
function mission_infinity_15m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 15m")
}
function mission_infinity_20m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 20m")
}
function mission_infinity_25m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 25m")
}
function mission_infinity_30m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 30m")
}
function mission_infinity_35m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 35m")
}
function mission_infinity_40m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 40m")
}
function mission_infinity_45m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 45m")
}
function mission_infinity_50m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 50m")
}
function mission_infinity_55m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffffff Time elapsed: 55m\n\x07ffff00[MISSION]\x07ffff88 5 minutes remaining.")
}
function mission_infinity_56m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffff88 4 minutes remaining.")
}
function mission_infinity_57m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffff88 3 minutes remaining.")
}
function mission_infinity_58m()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ffff00 2 minutes remaining.")
}
function mission_infinity_60sec()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ff9900 60 seconds remaining.")
}
function mission_infinity_30sec()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ff9900 30 seconds remaining.")
}
function mission_infinity_10sec()
{
    ClientPrint(null, 3 , "\x07ffff00[MISSION]\x07ff4545 10 seconds remaining!")
}


function music_label_boss1()
{
    ClientPrint(null, 3 , "\x07ffff00[BOSS]\x0799CCFF ShadowBo1t\n\x08FFFF0055Music : \x08FFFFFF55What I'm Made Of\n- Crush 40")
}
function music_label_boss2()
{
    ClientPrint(null, 3 , "\x07ffff00[BOSS]\x0799CCFF LEGENDARY Samurai Master\n\x08FFFF0055Music : \x08FFFFFF55Time for War\n- Miguel Johnson")
}
function music_label_boss3()
{
    ClientPrint(null, 3 , "\x07ffff00[BOSS]\x0799CCFF Supreme Pyro Elemental\n\x08FFFF0055Music : \x08FFFFFF55Frailty (2014)\n- PrinceWhateverer")
}
function music_label_boss4()
{
    ClientPrint(null, 3 , "\x07ffff00[BOSS]\x0799CCFF Clockwork\n\x08FFFF0055Music : \x08FFFFFF55Vortal Combat (Vandoorea Remix)\n- Half Life 2: Episode Two OST")
}
function music_label_boss5()
{
    ClientPrint(null, 3 , "\x07ffff00[BOSS]\x0799CCFF Alexander the Great\n\x08FFFF0055Music : \x08FFFFFF55Halo (FamilyJules Cover)\n- Martin O-donnell & Michael Salvatori")
}
function music_label_boss6()
{
    ClientPrint(null, 3 , "\x07ffff00[BOSS]\x0799CCFF Elemental Gods\n\x08FFFF0055Music : \x08FFFFFF55Queen of the Night\n- Per Kiilstofte")
}
function music_label_boss7()
{
    ClientPrint(null, 3 , "\x07ffff00[BOSS]\x0799CCFF Soul of Invictus\n\x08FFFF0055Music : \x08FFFFFF55Ultimate Battle (Friedrich Habetler Instrumental Cover)\n- Akira Kushida")
}
function music_label_boss8()
{
    ClientPrint(null, 3 , "\x07ffff00[BOSS]\x0799CCFF T1T4N-T4NK\n\x08FFFF0055Music : \x08FFFFFF55Castle (FamilyJules Cover)\n- Super Mario World OST")
}
function music_label_boss9()
{
    ClientPrint(null, 3 , "\x07ffff00[BOSS]\x0799CCFF SH4D0WB01T\n\x08FFFF0055Music : \x08FFFFFF55What I'm Made Of (NateWantsToBattle Cover)\n- Crush 40")
}