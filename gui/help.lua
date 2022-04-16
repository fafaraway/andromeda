local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')

local strList = {
    tip = L['Double-click left mouse button or press ESC key to exit this screen.'],
    cmd = {
        primary = {
            [0] = L['*/free|r @--|r#install|r @or|r */free|r @--|r#tutorial|r ~ Open tutorial panel'],
            [1] = L['*/free|r @--|r#gui|r @or|r */free|r @--|r#config|r ~ Open GUI panel'],
            [2] = L['*/free|r @--|r#unlock|r @or|r */free|r @--|r#layout|r ~ Unlock FreeUI interface to allow you to freely drag and drop the elements.'],
            [3] = L['*/free|r @--|r#reset|r @or|r */free|r @--|r#init|r ~ Initialize FreeUI and all settings will be reset to their default state.'],
            [4] = L['*/free|r @--|r#ver|r @or|r */free|r @--|r#version|r ~ Output the current version number of FreeUI.'],
            [5] = L['*/free|r @--|r#help|r @or|r */free|r @--|r#command|r ~ View all available commands.'],
            [6] = L['*/free|r @--|r#discord|r @or|r */free|r @--|r#feedback|r ~ Output the discord channel link of FreeUI.'],
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

local function FormatTextString(str)
    str = str:gsub('*', C.CLASS_COLOR)
    str = str:gsub('#', '|cffffeccb')
    str = str:gsub('@', C.GREY_COLOR)

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
    f.title = F.CreateFS(
        f,
        C.ASSET_PATH .. 'fonts\\header.ttf',
        56,
        nil,
        C.COLORED_ADDON_NAME,
        nil,
        'THICK',
        'TOP',
        0,
        -C.UI_GAP
    )
    f.version = F.CreateFS(
        f,
        C.Assets.Font.Bold,
        12,
        nil,
        'Version: ' .. C.ADDON_VERSION,
        'GREY',
        'THICK',
        'TOP',
        0,
        -90
    )
    f.tip = F.CreateFS(f, C.Assets.Font.Bold, 12, nil, strList.tip, { 0.3, 0.3, 0.3 }, 'THICK', 'BOTTOM', 0, C.UI_GAP)

    local offset = 50
    for k, v in ipairs(strList.cmd.primary) do
        local a, b = string.split('~', v)
        -- local newStr = FormatTextString(a .. b)

        F.CreateFS(
            f.box,
            C.Assets.Font.Bold,
            18,
            nil,
            FormatTextString(a),
            { 0.7, 0.7, 0.7 },
            'THICK',
            'TOPLEFT',
            0,
            -(k * 50)
        )

        F.CreateFS(f.box, C.Assets.Font.Bold, 16, nil, b, { 0.7, 0.7, 0.7 }, 'THICK', 'TOPLEFT', 0, -(k * 24) - offset)
        offset = offset + 26
    end

    for k, v in ipairs(strList.cmd.secondary) do
        local a, b = string.split('~', v)
        local newStr = FormatTextString(a .. b)

        F.CreateFS(
            f.box,
            C.Assets.Font.Bold,
            14,
            nil,
            newStr,
            { 0.7, 0.7, 0.7 },
            'THICK',
            'TOPLEFT',
            0,
            -(k * 24) - 340
        )
    end
end

function GUI:CreateCheatSheet()
    if InCombatLockdown() then
        return
    end
    if _G.FreeUICheatSheet then
        return
    end

    local f = CreateFrame('Button', 'FreeUICheatSheet', _G.UIParent)
    f:SetFrameStrata('FULLSCREEN')
    f:SetAllPoints()
    f:EnableMouse(true)
    f:SetAlpha(0)
    f:Hide()

    f.bg = F.SetBD(f)
    f.bg:SetBackdropColor(0, 0, 0, 0.7)

    f.box = CreateFrame('Frame', nil, f)
    f.box:SetSize(800, 700)
    f.box:SetPoint('TOP', f, 0, -100)

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
    if _G.FreeUICheatSheet then
        if _G.FreeUICheatSheet:IsShown() then
            Disable()
        else
            Enable()
        end
    else
        GUI:CreateCheatSheet()
    end
end
