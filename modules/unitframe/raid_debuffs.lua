local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local CreateFrame = CreateFrame
local EJ_GetInstanceInfo = EJ_GetInstanceInfo

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

local raidDebuffsList = {}
function UNITFRAME:RegisterDebuff(_, instID, _, spellID, level)
    local instName = EJ_GetInstanceInfo(instID)
    if not instName then
        if C.IsDeveloper then
            print('Invalid instance ID: ' .. instID)
        end
        return
    end

    if not raidDebuffsList[instName] then
        raidDebuffsList[instName] = {}
    end
    if not level then
        level = 2
    end
    if level > 6 then
        level = 6
    end

    raidDebuffsList[instName][spellID] = level
end

function UNITFRAME:InitializeRaidDebuffs()
    for instName, value in pairs(raidDebuffsList) do
        for spell, priority in pairs(value) do
            if _G.FREE_ADB['RaidDebuffsList'][instName] and _G.FREE_ADB['RaidDebuffsList'][instName][spell] and
                _G.FREE_ADB['RaidDebuffs'][instName][spell] == priority then
                _G.FREE_ADB['RaidDebuffsList'][instName][spell] = nil
            end
        end
    end
    for instName, value in pairs(_G.FREE_ADB['RaidDebuffsList']) do
        if not next(value) then
            _G.FREE_ADB['RaidDebuffsList'][instName] = nil
        end
    end

    C.RaidDebuffsList = raidDebuffsList
end

local debuffList = {}
function UNITFRAME:UpdateRaidDebuffs()
    wipe(debuffList)
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

local function buttonOnEnter(self)
    if not self.index then
        return
    end
    _G.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:SetUnitAura(self.__owner.unit, self.index, self.filter)
    _G.GameTooltip:Show()
end

function UNITFRAME:CreateRaidDebuff(self)
    local bu = CreateFrame('Frame', nil, self)
    bu:Size(self:GetHeight() * .6)
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
        bu:SetScript('OnEnter', buttonOnEnter)
        bu:SetScript('OnLeave', F.HideTooltip)
    end

    bu.ShowDispellableDebuff = true
    bu.ShowDebuffBorder = true
    bu.FilterDispellableDebuff = true

    if C.DB.Unitframe.InstanceAuras then
        if not next(debuffList) then
            UNITFRAME:UpdateRaidDebuffs()
        end

        bu.Debuffs = debuffList
    end

    self.RaidDebuffs = bu
end
