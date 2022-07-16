local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local debuffList = {}
function UNITFRAME:UpdateDebuffWatcher()
    wipe(debuffList)
    for instName, value in pairs(C.DebuffWatcherList) do
        for spell, priority in pairs(value) do
            if
                not (_G.ANDROMEDA_ADB['DebuffWatcherList'][instName] and _G.ANDROMEDA_ADB['DebuffWatcherList'][instName][spell])
            then
                if not debuffList[instName] then
                    debuffList[instName] = {}
                end
                debuffList[instName][spell] = priority
            end
        end
    end
    for instName, value in pairs(_G.ANDROMEDA_ADB['DebuffWatcherList']) do
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

local function Button_OnEnter(self)
    if not self.index then
        return
    end
    _G.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:SetUnitAura(self.__owner.unit, self.index, self.filter)
    _G.GameTooltip:Show()
end

function UNITFRAME:CreateDebuffWatcher(self)
    if not C.DB.Unitframe.DebuffWatcher then
        return
    end

    local bu = CreateFrame('Frame', nil, self)
    bu:SetSize(self:GetHeight() * 0.6, self:GetHeight() * 0.6)
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
    bu.icon:SetTexCoord(unpack(C.TEX_COORD))

    local parentFrame = CreateFrame('Frame', nil, bu)
    parentFrame:SetAllPoints()
    parentFrame:SetFrameLevel(bu:GetFrameLevel() + 6)

    local font = C.Assets.Font.Roadway
    local fontSize = max(bu:GetHeight() * 0.4, 12)
    bu.count = F.CreateFS(parentFrame, font, fontSize, true, '', nil, true)
    bu.count:SetPoint('CENTER', bu, 'TOP')
    bu.timer = F.CreateFS(parentFrame, font, fontSize, true, '', nil, true)
    bu.timer:SetPoint('CENTER', bu, 'BOTTOM')

    bu.glowFrame = F.CreateGlowFrame(bu, bu:GetHeight())

    if not C.DB.Unitframe.DebuffClickThrough then
        bu:SetScript('OnEnter', Button_OnEnter)
        bu:SetScript('OnLeave', F.HideTooltip)
    end

    bu.ShowDispellableDebuff = true
    bu.ShowDebuffBorder = true

    if C.DB.Unitframe.InstanceDebuffs then
        if not next(debuffList) then
            UNITFRAME:UpdateDebuffWatcher()
        end

        bu.Debuffs = debuffList
    end

    self.DebuffWatcher = bu
end

local instanceDebuffs = {}
function UNITFRAME:RegisterInstanceDebuff(_, instID, _, spellID, level)
    local instName = EJ_GetInstanceInfo(instID)
    if not instName then
        if C.IS_DEVELOPER then
            print('Invalid instance ID: ' .. instID)
        end
        return
    end

    if not instanceDebuffs[instName] then
        instanceDebuffs[instName] = {}
    end
    if not level then
        level = 2
    end
    if level > 6 then
        level = 6
    end

    instanceDebuffs[instName][spellID] = level
end

function UNITFRAME:InitDebuffWatcher()
    for instName, value in pairs(instanceDebuffs) do
        for spell, priority in pairs(value) do
            if
                _G.ANDROMEDA_ADB['DebuffWatcherList'][instName]
                and _G.ANDROMEDA_ADB['DebuffWatcherList'][instName][spell]
                and _G.ANDROMEDA_ADB['DebuffWatcherList'][instName][spell] == priority
            then
                _G.ANDROMEDA_ADB['DebuffWatcherList'][instName][spell] = nil
            end
        end
    end
    for instName, value in pairs(_G.ANDROMEDA_ADB['DebuffWatcherList']) do
        if not next(value) then
            _G.ANDROMEDA_ADB['DebuffWatcherList'][instName] = nil
        end
    end

    instanceDebuffs[0] = {} -- OTHER spells

    C.DebuffWatcherList = instanceDebuffs
end
