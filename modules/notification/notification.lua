local F, C = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')

local playSounds = true
local animations = true
local duration = 5
local bannerWidth = 240
local bannerHeight = 50
local padding = 4
local interval = 0.1

local function ConstructFrame()
    local f = CreateFrame('Frame', 'FreeUI_Notification', _G.UIParent, 'BackdropTemplate')
    f:SetFrameStrata('FULLSCREEN_DIALOG')
    f:SetSize(bannerWidth, bannerHeight)
    f:SetPoint('TOP', _G.UIParent, 'TOP', 0, -70)
    f:Hide()
    f:SetAlpha(0.1)
    f:SetScale(0.1)
    F.SetBD(f)
    NOTIFICATION.Frame = f

    local icon = f:CreateTexture(nil, 'OVERLAY')
    icon:SetSize(bannerHeight - padding * 2, bannerHeight - padding * 2)
    icon:SetPoint('TOPLEFT', f, padding, -padding)
    icon.bg = F.ReskinIcon(icon, true)
    icon.bg:SetBackdropBorderColor(0, 0, 0)
    NOTIFICATION.Icon = icon

    local sep = f:CreateTexture(nil, 'BACKGROUND')
    sep:SetSize(C.MULT, bannerHeight)
    sep:SetPoint('LEFT', icon, 'RIGHT', padding, 0)
    sep:SetColorTexture(0, 0, 0)

    local title = F.CreateFS(f, C.Assets.Font.Bold, 14, nil, '', 'YELLOW', true)
    title:SetPoint('TOPLEFT', sep, padding, -padding - 4)
    title:SetPoint('TOPRIGHT', f, -padding, -4)
    title:SetJustifyH('LEFT')
    NOTIFICATION.Title = title

    local text = F.CreateFS(f, C.Assets.Font.Regular, 12, nil, '', nil, true)
    text:SetPoint('BOTTOMLEFT', sep, padding, padding + 4)
    text:SetPoint('BOTTOMRIGHT', f, -padding, 4)
    text:SetJustifyH('LEFT')
    text:SetWordWrap(false)
    NOTIFICATION.Text = text
end

local bannerShown = false
local function HideBanner()
    if animations then
        local scale
        NOTIFICATION.Frame:SetScript('OnUpdate', function(self)
            scale = self:GetScale() - interval
            if scale <= 0.1 then
                self:SetScript('OnUpdate', nil)
                self:Hide()
                bannerShown = false
                return
            end
            self:SetScale(scale)
            self:SetAlpha(scale)
        end)
    else
        NOTIFICATION.Frame:Hide()
        NOTIFICATION.Frame:SetScale(0.1)
        NOTIFICATION.Frame:SetAlpha(0.1)
        bannerShown = false
    end
end

local function FadeTimer()
    local last = 0
    NOTIFICATION.Frame:SetScript('OnUpdate', function(self, elapsed)
        local width = NOTIFICATION.Frame:GetWidth()
        if width > bannerWidth then
            self:SetWidth(width - (interval * 100))
        end
        last = last + elapsed
        if last >= duration then
            self:SetWidth(bannerWidth)
            self:SetScript('OnUpdate', nil)
            HideBanner()
        end
    end)
end

local function ShowBanner()
    bannerShown = true
    if animations then
        NOTIFICATION.Frame:Show()
        local scale
        NOTIFICATION.Frame:SetScript('OnUpdate', function(self)
            scale = self:GetScale() + interval
            self:SetScale(scale)
            self:SetAlpha(scale)
            if scale >= 1 then
                self:SetScale(1)
                self:SetScript('OnUpdate', nil)
                FadeTimer()
            end
        end)
    else
        NOTIFICATION.Frame:SetScale(1)
        NOTIFICATION.Frame:SetAlpha(1)
        NOTIFICATION.Frame:Show()
        FadeTimer()
    end
end

local function Display(name, message, clickFunc, texture)
    if type(clickFunc) == 'function' then
        NOTIFICATION.Frame.clickFunc = clickFunc
    else
        NOTIFICATION.Frame.clickFunc = nil
    end

    if type(texture) == 'string' then
        NOTIFICATION.Icon:SetTexture(texture)
    else
        NOTIFICATION.Icon:SetTexture('Interface\\ICONS\\WoW_Store')
    end

    NOTIFICATION.Title:SetText(C.YELLOW_COLOR .. name)
    NOTIFICATION.Text:SetText(C.BLUE_COLOR .. message)

    ShowBanner()

    if playSounds then
        PlaySoundFile(C.Assets.Sound.Notification)
    end
end

local handler = CreateFrame('Frame')
local incoming = {}
local processing = false

local function HandleIncoming()
    processing = true
    local i = 1

    handler:SetScript('OnUpdate', function(self)
        if incoming[i] == nil then
            self:SetScript('OnUpdate', nil)
            incoming = {}
            processing = false
            return
        else
            if not bannerShown then
                Display(unpack(incoming[i]))
                i = i + 1
            end
        end
    end)
end

function F:CreateNotification(name, message, clickFunc, texture)
    if not C.DB.Notification.Enable then
        return
    end

    if UnitIsAFK('player') then
        table.insert(incoming, { name, message, clickFunc, texture })
        handler:RegisterEvent('PLAYER_FLAGS_CHANGED')
    elseif bannerShown or #incoming ~= 0 then
        table.insert(incoming, { name, message, clickFunc, texture })
        if not processing then
            HandleIncoming()
        end
    else
        Display(name, message, clickFunc, texture)
    end
end

local function Expand(self)
    local width = self:GetWidth()

    if NOTIFICATION.Text:IsTruncated() and width < (GetScreenWidth() / 1.5) then
        self:SetWidth(width + (interval * 100))
    else
        self:SetScript('OnUpdate', nil)
    end
end

local function OnEnter(self)
    self:SetScript('OnUpdate', nil)
    self:SetScale(1)
    self:SetAlpha(1)
    self:SetScript('OnUpdate', Expand)
end

local function OnMouseUp(self, button)
    self:SetScript('OnUpdate', nil)
    self:Hide()
    self:SetScale(0.1)
    self:SetAlpha(0.1)
    bannerShown = false

    if button ~= 'RightButton' and NOTIFICATION.Frame.clickFunc then
        NOTIFICATION.Frame.clickFunc()
    end

    if IsShiftKeyDown() then
        handler:SetScript('OnUpdate', nil)
        incoming = {}
        processing = false
    end
end

local function OnEvent(self, _, unit)
    if unit == 'player' and not UnitIsAFK('player') then
        HandleIncoming()
        self:UnregisterEvent('PLAYER_FLAGS_CHANGED')
    end
end

function NOTIFICATION:OnLogin()
    if not C.DB.Notification.Enable then
        return
    end

    ConstructFrame()

    NOTIFICATION.Frame:SetScript('OnEnter', OnEnter)
    NOTIFICATION.Frame:SetScript('OnLeave', FadeTimer)
    NOTIFICATION.Frame:SetScript('OnMouseUp', OnMouseUp)

    handler:SetScript('OnEvent', OnEvent)

    self:NewMailNotify()
    self:BagFullNotify()
    self:VersionCheck()
    self:RareNotify()
    self:ParagonNotify()
    self:InstanceNotify()
    self:CheckIncompatible()
end
