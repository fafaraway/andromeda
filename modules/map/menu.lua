local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('Map')

MAP.MenuList = {
    {
        text = _G.CHARACTER_BUTTON,
        func = function()
            ToggleCharacter('PaperDollFrame')
        end,
    },
    {
        text = _G.SPELLBOOK_ABILITIES_BUTTON,
        func = function()
            ToggleFrame(_G.SpellBookFrame)
        end,
    },
    {
        text = _G.TIMEMANAGER_TITLE,
        func = function()
            ToggleFrame(_G.TimeManagerFrame)
        end,
    },
    { text = _G.CHAT_CHANNELS, func = ToggleChannelFrame },
    { text = _G.SOCIAL_BUTTON, func = ToggleFriendsFrame },
    { text = _G.TALENTS_BUTTON, func = ToggleTalentFrame },
    { text = _G.GUILD, func = ToggleGuildFrame },
    { text = _G.LFG_TITLE, func = ToggleLFDParentFrame },

    { text = _G.COLLECTIONS, func = ToggleCollectionsJournal },
    { text = _G.ACHIEVEMENT_BUTTON, func = ToggleAchievementFrame },
    {
        text = L['Calendar'],
        func = function()
            _G.GameTimeFrame:Click()
        end,
    },
    {
        text = _G.BLIZZARD_STORE,
        func = function()
            _G.StoreMicroButton:Click()
        end,
    },
    {
        text = _G.GARRISON_TYPE_8_0_LANDING_PAGE_TITLE,
        func = function()
            GarrisonLandingPageMinimapButton_OnClick(_G.GarrisonLandingPageMinimapButton)
        end,
    },
    {
        text = _G.ENCOUNTER_JOURNAL,
        func = function()
            if not IsAddOnLoaded('Blizzard_EncounterJournal') then
                UIParentLoadAddOn('Blizzard_EncounterJournal')
            end
            ToggleFrame(_G.EncounterJournal)
        end,
    },
    {
        text = _G.MAINMENU_BUTTON,
        func = function()
            if not _G.GameMenuFrame:IsShown() then
                if _G.VideoOptionsFrame:IsShown() then
                    _G.VideoOptionsFrameCancel:Click()
                elseif _G.AudioOptionsFrame:IsShown() then
                    _G.AudioOptionsFrameCancel:Click()
                elseif _G.InterfaceOptionsFrame:IsShown() then
                    _G.InterfaceOptionsFrameCancel:Click()
                end

                CloseMenus()
                CloseAllWindows()
                PlaySound(850) --IG_MAINMENU_OPEN
                ShowUIPanel(_G.GameMenuFrame)
            else
                PlaySound(854) --IG_MAINMENU_QUIT
                HideUIPanel(_G.GameMenuFrame)
                MainMenuMicroButton_SetNormal()
            end
        end,
    },
    {
        text = _G.HELP_BUTTON,
        bottom = true,
        func = ToggleHelpFrame,
    },
}
