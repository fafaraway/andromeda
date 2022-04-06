local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local function OnUpdate(self)
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
    local bar = CreateFrame('StatusBar', nil, self)
    bar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
    bar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
    bar:GetStatusBarTexture():SetAlpha(0)
    bar:SetAllPoints()

    local spark = bar:CreateTexture(nil, 'OVERLAY')
    spark:SetTexture(C.Assets.Texture.Spark)
    spark:SetBlendMode('ADD')
    spark:SetPoint('TOPLEFT', bar:GetStatusBarTexture(), 'TOPRIGHT', -10, 10)
    spark:SetPoint('BOTTOMRIGHT', bar:GetStatusBarTexture(), 'BOTTOMRIGHT', 10, -10)
    bar.spark = spark

    bar:SetScript('OnUpdate', OnUpdate)
    self.GCDTicker = bar
end

function UNITFRAME:UpdateGCDTicker()
    local player = _G.oUF_Player
    local bar = player and player.GCDTicker
    if not bar then
        return
    end

    bar:SetShown(C.DB.Unitframe.GCDIndicator)
end
