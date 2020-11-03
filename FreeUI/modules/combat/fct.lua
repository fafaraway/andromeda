local F, C, L = unpack(select(2, ...))
local COMBAT = F.COMBAT


-- Floating combat text
-- Credits: RgsCT by Rubgrsch
-- https://github.com/Rubgrsch/RgsCT


local band, C_Timer_After, CombatLogGetCurrentEventInfo, format, GetSpellTexture, UnitGUID, pairs = bit.band, C_Timer.After, CombatLogGetCurrentEventInfo, format, GetSpellTexture, UnitGUID, pairs
local mask_mine_friendly_player = bit.bor(_G.COMBATLOG_OBJECT_AFFILIATION_MASK, _G.COMBATLOG_OBJECT_REACTION_MASK, _G.COMBATLOG_OBJECT_CONTROL_MASK)
local flag_mine_friendly_player = bit.bor(_G.COMBATLOG_OBJECT_AFFILIATION_MINE, _G.COMBATLOG_OBJECT_REACTION_FRIENDLY, _G.COMBATLOG_OBJECT_CONTROL_PLAYER)
local flag_pet_guardian = bit.bor(_G.COMBATLOG_OBJECT_TYPE_PET, _G.COMBATLOG_OBJECT_TYPE_GUARDIAN)
local eventFrame = CreateFrame('Frame')

local blacklist = {
	[201633] = true, -- Earthen Wall
	[143924] = true, -- Leech
}

local dmgcolor = {
	[1] = 'ffff00',
	[2] = 'ffe57f',
	[4] = 'ff7f00',
	[8] = '4cff4c',
	[16] = '7fffff',
	[32] = '7f7fff',
	[64] = 'ff7fff',
	[9] = 'a5ff26',
	[18] = 'bff2bf',
	[36] = 'bf7f7f',
	[5] = 'ffbf00',
	[10] = 'bff2bf',
	[20] = 'bfbf7f',
	[40] = '66bfa5',
	[80] = 'bfbfff',
	[127] = 'c1c48c',
	[126] = 'b7baa3',
	[3] = 'fff23f',
	[6] = 'ffb23f',
	[12] = 'a5bf26',
	[24] = '66ffa5',
	[48] = '7fbfff',
	[65] = 'ffbf7f',
	[124] = 'a8b2a8',
	[66] = 'ffb2bf',
	[96] = 'bf7fff',
	[72] = 'a5bfa5',
	[68] = 'ff7f7f',
	[28] = '99d670',
	[34] = 'bfb2bf',
	[33] = 'bfbf7f',
	[17] = 'bfff7f',
}
setmetatable(dmgcolor,{__index=function() return 'ffffff' end})

local environmentalTypeText = {
	Drowning = ACTION_ENVIRONMENTAL_DAMAGE_DROWNING,
	Falling = ACTION_ENVIRONMENTAL_DAMAGE_FALLING,
	Fatigue = ACTION_ENVIRONMENTAL_DAMAGE_FATIGUE,
	Fire = ACTION_ENVIRONMENTAL_DAMAGE_FIRE,
	Lava = ACTION_ENVIRONMENTAL_DAMAGE_LAVA,
	Slime = ACTION_ENVIRONMENTAL_DAMAGE_SLIME,
}

local dmgFunc
local mergeData = {
	[true] = {[true] = {}, [false] = {}},
	[false] = {[true] = {}, [false] = {}},
}

local function createCTFrame(frameName, spacing, maxLines, fadeDuration, timeVisible, justify, width, height)
	local frame = CreateFrame('ScrollingMessageFrame', frameName, UIParent)
	frame:SetSpacing(spacing)
	frame:SetMaxLines(maxLines)
	frame:SetFadeDuration(fadeDuration)
	frame:SetTimeVisible(timeVisible)
	frame:SetJustifyH(justify)
	frame:SetSize(width, height)
	frame:SetFont(C.Assets.Fonts.Regular, 14)
	frame:SetShadowColor(0, 0, 0, 1)
	frame:SetShadowOffset(2, -2)

	return frame
end

local inFrame = createCTFrame('CombatText_In', 3, 20, 0.2, 3, 'LEFT', 120, 160)
local outFrame = createCTFrame('CombatText_Out', 3, 20, 0.2, 3, 'RIGHT', 120, 160)


local function dmgString(isIn, isHealing, spellID, amount, school, isCritical, Hits)
	local frame = isIn and inFrame or outFrame
	local symbol = isHealing and '+' or (isIn and '-' or '')

	if isIn then
		if Hits and Hits > 1 then
			frame:AddMessage(format(isCritical and '|T%s:0:0:0:-5|t |cff%s%s*%s* x%d|r' or '|T%s:0:0:0:-5|t |cff%s%s%s x%d|r', GetSpellTexture(spellID) or '', dmgcolor[school], symbol, F.Numb(amount/Hits), Hits))
		else
			frame:AddMessage(format(isCritical and '|T%s:0:0:0:-5|t |cff%s%s*%s*|r' or '|T%s:0:0:0:-5|t |cff%s%s%s|r', GetSpellTexture(spellID) or '', dmgcolor[school], symbol, F.Numb(amount)))
		end
	else
		if Hits and Hits > 1 then
			frame:AddMessage(format(isCritical and '|cff%s%s*%s* x%d|r |T%s:0:0:0:-5|t' or '|cff%s%s%s x%d|r |T%s:0:0:0:-5|t', dmgcolor[school], symbol, F.Numb(amount/Hits), Hits, GetSpellTexture(spellID) or ''))
		else
			frame:AddMessage(format(isCritical and '|cff%s%s*%s*|r |T%s:0:0:0:-5|t' or '|cff%s%s%s|r |T%s:0:0:0:-5|t', dmgcolor[school], symbol, F.Numb(amount), GetSpellTexture(spellID) or ''))
		end
	end
end

local function missString(isIn, spellID, missType, amountMissed)
	local frame = isIn and inFrame or outFrame

	if isIn then
		if missType == 'ABSORB' then
			frame:AddMessage(format('|T%s:0:0:0:-5|t %s(%s)',GetSpellTexture(spellID) or '',_G[missType],F.Numb(amountMissed)))
		else
			frame:AddMessage(format('|T%s:0:0:0:-5|t %s',GetSpellTexture(spellID) or '',_G[missType]))
		end
	else
		if missType == 'ABSORB' then
			frame:AddMessage(format('%s(%s) |T%s:0:0:0:-5|t',_G[missType],F.Numb(amountMissed),GetSpellTexture(spellID) or ''))
		else
			frame:AddMessage(format('%s |T%s:0:0:0:-5|t',_G[missType],GetSpellTexture(spellID) or ''))
		end
	end
end

local function dmgMerge(isIn, isHealing, spellID, amount, school, critical)
	local tbl = mergeData[isIn][isHealing]

	if not tbl[spellID] then
		tbl[spellID] = {0,school,0,0}
		tbl[spellID].func = function()
			local tbl = tbl
			dmgString(isIn, isHealing, spellID, tbl[1], tbl[2], tbl[3] == tbl[4], tbl[4])
			tbl[1], tbl[3], tbl[4] = 0, 0, 0
		end
	end

	tbl = tbl[spellID]
	tbl[1], tbl[3], tbl[4] = tbl[1] + amount, tbl[3] + (critical and 1 or 0), tbl[4] + 1

	if tbl[4] == 1 then
		C_Timer_After(0.05, tbl.func)
	end
end

local role = nil
local function roleCheck()
	role = GetSpecializationRole(GetSpecialization())
end

local function setMerge()
	dmgFunc = C.DB.combat.fct_merge and dmgMerge or dmgString
end




local function vehicleChanged(self, event, unit, _, _, _, guid)
	if unit == 'player' then
		eventFrame.vehicleGUID = guid
	end
end


function COMBAT:FloatingCombatText()
	if not C.DB.combat.fct then return end

	if C.DB.combat.fct_in then
		F.Mover(inFrame, L['COMBAT_MOVER_IN'], 'FCTInFrame', {'RIGHT', UIParent, 'CENTER', -300, 0}, inFrame:GetWidth(), inFrame:GetHeight())
	end

	if C.DB.combat.fct_out then
		F.Mover(outFrame, L['COMBAT_MOVER_OUT'], 'FCTOutFrame', {'LEFT', UIParent, 'CENTER', 300, 140}, outFrame:GetWidth(), outFrame:GetHeight())
	end


	setMerge()

	eventFrame:SetScript('OnEvent', function(self)
		local _, Event, _, sourceGUID, _, sourceFlags, _, destGUID, _, _, _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, _, _, arg10 = CombatLogGetCurrentEventInfo()
		local vehicleGUID, playerGUID = self.vehicleGUID, self.playerGUID
		local fromMe = sourceGUID == playerGUID
		local fromMine = fromMe or (C.DB.combat.fct_pet and band(sourceFlags, mask_mine_friendly_player) == flag_mine_friendly_player and band(sourceFlags, flag_pet_guardian) > 0) or sourceGUID == vehicleGUID
		local toMe = destGUID == playerGUID or destGUID == vehicleGUID

		if Event == 'SWING_DAMAGE' then
			if fromMine then dmgFunc(false,false,5586,arg1,arg3,arg7) end
			if toMe then dmgFunc(true,false,5586,arg1,arg3,arg7) end

		elseif (Event == 'SPELL_DAMAGE' or Event == 'RANGE_DAMAGE') or (C.DB.combat.fct_periodic and Event == 'SPELL_PERIODIC_DAMAGE') then
			if blacklist[arg1] then return end
			if toMe then dmgFunc(true,false,arg1,arg4,arg6,arg10)
			elseif fromMine then dmgFunc(false,false,arg1,arg4,arg6,arg10) end

		elseif Event == 'SWING_MISSED' then
			if fromMe then missString(false,5586,arg1,arg3) end
			if toMe then missString(true,5586,arg1,arg3) end

		elseif (Event == 'SPELL_MISSED' or Event == 'RANGE_MISSED') then
			if blacklist[arg1] then return end
			if toMe then missString(true,arg1,arg4,arg6)
			elseif fromMine then missString(false,arg1,arg4,arg6) end

		elseif Event == 'SPELL_HEAL' or (C.DB.combat.fct_periodic and Event == 'SPELL_PERIODIC_HEAL') then
			-- block full-overhealing
			if blacklist[arg1] or arg4 == arg5 then return end
			-- Show healing in outFrame for healers, inFrame for tank/dps
			if fromMine and role == 'HEALER' then dmgFunc(false,true,arg1,arg4,arg3,arg7)
			elseif toMe then dmgFunc(true,true,arg1,arg4,arg3,arg7)
			elseif fromMine then dmgFunc(false,true,arg1,arg4,arg3,arg7) end

		elseif Event == 'ENVIRONMENTAL_DAMAGE' then
			if toMe then inFrame:AddMessage(format('|cff%s%s -%s|r',dmgcolor[arg4],environmentalTypeText[arg1],F.Numb(arg2))) end
		end
	end)
	eventFrame.playerGUID = UnitGUID('player')
	eventFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')

	F:RegisterEvent('PLAYER_ENTERING_WORLD', roleCheck)
	F:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', roleCheck)
	F:RegisterEvent('UNIT_ENTERED_VEHICLE', vehicleChanged)
	F:RegisterEvent('UNIT_EXITING_VEHICLE', vehicleChanged)
end
