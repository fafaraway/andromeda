local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')

local strList = {
    tip = L['Double click left mouse button or press ESC key to exit this screen.'],
    cmd = {
        primary = {
            [1] = L['*/and|r @--|r#tutorial|r ~ Open the installation/tutorial panel.'],
            [2] = L['*/and|r @--|r#gui|r ~ Open the control panel.'],
            [3] = L['*/and|r @--|r#layout|r ~ Unlock the user interface and move the components freely.'],
            [4] = L['*/and|r @--|r#reset|r ~ Initialize all settings and restore them to their default values.'],
            [5] = L['*/and|r @--|r#version|r ~ Show the current version number.'],
            [6] = L['*/and|r @--|r#help|r ~ Show all available command lines.'],
            [7] = L['*/and|r @--|r#logo|r ~ Show the logo animation.'],
        },
        secondary = {
            [1] = L['*/lg|r ~ Leave the current group, support both party and raid.'],
            [2] = L['*/disband|r ~ Disband the current group, support both party and raid.'],
            [3] = L['*/convert|r ~ Converts the current party to raid or vice versa.'],
            [4] = L['*/rdc|r ~ Initiate ready check.'],
            [5] = L['*/role|r ~ Initiate role poll.'],
            [6] = L['*/ri|r ~ Reset instance.'],
            [7] = L['*/tt|r ~ Whisper to current target.'],
            [8] = L['*/bb|r ~ Set BattleNet broadcast.'],
            [9] = L['*/clear|r ~ Clear the chat window.'],
            [10] = L['*/ss|r ~ Take a screenshot.'],
            [11] = L["*/spec|r ~ Switch specialization, such as '*/spec|r #2|r' will switch to the second specialization of your class."],
            [12] = L['*/rl|r ~ Reload interface.'],
        },
    },
}

function GUI:FormatTextString(str)
    str = gsub(str, '&ADDON_NAME&', C.COLORFUL_ADDON_TITLE)
    str = gsub(str, '*', C.MY_CLASS_COLOR)
    str = gsub(str, '#', '|cffffeccb')
    str = gsub(str, '@', C.GREY_COLOR)

    return str
end

local function Enable()
    local self = GUI.CheatSheet
    if not self then
        return
    end

    self:Show()
    self.fadeIn:Play()
end

local function Disable()
    local self = GUI.CheatSheet
    if not self then
        return
    end

    self.fadeOut:Play()
end

local function OnShow()
    PlaySound(SOUNDKIT.UI_BONUS_EVENT_SYSTEM_VIGNETTES)
end

local function OnHide()
    -- PlaySound(SOUNDKIT.KEY_RING_CLOSE)
end

local function OnKeyUp(_, key)
    local self = GUI.CheatSheet
    if not self then
        return
    end
    if key == 'ESCAPE' then
        if self:IsShown() then
            Disable()
        end
    end
end

local function OnEvent()
    local self = GUI.CheatSheet
    if not self then
        return
    end

    if self:IsShown() then
        Disable()
    end
end

local function ConstructAnimation(f)
    local fadeIn = f:CreateAnimationGroup()
    fadeIn.anim = fadeIn:CreateAnimation('Alpha')
    fadeIn.anim:SetDuration(2)
    fadeIn.anim:SetSmoothing('OUT')
    fadeIn.anim:SetFromAlpha(0)
    fadeIn.anim:SetToAlpha(1)
    fadeIn:HookScript('OnFinished', function(self)
        self:GetParent():SetAlpha(1)
    end)
    f.fadeIn = fadeIn

    local fadeOut = f:CreateAnimationGroup()
    fadeOut.anim = fadeOut:CreateAnimation('Alpha')
    fadeOut.anim:SetDuration(1)
    fadeOut.anim:SetSmoothing('OUT')
    fadeOut.anim:SetFromAlpha(1)
    fadeOut.anim:SetToAlpha(0)
    fadeOut:HookScript('OnFinished', function(self)
        self:GetParent():SetAlpha(0)
        self:GetParent():Hide()
    end)
    f.fadeOut = fadeOut
end

local function ConstructTextString(f)
    local outline = _G.ANDROMEDA_ADB.FontOutline
    f.title = F.CreateFS(f, C.ASSET_PATH .. 'fonts\\header.ttf', 56, outline, C.COLORFUL_ADDON_TITLE, nil, outline or 'THICK', 'TOP', 0, -C.UI_GAP)
    f.version = F.CreateFS(f, C.Assets.Font.Condensed, 12, outline, 'Version: ' .. C.ADDON_VERSION, { 0.7, 0.7, 0.7 }, outline or 'THICK', 'TOP', 0, -100)
    f.tip = F.CreateFS(f, C.Assets.Font.Bold, 10, outline, strList.tip, { 0.3, 0.3, 0.3 }, outline or 'THICK', 'BOTTOM', 0, C.UI_GAP)

    GUI:CreateGradientLine(f, 300, -150, -90, 150, -90)

    local offset = 50
    for k, v in ipairs(strList.cmd.primary) do
        local a, b = strsplit('~', v)
        local str1 = GUI:FormatTextString(a)
        local str2 = GUI:FormatTextString(b)

        F.CreateFS(f.lbox, C.Assets.Font.Bold, 18, outline, str1, { 0.7, 0.7, 0.7 }, outline or 'THICK', 'TOPLEFT', 0, -(k * 50))
        F.CreateFS(f.lbox, C.Assets.Font.Bold, 16, outline, str2, { 0.6, 0.6, 0.6 }, outline or 'THICK', 'TOPLEFT', 0, -(k * 24) - offset)

        offset = offset + 26
    end

    for k, v in ipairs(strList.cmd.secondary) do
        local a, b = strsplit('~', v)
        local newStr = GUI:FormatTextString(a .. b)

        F.CreateFS(f.rbox, C.Assets.Font.Bold, 14, outline, newStr, { 0.6, 0.6, 0.6 }, outline or 'THICK', 'TOPLEFT', 0, -(k * 24) - 26)
    end
end

function GUI:CreateCheatSheet()
    if InCombatLockdown() then
        return
    end
    if _G[C.ADDON_TITLE .. 'CheatSheet'] then
        return
    end

    local f = CreateFrame('Button', C.ADDON_TITLE .. 'CheatSheet', _G.UIParent)
    f:SetFrameStrata('FULLSCREEN')
    f:SetAllPoints()
    f:EnableMouse(true)
    f:SetAlpha(0)
    f:Hide()

    f.bg = F.SetBD(f)
    f.bg:SetBackdropColor(0, 0, 0, 0.85)

    -- f.box = CreateFrame('Frame', nil, f)
    -- f.box:SetSize(500, 700)
    -- f.box:SetPoint('TOP', f, 0, -100)

    f.lbox = CreateFrame('Frame', nil, f)
    f.lbox:SetSize(400, 600)
    f.lbox:SetPoint('TOPRIGHT', f, 'TOP', -20, -140)

    f.rbox = CreateFrame('Frame', nil, f)
    f.rbox:SetSize(400, 600)
    f.rbox:SetPoint('TOPLEFT', f, 'TOP', 80, -140)

    ConstructAnimation(f)
    ConstructTextString(f)

    f:SetScript('OnDoubleClick', Disable)
    f:SetScript('OnKeyUp', OnKeyUp)
    f:SetScript('OnShow', OnShow)
    f:SetScript('OnHide', OnHide)

    F:RegisterEvent('PLAYER_REGEN_DISABLED', OnEvent)

    GUI.CheatSheet = f
end

function GUI:ToggleCheatSheet()
    if _G[C.ADDON_TITLE .. 'CheatSheet'] then
        if _G[C.ADDON_TITLE .. 'CheatSheet']:IsShown() then
            Disable()
        else
            Enable()
        end
    else
        GUI:CreateCheatSheet()
    end
end
