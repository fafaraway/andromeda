local F, C, L = unpack(select(2, ...))
local M = F:RegisterModule('ScreenSaver')

function M:Enable()
    local self = M.Frame
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

function M:Disable()
    local self = M.Frame
    if not self then
        return
    end
    if not self.isActive then
        return
    end
    self.isActive = false
    self.fadeOut:Play()
end

local afkCount
function M:OnEvent()
    if UnitIsAFK('player') then
        afkCount = GetServerTime()
        M:Enable()
    else
        afkCount = nil
        M:Disable()
    end
end

function M:OnDoubleClick()
    M:Disable()
end

function M:CreateAnimation()
    local self = M.Frame

    self.fadeIn = self:CreateAnimationGroup()
    self.fadeIn.anim = self.fadeIn:CreateAnimation('Alpha')
    self.fadeIn.anim:SetDuration(1)
    self.fadeIn.anim:SetSmoothing('OUT')
    self.fadeIn.anim:SetFromAlpha(0)
    self.fadeIn.anim:SetToAlpha(1)
    self.fadeIn:HookScript(
        'OnFinished',
        function(self)
            self:GetParent():SetAlpha(1)
        end
    )

    self.fadeOut = self:CreateAnimationGroup()
    self.fadeOut.anim = self.fadeOut:CreateAnimation('Alpha')
    self.fadeOut.anim:SetDuration(1)
    self.fadeOut.anim:SetSmoothing('OUT')
    self.fadeOut.anim:SetFromAlpha(1)
    self.fadeOut.anim:SetToAlpha(0)
    self.fadeOut:HookScript(
        'OnFinished',
        function(self)
            self:GetParent():SetAlpha(0)
            self:GetParent():Hide()
        end
    )
end

function M:CreateBackdrop()
    local self = M.Frame
    self.bg = self:CreateTexture(nil, 'BACKGROUND', nil, -8)
    self.bg:SetColorTexture(1, 1, 1)
    self.bg:SetVertexColor(0, 0, 0, 1)
    self.bg:SetAllPoints()
end

function M:CreateGalaxy()
    local self = M.Frame
    self.galaxy = CreateFrame('PlayerModel', nil, self)
    self.galaxy:SetDisplayInfo(67918)
    self.galaxy:SetCamDistanceScale(2.4)
    --self.galaxy:SetRotation(math.rad(180))
    self.galaxy:SetAllPoints()
end

function M:CreatePlayerModel()
    local self = M.Frame
    local height = self:GetHeight()
    self.model = CreateFrame('PlayerModel', nil, self.galaxy)
    self.model:SetUnit('player')
    self.model:SetRotation(math.rad(-30))
    self.model:SetAnimation(96)
    self.model:SetSize(height, height * 1.5)
    self.model:SetPoint('BOTTOMRIGHT', height * .25, -height * .2)
end

_G.MINUTES_SECONDS = '%.2d : %.2d'
function M:UpdateTimer()
    local self = M.Frame
    if afkCount then
        local timeStr = SecondsToClock(GetServerTime() - afkCount)
        self.timer:SetText(timeStr)
    end
end

function M:CreateScreenSaverFrame()
    local f = CreateFrame('Button', nil, _G.UIParent)
    f:SetFrameStrata('FULLSCREEN')
    f:SetAllPoints()
    f:EnableMouse(true)
    f:SetAlpha(0)
    f:Hide()

    M.Frame = f
end

function M:CreateText()
    local self = M.Frame
    local font = C.Assets.Font.Header
    self.text = F.CreateFS(self.galaxy, font, 18, 'OUTLINE', L['Double click to unlock!'], 'GREY', nil, 'TOPLEFT', 20, -20)
    self.timer = F.CreateFS(self.galaxy, font, 18, 'OUTLINE', '', 'CLASS', nil, 'TOPLEFT', 20, -40)
end

function M:SetupScreenSaver()
    M.Frame:SetScript('OnUpdate', M.UpdateTimer)
    M.Frame:SetScript('OnEvent', M.OnEvent)
    M.Frame:SetScript('OnDoubleClick', M.OnDoubleClick)

    M.Frame:RegisterEvent('PLAYER_FLAGS_CHANGED')
    M.Frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    M.Frame:RegisterEvent('PLAYER_LEAVING_WORLD')
end

function M:UpdateScreenSaver()
    if C.DB.General.ScreenSaver then
        M.Frame:SetScript('OnUpdate', M.UpdateTimer)
        M.Frame:SetScript('OnEvent', M.OnEvent)
        M.Frame:SetScript('OnDoubleClick', M.OnDoubleClick)

        M.Frame:RegisterEvent('PLAYER_FLAGS_CHANGED')
        M.Frame:RegisterEvent('PLAYER_ENTERING_WORLD')
        M.Frame:RegisterEvent('PLAYER_LEAVING_WORLD')
    else
        M.Frame:SetScript('OnUpdate', nil)
        M.Frame:SetScript('OnEvent', nil)
        M.Frame:SetScript('OnDoubleClick', nil)

        M.Frame:UnregisterEvent('PLAYER_FLAGS_CHANGED')
        M.Frame:UnregisterEvent('PLAYER_ENTERING_WORLD')
        M.Frame:UnregisterEvent('PLAYER_LEAVING_WORLD')
    end
end

function M:OnLogin()
    if not C.DB.General.ScreenSaver then
        return
    end

    M:CreateScreenSaverFrame()
    M:CreateAnimation()
    M:CreateBackdrop()
    M:CreateGalaxy()
    M:CreatePlayerModel()
    M:CreateText()
    M:SetupScreenSaver()
end
