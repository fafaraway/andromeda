local F, C = unpack(select(2, ...))
local NAMEPLATE = F:GetModule('Nameplate')

local isInInstance
local function CheckInstanceStatus()
    isInInstance = IsInInstance()
end

function NAMEPLATE:QuestIconCheck()
    if not C.DB.Nameplate.QuestIndicator then
        return
    end

    CheckInstanceStatus()
    F:RegisterEvent('PLAYER_ENTERING_WORLD', CheckInstanceStatus)
end

local function isQuestTitle(textLine)
    local r, g, b = textLine:GetTextColor()
    if r > 0.99 and g > 0.82 and b == 0 then
        return true
    end
end

function NAMEPLATE:UpdateQuestUnit(_, unit)
    if not C.DB.Nameplate.QuestIndicator then
        return
    end

    local isNameOnly = self.plateType == 'NameOnly'
    local isInGroup = IsInRaid() or IsInGroup()

    if isInInstance then
        self.questIcon:Hide()
        self.questCount:SetText('')
        return
    end

    unit = unit or self.unit

    local startLooking, questProgress
    F.ScanTip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
    F.ScanTip:SetUnit(unit)

    for i = 2, F.ScanTip:NumLines() do
        local textLine = _G[C.ADDON_NAME .. 'ScanTooltipTextLeft' .. i]
        local text = textLine and textLine:GetText()

        if not text then
            break
        end

        if text ~= ' ' then
            if isInGroup and text == C.MY_NAME or (not isInGroup and isQuestTitle(textLine)) then
                startLooking = true
            elseif startLooking then
                local current, goal = string.match(text, '(%d+)/(%d+)')
                local progress = string.match(text, '(%d+)%%')
                if current and goal then
                    local diff = math.floor(goal - current)
                    if diff > 0 then
                        questProgress = diff
                        break
                    end
                elseif progress and not string.match(text, _G.THREAT_TOOLTIP) then
                    if math.floor(100 - progress) > 0 then
                        questProgress = progress .. '%' -- lower priority on progress, keep looking
                    end
                else
                    break
                end
            end
        end
    end

    if questProgress and not isNameOnly then
        self.questCount:SetText(questProgress)
        self.questIcon:SetAtlas('Warfronts-BaseMapIcons-Horde-Barracks-Minimap')
        self.questIcon:Show()
    else
        self.questCount:SetText('')
        self.questIcon:Hide()
    end
end

function NAMEPLATE:CreateQuestIndicator(self)
    if not C.DB.Nameplate.QuestIndicator then
        return
    end

    local height = C.DB.Nameplate.Height
    local qicon = self:CreateTexture(nil, 'OVERLAY', nil, 2)
    qicon:SetPoint('LEFT', self, 'RIGHT', 3, 0)
    qicon:SetSize(height + 10, height + 10)
    qicon:SetAtlas('adventureguide-microbutton-alert')
    qicon:Hide()

    local count = F.CreateFS(self, C.Assets.Font.Condensed, 12, nil, '', nil, true)
    count:SetPoint('LEFT', qicon, 'RIGHT', -3, 0)
    count:SetTextColor(0.6, 0.8, 1)

    self.questIcon = qicon
    self.questCount = count
    self:RegisterEvent('QUEST_LOG_UPDATE', NAMEPLATE.UpdateQuestUnit, true)
end
