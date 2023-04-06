local F, C = unpack(select(2, ...))
local NAMEPLATE = F:GetModule('Nameplate')

local isInInstance
local function checkInstanceStatus()
    isInInstance = IsInInstance()
end

function NAMEPLATE:QuestIconCheck()
    if not C.DB.Nameplate.QuestIndicator then
        return
    end

    checkInstanceStatus()
    F:RegisterEvent('PLAYER_ENTERING_WORLD', checkInstanceStatus)
end

function NAMEPLATE:UpdateQuestUnit(_, unit)
    if not C.DB.Nameplate.QuestIndicator then
        return
    end

    local isNameOnly = self.plateType == 'NameOnly'

    if isInInstance then
        self.questIcon:Hide()
        self.questCount:SetText('')
        return
    end

    unit = unit or self.unit

    local questProgress
    local prevDiff = 0

    local data = C_TooltipInfo.GetUnit(unit)
    if data then
        if C.IS_NEW_PATCH_10_1 then
            for i = 1, #data.lines do
                local lineData = data.lines[i]
                if lineData.type == 8 then
                    local text = lineData.leftText -- progress string
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
        else
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

function NAMEPLATE:CreateQuestIndicator(frame)
    if not C.DB.Nameplate.QuestIndicator then
        return
    end

    local height = C.DB.Nameplate.Height
    local qicon = frame:CreateTexture(nil, 'OVERLAY', nil, 2)
    qicon:SetPoint('LEFT', frame, 'RIGHT', 3, 0)
    qicon:SetSize(height + 10, height + 10)
    qicon:SetAtlas('adventureguide-microbutton-alert')
    qicon:Hide()

    local outline = _G.ANDROMEDA_ADB.FontOutline
    local count = F.CreateFS(frame, C.Assets.Fonts.Condensed, 12, outline or nil, '', nil, outline and 'NONE' or 'THICK')
    count:SetPoint('LEFT', qicon, 'RIGHT', -3, 0)
    count:SetTextColor(0.6, 0.8, 1)

    frame.questIcon = qicon
    frame.questCount = count
    frame:RegisterEvent('QUEST_LOG_UPDATE', NAMEPLATE.UpdateQuestUnit, true)
end
