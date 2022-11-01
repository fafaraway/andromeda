local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local function postUpdate(element, unit)
    local r, g, b = F:UnitColor(unit)

    if element.myBar then
        element.myBar:SetStatusBarColor(r / 2, g / 2, b / 2, 0.6)
    end

    if element.otherBar then
        element.otherBar:SetStatusBarColor(r / 2, g / 2, b / 2, 0.6)
    end

    if element.absorbBar then
        element.absorbBar:SetStatusBarColor(r / 2, g / 2, b / 2, 0.6)
    end
end

function UNITFRAME:CreateHealPrediction(self)
    local inverted = C.DB.Unitframe.InvertedColorMode

    local myBar = CreateFrame('StatusBar', nil, self.Health)
    myBar:SetPoint('TOP')
    myBar:SetPoint('BOTTOM')
    myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), inverted and 'LEFT' or 'RIGHT')
    myBar:SetStatusBarTexture(UNITFRAME.StatusBarTex)
    myBar:SetWidth(self:GetWidth())

    local otherBar = CreateFrame('StatusBar', nil, self.Health)
    otherBar:SetPoint('TOP')
    otherBar:SetPoint('BOTTOM')
    otherBar:SetPoint('LEFT', myBar:GetStatusBarTexture(), inverted and 'LEFT' or 'RIGHT')
    otherBar:SetStatusBarTexture(UNITFRAME.StatusBarTex)
    otherBar:SetWidth(self:GetWidth())

    local absorbBar = CreateFrame('StatusBar', nil, self.Health)
    absorbBar:SetPoint('TOP')
    absorbBar:SetPoint('BOTTOM')
    absorbBar:SetPoint('LEFT', otherBar:GetStatusBarTexture(), inverted and 'LEFT' or 'RIGHT')
    absorbBar:SetStatusBarTexture(C.Assets.Textures.StatusbarStripesThin)
    absorbBar:GetStatusBarTexture():SetBlendMode('ADD')
    -- absorbBar:GetStatusBarTexture():SetHorizTile(true)
    -- absorbBar:GetStatusBarTexture():SetVertTile(true)

    absorbBar:SetStatusBarColor(0.3, 0.3, 0.3, 0.8)
    absorbBar:SetWidth(self:GetWidth())

    local overAbsorb = self.Health:CreateTexture(nil, 'OVERLAY')
    overAbsorb:SetPoint('TOP', self.Health, 'TOPRIGHT', -1, 4)
    overAbsorb:SetPoint('BOTTOM', self.Health, 'BOTTOMRIGHT', -1, -4)
    overAbsorb:SetWidth(12)
    overAbsorb:SetTexture(C.Assets.Textures.Spark)
    overAbsorb:SetBlendMode('ADD')

    self.HealthPrediction = {
        myBar = myBar,
        otherBar = otherBar,
        absorbBar = absorbBar,
        overAbsorb = overAbsorb,
        maxOverflow = 1,
        frequentUpdates = true,
    }
    self.HealthPrediction.PostUpdate = postUpdate
end
