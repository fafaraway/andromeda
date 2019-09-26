local F, C, L = unpack(select(2, ...))
local module = F:GetModule('Misc')


-- Based on RgsCT by Rubgrsch

local C_Timer_After, CombatLogGetCurrentEventInfo, format, unpack, GetSpellTexture, UnitGUID, pairs = C_Timer.After, CombatLogGetCurrentEventInfo, format, unpack, GetSpellTexture, UnitGUID, pairs

local cfg = {
	['Pet'] = true,
	['Merge'] = true,
	['Periodic'] = true,
	['Outline'] = false,
	['Info_width'] = 400,
	['Info_height'] = 80,
	['Info_position'] = {'CENTER', UIParent, 'CENTER', 0, 300},
	['Info_font'] = {C.font.header, 26, 'OUTLINE'},
	['Incoming_width'] = 200,
	['Incoming_height'] = 150,
	['Incoming_position'] = {'CENTER', UIParent, 'CENTER', -300, 0},
	['Incoming_font'] = {C.font.normal, 20, 'OUTLINE'},
	['Outgoing_width'] = 200,
	['Outgoing_height'] = 150,
	['Outgoing_position'] = {'CENTER', UIParent, 'CENTER', 300, 0},
	['Outgoing_font'] = {C.font.normal, 20, 'OUTLINE'},
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



local function CreateCTFrame(frameName, spacing, maxLines, fadeDuration, timeVisible, justify, width, height)
	local frame = CreateFrame('ScrollingMessageFrame', frameName, UIParent)
	frame:SetSpacing(spacing)
	frame:SetMaxLines(maxLines)
	frame:SetFadeDuration(fadeDuration)
	frame:SetTimeVisible(timeVisible)
	frame:SetJustifyH(justify)
	frame:SetSize(width, height)

	return frame
end

local InFrame = CreateCTFrame('CombatText_In', 3, 20, 0.2, 3, 'LEFT', 120, 160)
local OutFrame = CreateCTFrame('CombatText_Out', 3, 20, 0.2, 3, 'RIGHT', 120, 160)
local InfoFrame = CreateCTFrame('CombatText_Info', 3, 20, 0.2, 2, 'CENTER', 400, 100)




local function DamageHealingString(isIn,isHealing,spellID,amount,school,isCritical,Hits)
	local frame = isIn and InFrame or OutFrame
	local symbol = isHealing and '+' or (isIn and '-' or '')

	if isIn then
		if Hits and Hits > 1 then
			frame:AddMessage(format(isCritical and '|T%s:0:0:0:-5|t |cff%s%s*%s* x%d|r' or '|T%s:0:0:0:-5|t |cff%s%s%s x%d|r',GetSpellTexture(spellID) or '',dmgcolor[school],symbol,F.Numb(amount/Hits),Hits))
		else
			frame:AddMessage(format(isCritical and '|T%s:0:0:0:-5|t |cff%s%s*%s*|r' or '|T%s:0:0:0:-5|t |cff%s%s%s|r',GetSpellTexture(spellID) or '',dmgcolor[school],symbol,F.Numb(amount)))
		end
	else
		if Hits and Hits > 1 then
			frame:AddMessage(format(isCritical and '|cff%s%s*%s* x%d|r |T%s:0:0:0:-5|t' or '|cff%s%s%s x%d|r |T%s:0:0:0:-5|t',dmgcolor[school],symbol,F.Numb(amount/Hits),Hits,GetSpellTexture(spellID) or ''))
		else
			frame:AddMessage(format(isCritical and '|cff%s%s*%s*|r |T%s:0:0:0:-5|t' or '|cff%s%s%s|r |T%s:0:0:0:-5|t',dmgcolor[school],symbol,F.Numb(amount), GetSpellTexture(spellID) or ''))
		end
	end
end

local function MissString(isIn,spellID,missType,amountMissed)
	local frame = isIn and InFrame or OutFrame

	if isIn then
		if missType == 'ABSORB' then
			frame:AddMessage(format('|T%s:0:0:0:-5|t%s(%s)',GetSpellTexture(spellID) or '',_G[missType],F.Numb(amountMissed)))
		else
			frame:AddMessage(format('|T%s:0:0:0:-5|t%s',GetSpellTexture(spellID) or '',_G[missType]))
		end
	else
		if missType == 'ABSORB' then
			frame:AddMessage(format('%s(%s) |T%s:0:0:0:-5|t',_G[missType],F.Numb(amountMissed),GetSpellTexture(spellID) or ''))
		else
			frame:AddMessage(format('%s |T%s:0:0:0:-5|t',_G[missType],GetSpellTexture(spellID) or ''))
		end
	end
end


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
			local tbl = tbl
			DamageHealingString(isIn,isHealing,spellID,tbl[1],tbl[2],tbl[3]==tbl[4],tbl[4])
			tbl[1], tbl[3], tbl[4] = 0, 0, 0
		end
	end
	tbl = tbl[spellID]
	tbl[1], tbl[3], tbl[4] = tbl[1] + amount, tbl[3] + (critical and 1 or 0), tbl[4] + 1
	if tbl[4] == 1 then C_Timer_After(0.05,tbl.func) end
end



local f, role = CreateFrame('Frame'), nil
f:RegisterEvent('PLAYER_LOGIN')
f:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
f:SetScript('OnEvent', function() role = GetSpecializationRole(GetSpecialization()) end)


local MY_PET_FLAGS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET)
local MY_GUARDIAN_FLAGS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_GUARDIAN)


local eventFrame = CreateFrame('Frame')
eventFrame:SetScript('OnEvent', function()
	local _, Event, _, sourceGUID, _, sourceFlags, _, destGUID, destName, _, _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, _, _, arg10 = CombatLogGetCurrentEventInfo()
	local vehicleGUID, playerGUID = UnitGUID('vehicle'), UnitGUID('player')
	local fromMe = sourceGUID == playerGUID
	local fromMine = fromMe or (cfg.Pet and (sourceFlags == MY_PET_FLAGS or sourceFlags == MY_GUARDIAN_FLAGS)) or sourceGUID == vehicleGUID
	local toMe = destGUID == playerGUID or destGUID == vehicleGUID
	if Event == 'SWING_DAMAGE' then
		if fromMine then merge(false,false,5586,arg1,arg3,arg7) end
		if toMe then merge(true,false,5586,arg1,arg3,arg7) end
	elseif (Event == 'SPELL_DAMAGE' or Event == 'RANGE_DAMAGE') or (cfg.Periodic and Event == 'SPELL_PERIODIC_DAMAGE') then
		if toMe then merge(true,false,arg1,arg4,arg6,arg10)
		-- use elseif to block self damage, e.g. stagger
		elseif fromMine then merge(false,false,arg1,arg4,arg6,arg10) end
	elseif Event == 'SWING_MISSED' then
		if fromMe then MissString(false,5586,arg1,arg3) end
		if toMe then MissString(true,5586,arg1,arg3) end
	elseif (Event == 'SPELL_MISSED' or Event == 'RANGE_MISSED') then
		if fromMe then MissString(false,arg1,arg4,arg6) end
		if toMe then MissString(true,arg1,arg4,arg6) end
	elseif Event == 'SPELL_HEAL' or (cfg.Periodic and Event == 'SPELL_PERIODIC_HEAL') then
		-- block leech and full-overhealing
		if arg1 == 143924 or arg4 == arg5 then return end
		-- Show healing in OutFrame for healers, InFrame for tank/dps
		if fromMine and role == 'HEALER' then merge(false,true,arg1,arg4,arg3,arg7)
		elseif toMe then merge(true,true,arg1,arg4,arg3,arg7)
		elseif fromMine then merge(false,true,arg1,arg4,arg3,arg7) end
	elseif Event == 'ENVIRONMENTAL_DAMAGE' then
		if toMe then InFrame:AddMessage(format('|cff%s%s-%s|r',dmgcolor[arg4],environmentalTypeText[arg1],F.Numb(arg2))) end
	end
end)

local combatF = CreateFrame('Frame')
combatF:RegisterEvent('PLAYER_REGEN_ENABLED')
combatF:RegisterEvent('PLAYER_REGEN_DISABLED')
combatF:SetScript('OnEvent', function(_,event)
	if not C.general.combatText_info then return end

	if event == 'PLAYER_REGEN_ENABLED' then
		InfoFrame:AddMessage(LEAVING_COMBAT,0,1,0)
	else
		InfoFrame:AddMessage(ENTERING_COMBAT,1,0,0)
	end
end)

function module:CombatText()
	if not C.general.combatText then return end
	
	if C.general.combatText_incoming then
		local InFrameMover = F.Mover(InFrame, L['MOVER_COMBATTEXT_INCOMING'], 'CombatText_In', cfg.Incoming_position, cfg.Incoming_width, cfg.Incoming_height)
		InFrame:SetPoint('TOPRIGHT', InFrameMover)
		InFrame:SetFont(cfg.Incoming_font[1], cfg.Incoming_font[2], cfg.Outline and cfg.Incoming_font[3])
	end

	if C.general.combatText_outgoing then
		local OutFrameMover = F.Mover(OutFrame, L['MOVER_COMBATTEXT_OUTGOING'], 'CombatText_Out', cfg.Outgoing_position, cfg.Outgoing_width, cfg.Outgoing_height)
		OutFrame:SetPoint('TOPRIGHT', OutFrameMover)
		OutFrame:SetFont(cfg.Outgoing_font[1], cfg.Outgoing_font[2], cfg.Outline and cfg.Outgoing_font[3])
	end

	if C.general.combatText_info then
		local InfoFrameMover = F.Mover(InfoFrame, L['MOVER_COMBATTEXT_INFORMATION'], 'CombatText_Info', cfg.Info_position, cfg.Info_width, cfg.Info_height)
		InfoFrame:SetPoint('TOPRIGHT', InfoFrameMover)
		InfoFrame:SetFont(cfg.Info_font[1], cfg.Info_font[2], cfg.Outline and cfg.Info_font[3])
	end

	if not cfg.Outline then
		local frames = {InFrame, OutFrame, InfoFrame}
		for _, f in pairs(frames) do
			f:SetShadowColor(0, 0, 0, 1)
			f:SetShadowOffset(2, -2)
		end
	end

	merge = cfg.Merge and dmgMerge or DamageHealingString

	eventFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
end