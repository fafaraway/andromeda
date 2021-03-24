local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local FadingFrame_Show = FadingFrame_Show

local F, C = unpack(select(2, ...))
local BLIZZARD = F.BLIZZARD

local holdtime = .52
local fadeintime = .08
local fadeouttime = .16
local state = 0

local ignoredList = {
    [_G.ERR_ABILITY_COOLDOWN] = true,
    [_G.ERR_ATTACK_MOUNTED] = true,
    [_G.ERR_OUT_OF_ENERGY] = true,
    [_G.ERR_OUT_OF_FOCUS] = true,
    [_G.ERR_OUT_OF_HEALTH] = true,
    [_G.ERR_OUT_OF_MANA] = true,
    [_G.ERR_OUT_OF_RAGE] = true,
    [_G.ERR_OUT_OF_RANGE] = true,
    [_G.ERR_OUT_OF_RUNES] = true,
    [_G.ERR_OUT_OF_HOLY_POWER] = true,
    [_G.ERR_OUT_OF_RUNIC_POWER] = true,
    [_G.ERR_OUT_OF_SOUL_SHARDS] = true,
    [_G.ERR_OUT_OF_ARCANE_CHARGES] = true,
    [_G.ERR_OUT_OF_COMBO_POINTS] = true,
    [_G.ERR_OUT_OF_CHI] = true,
    [_G.ERR_OUT_OF_POWER_DISPLAY] = true,
    [_G.ERR_SPELL_COOLDOWN] = true,
    [_G.ERR_ITEM_COOLDOWN] = true,
    [_G.SPELL_FAILED_BAD_IMPLICIT_TARGETS] = true,
    [_G.SPELL_FAILED_BAD_TARGETS] = true,
    [_G.SPELL_FAILED_CASTER_AURASTATE] = true,
    [_G.SPELL_FAILED_NO_COMBO_POINTS] = true,
    [_G.SPELL_FAILED_SPELL_IN_PROGRESS] = true,
    [_G.SPELL_FAILED_TARGET_AURASTATE] = true,
    [_G.ERR_NO_ATTACK_TARGET] = true,
}

local firstErrorFrame = CreateFrame('Frame', 'FreeUI_Errors1', _G.UIParent)
firstErrorFrame:SetScript('OnUpdate', _G.FadingFrame_OnUpdate)
firstErrorFrame.fadeInTime = fadeintime
firstErrorFrame.fadeOutTime = fadeouttime
firstErrorFrame.holdTime = holdtime
firstErrorFrame:Hide()
firstErrorFrame:SetFrameStrata('TOOLTIP')
firstErrorFrame:SetFrameLevel(30)

local secondErrorFrame = CreateFrame('Frame', 'FreeUI_Errors2', _G.UIParent)
secondErrorFrame:SetScript('OnUpdate', _G.FadingFrame_OnUpdate)
secondErrorFrame.fadeInTime = fadeintime
secondErrorFrame.fadeOutTime = fadeouttime
secondErrorFrame.holdTime = holdtime
secondErrorFrame:Hide()
secondErrorFrame:SetFrameStrata('TOOLTIP')
secondErrorFrame:SetFrameLevel(30)

local function OnEvent(_, _, msg)
    if ignoredList[msg] and InCombatLockdown() then
        return
    end

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
    if _G.FREE_ADB.font_outline then
        firstErrorFrame.text = F.CreateFS(firstErrorFrame, C.Assets.Fonts.Bold, 14, true, '', 'RED', true)
        secondErrorFrame.text = F.CreateFS(secondErrorFrame, C.Assets.Fonts.Bold, 14, true, '', 'RED', true)
    else
        firstErrorFrame.text = F.CreateFS(firstErrorFrame, C.Assets.Fonts.Bold, 14, nil, '', 'RED', 'THICK')
        secondErrorFrame.text = F.CreateFS(secondErrorFrame, C.Assets.Fonts.Bold, 14, nil, '', 'RED', 'THICK')
    end
    firstErrorFrame.text:SetPoint('TOP', _G.UIParent, 0, -80)
    secondErrorFrame.text:SetPoint('TOP', _G.UIParent, 0, -96)

    if C.DB.blizzard.concise_errors then
        _G.UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
        F:RegisterEvent('UI_ERROR_MESSAGE', OnEvent)
    else
        _G.UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
        F:UnregisterEvent('UI_ERROR_MESSAGE', OnEvent)
    end
end
BLIZZARD:RegisterBlizz('ErrorsFrame', BLIZZARD.ErrorsFrame)
