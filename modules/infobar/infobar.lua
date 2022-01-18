local F, C = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

INFOBAR.Buttons = {}
local barAlpha, buttonAlpha

local function BorderAnim_OnEvent(event)
    local bar = INFOBAR.Bar
    if event == 'PLAYER_REGEN_DISABLED' then
        bar.bg:SetBackdropBorderColor(1, 0, 0)
        bar.anim:Play()
    elseif not InCombatLockdown() then
        if C_Calendar.GetNumPendingInvites() > 0 then
            bar.bg:SetBackdropBorderColor(1, 1, 0)
            bar.anim:Play()
        else
            bar.anim:Stop()
            bar.bg:SetBackdropBorderColor(0, 0, 0)
        end
    end
end

function INFOBAR:UpdateCombatPulse()
    if C.DB.Infobar.CombatPulse then
        F:RegisterEvent('PLAYER_REGEN_ENABLED', BorderAnim_OnEvent)
        F:RegisterEvent('PLAYER_REGEN_DISABLED', BorderAnim_OnEvent)
        F:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES', BorderAnim_OnEvent)
    else
        F:UnregisterEvent('PLAYER_REGEN_ENABLED', BorderAnim_OnEvent)
        F:UnregisterEvent('PLAYER_REGEN_DISABLED', BorderAnim_OnEvent)
        F:UnregisterEvent('CALENDAR_UPDATE_PENDING_INVITES', BorderAnim_OnEvent)
    end
end

function INFOBAR:CreateInfoBar()
    local mouseover = C.DB.Infobar.Mouseover
    local anchorTop = C.DB.Infobar.AnchorTop

    local bar = CreateFrame('Frame', 'FreeUI_Infobar', _G.UIParent, 'BackdropTemplate')
    bar:SetFrameStrata('BACKGROUND')
    bar:SetHeight(C.DB.Infobar.Height)
    bar:SetPoint(anchorTop and 'TOPLEFT' or 'BOTTOMLEFT', 0, 0)
    bar:SetPoint(anchorTop and 'TOPRIGHT' or 'BOTTOMRIGHT', 0, 0)

    barAlpha = mouseover and .25 or .65
    buttonAlpha = mouseover and 0 or 1

    bar:SetScript('OnEnter', INFOBAR.ShowBar)
    bar:SetScript('OnLeave', INFOBAR.HideBar)

    _G.RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show')

    INFOBAR.Bar = bar

    bar.bg = CreateFrame('Frame', nil, bar, 'BackdropTemplate')
    bar.bg:SetOutside(bar, 2, 2)
    bar.bg:SetFrameStrata('BACKGROUND')
    bar.bg:SetFrameLevel(1) -- Make sure the frame level is higher than the vignetting
    bar.bg:SetBackdrop({bgFile = C.Assets.Textures.Backdrop, edgeFile = C.Assets.Textures.Backdrop, edgeSize = 1})
    bar.bg:SetBackdropColor(0, 0, 0, mouseover and .25 or .65)
    bar.bg:SetBackdropBorderColor(0, 0, 0)

    bar.anim = bar.bg:CreateAnimationGroup()
    bar.anim:SetLooping('BOUNCE')
    bar.anim.fader = bar.anim:CreateAnimation('Alpha')
    bar.anim.fader:SetFromAlpha(1)
    bar.anim.fader:SetToAlpha(.2)
    bar.anim.fader:SetDuration(1)
    bar.anim.fader:SetSmoothing('OUT')
end

function INFOBAR:FadeIn(elapsed)
    if barAlpha < 0.5 then
        barAlpha = barAlpha + elapsed
        buttonAlpha = buttonAlpha + (elapsed * 4)
    else
        barAlpha = 0.5
        buttonAlpha = 1
        self:SetScript('OnUpdate', nil)
    end

    self.bg:SetBackdropColor(0, 0, 0, barAlpha)

    for _, button in pairs(INFOBAR.Buttons) do
        button:SetAlpha(buttonAlpha)
    end
end

function INFOBAR:FadeOut(elapsed)
    if barAlpha > .25 then
        barAlpha = barAlpha - elapsed
        buttonAlpha = buttonAlpha - (elapsed * 4)
    else
        barAlpha = .25
        buttonAlpha = 0
        self:SetScript('OnUpdate', nil)
    end

    self.bg:SetBackdropColor(0, 0, 0, barAlpha)

    for _, button in pairs(INFOBAR.Buttons) do
        button:SetAlpha(buttonAlpha)
    end
end

function INFOBAR:ShowBar()
    if not C.DB.Infobar.Mouseover then
        return
    end
    local bar = INFOBAR.Bar
    bar:SetScript('OnUpdate', INFOBAR.FadeIn)
end

function INFOBAR:HideBar()
    if not C.DB.Infobar.Mouseover then
        return
    end
    local bar = INFOBAR.Bar
    bar:SetScript('OnUpdate', INFOBAR.FadeOut)
end

function INFOBAR:Button_OnEnter()
    INFOBAR.ShowBar()
    self:SetBackdropColor(C.r, C.g, C.b, .25)
end

function INFOBAR:Button_OnLeave()
    INFOBAR.HideBar()
    self:SetBackdropColor(0, 0, 0, 0)
end

local function ReanchorButtons()
    local bar = INFOBAR.Bar
    local leftOffset, rightOffset = 0, 0

    for i = 1, #INFOBAR.Buttons do
        local bu = INFOBAR.Buttons[i]

        if bu:IsShown() then
            if bu.position == 'LEFT' then
                bu:SetPoint('LEFT', bar, 'LEFT', leftOffset, 0)
                leftOffset = leftOffset + (bu:GetWidth() - C.Mult)
            elseif bu.position == 'RIGHT' then
                bu:SetPoint('RIGHT', bar, 'RIGHT', rightOffset, 0)
                rightOffset = rightOffset - (bu:GetWidth() - C.Mult)
            else
                bu:SetPoint('CENTER', bar)
            end
        end
    end
end

function INFOBAR:ShowButton(button)
    button:Show()
    ReanchorButtons()
end

function INFOBAR:HideButton(button)
    button:Hide()
    ReanchorButtons()
end

function INFOBAR:AddBlock(text, position, width)
    local bar = INFOBAR.Bar
    local bu = CreateFrame('Button', nil, bar, 'BackdropTemplate')
    bu:SetPoint('TOP', bar, 'TOP')
    bu:SetPoint('BOTTOM', bar, 'BOTTOM')
    bu:SetWidth(width)
    F.CreateBD(bu)
    bu:SetBackdropColor(0, 0, 0, 0)
    bu:SetBackdropBorderColor(0, 0, 0, 0)

    if C.DB.Infobar.Mouseover then
        bu:SetAlpha(0)
    end

    local text = F.CreateFS(bu, C.Assets.Fonts.Condensed, 11, nil, text, nil, true, 'CENTER', 0, 0)
    bu.Text = text

    bu:SetScript('OnEnter', INFOBAR.Button_OnEnter)
    bu:SetScript('OnLeave', INFOBAR.Button_OnLeave)

    bu.position = position

    table.insert(INFOBAR.Buttons, bu)

    ReanchorButtons()

    return bu
end

function INFOBAR:OnLogin()
    if not C.DB.Infobar.Enable then
        return
    end

    INFOBAR:CreateInfoBar()
    INFOBAR:UpdateCombatPulse()
    INFOBAR:CreateStatsBlock()
    INFOBAR:CreateSpecBlock()
    INFOBAR:CreateDurabilityBlock()
    INFOBAR:CreateGuildBlock()
    INFOBAR:CreateFriendsBlock()
    INFOBAR:CreateReportBlock()
    INFOBAR:CreateCurrenciesBlock()
    INFOBAR:CreateGoldBlock()
end
