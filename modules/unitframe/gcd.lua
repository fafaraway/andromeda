local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

local function UpdateGCDTicker(self)
    local start, duration = GetSpellCooldown(61304)
    if start > 0 and duration > 0 then
        if self.duration ~= duration then
            self:SetMinMaxValues(0, duration)
            self.duration = duration
        end
        self:SetValue(GetTime() - start)
        self.spark:Show()
    else
        self.spark:Hide()
    end
end

function UNITFRAME:CreateGCDTicker(self)
    local ticker = CreateFrame('StatusBar', nil, self)
    ticker:SetFrameLevel(self.Health:GetFrameLevel() + 1)
    ticker:SetStatusBarTexture(C.Assets.norm_tex)
    ticker:GetStatusBarTexture():SetAlpha(0)
    ticker:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 0)
    ticker:SetWidth(self:GetWidth())
    ticker:SetHeight(6)

    local spark = ticker:CreateTexture(nil, 'OVERLAY')
    spark:SetTexture(C.Assets.spark_tex)
    spark:SetBlendMode('ADD')
    spark:SetPoint('TOPLEFT', ticker:GetStatusBarTexture(), 'TOPRIGHT', -3, 3)
    spark:SetPoint('BOTTOMRIGHT', ticker:GetStatusBarTexture(), 'BOTTOMRIGHT', 3, -3)

    ticker.spark = spark

    ticker:SetScript('OnUpdate', UpdateGCDTicker)
    self.GCDTicker = ticker
end
