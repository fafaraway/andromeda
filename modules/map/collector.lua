local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('Map')

local buttonBlackList = {
    ['MiniMapLFGFrame'] = true,
    ['BattlefieldMinimap'] = true,
    ['MinimapBackdrop'] = true,
    ['TimeManagerClockButton'] = true,
    ['FeedbackUIButton'] = true,
    ['MiniMapBattlefieldFrame'] = true,
    ['QueueStatusMinimapButton'] = true,
    ['GarrisonLandingPageMinimapButton'] = true,
    ['MinimapZoneTextButton'] = true,
    ['FreeUIMinimapAddOnIconCollectorTray'] = true,
    ['FreeUIMinimapAddOnIconCollector'] = true,
}

local ignoredButtons = {
    ['GatherMatePin'] = true,
    ['HandyNotes.-Pin'] = true,
}

local isGoodLookingIcon = {
    ['Narci_MinimapButton'] = true,
}

local function UpdateCollectorTip(bu)
    bu.text = C.MOUSE_RIGHT_BUTTON
        .. L['Auto Hide']
        .. ': '
        .. (
            FREE_ADB['MinimapAddOnCollector'] and '|cff55ff55' .. VIDEO_OPTIONS_ENABLED
            or '|cffff5555' .. VIDEO_OPTIONS_DISABLED
        )
end

local function HideCollectorTray()
    Minimap.AddOnCollectorTray:Hide()
end

local function ClickFunc(force)
    if force == 1 or FREE_ADB['MinimapAddOnCollector'] then
        F:UIFrameFadeOut(Minimap.AddOnCollectorTray, 0.5, 1, 0)
        F:Delay(0.5, HideCollectorTray)
    end
end

local function IsButtonIgnored(name)
    for addonName in pairs(ignoredButtons) do
        if string.match(name, addonName) then
            return true
        end
    end
end

local iconsPerRow = 5
local rowMult = iconsPerRow / 2 - 1
local currentIndex, pendingTime, timeThreshold = 0, 5, 12
local buttons, numMinimapChildren = {}, 0
local removedTextures = {
    [136430] = true,
    [136467] = true,
}

local function RestyleAddOnIcon(child, name)
    for j = 1, child:GetNumRegions() do
        local region = select(j, child:GetRegions())
        if region:IsObjectType('Texture') then
            local texture = region:GetTexture() or ''
            if
                removedTextures[texture]
                or string.find(texture, 'Interface\\CharacterFrame')
                or string.find(texture, 'Interface\\Minimap')
            then
                region:SetTexture(nil)
            end
            region:ClearAllPoints()
            region:SetAllPoints()
            if not isGoodLookingIcon[name] then
                region:SetTexCoord(unpack(C.TEX_COORD))
            end
        end
        child:SetSize(24, 24)
        child.bg = F.CreateBDFrame(child, 1)
        child.bg:SetBackdropBorderColor(0, 0, 0)
    end

    table.insert(buttons, child)
end

local function KillAddOnIcon()
    for _, child in pairs(buttons) do
        if not child.styled then
            child:SetParent(Minimap.AddOnCollectorTray)
            if child:HasScript('OnDragStop') then
                child:SetScript('OnDragStop', nil)
            end
            if child:HasScript('OnDragStart') then
                child:SetScript('OnDragStart', nil)
            end
            if child:HasScript('OnClick') then
                child:HookScript('OnClick', ClickFunc)
            end

            if child:IsObjectType('Button') then
                child:SetHighlightTexture(C.Assets.Texture.Backdrop) -- prevent nil function
                child:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
            elseif child:IsObjectType('Frame') then
                child.highlight = child:CreateTexture(nil, 'HIGHLIGHT')
                child.highlight:SetAllPoints()
                child.highlight:SetColorTexture(1, 1, 1, 0.25)
            end

            -- Naughty Addons
            local name = child:GetName()
            if name == 'DBMMinimapButton' then
                child:SetScript('OnMouseDown', nil)
                child:SetScript('OnMouseUp', nil)
            elseif name == 'BagSync_MinimapButton' then
                child:HookScript('OnMouseUp', ClickFunc)
            end

            child.styled = true
        end
    end
end

local function CollectRubbish()
    local numChildren = Minimap:GetNumChildren()
    if numChildren ~= numMinimapChildren then
        for i = 1, numChildren do
            local child = select(i, Minimap:GetChildren())
            local name = child and child.GetName and child:GetName()
            if name and not child.isExamed and not buttonBlackList[name] then
                if
                    (child:IsObjectType('Button') or string.match(string.upper(name), 'BUTTON'))
                    and not IsButtonIgnored(name)
                then
                    RestyleAddOnIcon(child, name)
                end
                child.isExamed = true
            end
        end

        numMinimapChildren = numChildren
    end

    KillAddOnIcon()

    currentIndex = currentIndex + 1
    if currentIndex < timeThreshold then
        F:Delay(pendingTime, CollectRubbish)
    end
end

local shownButtons = {}
local function SortRubbish()
    if #buttons == 0 then
        return
    end

    table.wipe(shownButtons)
    for _, button in pairs(buttons) do
        if next(button) and button:IsShown() then -- fix for fuxking AHDB
            table.insert(shownButtons, button)
        end
    end

    local numShown = #shownButtons
    local row = numShown == 0 and 1 or F:Round((numShown + rowMult) / iconsPerRow)
    local newHeight = row * 24
    Minimap.AddOnCollectorTray:SetHeight(newHeight)

    for index, button in pairs(shownButtons) do
        button:ClearAllPoints()
        if index == 1 then
            button:SetPoint('BOTTOMRIGHT', Minimap.AddOnCollectorTray, -3, 3)
        elseif row > 1 and math.fmod(index, row) == 1 or row == 1 then
            button:SetPoint('RIGHT', shownButtons[index - row], 'LEFT', -3, 0)
        else
            button:SetPoint('BOTTOM', shownButtons[index - 1], 'TOP', 0, 3)
        end
    end
end

local function Button_OnClick(self, btn)
    if btn == 'RightButton' then
        FREE_ADB['MinimapAddOnCollector'] = not FREE_ADB['MinimapAddOnCollector']
        UpdateCollectorTip(Minimap.AddOnCollector)
        Minimap.AddOnCollector:GetScript('OnEnter')(Minimap.AddOnCollector)
    else
        if Minimap.AddOnCollectorTray:IsShown() then
            ClickFunc(1)
        else
            SortRubbish()
            F:UIFrameFadeIn(Minimap.AddOnCollectorTray, 0.5, 0, 1)
        end
    end
end

function MAP:AddOnIconCollector()
    if not C.DB.Map.Collector then
        return
    end

    local bu = CreateFrame('Button', 'FreeUIMinimapAddOnIconCollector', Minimap)
    bu:SetSize(20, 20)
    bu:SetPoint('TOPRIGHT', -4, -Minimap.halfDiff - 8)
    bu:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    bu.Icon = bu:CreateTexture(nil, 'ARTWORK')
    bu.Icon:SetAllPoints()
    bu.Icon:SetTexture(C.Assets.Texture.Collector)
    bu:SetHighlightTexture(C.Assets.Texture.Collector)
    bu.title = C.INFO_COLOR .. L['AddOn Icon Collector']
    F.AddTooltip(bu, 'ANCHOR_LEFT')
    UpdateCollectorTip(bu)
    Minimap.AddOnCollector = bu

    local tray = CreateFrame('Frame', 'FreeUIMinimapAddOnIconCollectorTray', Minimap)
    tray:SetPoint('BOTTOMRIGHT', Minimap, 'TOPRIGHT', 0, -Minimap.halfDiff)
    tray:SetSize(Minimap:GetWidth(), 24)
    tray:Hide()
    Minimap.AddOnCollectorTray = tray

    F:SplitList(ignoredButtons, FREE_ADB['IgnoredAddOns'])

    bu:SetScript('OnClick', Button_OnClick)

    CollectRubbish()
end
