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
    ticker:SetStatusBarTexture(C.Assets.Texture.Backdrop)
    ticker:GetStatusBarTexture():SetAlpha(0)

    local separateCastbar = C.DB.Unitframe.SeparateCastbar
    if separateCastbar then
        ticker:SetAllPoints()
    else
        ticker:SetPoint('BOTTOMLEFT', self, 'TOPLEFT')
        ticker:SetWidth(self:GetWidth())
        ticker:SetHeight(6)
    end

    local spark = ticker:CreateTexture(nil, 'OVERLAY')
    spark:SetTexture(C.Assets.Texture.Spark)
    spark:SetBlendMode('ADD')

    if separateCastbar then
        spark:SetPoint('TOPLEFT', ticker:GetStatusBarTexture(), 'TOPRIGHT', -10, 10)
        spark:SetPoint('BOTTOMRIGHT', ticker:GetStatusBarTexture(), 'BOTTOMRIGHT', 10, -10)
    else
        spark:SetPoint('TOPLEFT', ticker:GetStatusBarTexture(), 'TOPRIGHT', -3, 3)
        spark:SetPoint('BOTTOMRIGHT', ticker:GetStatusBarTexture(), 'BOTTOMRIGHT', 3, -3)
    end

    ticker.spark = spark

    ticker:SetScript('OnUpdate', UpdateGCDTicker)
    self.GCDTicker = ticker

    UNITFRAME:ToggleGCDTicker()
end
