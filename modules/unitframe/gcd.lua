local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

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

function UNITFRAME:ToggleGCDTicker()
    local player = _G.oUF_Player
    local ticker = player and player.GCDTicker
    if not ticker then
        return
    end

    ticker:SetShown(C.DB.Unitframe.GCDIndicator)
end

function UNITFRAME:CreateGCDTicker(self)
    local ticker = CreateFrame('StatusBar', nil, self)
    ticker:SetFrameLevel(self.Health:GetFrameLevel() + 1)
    ticker:SetStatusBarTexture(C.Assets.bd_tex)
    ticker:GetStatusBarTexture():SetAlpha(0)
    ticker:SetAllPoints()

    local spark = ticker:CreateTexture(nil, 'OVERLAY')
    spark:SetTexture(C.Assets.spark_tex)
    spark:SetBlendMode('ADD')
    spark:SetPoint('TOPLEFT', ticker:GetStatusBarTexture(), 'TOPRIGHT', -10, 10)
    spark:SetPoint('BOTTOMRIGHT', ticker:GetStatusBarTexture(), 'BOTTOMRIGHT', 10, -10)

    ticker.spark = spark

    ticker:SetScript('OnUpdate', UpdateGCDTicker)
    self.GCDTicker = ticker

    UNITFRAME:ToggleGCDTicker()
end
