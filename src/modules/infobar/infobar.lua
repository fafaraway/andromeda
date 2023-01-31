local F, C = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

local barAlpha, blockAlpha

INFOBAR.Modules = {}
INFOBAR.Blocks = {}

local function fadeIn(self, elapsed)
    local bar = INFOBAR.Bar
    if barAlpha < 0.5 then
        barAlpha = barAlpha + elapsed
        blockAlpha = blockAlpha + (elapsed * 4)
    else
        barAlpha = 0.5
        blockAlpha = 1
        bar:SetScript('OnUpdate', nil)
    end

    if bar.bg then
        bar.bg:SetBackdropColor(0, 0, 0, barAlpha)
    end

    for _, block in pairs(INFOBAR.Blocks) do
        if not block.noFade then
            block:SetAlpha(F.TempFixSetAlpha(blockAlpha))
        end
    end
end

local function fadeOut(self, elapsed)
    local bar = INFOBAR.Bar
    if barAlpha > 0.25 then
        barAlpha = barAlpha - elapsed
        blockAlpha = blockAlpha - (elapsed * 4)
    else
        barAlpha = 0.25
        blockAlpha = 0
        bar:SetScript('OnUpdate', nil)
    end

    if bar.bg then
        bar.bg:SetBackdropColor(0, 0, 0, barAlpha)
    end

    for _, block in pairs(INFOBAR.Blocks) do
        if not block.noFade then
            block:SetAlpha(F.TempFixSetAlpha(blockAlpha))
        end
    end
end

local function bar_OnEnter()
    if not C.DB.Infobar.Mouseover then
        return
    end

    local bar = INFOBAR.Bar
    bar:SetScript('OnUpdate', fadeIn)
end

local function bar_OnLeave()
    if not C.DB.Infobar.Mouseover then
        return
    end

    local bar = INFOBAR.Bar
    bar:SetScript('OnUpdate', fadeOut)
end

local function block_OnEnter(block)
    bar_OnEnter()
    block:SetBackdropColor(C.r, C.g, C.b, 0.25)
end

local function block_OnLeave(block)
    bar_OnLeave()
    block:SetBackdropColor(0, 0, 0, 0)
end

local function block_OnEvent(block, ...)
    block:onEvent(...)
end

local function sortBlock()
    local bar = INFOBAR.Bar
    local leftOffset, rightOffset = 0, 0

    for i = 1, #INFOBAR.Blocks do
        local block = INFOBAR.Blocks[i]

        if block:IsShown() then
            if block.position == 'LEFT' then
                block:SetPoint('LEFT', bar, 'LEFT', leftOffset, 0)
                leftOffset = leftOffset + (block:GetWidth() - C.MULT)
            elseif block.position == 'RIGHT' then
                block:SetPoint('RIGHT', bar, 'RIGHT', rightOffset, 0)
                rightOffset = rightOffset - (block:GetWidth() - C.MULT)
            else
                block:SetPoint('CENTER', bar)
            end
        end
    end
end

function INFOBAR:RegisterNewBlock(name, position, width, noFade)
    local block = CreateFrame('Button', nil, INFOBAR.Bar, 'BackdropTemplate')
    block:SetPoint('TOP', INFOBAR.Bar, 'TOP')
    block:SetPoint('BOTTOM', INFOBAR.Bar, 'BOTTOM')
    block:SetWidth(width)
    F.CreateBD(block)
    block:SetBackdropColor(0, 0, 0, 0)
    block:SetBackdropBorderColor(0, 0, 0, 0)

    local outline = _G.ANDROMEDA_ADB.FontOutline
    block.text = F.CreateFS(block, C.Assets.Fonts.Condensed, 11, outline or nil, '', nil, outline and 'NONE' or 'THICK', 'CENTER', 0, 0)
    block.position = position

    if C.DB.Infobar.Mouseover and not noFade then
        block:SetAlpha(0)
    end

    block:SetScript('OnEnter', block_OnEnter)
    block:SetScript('OnLeave', block_OnLeave)

    if noFade then
        block.noFade = true
    end

    INFOBAR.Modules[strlower(name)] = block

    tinsert(INFOBAR.Blocks, block)

    sortBlock()

    return block
end

function INFOBAR:CreateInfoBar()
    local mouseover = C.DB.Infobar.Mouseover
    local anchorTop = C.DB.Infobar.AnchorTop

    local bar = CreateFrame('Frame', C.ADDON_TITLE .. 'Infobar', _G.UIParent, 'BackdropTemplate')
    bar:SetFrameStrata('BACKGROUND')
    bar:SetHeight(C.DB.Infobar.Height)
    bar:SetPoint(anchorTop and 'TOPLEFT' or 'BOTTOMLEFT', 0, 0)
    bar:SetPoint(anchorTop and 'TOPRIGHT' or 'BOTTOMRIGHT', 0, 0)

    barAlpha = mouseover and 0.25 or 0.65
    blockAlpha = mouseover and 0 or 1

    bar:SetScript('OnEnter', bar_OnEnter)
    bar:SetScript('OnLeave', bar_OnLeave)

    _G.RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show')

    INFOBAR.Bar = bar

    bar.bg = CreateFrame('Frame', nil, bar, 'BackdropTemplate')
    bar.bg:SetOutside(bar, 2, 2)
    bar.bg:SetFrameStrata('BACKGROUND')
    bar.bg:SetFrameLevel(1) -- Make sure the frame level is higher than the vignetting
    bar.bg:SetBackdrop({ bgFile = C.Assets.Textures.Backdrop, edgeFile = C.Assets.Textures.Backdrop, edgeSize = 1 })
    bar.bg:SetBackdropColor(0, 0, 0, mouseover and 0.25 or 0.65)
    bar.bg:SetBackdropBorderColor(0, 0, 0)

    bar.anim = bar.bg:CreateAnimationGroup()
    bar.anim:SetLooping('BOUNCE')
    bar.anim.fader = bar.anim:CreateAnimation('Alpha')
    bar.anim.fader:SetFromAlpha(1)
    bar.anim.fader:SetToAlpha(0.2)
    bar.anim.fader:SetDuration(1)
    bar.anim.fader:SetSmoothing('OUT')
end

function INFOBAR:LoadInfobar(block)
    if block.eventList then
        for _, event in pairs(block.eventList) do
            block:RegisterEvent(event)
        end
        block:HookScript('OnEvent', block_OnEvent)
    end

    if block.onEnter then
        block:HookScript('OnEnter', block.onEnter)
    end

    if block.onLeave then
        block:HookScript('OnLeave', block.onLeave)
    end

    if block.onMouseUp then
        block:HookScript('OnMouseUp', block.onMouseUp)
    end

    if block.onUpdate then
        block:HookScript('OnUpdate', block.onUpdate)
    end
end

local function UpdateCombatPulse(event)
    local bar = INFOBAR.Bar
    if event == 'PLAYER_REGEN_DISABLED' then
        bar.bg:SetBackdropBorderColor(C.r, C.g, C.b)
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

function INFOBAR:CreateCombatPulse()
    if C.DB.Infobar.CombatPulse then
        F:RegisterEvent('PLAYER_REGEN_ENABLED', UpdateCombatPulse)
        F:RegisterEvent('PLAYER_REGEN_DISABLED', UpdateCombatPulse)
        F:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES', UpdateCombatPulse)
    else
        F:UnregisterEvent('PLAYER_REGEN_ENABLED', UpdateCombatPulse)
        F:UnregisterEvent('PLAYER_REGEN_DISABLED', UpdateCombatPulse)
        F:UnregisterEvent('CALENDAR_UPDATE_PENDING_INVITES', UpdateCombatPulse)
    end
end

function INFOBAR:OnLogin()
    if not C.DB.Infobar.Enable then
        return
    end

    INFOBAR:CreateInfoBar()
    INFOBAR:CreateCombatPulse()

    INFOBAR:CreateSystemBlock()
    INFOBAR:CreateDurabilityBlock()
    INFOBAR:CreateCurrencyBlock()
    INFOBAR:CreateGoldBlock()
    INFOBAR:CreateSpecBlock()

    INFOBAR:CreateGuildBlock()
    INFOBAR:CreateFriendsBlock()
    INFOBAR:CreateDailyBlock()

    for _, block in pairs(INFOBAR.Modules) do
        INFOBAR:LoadInfobar(block)
    end

    INFOBAR.loginTime = GetTime()
end
