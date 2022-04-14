local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

function UNITFRAME:CreateGCDTicker(self)
    local bar = CreateFrame('StatusBar', nil, self)
    bar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
    bar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
    bar:GetStatusBarTexture():SetAlpha(0)
    bar:SetAllPoints()

    bar.spark = bar:CreateTexture(nil, 'OVERLAY')
    bar.spark:SetTexture(C.Assets.Texture.Spark)
    bar.spark:SetBlendMode('ADD')
    bar.spark:SetPoint('TOPLEFT', bar:GetStatusBarTexture(), 'TOPRIGHT', -10, 10)
    bar.spark:SetPoint('BOTTOMRIGHT', bar:GetStatusBarTexture(), 'BOTTOMRIGHT', 10, -10)

    self.GCD = bar
end

function UNITFRAME:UpdateGCDTicker()
    local frame = _G.oUF_Player
    if not frame then
        return
    end

    if C.DB.Unitframe.GCDIndicator then
        if not frame:IsElementEnabled('GCD') then
            frame:EnableElement('GCD')
            if frame.GCD then
                frame.GCD:ForceUpdate()
            end
        end
    else
        if frame:IsElementEnabled('GCD') then
            frame:DisableElement('GCD')
        end
    end
end
