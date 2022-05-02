local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('Map')

MAP.MenuList = {
    {
        text = CHARACTER_BUTTON,
        func = function()
            ToggleCharacter('PaperDollFrame')
        end,
    },
    {
        text = SPELLBOOK_ABILITIES_BUTTON,
        func = function()
            ToggleFrame(SpellBookFrame)
        end,
    },
    {
        text = TIMEMANAGER_TITLE,
        func = function()
            ToggleFrame(TimeManagerFrame)
        end,
    },
    { text = CHAT_CHANNELS, func = ToggleChannelFrame },
    { text = SOCIAL_BUTTON, func = ToggleFriendsFrame },
    { text = TALENTS_BUTTON, func = ToggleTalentFrame },
    { text = GUILD, func = ToggleGuildFrame },
    { text = LFG_TITLE, func = ToggleLFDParentFrame },

    { text = COLLECTIONS, func = ToggleCollectionsJournal },
    { text = ACHIEVEMENT_BUTTON, func = ToggleAchievementFrame },
    {
        text = L['Calendar'],
        func = function()
            GameTimeFrame:Click()
        end,
    },
    {
        text = BLIZZARD_STORE,
        func = function()
            StoreMicroButton:Click()
        end,
    },
    {
        text = GARRISON_TYPE_8_0_LANDING_PAGE_TITLE,
        func = function()
            GarrisonLandingPageMinimapButton_OnClick(GarrisonLandingPageMinimapButton)
        end,
    },
    {
        text = ENCOUNTER_JOURNAL,
        func = function()
            if not IsAddOnLoaded('Blizzard_EncounterJournal') then
                UIParentLoadAddOn('Blizzard_EncounterJournal')
            end
            ToggleFrame(EncounterJournal)
        end,
    },
    {
        text = MAINMENU_BUTTON,
        func = function()
            if not GameMenuFrame:IsShown() then
                if VideoOptionsFrame:IsShown() then
                    VideoOptionsFrameCancel:Click()
                elseif AudioOptionsFrame:IsShown() then
                    AudioOptionsFrameCancel:Click()
                elseif InterfaceOptionsFrame:IsShown() then
                    InterfaceOptionsFrameCancel:Click()
                end

                CloseMenus()
                CloseAllWindows()
                PlaySound(850) --IG_MAINMENU_OPEN
                ShowUIPanel(GameMenuFrame)
            else
                PlaySound(854) --IG_MAINMENU_QUIT
                HideUIPanel(GameMenuFrame)
                MainMenuMicroButton_SetNormal()
            end
        end,
    },
    {
        text = HELP_BUTTON,
        bottom = true,
        func = ToggleHelpFrame,
    },
}
