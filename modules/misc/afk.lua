--[[
    ScreenSaver
    Credit: Zork
]]

local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local UnitIsAFK = UnitIsAFK
local GetServerTime = GetServerTime
local SecondsToClock = SecondsToClock

local F, C, L = unpack(select(2, ...))
local SS = F:RegisterModule('ScreenSaver')

function SS:Enable()
    local self = SS.Frame
    if self.isActive then
        return
    end
    self.isActive = true
    self:Show()
    self.fadeIn:Play()
end

function SS:Disable()
    local self = SS.Frame
    if not self.isActive then
        return
    end
    self.isActive = false
    self.fadeOut:Play()
end

local afkCount
function SS:OnEvent(event)
    if UnitIsAFK('player') then
        afkCount = GetServerTime()
        SS:Enable()
    else
        afkCount = nil
        SS:Disable()
    end
end

function SS:OnDoubleClick()
    SS:Disable()
end

function SS:CreateAnimation()
    local self = SS.Frame

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

function SS:CreateBackdrop()
    local self = SS.Frame
    self.bg = self:CreateTexture(nil, 'BACKGROUND', nil, -8)
    self.bg:SetColorTexture(1, 1, 1)
    self.bg:SetVertexColor(0, 0, 0, 1)
    self.bg:SetAllPoints()
end

function SS:CreateGalaxy()
    local self = SS.Frame
    self.galaxy = CreateFrame('PlayerModel', nil, self)
    self.galaxy:SetDisplayInfo(67918)
    self.galaxy:SetCamDistanceScale(2.4)
    --self.galaxy:SetRotation(math.rad(180))
    self.galaxy:SetAllPoints()
end

function SS:CreatePlayerModel()
    local self = SS.Frame
    local height = self:GetHeight()
    self.model = CreateFrame('PlayerModel', nil, self.galaxy)
    self.model:SetUnit('player')
    self.model:SetRotation(math.rad(-30))
    self.model:SetAnimation(96)
    self.model:SetSize(height, height * 1.5)
    self.model:SetPoint('BOTTOMRIGHT', height * .25, -height * .2)
end

_G.MINUTES_SECONDS = '%.2d : %.2d'
function SS:UpdateTimer()
    local self = SS.Frame
    if afkCount then
        local timeStr = SecondsToClock(GetServerTime() - afkCount)
        self.timer:SetText(timeStr)
    end
end

function SS:CreateText()
    local self = SS.Frame
    local font = C.Assets.Fonts.Combat
    self.text = F.CreateFS(self.galaxy, font, 18, 'OUTLINE', L['Double click to unlock!'], 'GREY', nil, 'TOPLEFT', 20, -20)
    self.timer = F.CreateFS(self.galaxy, font, 18, 'OUTLINE', '', 'CLASS', nil, 'TOPLEFT', 20, -40)
end

function SS:SetupScreenSaver()
    local f = CreateFrame('Button', nil, _G.UIParent)
    f:SetFrameStrata('FULLSCREEN')
    f:SetAllPoints()
    f:EnableMouse(true)
    f:SetAlpha(0)
    f:Hide()

    f:SetScript('OnUpdate', SS.UpdateTimer)
    f:SetScript('OnEvent', SS.OnEvent)
    f:SetScript('OnDoubleClick', SS.OnDoubleClick)

    f:RegisterEvent('PLAYER_FLAGS_CHANGED')
    f:RegisterEvent('PLAYER_ENTERING_WORLD')
    f:RegisterEvent('PLAYER_LEAVING_WORLD')

    SS.Frame = f

    SS:CreateAnimation()
    SS:CreateBackdrop()
    SS:CreateGalaxy()
    SS:CreatePlayerModel()
    SS:CreateText()
end

function SS:OnLogin()
    if not C.DB.General.ScreenSaver then
        return
    end

    SS:SetupScreenSaver()
end
