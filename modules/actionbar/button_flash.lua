local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetActionButtonForID = GetActionButtonForID

local F, C = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

local offset = 10

function ACTIONBAR:SetupButtonFlash()
    local frame = CreateFrame('Frame', nil)
    frame:SetFrameStrata('TOOLTIP')

    local texture = frame:CreateTexture()
    texture:SetTexture([[Interface\Cooldown\star4]])
    texture:SetAlpha(0)
    texture:SetAllPoints(frame)
    texture:SetBlendMode('ADD')
    texture:SetDrawLayer('OVERLAY', 7)

    local animation = texture:CreateAnimationGroup()

    local alpha = animation:CreateAnimation('Alpha')
    alpha:SetFromAlpha(0)
    alpha:SetToAlpha(1)
    alpha:SetDuration(0)
    alpha:SetOrder(1)

    local scale1 = animation:CreateAnimation('Scale')
    scale1:SetScale(1.5, 1.5)
    scale1:SetDuration(0)
    scale1:SetOrder(1)

    local scale2 = animation:CreateAnimation('Scale')
    scale2:SetScale(0, 0)
    scale2:SetDuration(.3)
    scale2:SetOrder(2)

    local rotation = animation:CreateAnimation('Rotation')
    rotation:SetDegrees(90)
    rotation:SetDuration(.3)
    rotation:SetOrder(2)

    self.overlay = frame
    self.animation = animation
end

function ACTIONBAR:ActionButtonDown(id)
    local button = GetActionButtonForID(id)
    if (button) then
        self:AnimateButton(button)
    end
end

function ACTIONBAR:MultiActionButtonDown(bar, id)
    local button = _G[bar .. 'Button' .. id]
    if (button) then
        self:AnimateButton(button)
    end
end

function ACTIONBAR:AnimateButton(button)
    if (not button:IsVisible()) then
        return
    end

    self.overlay:SetParent(button)
    self.overlay:ClearAllPoints()
    self.overlay:SetPoint('TOPLEFT', button, 'TOPLEFT', -offset, offset)
    self.overlay:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', offset, -offset)

    self.animation:Stop()
    self.animation:Play()
end

local function Button_ActionButtonDown(id)
    ACTIONBAR:ActionButtonDown(id)
end

local function Button_MultiActionButtonDown(bar, id)
    ACTIONBAR:MultiActionButtonDown(bar, id)
end

function ACTIONBAR:HookActionEvents()
    hooksecurefunc('ActionButtonDown', Button_ActionButtonDown)
    hooksecurefunc('MultiActionButtonDown', Button_MultiActionButtonDown)
end

function ACTIONBAR:ButtonFlash()
    if not C.DB.Actionbar.ButtonFlash then
        return
    end

    self:SetupButtonFlash()
    self:HookActionEvents()
end
