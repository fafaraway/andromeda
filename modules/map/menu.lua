local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('Map')

local menuList = {
    { text = _G.MAINMENU_BUTTON, isTitle = true, notCheckable = true },
    {
        text = _G.CHARACTER_BUTTON,
        icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleCharacter, 'PaperDollFrame')
        end,
        notCheckable = true,
    },
    {
        text = _G.SPELLBOOK_ABILITIES_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\Class',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            if not _G.SpellBookFrame:IsShown() then
                _G.ShowUIPanel(_G.SpellBookFrame)
            else
                _G.HideUIPanel(_G.SpellBookFrame)
            end
        end,
        notCheckable = true,
    },
    {
        text = _G.TALENTS_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\Ammunition',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            if not _G.PlayerTalentFrame then
                LoadAddOn('Blizzard_TalentUI')
            end
            if not _G.GlyphFrame then
                LoadAddOn('Blizzard_GlyphUI')
            end
            securecall(_G.ToggleFrame, _G.PlayerTalentFrame)
        end,
        notCheckable = true,
    },
    {
        text = _G.ACHIEVEMENT_BUTTON,
        icon = 'Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Shield',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleAchievementFrame)
        end,
        notCheckable = true,
    },
    {
        text = _G.MAP_AND_QUEST_LOG, -- OLD: QUESTLOG_BUTTON
        icon = 'Interface\\GossipFrame\\ActiveQuestIcon',
        func = function()
            securecall(_G.ToggleFrame, _G.WorldMapFrame)
        end,
        notCheckable = true,
    },
    {
        text = _G.COMMUNITIES_FRAME_TITLE, -- OLD: COMMUNITIES
        icon = 'Interface\\FriendsFrame\\UI-Toast-ChatInviteIcon',
        arg1 = IsInGuild('player'),
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            _G.ToggleCommunitiesFrame()
        end,
        notCheckable = true,
    },
    {
        text = _G.SOCIAL_BUTTON,
        icon = 'Interface\\FriendsFrame\\PlusManz-BattleNet',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleFriendsFrame, 1)
        end,
        notCheckable = true,
    },
    {
        text = _G.GROUP_FINDER, -- DUNGEONS_BUTTON
        icon = 'Interface\\LFGFRAME\\BattleNetWorking0',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleLFDParentFrame) -- OR securecall(PVEFrame_ToggleFrame, "GroupFinderFrame")
        end,
        notCheckable = true,
    },
    {
        text = _G.COLLECTIONS, -- OLD: MOUNTS_AND_PETS
        icon = 'Interface\\MINIMAP\\TRACKING\\Reagents',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffffff00' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleCollectionsJournal, 1)
        end,
        notCheckable = true,
    },
    {
        text = _G.ADVENTURE_JOURNAL, -- OLD: ENCOUNTER_JOURNAL
        icon = 'Interface\\MINIMAP\\TRACKING\\Profession',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleEncounterJournal)
        end,
        notCheckable = true,
    },
    {
        text = _G.BLIZZARD_STORE,
        icon = 'Interface\\MINIMAP\\TRACKING\\Auctioneer',
        func = function()
            if not _G.StoreFrame then
                LoadAddOn('Blizzard_StoreUI')
            end
            securecall(_G.ToggleStoreUI)
        end,
        notCheckable = true,
    },
    { text = '', isTitle = true, notCheckable = true },
    { text = _G.OTHER, isTitle = true, notCheckable = true },
    {
        text = _G.BACKPACK_TOOLTIP,
        icon = 'Interface\\MINIMAP\\TRACKING\\Banker',
        func = function()
            securecall(_G.ToggleAllBags)
        end,
        notCheckable = true,
    },
    --[[ {
        text = GARRISON_LANDING_PAGE_TITLE,
        icon = 'Interface\\HELPFRAME\\OpenTicketIcon',
        func = function()
            if InCombatLockdown() then
                UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(ShowGarrisonLandingPage, 2)
        end,
        notCheckable = true
    },
    {
        text = ORDER_HALL_LANDING_PAGE_TITLE,
        icon = 'Interface\\GossipFrame\\WorkOrderGossipIcon',
        func = function()
            if InCombatLockdown() then
                UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(ShowGarrisonLandingPage, 3)
        end,
        notCheckable = true
    }, ]]
    {
        text = _G.PLAYER_V_PLAYER,
        icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.TogglePVPUI, 1)
        end,
        notCheckable = true,
    },
    {
        text = _G.RAID,
        icon = 'Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleFriendsFrame, 3)
        end,
        notCheckable = true,
    },
    {
        text = _G.GM_EMAIL_NAME,
        icon = 'Interface\\CHATFRAME\\UI-ChatIcon-Blizz',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleHelpFrame)
        end,
        notCheckable = true,
    },
    {
        text = _G.CHANNEL,
        icon = 'Interface\\CHATFRAME\\UI-ChatIcon-ArmoryChat-AwayMobile',
        func = function()
            _G.ToggleChannelFrame()
        end,
        notCheckable = true,
    },
    {
        text = L['Calendar'],
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            if not _G.CalendarFrame then
                LoadAddOn('Blizzard_Calendar')
            end
            _G.Calendar_Toggle()
        end,
        notCheckable = true,
    },
    {
        text = _G.BATTLEFIELD_MINIMAP,
        colorCode = '|cff999999',
        func = function()
            if not _G.BattlefieldMapFrame then
                LoadAddOn('Blizzard_BattlefieldMap')
            end
            _G.BattlefieldMapFrame:Toggle()
        end,
        notCheckable = true,
    },
    { text = '', isTitle = true, notCheckable = true },
    { text = _G.ADDONS, isTitle = true, notCheckable = true },
    {
        text = _G.RELOADUI,
        colorCode = '|cff999999',
        func = function()
            _G.ReloadUI()
        end,
        notCheckable = true,
    },
}

function MAP:OnMouseWheel(zoom)
    if zoom > 0 then
        _G.Minimap_ZoomIn()
    else
        _G.Minimap_ZoomOut()
    end
end

function MAP:OnMouseUp(btn)
    if btn == 'RightButton' then
        if InCombatLockdown() then
            _G.UIErrorsFrame:AddMessage(C.INFO_COLOR .. _G.ERR_NOT_IN_COMBAT)
            return
        end
        _G.EasyMenu(menuList, F.EasyMenu, 'cursor', 0, 0, 'MENU', 3)
    elseif btn == 'MiddleButton' then
        _G.ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, self)
    else
        _G.Minimap_OnClick(self)
    end
end

function MAP:MouseFunc()
    _G.Minimap:EnableMouseWheel(true)
    _G.Minimap:SetScript('OnMouseWheel', MAP.OnMouseWheel)
    _G.Minimap:SetScript('OnMouseUp', MAP.OnMouseUp)
end
