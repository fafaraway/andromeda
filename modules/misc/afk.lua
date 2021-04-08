local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local PlaySound = PlaySound
local UnitIsAFK = UnitIsAFK
local UnitAffectingCombat = UnitAffectingCombat
local GetServerTime = GetServerTime
local SecondsToClock = SecondsToClock

local F, C = unpack(select(2, ...))
local MISC = F.MISC

local afkStart
local function UpdateTimer(self)
    if UnitIsAFK('player') then
        if not afkStart then
            afkStart = GetServerTime()
            MISC.AFK.alphaIn:Play()
        end
    else
        afkStart = nil
        MISC.AFK.alphaOut:Play()
    end
end

local function CreateScreenSaver(self)
    local frame = CreateFrame('Frame', nil, _G.UIParent, 'BackdropTemplate')
    frame:SetPoint('TOPLEFT', 0, -300)
    frame:SetPoint('TOPRIGHT', 0, -300)
    frame:SetHeight(80)
    F.SetBD(frame, .65)

    frame:SetScript('OnUpdate', function()
        if afkStart then
            local timeStr = SecondsToClock(GetServerTime() - afkStart)
            frame.time:SetText(timeStr)
        end
    end)

    local alphaIn = frame:CreateAnimationGroup()
    alphaIn:SetScript('OnPlay', function()
        frame:Show()
    end)

    alphaIn:SetScript('OnFinished', function()
        frame:SetAlpha(1)
    end)

    local animIn = alphaIn:CreateAnimation('Alpha')
    animIn:SetDuration(.5)
    animIn:SetFromAlpha(0)
    animIn:SetToAlpha(1)
    frame.alphaIn = alphaIn

    local alphaOut = frame:CreateAnimationGroup()
    alphaOut:SetScript('OnPlay', function()
        frame.time:SetText('')
    end)

    alphaOut:SetScript('OnFinished', function()
        frame:SetAlpha(0)
        frame:Hide()
    end)

    local animOut = alphaOut:CreateAnimation('Alpha')
    animOut:SetDuration(.5)
    animOut:SetFromAlpha(1)
    animOut:SetToAlpha(0)
    frame.alphaOut = alphaOut

    local bg = frame:CreateTexture(nil, 'BACKGROUND')
    bg:SetColorTexture(0, 0, 0, .85)
    bg:SetAllPoints(_G.UIParent)

    local font = C.Assets.Fonts.Header
    frame.text = F.CreateFS(frame, font, 42, 'OUTLINE', 'You are now away', 'GREY', true, 'CENTER', 0, 0)
    frame.time = F.CreateFS(frame, font, 36, 'OUTLINE', '', 'CLASS', true, 'CENTER', 0, -60)

    MISC.AFK = frame
end

local function Refresh()
    UpdateTimer('Refresh')
end

function MISC:ScreenSaver()
    if not C.DB.General.ScreenSaver then
        return
    end

    CreateScreenSaver()
    Refresh()

    F:RegisterEvent('PLAYER_FLAGS_CHANGED', UpdateTimer)
end
MISC:RegisterMisc('ScreenSaver', MISC.ScreenSaver)
