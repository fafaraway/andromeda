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
    if r > 0.99 and g > 0.8 and b == 0 then
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
    local prevDiff = 0

    local data = C_TooltipInfo.GetUnit(unit)
    if data then
        for i = 1, #data.lines do
            local lineData = data.lines[i]
            local argVal = lineData and lineData.args
            if argVal[1] and argVal[1].intVal == 8 then
                local text = argVal[2] and argVal[2].stringVal -- progress string
                if text then
                    local current, goal = strmatch(text, '(%d+)/(%d+)')
                    local progress = strmatch(text, '(%d+)%%')
                    if current and goal then
                        local diff = floor(goal - current)
                        if diff > prevDiff then
                            questProgress = diff
                            prevDiff = diff
                        end
                    elseif progress and prevDiff == 0 then
                        if floor(100 - progress) > 0 then
                            questProgress = progress .. '%' -- lower priority on progress, keep looking
                        end
                    end
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

    local outline = _G.ANDROMEDA_ADB.FontOutline
    local count = F.CreateFS(self, C.Assets.Fonts.Condensed, 12, outline or nil, '', nil, outline and 'NONE' or 'THICK')
    count:SetPoint('LEFT', qicon, 'RIGHT', -3, 0)
    count:SetTextColor(0.6, 0.8, 1)

    self.questIcon = qicon
    self.questCount = count
    self:RegisterEvent('QUEST_LOG_UPDATE', NAMEPLATE.UpdateQuestUnit, true)
end
