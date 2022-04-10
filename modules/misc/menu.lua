local F, C, L = unpack(select(2, ...))
local MM = F:RegisterModule('MicroMenu')

local texPath = 'Interface\\AddOns\\FreeUI\\assets\\textures\\menu\\'
local buttonList = {}

local buAlpha = .6
local glowAlpha = .35
local buNum = 12
local buSize = 20
local buGap = 3
local barWidth = (buSize * buNum) + (buGap * (buNum - 1))

local buttonsList = {
    {'player', 'CharacterMicroButton'},
    {'spellbook', 'SpellbookMicroButton'},
    {'talents', 'TalentMicroButton'},
    {'achievements', 'AchievementMicroButton'},
    {'quests', 'QuestLogMicroButton'},
    {'guild', 'GuildMicroButton'},
    {'lfg', 'LFDMicroButton'},
    {'encounter', 'EJMicroButton'},
    {'collections', 'CollectionsMicroButton'},
    {'store', 'StoreMicroButton'},
    {'help', 'MainMenuMicroButton', MicroButtonTooltipText(_G.MAINMENU_BUTTON, 'TOGGLEGAMEMENU')},
    {
        'bags',
        function()
            ToggleAllBags()
        end,
        MicroButtonTooltipText(_G.BAGSLOT, 'OPENALLBAGS'),
    },
}

local function CreateButtonTexture(icon, texture)
    icon:SetOutside(nil, 3, 3)
    icon:SetTexture(texPath .. texture)
    icon:SetVertexColor(C.r, C.g, C.b)
end

local function CreateBarGlow(bar)
    local glow = bar:CreateTexture(nil, 'OVERLAY')
    glow:SetPoint('BOTTOMLEFT', bar, 'BOTTOMLEFT', -30, 0)
    glow:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 30, 0)
    glow:SetHeight(30)
    glow:SetTexture(C.Assets.Texture.Glow)
    glow:SetVertexColor(C.r, C.g, C.b, glowAlpha)
end

local function ResetButtonParent(button, parent)
    if parent ~= button.__owner then
        button:SetParent(button.__owner)
    end
end

local function ResetButtonAnchor(button)
    button:ClearAllPoints()
    button:SetAllPoints()
end

function MM:Constructor(parent, data)
    local texture, method, tooltip = unpack(data)

    local bu = CreateFrame('Frame', nil, parent)
    table.insert(buttonList, bu)
    bu:SetSize(buSize, buSize)
    bu:SetAlpha(buAlpha)

    local icon = bu:CreateTexture(nil, 'ARTWORK')
    CreateButtonTexture(icon, texture)

    if type(method) == 'string' then
        local button = _G[method]
        button:SetHitRectInsets(0, 0, 0, 0)
        button:SetParent(bu)
        button.__owner = bu
        hooksecurefunc(button, 'SetParent', ResetButtonParent)
        ResetButtonAnchor(button)
        hooksecurefunc(button, 'SetPoint', ResetButtonAnchor)
        button:UnregisterAllEvents()
        button:SetNormalTexture(nil)
        button:SetPushedTexture(nil)
        button:SetDisabledTexture(nil)

        if tooltip then
            F.AddTooltip(button, 'ANCHOR_RIGHT', tooltip)
        end

        local hl = button:GetHighlightTexture()
        CreateButtonTexture(hl, texture)
        hl:SetVertexColor(1, 1, 1)

        local flash = button.Flash
        CreateButtonTexture(flash, texture)
        flash:SetVertexColor(1, 1, 1)
    else
        bu:HookScript('OnMouseUp', method)
        F.AddTooltip(bu, 'ANCHOR_RIGHT', tooltip)

        local hl = bu:CreateTexture(nil, 'HIGHLIGHT')
        hl:SetBlendMode('ADD')
        CreateButtonTexture(hl, texture)
        hl:SetVertexColor(1, 1, 1)
    end
end

function MM:OnLogin()
    if not C.DB.General.MicroMenu then
        return
    end

    local bar = CreateFrame('Frame', 'FreeUIMicroMenu', _G.UIParent)
    bar:SetSize(barWidth, buSize)

    CreateBarGlow(bar)

    for _, info in pairs(buttonsList) do
        MM:Constructor(bar, info)
    end

    -- Order Positions
    for i = 1, #buttonList do
        if i == 1 then
            buttonList[i]:SetPoint('LEFT')
        else
            buttonList[i]:SetPoint('LEFT', buttonList[i - 1], 'RIGHT', buGap, 0)
        end
    end

    -- Create Mover
    F.Mover(bar, L['Micro Menu'], 'MicroMenu', {'BOTTOM'})

    -- Default elements
    F.HideObject(_G.MicroButtonPortrait)
    F.HideObject(_G.GuildMicroButtonTabard)
    F.HideObject(_G.MainMenuBarDownload)
    F.HideObject(_G.HelpOpenWebTicketButton)
    F.HideObject(_G.MainMenuBarPerformanceBar)
    _G.MainMenuMicroButton:SetScript('OnUpdate', nil)
end
