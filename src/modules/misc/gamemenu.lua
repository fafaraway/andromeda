local F, C, L = unpack(select(2, ...))
local MM = F:RegisterModule('GameMenu')

local buttonsList = {}
local menuList = {
    {
        _G.CHARACTER_BUTTON,
        C.Assets.Texture.MenuBarPlayer,
        function()
            securecall(_G.ToggleFrame, _G.CharacterFrame)
        end,
    },

    {
        _G.SPELLBOOK_ABILITIES_BUTTON,
        C.Assets.Texture.MenuBarSpellbook,
        function()
            securecall(_G.ToggleFrame, _G.SpellBookFrame)
        end,
    },
    {
        _G.TALENTS_BUTTON,
        C.Assets.Texture.MenuBarTalent,
        function()
            ToggleTalentFrame()
        end,
    },
    {
        _G.SOCIAL_BUTTON,
        C.Assets.Texture.MenuBarFriend,
        function()
            ToggleFriendsFrame()
        end,
    },
    {
        _G.GUILD,
        C.Assets.Texture.MenuBarGuild,
        function()
            ToggleGuildFrame()
        end,
    },
    {
        _G.ACHIEVEMENT_BUTTON,
        C.Assets.Texture.MenuBarAchievement,
        function()
            ToggleAchievementFrame()
        end,
    },
    {
        _G.COLLECTIONS,
        C.Assets.Texture.MenuBarCollection,
        function()
            ToggleCollectionsJournal()
        end,
    },
    {
        _G.LFG_TITLE,
        C.Assets.Texture.MenuBarLfg,
        function()
            ToggleLFDParentFrame()
        end,
    },
    {
        _G.ENCOUNTER_JOURNAL,
        C.Assets.Texture.MenuBarEncounter,
        function()
            ToggleEncounterJournal()
        end,
    },
    {
        L['Calendar'],
        C.Assets.Texture.MenuBarCalendar,
        function()
            ToggleCalendar()
        end,
    },
    {
        _G.MAP_AND_QUEST_LOG,
        C.Assets.Texture.MenuBarMap,
        function()
            ToggleWorldMap()
        end,
    },
    {
        _G.BAGSLOT,
        C.Assets.Texture.MenuBarBag,
        function()
            ToggleAllBags()
        end,
    },
    {
        _G.BLIZZARD_STORE,
        C.Assets.Texture.MenuBarStore,
        function()
            ToggleStoreUI()
        end,
    },
    {
        _G.GAMEMENU_SUPPORT,
        C.Assets.Texture.MenuBarHelp,
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
    tinsert(buttonsList, bu)
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
    local buNum = #menuList

    local barWidth = (buSize * buNum) + (buGap * (buNum - 1))
    local bar = CreateFrame('Frame', C.ADDON_TITLE .. 'GameMenu', _G.UIParent)
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

    for _, info in pairs(menuList) do
        MM:Constructor(bar, info)
    end

    for i = 1, #buttonsList do
        if i == 1 then
            buttonsList[i]:SetPoint('LEFT')
        else
            buttonsList[i]:SetPoint('LEFT', buttonsList[i - 1], 'RIGHT', C.DB.General.GameMenuButtonGap, 0)
        end
    end

    F.Mover(bar, L['GameMenu'], 'GameMenu', { 'BOTTOM' })
end
