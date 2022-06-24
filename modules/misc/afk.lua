local F, C, L = unpack(select(2, ...))
local SS = F:RegisterModule('ScreenSaver')

local function Enable()
    local self = SS.ScreenSaver
    if not self then
        return
    end

    if self.isActive then
        return
    end

    self.isActive = true
    self:Show()
    self.fadeIn:Play()
end

local function Disable()
    local self = SS.ScreenSaver
    if not self then
        return
    end

    if not self.isActive then
        return
    end

    self.isActive = false
    self.fadeOut:Play()
end

local afkStart = nil
local function OnEvent()
    if _G.UnitIsAFK('player') then
        if not afkStart then
            afkStart = _G.GetServerTime()
            Enable()
        end

        if _G.UnitAffectingCombat('player') then
            _G.PlaySound(15262, 'MASTER')
            Disable()
        end
    else
        afkStart = nil
        Disable()
    end
end

local function FormatTimer(seconds)
    local units = ConvertSecondsToUnits(seconds)
    if units.hours > 0 then
        return string.format('%.2d : %.2d : %.2d', units.hours, units.minutes, units.seconds)
    else
        return string.format('%.2d : %.2d', units.minutes, units.seconds)
    end
end

local function OnUpdate(self)
    if afkStart then
        local timeStr = FormatTimer(GetServerTime() - afkStart)
        self.timer:SetText(timeStr)
    end
end

local function OnKeyUp(_, key)
    local self = SS.ScreenSaver
    if not self then
        return
    end
    if key == 'ESCAPE' then
        if self:IsShown() then
            Disable()
        end
    end
end

local function ConstructTextString(f)
    f.text = F.CreateFS(
        f,
        C.Assets.Font.Bold,
        12,
        nil,
        L['Double click left mouse button or press ESC key to exit this screen.'],
        { 0.3, 0.3, 0.3 },
        'THICK',
        'BOTTOM',
        0,
        C.UI_GAP
    )
    f.timer = F.CreateFS(
        f,
        C.ASSET_PATH .. 'fonts\\header.ttf',
        56,
        nil,
        'timer',
        'CLASS',
        'THICK',
        'TOP',
        0,
        -C.UI_GAP
    )
end

local function ConstructAnimation(f)
    local fadeIn = f:CreateAnimationGroup()
    fadeIn.anim = fadeIn:CreateAnimation('Alpha')
    fadeIn.anim:SetDuration(2)
    fadeIn.anim:SetSmoothing('OUT')
    fadeIn.anim:SetFromAlpha(0)
    fadeIn.anim:SetToAlpha(1)
    fadeIn:HookScript('OnFinished', function(self)
        self:GetParent():SetAlpha(1)
    end)
    f.fadeIn = fadeIn

    local fadeOut = f:CreateAnimationGroup()
    fadeOut.anim = fadeOut:CreateAnimation('Alpha')
    fadeOut.anim:SetDuration(1)
    fadeOut.anim:SetSmoothing('OUT')
    fadeOut.anim:SetFromAlpha(1)
    fadeOut.anim:SetToAlpha(0)
    fadeOut:HookScript('OnFinished', function(self)
        self:GetParent():SetAlpha(0)
        self:GetParent():Hide()
    end)
    f.fadeOut = fadeOut
end

local function ConstructModel(f)
    f.galaxy = CreateFrame('PlayerModel', nil, f)
    f.galaxy:SetDisplayInfo(67918)
    f.galaxy:SetCamDistanceScale(2.4)
    -- f.galaxy:SetRotation(math.rad(180))
    f.galaxy:SetAllPoints()

    local height = f:GetHeight()
    f.model = CreateFrame('PlayerModel', nil, f.galaxy)
    f.model:SetUnit('player')
    f.model:SetRotation(math.rad(-30))
    f.model:SetAnimation(96)
    f.model:SetSize(height, height * 1.5)
    f.model:SetPoint('BOTTOMRIGHT', height * 0.25, -height * 0.2)
end

function SS:UpdateScreenSaver()
    local f = _G[C.ADDON_TITLE .. 'ScreenSave']

    if not f then return end

    if C.DB.General.ScreenSaver then
        if not f then
            SS:CreateScreenSaver()
        end

        f:SetScript('OnKeyUp', OnKeyUp)
        f:SetScript('OnDoubleClick', Disable)
        f:SetScript('OnUpdate', OnUpdate)

        F:RegisterEvent('PLAYER_FLAGS_CHANGED', OnEvent)
        F:RegisterEvent('PLAYER_REGEN_DISABLED', OnEvent)
        F:RegisterEvent('PLAYER_REGEN_ENABLED', OnEvent)
    else
        if f then
            f:Hide()
        end

        f:SetScript('OnKeyUp', nil)
        f:SetScript('OnDoubleClick', nil)
        f:SetScript('OnUpdate', nil)

        F:UnregisterEvent('PLAYER_FLAGS_CHANGED', OnEvent)
        F:UnregisterEvent('PLAYER_REGEN_DISABLED', OnEvent)
        F:UnregisterEvent('PLAYER_REGEN_ENABLED', OnEvent)
    end
end

function SS:CreateScreenSaver()
    if InCombatLockdown() then
        return
    end
    if _G[C.ADDON_TITLE .. 'ScreenSave'] then
        return
    end

    local f = CreateFrame('Button', C.ADDON_TITLE .. 'ScreenSave', _G.UIParent)
    f:SetFrameStrata('FULLSCREEN')
    f:SetAllPoints()
    f:EnableMouse(true)
    f:SetAlpha(0)
    f:Hide()

    f.bg = F.SetBD(f)
    f.bg:SetBackdropColor(0, 0, 0, 1)

    ConstructAnimation(f)
    ConstructModel(f)
    ConstructTextString(f)

    SS.ScreenSaver = f

    f:SetScript('OnKeyUp', OnKeyUp)
    f:SetScript('OnDoubleClick', Disable)
    f:SetScript('OnUpdate', OnUpdate)

    F:RegisterEvent('PLAYER_FLAGS_CHANGED', OnEvent)
    F:RegisterEvent('PLAYER_REGEN_DISABLED', OnEvent)
    F:RegisterEvent('PLAYER_REGEN_ENABLED', OnEvent)
end

function SS:OnLogin()
    if not C.DB.General.ScreenSaver then
        return
    end

    SS:CreateScreenSaver()
end
