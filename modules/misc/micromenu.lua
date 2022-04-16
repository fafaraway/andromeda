local F, C, L = unpack(select(2, ...))
local MM = F:RegisterModule('MicroMenu')

local buttonList = {}
local texPath = 'Interface\\AddOns\\FreeUI\\assets\\textures\\menu\\'
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
            _G.ToggleTalentFrame()
        end,
    },
    {
        _G.SOCIAL_BUTTON,
        texPath .. 'friend',
        function()
            _G.ToggleFriendsFrame()
        end,
    },
    {
        _G.GUILD,
        texPath .. 'guild',
        function()
            _G.ToggleGuildFrame()
        end,
    },
    {
        _G.ACHIEVEMENT_BUTTON,
        texPath .. 'achievement',
        function()
            _G.ToggleAchievementFrame()
        end,
    },
    {
        _G.COLLECTIONS,
        texPath .. 'collection',
        function()
            _G.ToggleCollectionsJournal()
        end,
    },
    {
        _G.LFG_TITLE,
        texPath .. 'lfg',
        function()
            _G.ToggleLFDParentFrame()
        end,
    },
    {
        _G.ENCOUNTER_JOURNAL,
        texPath .. 'encounter',
        function()
            _G.ToggleEncounterJournal()
        end,
    },
    {
        L['Calendar'],
        texPath .. 'calendar',
        function()
            _G.ToggleCalendar()
        end,
    },
    {
        _G.MAP_AND_QUEST_LOG,
        texPath .. 'map',
        function()
            _G.ToggleWorldMap()
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
            _G.ToggleStoreUI()
        end,
    },
    {
        _G.GAMEMENU_SUPPORT,
        texPath .. 'help',
        function()
            _G.ToggleHelpFrame()
        end,
    },
}

local function CreateButtonTexture(icon, texture)
    icon:SetAllPoints()
    icon:SetTexture(texture)
    if C.DB.General.MicroMenuClassColor then
        icon:SetVertexColor(C.r, C.g, C.b)
    else
        icon:SetVertexColor(1, 1, 1)
    end
end

local function OnEnter(self)
    F:UIFrameFadeIn(self, C.DB.General.MicroMenuSmooth, self:GetAlpha(), C.DB.General.MicroMenuButtonInAlpha)
end

local function OnLeave(self)
    F:UIFrameFadeOut(self, C.DB.General.MicroMenuSmooth, self:GetAlpha(), C.DB.General.MicroMenuButtonOutAlpha)
end

local function OnClick(self)
    self.func()
end

function MM:Constructor(bar, data)
    local tip, texture, func = unpack(data)

    local bu = CreateFrame('Button', nil, bar)
    table.insert(buttonList, bu)
    bu:SetSize(C.DB.General.MicroMenuButtonSize, C.DB.General.MicroMenuButtonSize)
    bu:SetAlpha(C.DB.General.MicroMenuButtonOutAlpha)
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
    if not C.DB.General.MicroMenu then
        return
    end

    local buSize = C.DB.General.MicroMenuButtonSize
    local buGap = C.DB.General.MicroMenuButtonGap
    local buNum = #buttonsList

    local barWidth = (buSize * buNum) + (buGap * (buNum - 1))
    local bar = CreateFrame('Frame', 'FreeUIMicroMenu', _G.UIParent)
    bar:SetSize(barWidth, C.DB.General.MicroMenuBarHeight)

    local glow = bar:CreateTexture(nil, 'BACKGROUND')
    glow:SetPoint('BOTTOMLEFT', bar, 'BOTTOMLEFT', -30, 0)
    glow:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 30, 0)
    glow:SetHeight(C.DB.General.MicroMenuButtonSize * 2)
    glow:SetTexture(C.Assets.Texture.Glow)
    if C.DB.General.MicroMenuClassColor then
        glow:SetVertexColor(C.r, C.g, C.b, C.DB.General.MicroMenuBackdropAlpha)
    else
        glow:SetVertexColor(1, 1, 1, C.DB.General.MicroMenuBackdropAlpha)
    end

    for _, info in pairs(buttonsList) do
        MM:Constructor(bar, info)
    end

    for i = 1, #buttonList do
        if i == 1 then
            buttonList[i]:SetPoint('LEFT')
        else
            buttonList[i]:SetPoint('LEFT', buttonList[i - 1], 'RIGHT', C.DB.General.MicroMenuButtonGap, 0)
        end
    end

    F.Mover(bar, L['Micro Menu'], 'MicroMenu', { 'BOTTOM' })
end
