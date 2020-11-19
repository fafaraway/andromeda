local F, C, L = unpack(select(2, ...))
local BLIZZARD = F.BLIZZARD


local holdtime = .52
local fadeintime = .08
local fadeouttime = .16
local state = 0

local ignoredList = {
	[ERR_ABILITY_COOLDOWN] = true,
	[ERR_ATTACK_MOUNTED] = true,
	[ERR_OUT_OF_ENERGY] = true,
	[ERR_OUT_OF_FOCUS] = true,
	[ERR_OUT_OF_HEALTH] = true,
	[ERR_OUT_OF_MANA] = true,
	[ERR_OUT_OF_RAGE] = true,
	[ERR_OUT_OF_RANGE] = true,
	[ERR_OUT_OF_RUNES] = true,
	[ERR_OUT_OF_HOLY_POWER] = true,
	[ERR_OUT_OF_RUNIC_POWER] = true,
	[ERR_OUT_OF_SOUL_SHARDS] = true,
	[ERR_OUT_OF_ARCANE_CHARGES] = true,
	[ERR_OUT_OF_COMBO_POINTS] = true,
	[ERR_OUT_OF_CHI] = true,
	[ERR_OUT_OF_POWER_DISPLAY] = true,
	[ERR_SPELL_COOLDOWN] = true,
	[ERR_ITEM_COOLDOWN] = true,
	[SPELL_FAILED_BAD_IMPLICIT_TARGETS] = true,
	[SPELL_FAILED_BAD_TARGETS] = true,
	[SPELL_FAILED_CASTER_AURASTATE] = true,
	[SPELL_FAILED_NO_COMBO_POINTS] = true,
	[SPELL_FAILED_SPELL_IN_PROGRESS] = true,
	[SPELL_FAILED_TARGET_AURASTATE] = true,
	[ERR_NO_ATTACK_TARGET] = true,
}

local firstErrorFrame = CreateFrame('Frame', 'FreeUI_Errors1', UIParent)
firstErrorFrame:SetScript('OnUpdate', FadingFrame_OnUpdate)
firstErrorFrame.fadeInTime = fadeintime
firstErrorFrame.fadeOutTime = fadeouttime
firstErrorFrame.holdTime = holdtime
firstErrorFrame:Hide()
firstErrorFrame:SetFrameStrata('TOOLTIP')
firstErrorFrame:SetFrameLevel(30)

local secondErrorFrame = CreateFrame('Frame', 'FreeUI_Errors2', UIParent)
secondErrorFrame:SetScript('OnUpdate', FadingFrame_OnUpdate)
secondErrorFrame.fadeInTime = fadeintime
secondErrorFrame.fadeOutTime = fadeouttime
secondErrorFrame.holdTime = holdtime
secondErrorFrame:Hide()
secondErrorFrame:SetFrameStrata('TOOLTIP')
secondErrorFrame:SetFrameLevel(30)



local function OnEvent(_, _, msg)
	if ignoredList[msg] and InCombatLockdown() then return end

	if state == 0 then
		firstErrorFrame.text:SetText(msg)
		FadingFrame_Show(firstErrorFrame)
		state = 1
	else
		secondErrorFrame.text:SetText(msg)
		FadingFrame_Show(secondErrorFrame)
		state = 0
	end
end


function BLIZZARD:ErrorsFrame()
	firstErrorFrame.text = F.CreateFS(firstErrorFrame, C.Assets.Fonts.Bold, 14, nil, '', 'RED', 'THICK')
	firstErrorFrame.text:SetPoint('TOP', UIParent, 0, -80)
	secondErrorFrame.text = F.CreateFS(secondErrorFrame, C.Assets.Fonts.Bold, 14, nil, '', 'RED', 'THICK')
	secondErrorFrame.text:SetPoint('TOP', UIParent, 0, -96)

	if C.DB.blizzard.concise_errors then
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
		F:RegisterEvent('UI_ERROR_MESSAGE', OnEvent)
	else
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
		F:UnregisterEvent('UI_ERROR_MESSAGE', OnEvent)
	end
end
BLIZZARD:RegisterBlizz('ErrorsFrame', BLIZZARD.ErrorsFrame)
