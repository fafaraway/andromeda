local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local debuffList = {}
function UNITFRAME:UpdateRaidDebuffs()
    table.wipe(debuffList)
    for instName, value in pairs(C.RaidDebuffsList) do
        for spell, priority in pairs(value) do
            if not (_G.FREE_ADB['RaidDebuffsList'][instName] and _G.FREE_ADB['RaidDebuffsList'][instName][spell]) then
                if not debuffList[instName] then
                    debuffList[instName] = {}
                end
                debuffList[instName][spell] = priority
            end
        end
    end
    for instName, value in pairs(_G.FREE_ADB['RaidDebuffsList']) do
        for spell, priority in pairs(value) do
            if priority > 0 then
                if not debuffList[instName] then
                    debuffList[instName] = {}
                end
                debuffList[instName][spell] = priority
            end
        end
    end
end

local function ButtonOnEnter(self)
    if not self.index then
        return
    end
    _G.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:SetUnitAura(self.__owner.unit, self.index, self.filter)
    _G.GameTooltip:Show()
end

function UNITFRAME:CreateRaidDebuff(self)
    if not C.DB.Unitframe.InstanceDebuffs then return end

    local bu = CreateFrame('Frame', nil, self)
    bu:SetSize(self:GetHeight() * .6, self:GetHeight() * .6)
    bu:SetPoint('CENTER')
    bu:SetFrameLevel(self.Health:GetFrameLevel() + 2)
    bu.bg = F.CreateBDFrame(bu)
    bu.shadow = F.CreateSD(bu.bg)
    if bu.shadow then
        bu.shadow:SetFrameLevel(bu:GetFrameLevel() - 1)
    end
    bu:Hide()

    bu.icon = bu:CreateTexture(nil, 'ARTWORK')
    bu.icon:SetAllPoints()
    bu.icon:SetTexCoord(unpack(C.TexCoord))

    local parentFrame = CreateFrame('Frame', nil, bu)
    parentFrame:SetAllPoints()
    parentFrame:SetFrameLevel(bu:GetFrameLevel() + 6)

    bu.count = F.CreateFS(parentFrame, C.Assets.Fonts.Square, 12, true, '', nil, true, 'TOPRIGHT', 2, 4)
    bu.timer = F.CreateFS(bu, C.Assets.Fonts.Square, 12, true, '', nil, true, 'BOTTOMLEFT', 2, -4)

    bu.glowFrame = F.CreateGlowFrame(bu, bu:GetHeight())

    if not C.DB.Unitframe.AurasClickThrough then
        bu:SetScript('OnEnter', ButtonOnEnter)
        bu:SetScript('OnLeave', F.HideTooltip)
    end

    bu.ShowDispellableDebuff = true
    bu.ShowDebuffBorder = true

    if not next(debuffList) then
        UNITFRAME:UpdateRaidDebuffs()
    end

    bu.Debuffs = debuffList

    self.RaidDebuffs = bu
end
