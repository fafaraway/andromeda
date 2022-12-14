local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function onEnter(self)
    if not self:IsVisible() then
        return
    end

    _G.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
    self:UpdateTooltip()
end

local function updateTooltip(self)
    local value = self:GetValue()
    local min, max = self:GetMinMaxValues()
    local name, tooltip = GetUnitPowerBarStringsByID(self.__barID)
    _G.GameTooltip:SetText(name or '', 1, 1, 1)
    _G.GameTooltip:AddLine(tooltip or '', nil, nil, nil, true)
    _G.GameTooltip:AddLine(format('%d (%d%%)', value, (value - min) / (max - min) * 100), 1, 1, 1)
    _G.GameTooltip:Show()
end

local function postUpdate(self, _, cur, _, max)
    local parent = self.__owner

    if cur and max then
        local value = parent.AltPowerTag
        local r, g, b = F:ColorGradient(cur / max, unpack(oUF.colors.smooth))

        self:SetStatusBarColor(r, g, b)
        value:SetTextColor(r, g, b)
    end

    if self:IsShown() then
        if parent.ClassPowerBar then
            parent.ClassPowerBar:ClearAllPoints()
            parent.ClassPowerBar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)
        end
    else
        if parent.ClassPowerBar then
            parent.ClassPowerBar:ClearAllPoints()
            parent.ClassPowerBar:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', 0, -3)
        end
    end
end

function UNITFRAME:CreateAlternativePowerBar(self)
    local altPower = CreateFrame('StatusBar', nil, self)
    altPower:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
    altPower:SetPoint('TOP', self.Power, 'BOTTOM', 0, -2)
    altPower:SetSize(self:GetWidth(), C.DB.Unitframe.AltPowerHeight)
    altPower:EnableMouse(true)

    F:SetSmoothing(altPower, C.DB.Unitframe.Smooth)

    altPower.bg = F.SetBD(altPower)

    altPower.UpdateTooltip = updateTooltip
    altPower:SetScript('OnEnter', onEnter)

    self.AlternativePower = altPower
    self.AlternativePower.PostUpdate = postUpdate
end


function UNITFRAME:UpdateAlternativePower()
    for _, frame in pairs(oUF.objects) do
        if C.DB.Unitframe.AlternativePower then
            if not frame:IsElementEnabled('AlternativePower') then
                frame:EnableElement('AlternativePower')
                if frame.AlternativePower then
                    frame.AlternativePower:ForceUpdate()
                end
            end
        else
            if frame:IsElementEnabled('AlternativePower') then
                frame:DisableElement('AlternativePower')
            end
        end
    end
end
