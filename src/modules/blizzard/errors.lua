local F, C = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

local holdtime = 0.52
local fadeintime = 0.08
local fadeouttime = 0.16
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

local function CreateErrorFrames()
    local font = C.Assets.Font.Bold
    local outline = _G.ANDROMEDA_ADB.FontOutline

    local frame1 = CreateFrame('Frame', C.ADDON_TITLE .. 'ErrorFrame1', _G.UIParent)
    frame1:SetScript('OnUpdate', _G.FadingFrame_OnUpdate)
    frame1.fadeInTime = fadeintime
    frame1.fadeOutTime = fadeouttime
    frame1.holdTime = holdtime
    frame1:Hide()
    frame1:SetFrameStrata('TOOLTIP')
    frame1:SetFrameLevel(30)
    frame1.text = F.CreateFS(frame1, font, 14, outline, '', 'RED', outline or 'THICK')
    frame1.text:SetPoint('TOP', _G.UIParent, 0, -80)

    local frame2 = CreateFrame('Frame', C.ADDON_TITLE .. 'ErrorFrame2', _G.UIParent)
    frame2:SetScript('OnUpdate', _G.FadingFrame_OnUpdate)
    frame2.fadeInTime = fadeintime
    frame2.fadeOutTime = fadeouttime
    frame2.holdTime = holdtime
    frame2:Hide()
    frame2:SetFrameStrata('TOOLTIP')
    frame2:SetFrameLevel(30)
    frame2.text = F.CreateFS(frame2, font, 14, outline, '', 'RED', outline or 'THICK')
    frame2.text:SetPoint('TOP', _G.UIParent, 0, -96)

    BLIZZARD.ErrorFrame1 = frame1
    BLIZZARD.ErrorFrame2 = frame2
end

local function OnEvent(_, _, msg)
    if ignoredList[msg] and InCombatLockdown() then
        return
    end

    if state == 0 then
        BLIZZARD.ErrorFrame1.text:SetText(msg)
        _G.FadingFrame_Show(BLIZZARD.ErrorFrame1)
        state = 1
    else
        BLIZZARD.ErrorFrame2.text:SetText(msg)
        _G.FadingFrame_Show(BLIZZARD.ErrorFrame2)
        state = 0
    end
end

function BLIZZARD:SimplifyErrors()
    CreateErrorFrames()

    if C.DB.General.SimplifyErrors then
        _G.UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
        F:RegisterEvent('UI_ERROR_MESSAGE', OnEvent)
    else
        _G.UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
        F:UnregisterEvent('UI_ERROR_MESSAGE', OnEvent)
    end
end
BLIZZARD:RegisterBlizz('SimplifyErrors', BLIZZARD.SimplifyErrors)
