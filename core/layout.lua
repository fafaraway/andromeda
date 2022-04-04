local F, C, L = unpack(select(2, ...))
local M = F:RegisterModule('Layout')

-- Grids
local toggle = 0
local shadeFrame = CreateFrame('Frame')
local shadeTexture = shadeFrame:CreateTexture(nil, 'BACKGROUND', nil, -8)

shadeFrame:SetFrameStrata('BACKGROUND')
shadeFrame:SetWidth(GetScreenWidth() * _G.UIParent:GetEffectiveScale())
shadeFrame:SetHeight(GetScreenHeight() * _G.UIParent:GetEffectiveScale())
shadeTexture:SetAllPoints(shadeFrame)
shadeFrame:SetPoint('CENTER', 0, 0)

local crosshairFrameNS = CreateFrame('Frame')
local crosshairTextureNS = crosshairFrameNS:CreateTexture(nil, 'TOOLTIP')

crosshairFrameNS:SetFrameStrata('TOOLTIP')
crosshairFrameNS:SetWidth(1)
crosshairFrameNS:SetHeight(GetScreenHeight() * _G.UIParent:GetEffectiveScale())
crosshairTextureNS:SetAllPoints(crosshairFrameNS)
crosshairTextureNS:SetColorTexture(0, 0, 0, 1)

local crosshairFrameEW = CreateFrame('Frame')
local crosshairTextureEW = crosshairFrameEW:CreateTexture(nil, 'TOOLTIP')

crosshairFrameEW:SetFrameStrata('TOOLTIP')
crosshairFrameEW:SetWidth(GetScreenWidth() * _G.UIParent:GetEffectiveScale())
crosshairFrameEW:SetHeight(1)
crosshairTextureEW:SetAllPoints(crosshairFrameEW)
crosshairTextureEW:SetColorTexture(0, 0, 0, 1)

local function clear()
    shadeFrame:Hide()
    crosshairFrameNS:Hide()
    crosshairFrameEW:Hide()
end

local function shade(r, g, b, a)
    shadeTexture:SetColorTexture(r, g, b, a)
    shadeFrame:Show()
end

local function follow()
    local mouseX, mouseY = GetCursorPosition()
    crosshairFrameNS:SetPoint('TOPLEFT', mouseX, 0)
    crosshairFrameEW:SetPoint('BOTTOMLEFT', 0, mouseY)
end

local function crosshair(arg)
    local mouseX, mouseY = GetCursorPosition()
    crosshairFrameNS:SetPoint('TOPLEFT', mouseX, 0)
    crosshairFrameEW:SetPoint('BOTTOMLEFT', 0, mouseY)
    crosshairFrameNS:Show()
    crosshairFrameEW:Show()
    if arg == 'follow' then
        crosshairFrameNS:SetScript('OnUpdate', follow)
    else
        crosshairFrameNS:SetScript('OnUpdate', nil)
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
        C.DB['UIAnchorTemp'][frame:GetName()] = {orig, 'UIParent', tar, x, y}
    end)
end

function F:RestoreMF()
    local name = self:GetName()
    if name and C.DB['UIAnchorTemp'][name] then
        self:ClearAllPoints()
        self:SetPoint(unpack(C.DB['UIAnchorTemp'][name]))
    end
end

-- Frame Mover
local MoverList, f = {}
local updater

function F:Mover(text, value, anchor, width, height)
    local key = 'UIAnchor'

    local mover = CreateFrame('Frame', nil, _G.UIParent)
    mover:SetWidth(width or self:GetWidth())
    mover:SetHeight(height or self:GetHeight())
    mover.bg = F.SetBD(mover)
    mover:Hide()
    mover.text = F.CreateFS(mover, C.Assets.Font.Regular, 12, 'OUTLINE', text)
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

    table.insert(MoverList, mover)

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
        C.DB[mover.__key][mover.__value] = {point, 'UIParent', point, x, y}
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
    self.text:SetTextColor(1, .8, 0)
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
    C.DB[self.__key][self.__value] = {orig, 'UIParent', tar, x, y}
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
    clear()
end

-- Mover Console
local function CreateConsole()
    if f then
        return
    end

    f = CreateFrame('Frame', nil, _G.UIParent, 'BackdropTemplate')
    f:SetPoint('TOP', 0, -150)
    f:SetSize(260, 70)
    F.CreateBD(f)
    F.CreateSD(f)
    F.CreateFS(f, C.Assets.Font.Regular, 12, true, L['Layout'], 'YELLOW', nil, 'TOP', 0, -10)

    local bu, text = {}, {_G.LOCK, L['Grids'], _G.RESET}

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
            shade(1, 1, 1, 0.85)
            crosshairTextureNS:SetColorTexture(0, 0, 0, 1)
            crosshairTextureEW:SetColorTexture(0, 0, 0, 1)
            crosshair('follow')
            toggle = 1
        else
            toggle = 0
            clear()
        end
    end)

    -- Reset
    bu[3]:SetScript('OnClick', function()
        _G.StaticPopup_Show('FREEUI_RESET_LAYOUT')
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
    f.__trimText = F.CreateFS(frame, C.Assets.Font.Regular, 12, true, '', 'YELLOW', nil, 'BOTTOM', 0, 5)

    local xBox = F.CreateEditBox(frame, 60, 22)
    xBox:SetPoint('TOPRIGHT', frame, 'TOP', -12, -15)
    F.CreateFS(xBox, C.Assets.Font.Regular, 11, 'OUTLINE', 'X', 'YELLOW', true, 'LEFT', -20, 0)
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
    F.CreateFS(yBox, C.Assets.Font.Regular, 11, 'OUTLINE', 'Y', 'YELLOW', true, 'LEFT', -20, 0)
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
    local arrowIndex = {[1] = {degree = 180, offset = -1, x = 28, y = 9}, [2] = {degree = 0, offset = 1, x = 72, y = 9}, [3] = {degree = 90, offset = 1, x = 50, y = 20}, [4] = {degree = -90, offset = -1, x = 50, y = -2}}
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
        arrows[i].Icon:SetRotation(math.rad(arrowData.degree))
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
end

