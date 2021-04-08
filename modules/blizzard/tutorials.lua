-- Credit ketho
-- https://github.com/ketho-wow/HideTutorial

local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetBuildInfo = GetBuildInfo
local C_CVar = C_CVar
local C_PlayerInfo = C_PlayerInfo
local NUM_LE_FRAME_TUTORIALS = NUM_LE_FRAME_TUTORIALS
local NUM_LE_FRAME_TUTORIAL_ACCCOUNTS = NUM_LE_FRAME_TUTORIAL_ACCCOUNTS
local SetCVar = SetCVar
local NewPlayerExperience = NewPlayerExperience
local NPE_TutorialKeyboardMouseFrame_Frame = NPE_TutorialKeyboardMouseFrame_Frame

local F, C = unpack(select(2, ...))

local function OnEvent(self, event, addon)
    if event == 'ADDON_LOADED' and addon == 'HideTutorial' then
        local tocVersion = select(4, GetBuildInfo())
        if not C.DB.toc_version or C.DB.toc_version < tocVersion then
            -- only do this once per character
            C.DB.toc_version = tocVersion
        end
    elseif event == 'VARIABLES_LOADED' then
        local lastInfoFrame = C_CVar.GetCVarBitfield('closedInfoFrames', NUM_LE_FRAME_TUTORIALS)
        if C.DB.InstallationComplete or not lastInfoFrame then
            C_CVar.SetCVar('showTutorials', 0)
            C_CVar.SetCVar('showNPETutorials', 0)
            C_CVar.SetCVar('hideAdventureJournalAlerts', 1)
            -- help plates
            for i = 1, NUM_LE_FRAME_TUTORIALS do
                C_CVar.SetCVarBitfield('closedInfoFrames', i, true)
            end
            for i = 1, NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
                C_CVar.SetCVarBitfield('closedInfoFramesAccountWide', i, true)
            end
        end

        function MainMenuMicroButton_AreAlertsEnabled()
            return false
        end
    end
end

-- if you're in Exile's Reach and level 1 this cvar gets automatically enabled
hooksecurefunc('NPE_CheckTutorials', function()
    if C_PlayerInfo.IsPlayerNPERestricted() and C.MyLevel == 1 then
        SetCVar('showTutorials', 0)
        NewPlayerExperience:Shutdown()
        -- for some reason this window still shows up
        NPE_TutorialKeyboardMouseFrame_Frame:Hide()
    end
end)

local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('VARIABLES_LOADED')
f:SetScript('OnEvent', OnEvent)

