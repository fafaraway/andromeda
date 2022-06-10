local F, C, L = unpack(select(2, ...))
local MM = F:RegisterModule('GameMenu')

local buttonList = {}
local texPath = 'Interface\\AddOns\\' .. C.ADDON_NAME .. '\\assets\\textures\\menu\\'
local buttonsList = {
    {
        _G.CHARACTER_BUTTON,
        texPath .. 'player',
        function()
            securecall(_G.ToggleFrame, _G.CharacterFrame)
        end,
    },

    {
        _G.SPELLBOOK_ABILITIES_BUTTON,
        texPath .. 'spellbook',
        function()
            securecall(_G.ToggleFrame, _G.SpellBookFrame)
        end,
    },
    {
        _G.TALENTS_BUTTON,
        texPath .. 'talent',
        function()
            ToggleTalentFrame()
        end,
    },
    {
        _G.SOCIAL_BUTTON,
        texPath .. 'friend',
        function()
            ToggleFriendsFrame()
        end,
    },
    {
        _G.GUILD,
        texPath .. 'guild',
        function()
            ToggleGuildFrame()
        end,
    },
    {
        _G.ACHIEVEMENT_BUTTON,
        texPath .. 'achievement',
        function()
            ToggleAchievementFrame()
        end,
    },
    {
        _G.COLLECTIONS,
        texPath .. 'collection',
        function()
            ToggleCollectionsJournal()
        end,
    },
    {
        _G.LFG_TITLE,
        texPath .. 'lfg',
        function()
            ToggleLFDParentFrame()
        end,
    },
    {
        _G.ENCOUNTER_JOURNAL,
        texPath .. 'encounter',
        function()
            ToggleEncounterJournal()
        end,
    },
    {
        L['Calendar'],
        texPath .. 'calendar',
        function()
            ToggleCalendar()
        end,
    },
    {
        _G.MAP_AND_QUEST_LOG,
        texPath .. 'map',
        function()
            ToggleWorldMap()
        end,
    },
    {
        _G.BAGSLOT,
        texPath .. 'bag',
        function()
            ToggleAllBags()
        end,
    },
    {
        _G.BLIZZARD_STORE,
        texPath .. 'store',
        function()
            ToggleStoreUI()
        end,
    },
    {
        _G.GAMEMENU_SUPPORT,
        texPath .. 'help',
        function()
            ToggleHelpFrame()
        end,
    },
}

local function CreateButtonTexture(icon, texture)
    icon:SetAllPoints()
    icon:SetTexture(texture)
    if C.DB.General.GameMenuClassColor then
        icon:SetVertexColor(C.r, C.g, C.b)
    else
        icon:SetVertexColor(1, 1, 1)
    end
end

local function OnEnter(self)
    F:UIFrameFadeIn(self, C.DB.General.GameMenuSmooth, self:GetAlpha(), C.DB.General.GameMenuButtonInAlpha)
end

local function OnLeave(self)
    F:UIFrameFadeOut(self, C.DB.General.GameMenuSmooth, self:GetAlpha(), C.DB.General.GameMenuButtonOutAlpha)
end

local function OnClick(self)
    self.func()
end

function MM:Constructor(bar, data)
    local tip, texture, func = unpack(data)

    local bu = CreateFrame('Button', nil, bar)
    table.insert(buttonList, bu)
    bu:SetSize(C.DB.General.GameMenuButtonSize, C.DB.General.GameMenuButtonSize)
    bu:SetAlpha(C.DB.General.GameMenuButtonOutAlpha)
    bu.icon = bu:CreateTexture(nil, 'ARTWORK')

    bu.tip = tip
    bu.texture = texture
    bu.func = func

    CreateButtonTexture(bu.icon, texture)

    F.AddTooltip(bu, 'ANCHOR_RIGHT', tip)

    bu:HookScript('OnEnter', OnEnter)
    bu:HookScript('OnLeave', OnLeave)
    bu:HookScript('OnClick', OnClick)
end

function MM:OnLogin()
    if not C.DB.General.GameMenu then
        return
    end

    local buSize = C.DB.General.GameMenuButtonSize
    local buGap = C.DB.General.GameMenuButtonGap
    local buNum = #buttonsList

    local barWidth = (buSize * buNum) + (buGap * (buNum - 1))
    local bar = CreateFrame('Frame', C.ADDON_NAME .. 'GameMenu', _G.UIParent)
    bar:SetSize(barWidth, C.DB.General.GameMenuBarHeight)

    local glow = bar:CreateTexture(nil, 'BACKGROUND')
    glow:SetPoint('BOTTOMLEFT', bar, 'BOTTOMLEFT', -30, 0)
    glow:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 30, 0)
    glow:SetHeight(C.DB.General.GameMenuButtonSize * 2)
    glow:SetTexture(C.Assets.Texture.Glow)
    if C.DB.General.GameMenuClassColor then
        glow:SetVertexColor(C.r, C.g, C.b, C.DB.General.GameMenuBackdropAlpha)
    else
        glow:SetVertexColor(1, 1, 1, C.DB.General.GameMenuBackdropAlpha)
    end

    for _, info in pairs(buttonsList) do
        MM:Constructor(bar, info)
    end

    for i = 1, #buttonList do
        if i == 1 then
            buttonList[i]:SetPoint('LEFT')
        else
            buttonList[i]:SetPoint('LEFT', buttonList[i - 1], 'RIGHT', C.DB.General.GameMenuButtonGap, 0)
        end
    end

    F.Mover(bar, L['GameMenu'], 'GameMenu', { 'BOTTOM' })
end
