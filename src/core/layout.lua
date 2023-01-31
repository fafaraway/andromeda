local F, C, L = unpack(select(2, ...))
local M = F:GetModule('Layout')

-- Grids

local toggle = 0

do
    local shadeFrame = CreateFrame('Frame')
    local shadeTexture = shadeFrame:CreateTexture(nil, 'BACKGROUND', nil, -8)

    shadeFrame:SetFrameStrata('BACKGROUND')
    shadeFrame:SetWidth(GetScreenWidth() * _G.UIParent:GetEffectiveScale())
    shadeFrame:SetHeight(GetScreenHeight() * _G.UIParent:GetEffectiveScale())
    shadeTexture:SetAllPoints(shadeFrame)
    shadeFrame:SetPoint('CENTER', 0, 0)

    M.crosshairFrameNS = CreateFrame('Frame')
    M.crosshairTextureNS = M.crosshairFrameNS:CreateTexture(nil, 'ARTWORK')

    M.crosshairFrameNS:SetWidth(1)
    M.crosshairFrameNS:SetHeight(GetScreenHeight() * _G.UIParent:GetEffectiveScale())
    M.crosshairTextureNS:SetAllPoints(M.crosshairFrameNS)
    M.crosshairTextureNS:SetColorTexture(0, 0, 0, 1)

    M.crosshairFrameEW = CreateFrame('Frame')
    M.crosshairTextureEW = M.crosshairFrameEW:CreateTexture(nil, 'ARTWORK')

    M.crosshairFrameEW:SetWidth(GetScreenWidth() * _G.UIParent:GetEffectiveScale())
    M.crosshairFrameEW:SetHeight(1)
    M.crosshairTextureEW:SetAllPoints(M.crosshairFrameEW)
    M.crosshairTextureEW:SetColorTexture(0, 0, 0, 1)

    function M.ClearCrosshair()
        shadeFrame:Hide()
        M.crosshairFrameNS:Hide()
        M.crosshairFrameEW:Hide()
    end

    function M.ShadeCrosshair(r, g, b, a)
        shadeTexture:SetColorTexture(r, g, b, a)
        shadeFrame:Show()
    end

    local function follow()
        local mouseX, mouseY = GetCursorPosition()
        M.crosshairFrameNS:SetPoint('TOPLEFT', mouseX, 0)
        M.crosshairFrameEW:SetPoint('BOTTOMLEFT', 0, mouseY)
    end

    function M.ShowCrosshair(arg)
        local mouseX, mouseY = GetCursorPosition()
        M.crosshairFrameNS:SetPoint('TOPLEFT', mouseX, 0)
        M.crosshairFrameEW:SetPoint('BOTTOMLEFT', 0, mouseY)
        M.crosshairFrameNS:Show()
        M.crosshairFrameEW:Show()
        if arg == 'follow' then
            M.crosshairFrameNS:SetScript('OnUpdate', follow)
        else
            M.crosshairFrameNS:SetScript('OnUpdate', nil)
        end
    end
end

-- Movable Frame

function F:CreateMF(parent, saved)
    local frame = parent or self
    frame:SetMovable(true)
    frame:SetUserPlaced(true)
    frame:SetClampedToScreen(true)

    self:EnableMouse(true)
    self:RegisterForDrag('LeftButton')
    self:SetScript('OnDragStart', function()
        frame:StartMoving()
    end)
    self:SetScript('OnDragStop', function()
        frame:StopMovingOrSizing()
        if not saved then
            return
        end
        local orig, _, tar, x, y = frame:GetPoint()
        x, y = F:Round(x), F:Round(y)
        C.DB['UIAnchorTemp'][frame:GetName()] = { orig, 'UIParent', tar, x, y }
    end)
end

function F:RestoreMF()
    local name = self:GetName()
    if name and C.DB['UIAnchorTemp'][name] then
        self:ClearAllPoints()
        self:SetPoint(unpack(C.DB['UIAnchorTemp'][name]))
    end
end

function F:UpdateBlizzFrame()
    if InCombatLockdown() then
        return
    end
    if self.isRestoring then
        return
    end
    self.isRestoring = true
    F.RestoreMF(self)
    self.isRestoring = nil
end

function F:RestoreBlizzFrame()
    if IsControlKeyDown() then
        C.DB['UIAnchorTemp'][self:GetName()] = nil
        UpdateUIPanelPositions(self)
    end
end

function F:BlizzFrameMover(frame)
    F.CreateMF(frame, nil, true)
    hooksecurefunc(frame, 'SetPoint', F.UpdateBlizzFrame)
    frame:HookScript('OnMouseUp', F.RestoreBlizzFrame)
end

-- Frame Mover
local MoverList, f = {}
local updater

function F:Mover(text, value, anchor, width, height)
    local outline = _G.ANDROMEDA_ADB.FontOutline
    local key = 'UIAnchor'

    local mover = CreateFrame('Frame', nil, _G.UIParent)
    mover:SetWidth(width or self:GetWidth())
    mover:SetHeight(height or self:GetHeight())
    mover.bg = F.SetBD(mover)
    mover:Hide()
    mover.text = F.CreateFS(mover, C.Assets.Fonts.Regular, 12, outline or nil, text, nil, outline and 'NONE' or 'THICK')
    mover.text:SetWordWrap(true)

    if not C.DB[key][value] then
        mover:SetPoint(unpack(anchor))
    else
        mover:SetPoint(unpack(C.DB[key][value]))
    end
    mover:EnableMouse(true)
    mover:SetMovable(true)
    mover:SetClampedToScreen(true)
    mover:SetFrameStrata('HIGH')
    mover:RegisterForDrag('LeftButton')
    mover.__key = key
    mover.__value = value
    mover.__anchor = anchor
    mover:SetScript('OnEnter', M.Mover_OnEnter)
    mover:SetScript('OnLeave', M.Mover_OnLeave)
    mover:SetScript('OnDragStart', M.Mover_OnDragStart)
    mover:SetScript('OnDragStop', M.Mover_OnDragStop)
    mover:SetScript('OnMouseUp', M.Mover_OnClick)

    tinsert(MoverList, mover)

    self:ClearAllPoints()
    self:SetPoint('TOPLEFT', mover)

    return mover
end

function M:CalculateMoverPoints(mover, trimX, trimY)
    local screenWidth = F:Round(_G.UIParent:GetRight())
    local screenHeight = F:Round(_G.UIParent:GetTop())
    local screenCenter = F:Round(_G.UIParent:GetCenter(), nil)
    local x, y = mover:GetCenter()

    local LEFT = screenWidth / 3
    local RIGHT = screenWidth * 2 / 3
    local TOP = screenHeight / 2
    local point

    if y >= TOP then
        point = 'TOP'
        y = -(screenHeight - mover:GetTop())
    else
        point = 'BOTTOM'
        y = mover:GetBottom()
    end

    if x >= RIGHT then
        point = point .. 'RIGHT'
        x = mover:GetRight() - screenWidth
    elseif x <= LEFT then
        point = point .. 'LEFT'
        x = mover:GetLeft()
    else
        x = x - screenCenter
    end

    x = x + (trimX or 0)
    y = y + (trimY or 0)

    return x, y, point
end

function M:UpdateTrimFrame()
    local x, y = M:CalculateMoverPoints(self)
    x, y = F:Round(x), F:Round(y)
    f.__x:SetText(x)
    f.__y:SetText(y)
    f.__x.__current = x
    f.__y.__current = y
    f.__trimText:SetText(self.text:GetText())
end

function M:DoTrim(trimX, trimY)
    local mover = updater.__owner
    if mover then
        local x, y, point = M:CalculateMoverPoints(mover, trimX, trimY)
        x, y = F:Round(x), F:Round(y)
        f.__x:SetText(x)
        f.__y:SetText(y)
        f.__x.__current = x
        f.__y.__current = y
        mover:ClearAllPoints()
        mover:SetPoint(point, _G.UIParent, point, x, y)
        C.DB[mover.__key][mover.__value] = { point, 'UIParent', point, x, y }
    end
end

function M:Mover_OnClick(btn)
    if IsShiftKeyDown() and btn == 'RightButton' then
        self:Hide()
    elseif IsControlKeyDown() and btn == 'RightButton' then
        self:ClearAllPoints()
        self:SetPoint(unpack(self.__anchor))
        C.DB[self.__key][self.__value] = nil
    end
    updater.__owner = self
    M.UpdateTrimFrame(self)
end

function M:Mover_OnEnter()
    self.bg:SetBackdropBorderColor(C.r, C.g, C.b)
    self.text:SetTextColor(1, 0.8, 0)
end

function M:Mover_OnLeave()
    F.SetBorderColor(self.bg)
    self.text:SetTextColor(1, 1, 1)
end

function M:Mover_OnDragStart()
    self:StartMoving()
    M.UpdateTrimFrame(self)
    updater.__owner = self
    updater:Show()
end

function M:Mover_OnDragStop()
    self:StopMovingOrSizing()
    local orig, _, tar, x, y = self:GetPoint()
    x = F:Round(x)
    y = F:Round(y)

    self:ClearAllPoints()
    self:SetPoint(orig, 'UIParent', tar, x, y)
    C.DB[self.__key][self.__value] = { orig, 'UIParent', tar, x, y }
    M.UpdateTrimFrame(self)
    updater:Hide()
end

function M:UnlockElements()
    for i = 1, #MoverList do
        local mover = MoverList[i]
        if not mover:IsShown() then
            mover:Show()
        end
    end

    f:Show()
end

function M:LockElements()
    for i = 1, #MoverList do
        local mover = MoverList[i]
        mover:Hide()
    end
    f:Hide()

    toggle = 0
    M.ClearCrosshair()
end

-- Mover Console
local function CreateConsole()
    if f then
        return
    end

    local outline = _G.ANDROMEDA_ADB.FontOutline
    f = CreateFrame('Frame', nil, _G.UIParent, 'BackdropTemplate')
    f:SetPoint('TOP', 0, -150)
    f:SetSize(260, 70)
    F.CreateBD(f)
    F.CreateSD(f)
    F.CreateFS(f, C.Assets.Fonts.Regular, 12, outline or nil, L['Layout'], 'YELLOW', outline and 'NONE' or 'THICK', 'TOP', 0, -10)

    local bu, text = {}, { _G.LOCK, L['Grids'], _G.RESET }

    for i = 1, 3 do
        bu[i] = F.CreateButton(f, 80, 24, text[i])
        if i == 1 then
            bu[i]:SetPoint('BOTTOMLEFT', 6, 6)
        else
            bu[i]:SetPoint('LEFT', bu[i - 1], 'RIGHT', 4, 0)
        end
    end

    -- Lock
    bu[1]:SetScript('OnClick', M.LockElements)

    -- Grids
    bu[2]:SetScript('OnClick', function()
        if toggle == 0 then
            M.ShadeCrosshair(1, 1, 1, 0.85)
            M.crosshairTextureNS:SetColorTexture(0, 0, 0, 1)
            M.crosshairTextureEW:SetColorTexture(0, 0, 0, 1)
            M.ShowCrosshair('follow')
            toggle = 1
        else
            toggle = 0
            M.ClearCrosshair()
        end
    end)

    -- Reset
    bu[3]:SetScript('OnClick', function()
        _G.StaticPopup_Show('ANDROMEDA_RESET_LAYOUT')
    end)

    local header = CreateFrame('Frame', nil, f)
    header:SetSize(260, 30)
    header:SetPoint('TOP')
    F.CreateMF(header, f)
    local tips = '|nCTRL +' .. C.MOUSE_RIGHT_BUTTON .. L['Reset default anchor'] .. '|nSHIFT +' .. C.MOUSE_RIGHT_BUTTON .. L['Hide the frame']
    header.title = L['Layout']
    F.AddTooltip(header, 'ANCHOR_TOP', tips, 'BLUE')

    local frame = CreateFrame('Frame', nil, f, 'BackdropTemplate')
    frame:SetSize(260, 100)
    frame:SetPoint('TOP', f, 'BOTTOM', 0, -2)
    F.SetBD(frame)
    f.__trimText = F.CreateFS(frame, C.Assets.Fonts.Regular, 12, outline or nil, '', 'YELLOW', outline and 'NONE' or 'THICK', 'BOTTOM', 0, 5)

    local xBox = F.CreateEditBox(frame, 60, 22)
    xBox:SetPoint('TOPRIGHT', frame, 'TOP', -12, -15)
    F.CreateFS(xBox, C.Assets.Fonts.Regular, 11, outline or nil, 'X', 'YELLOW', outline and 'NONE' or 'THICK', 'LEFT', -20, 0)
    xBox:SetJustifyH('CENTER')
    xBox.__current = 0
    xBox:HookScript('OnEnterPressed', function(self)
        local text = self:GetText()
        text = tonumber(text)
        if text then
            local diff = text - self.__current
            self.__current = text
            M:DoTrim(diff)
        end
    end)
    f.__x = xBox

    local yBox = F.CreateEditBox(frame, 60, 22)
    yBox:SetPoint('TOPRIGHT', frame, 'TOP', -12, -39)
    F.CreateFS(yBox, C.Assets.Fonts.Regular, 11, outline or nil, 'Y', 'YELLOW', outline and 'NONE' or 'THICK', 'LEFT', -20, 0)
    yBox:SetJustifyH('CENTER')
    yBox.__current = 0
    yBox:HookScript('OnEnterPressed', function(self)
        local text = self:GetText()
        text = tonumber(text)
        if text then
            local diff = text - self.__current
            self.__current = text
            M:DoTrim(nil, diff)
        end
    end)
    f.__y = yBox

    local arrows = {}
    local arrowIndex = {
        [1] = { degree = 180, offset = -1, x = 28, y = 9 },
        [2] = { degree = 0, offset = 1, x = 72, y = 9 },
        [3] = { degree = 90, offset = 1, x = 50, y = 20 },
        [4] = { degree = -90, offset = -1, x = 50, y = -2 },
    }
    local function arrowOnClick(self)
        local modKey = IsModifierKeyDown()
        if self.__index < 3 then
            M:DoTrim(self.__offset * (modKey and 10 or 1))
        else
            M:DoTrim(nil, self.__offset * (modKey and 10 or 1))
        end
        PlaySound(_G.SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    end

    for i = 1, 4 do
        arrows[i] = CreateFrame('Button', nil, frame)
        arrows[i]:SetSize(20, 20)
        F.PixelIcon(arrows[i], 'Interface\\OPTIONSFRAME\\VoiceChat-Play', true)
        local arrowData = arrowIndex[i]
        arrows[i].__index = i
        arrows[i].__offset = arrowData.offset
        arrows[i]:SetScript('OnClick', arrowOnClick)
        arrows[i]:SetPoint('CENTER', arrowData.x, arrowData.y)
        arrows[i].Icon:SetPoint('TOPLEFT', 3, -3)
        arrows[i].Icon:SetPoint('BOTTOMRIGHT', -3, 3)
        arrows[i].Icon:SetRotation(rad(arrowData.degree))
    end

    local function showLater(event)
        if event == 'PLAYER_REGEN_DISABLED' then
            if f:IsShown() then
                M:LockElements()
                F:RegisterEvent('PLAYER_REGEN_ENABLED', showLater)
            end
        else
            M:UnlockElements()
            F:UnregisterEvent(event, showLater)
        end
    end
    F:RegisterEvent('PLAYER_REGEN_DISABLED', showLater)
end

function F:MoverConsole()
    if InCombatLockdown() then
        _G.UIErrorsFrame:AddMessage(C.INFO_COLOR .. _G.ERR_NOT_IN_COMBAT)
        return
    end
    CreateConsole()
    M:UnlockElements()
end

function M:OnLogin()
    updater = CreateFrame('Frame')
    updater:Hide()
    updater:SetScript('OnUpdate', function()
        M.UpdateTrimFrame(updater.__owner)
    end)

    M:DisableBlizzardMover()
end

-- Disable blizzard edit mode
local function isUnitFrameEnable()
    return C.DB['Unitframe']['Enable']
end

local function isBuffEnable()
    return C.DB['Aura']['Enable'] or C.DB['Aura']['HideBlizzFrame']
end

local function isActionbarEnable()
    return C.DB['Actionbar']['Enable']
end

local function isCastbarEnable()
    return C.DB['Unitframe']['Enable']
end

local function isPartyEnable()
    return C.DB['Unitframe']['Enable'] and C.DB['Unitframe']['RaidFrame'] and C.DB['Unitframe']['PartyFrame']
end

local function isRaidEnable()
    return C.DB['Unitframe']['Enable'] and C.DB['Unitframe']['RaidFrame']
end

local function isArenaEnable()
    return C.DB['Unitframe']['Enable'] and C.DB['Unitframe']['Arena']
end

local function isTalkingHeadHidden()
    return C.DB['General']['HideTalkingHead']
end

local ignoredFrames = {
    -- ActionBars
    ['StanceBar'] = isActionbarEnable,
    ['EncounterBar'] = isActionbarEnable,
    ['PetActionBar'] = isActionbarEnable,
    ['PossessActionBar'] = isActionbarEnable,
    ['MainMenuBarVehicleLeaveButton'] = isActionbarEnable,
    ['MultiBarBottomLeft'] = isActionbarEnable,
    ['MultiBarBottomRight'] = isActionbarEnable,
    ['MultiBarLeft'] = isActionbarEnable,
    ['MultiBarRight'] = isActionbarEnable,
    ['MultiBar5'] = isActionbarEnable,
    ['MultiBar6'] = isActionbarEnable,
    ['MultiBar7'] = isActionbarEnable,
    -- Auras
    ['BuffFrame'] = isBuffEnable,
    ['DebuffFrame'] = isBuffEnable,
    -- UnitFrames
    ['PlayerFrame'] = isUnitFrameEnable,
    ['PlayerCastingBarFrame'] = isCastbarEnable,
    ['FocusFrame'] = isUnitFrameEnable,
    ['TargetFrame'] = isUnitFrameEnable,
    ['BossTargetFrameContainer'] = isUnitFrameEnable,
    ['PartyFrame'] = isPartyEnable,
    ['CompactRaidFrameContainer'] = isRaidEnable,
    ['ArenaEnemyFramesContainer'] = isArenaEnable,
    -- Misc
    ['MinimapCluster'] = function()
        return C.DB['Map']['Minimap']
    end,
    ['GameTooltipDefaultContainer'] = function()
        return true
    end,
    ['TalkingHeadFrame'] = isTalkingHeadHidden,
}

local shutdownMode = {
    'OnEditModeEnter',
    'OnEditModeExit',
    'HasActiveChanges',
    'HighlightSystem',
    'SelectSystem',
}

function M:DisableBlizzardMover()
    local editMode = _G.EditModeManagerFrame

    -- remove the initial registers
    local registered = editMode.registeredSystemFrames
    for i = #registered, 1, -1 do
        local frame = registered[i]
        local ignore = ignoredFrames[frame:GetName()]

        if ignore and ignore() then
            for _, key in next, shutdownMode do
                frame[key] = nop
            end
        end
    end

    -- account settings will be tainted
    local mixin = editMode.AccountSettings
    if isCastbarEnable() then
        mixin.RefreshCastBar = nop
    end
    if isBuffEnable() then
        mixin.RefreshAuraFrame = nop
    end
    if isRaidEnable() then
        mixin.ResetRaidFrames = nop
        mixin.RefreshRaidFrames = nop
    end
    if isArenaEnable() then
        mixin.RefreshArenaFrames = nop
    end
    if isPartyEnable() then
        mixin.ResetPartyFrames = nop
        mixin.RefreshPartyFrames = nop
    end
    if isTalkingHeadHidden() then
        mixin.RefreshTalkingHeadFrame = nop
    end
    if isUnitFrameEnable() then
        mixin.ResetTargetAndFocus = nop
        mixin.RefreshTargetAndFocus = nop
        mixin.RefreshBossFrames = nop
    end
    if isActionbarEnable() then
        mixin.RefreshEncounterBar = nop
        mixin.RefreshActionBarShown = nop
        mixin.RefreshVehicleLeaveButton = nop
    end
    _G.ObjectiveTrackerFrame.IsInDefaultPosition = nop
end

do
    local function onClick()
        F:MoverConsole()
        HideUIPanel(_G.GameMenuFrame)
    end

    _G.GameMenuButtonEditMode:SetScript('OnClick', onClick)
end
