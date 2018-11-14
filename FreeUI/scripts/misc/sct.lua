local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("sct")
if not C.misc.sct then return end

-- based on RgsCT by Rubgrsch


local C_Timer_After, CombatLogGetCurrentEventInfo, format, unpack, GetSpellTexture, UnitGUID, pairs = C_Timer.After, CombatLogGetCurrentEventInfo, format, unpack, GetSpellTexture, UnitGUID, pairs

local MY_PET_FLAGS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET)
local MY_GUARDIAN_FLAGS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_GUARDIAN)

local dmgcolor = {
	[1] = "ffff00",
	[2] = "ffe57f",
	[4] = "ff7f00",
	[8] = "4cff4c",
	[16] = "7fffff",
	[32] = "7f7fff",
	[64] = "ff7fff",
	[9] = "a5ff26",
	[18] = "bff2bf",
	[36] = "bf7f7f",
	[5] = "ffbf00",
	[10] = "bff2bf",
	[20] = "bfbf7f",
	[40] = "66bfa5",
	[80] = "bfbfff",
	[127] = "c1c48c",
	[126] = "b7baa3",
	[3] = "fff23f",
	[6] = "ffb23f",
	[12] = "a5bf26",
	[24] = "66ffa5",
	[48] = "7fbfff",
	[65] = "ffbf7f",
	[124] = "a8b2a8",
	[66] = "ffb2bf",
	[96] = "bf7fff",
	[72] = "a5bfa5",
	[68] = "ff7f7f",
	[28] = "99d670",
	[34] = "bfb2bf",
	[33] = "bfbf7f",
	[17] = "bfff7f",
}

local environmentalTypeText = {
	Drowning = ACTION_ENVIRONMENTAL_DAMAGE_DROWNING,
	Falling = ACTION_ENVIRONMENTAL_DAMAGE_FALLING,
	Fatigue = ACTION_ENVIRONMENTAL_DAMAGE_FATIGUE,
	Fire = ACTION_ENVIRONMENTAL_DAMAGE_FIRE,
	Lava = ACTION_ENVIRONMENTAL_DAMAGE_LAVA,
	Slime = ACTION_ENVIRONMENTAL_DAMAGE_SLIME,
}

local OutFrame = CreateFrame("ScrollingMessageFrame", "SctOut", UIParent)
OutFrame:SetSpacing(4)
OutFrame:SetMaxLines(20)
OutFrame:SetFadeDuration(0.2)
OutFrame:SetTimeVisible(3)
OutFrame:SetFont(C.font.normal, 18)
OutFrame:SetShadowColor(0, 0, 0, 1)
OutFrame:SetShadowOffset(2, -2)
OutFrame:SetJustifyH("RIGHT")
OutFrame:SetSize(160, 200)
OutFrame:SetPoint(unpack(C.misc.sctDmgOutPos))

local InFrame = CreateFrame("ScrollingMessageFrame", "SctIn", UIParent)
InFrame:SetSpacing(4)
InFrame:SetMaxLines(20)
InFrame:SetFadeDuration(0.2)
InFrame:SetTimeVisible(3)
InFrame:SetFont(C.font.normal, 18)
InFrame:SetShadowColor(0, 0, 0, 1)
InFrame:SetShadowOffset(2, -2)
InFrame:SetJustifyH("LEFT")
InFrame:SetSize(160, 200)
InFrame:SetPoint(unpack(C.misc.sctDmgInPos))

local InfoFrame = CreateFrame("ScrollingMessageFrame", "SctInfo", UIParent)
InfoFrame:SetSpacing(4)
InfoFrame:SetMaxLines(1)
InfoFrame:SetFadeDuration(.4)
InfoFrame:SetTimeVisible(2)
InfoFrame:SetFont(C.font.header, 24)
InfoFrame:SetShadowColor(0, 0, 0, 1)
InfoFrame:SetShadowOffset(2, -2)
InfoFrame:SetJustifyH("CENTER")
InfoFrame:SetSize(300, 100)
InfoFrame:SetPoint(unpack(C.misc.sctDmgInfoPos))


local function NumUnitFormat(value)
	if value > 1e9 then
		return format("%.1fB",value/1e9)
	elseif value > 1e6 then
		return format("%.1fM",value/1e6)
	elseif value > 1e3 then
		return format("%.1fK",value/1e3)
	else
		return format("%.0f",value)
	end
end

local function DamageHealingString(isIn,isHealing,spellID,amount,school,isCritical,Hits)
	local frame = isIn and InFrame or OutFrame
	local symbol = isHealing and "+" or (isIn and "-" or "")
	if Hits and Hits > 1 then
		frame:AddMessage(format("|T%s:0:0:0:-5|t |cff%s%s%s x%d|r",GetSpellTexture(spellID) or "",dmgcolor[school] or "ffffff",symbol,NumUnitFormat(amount/Hits),Hits))
	else
		frame:AddMessage(format(isCritical and "|T%s:0:0:0:-5|t |cff%s%s*%s*|r" or "|T%s:0:0:0:-5|t |cff%s%s%s|r",GetSpellTexture(spellID) or "",dmgcolor[school] or "ffffff",symbol,NumUnitFormat(amount)))
	end
end

local function MissString(isIn,spellID,missType)
	(isIn and InFrame or OutFrame):AddMessage(format("|T%s:0:0:0:-5|t %s",GetSpellTexture(spellID) or "",_G[missType]))
end

-- Merge --
local merge
local mergeData = {
	[true] = {[true] = {}, [false] = {}},
	[false] = {[true] = {}, [false] = {}},
}

local function dmgMerge(isIn,isHealing,spellID,amount,school,critical)
	local tbl = mergeData[isIn][isHealing]
	if not tbl[spellID] then
		tbl[spellID] = {0,school,0,0}
		tbl[spellID].func = function()
			DamageHealingString(isIn,isHealing,spellID,unpack(tbl))
			tbl[1], tbl[4] = 0, 0
		end
	end
	tbl = tbl[spellID]
	tbl[1], tbl[3], tbl[4] = tbl[1] + amount, critical, tbl[4] + 1
	if tbl[4] == 1 then C_Timer_After(0.05,tbl.func) end
end

function module:SetMerge()
	merge = C.misc.sctMerge and dmgMerge or DamageHealingString
end

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function()
	local _, Event, _, sourceGUID, _, sourceFlags, _, destGUID, destName, _, _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, _, _, arg10 = CombatLogGetCurrentEventInfo()
	local vehicleGUID, playerGUID = UnitGUID("vehicle"), UnitGUID("player")
	local fromMe = sourceGUID == playerGUID
	local fromMine = fromMe or (C.misc.sctPet and (sourceFlags == MY_PET_FLAGS or sourceFlags == MY_GUARDIAN_FLAGS)) or sourceGUID == vehicleGUID
	local toMe = destGUID == playerGUID or destGUID == vehicleGUID
	if Event == "SWING_DAMAGE" then -- melee
		-- amount, overkill, school, resisted, blocked, absorbed, critical
		if fromMine then merge(false,false,5586,arg1,arg3,arg7) end
		if toMe then merge(true,false,5586,arg1,arg3,arg7) end
	elseif (Event == "SPELL_DAMAGE" or Event == "RANGE_DAMAGE") or (C.misc.sctPeriodic and Event == "SPELL_PERIODIC_DAMAGE") then -- spell damage
		-- spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical
		if toMe then merge(true,false,arg1,arg4,arg6,arg10)
		elseif fromMine then merge(false,false,arg1,arg4,arg6,arg10) end
	elseif Event == "SWING_MISSED" then -- melee miss
		-- missType, isOffHand, amountMissed
		if fromMe then MissString(false,5586,arg1) end
		if toMe then MissString(true,5586,arg1) end
	elseif (Event == "SPELL_MISSED" or Event == "RANGE_MISSED") then -- spell miss
		-- spellId, spellName, spellSchool, missType, isOffHand, amountMissed
		if fromMe then MissString(false,arg1,arg4) end
		if toMe then MissString(true,arg1,arg4) end
	elseif Event == "SPELL_HEAL" or (C.misc.sctPeriodic and Event == "SPELL_PERIODIC_HEAL") then -- Healing
		-- spellId, spellName, spellSchool, amount, overhealing, absorbed, critical
		if arg1 == 143924 or arg4 == arg5 then return end
		if fromMine and C.PlayerRole == "HEALER" then merge(false,true,arg1,arg4,arg3,arg7)
		elseif toMe then merge(true,true,arg1,arg4,arg3,arg7)
		elseif fromMine then merge(false,true,arg1,arg4,arg3,arg7) end
	elseif Event == "ENVIRONMENTAL_DAMAGE" then -- environmental damage
		-- environmentalType, amount, overkill, school, resisted, blocked, absorbed, critical
		if toMe then InFrame:AddMessage(format("|cff%s%s-%s|r",dmgcolor[arg4] or "ffffff",environmentalTypeText[arg1],NumUnitFormat(arg2))) end
	--[[elseif C.misc.sctInfo and fromMe then
		-- spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSchool, auraType
		if Event == "SPELL_INTERRUPT" then -- player interrupts
			InfoFrame:AddMessage(format(L["InterruptedSpell"], destName, arg5))
		elseif Event == "SPELL_DISPEL" then -- player dispels
			InfoFrame:AddMessage(format(L["Dispeled"], destName, arg5))
		elseif Event == "SPELL_STOLEN" then -- player stolen
			InfoFrame:AddMessage(format(L["Stole"], destName, arg5))
		end]]
	end
end)

local combatF = CreateFrame("Frame")
combatF:RegisterEvent("PLAYER_REGEN_ENABLED")
combatF:RegisterEvent("PLAYER_REGEN_DISABLED")
combatF:SetScript("OnEvent", function(_,event)
	if not (C.misc.sct and C.misc.sctInfo) then return end
	if event == "PLAYER_REGEN_ENABLED" then
		InfoFrame:AddMessage(LEAVING_COMBAT,0,1,0)
	else
		InfoFrame:AddMessage(ENTERING_COMBAT,1,0,0)
	end
end)

function module:OnLogin()
	module:SetMerge()
	eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end