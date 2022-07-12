local F, C, L = unpack(select(2, ...))
local M = F:GetModule('Misc')

-- Force warning
do
    local function onEvent(_, event)
        if event == 'UPDATE_BATTLEFIELD_STATUS' then
            for i = 1, GetMaxBattlefieldID() do
                local status = GetBattlefieldStatus(i)
                if status == 'confirm' then
                    PlaySound(_G.SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
                    break
                end
                i = i + 1
            end
        elseif event == 'PET_BATTLE_QUEUE_PROPOSE_MATCH' then
            PlaySound(_G.SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
        elseif event == 'LFG_PROPOSAL_SHOW' then
            PlaySound(_G.SOUNDKIT.READY_CHECK, 'Master')
        elseif event == 'RESURRECT_REQUEST' then
            PlaySound(37, 'Master')
        end
    end

    local function hook(_, initiator)
        if initiator ~= 'player' then
            PlaySound(_G.SOUNDKIT.READY_CHECK, 'Master')
        end
    end

    function M:ForceWarning()
        F:RegisterEvent('UPDATE_BATTLEFIELD_STATUS', onEvent)
        F:RegisterEvent('PET_BATTLE_QUEUE_PROPOSE_MATCH', onEvent)
        F:RegisterEvent('LFG_PROPOSAL_SHOW', onEvent)
        F:RegisterEvent('RESURRECT_REQUEST', onEvent)

        hooksecurefunc('ShowReadyCheck', hook)
    end
end

-- alt+click to buy a stack
do
    local str = '\n|cffff0000<' .. L['Alt+Click to buy a stack'] .. '>|r'
    _G.ITEM_VENDOR_STACK_BUY = _G.ITEM_VENDOR_STACK_BUY .. str

    local function OnModifiedClick(self)
        if not IsAltKeyDown() then
            return
        end

        local id = self:GetID()
        local itemLink = GetMerchantItemLink(id)

        if not itemLink then
            return
        end

        local maxStack = select(8, GetItemInfo(itemLink))
        if maxStack and maxStack > 1 then
            local numAvailable = select(5, GetMerchantItemInfo(id))
            if numAvailable > -1 then
                BuyMerchantItem(id, numAvailable)
            else
                BuyMerchantItem(id, GetMerchantItemMaxStack(id))
            end
        end
    end

    hooksecurefunc('MerchantItemButton_OnModifiedClick', OnModifiedClick)
end

-- mute some annoying sounds
do
    local soundsList = {
        -- Train
        -- Blood Elf
        '539219',
        '539203',
        '1313588',
        '1306531',
        -- Draenei
        '539516',
        '539730',
        -- Dwarf
        '539802',
        '539881',
        -- Gnome
        '540271',
        '540275',
        -- Goblin
        '541769',
        '542017',
        -- Human
        '540535',
        '540734',
        -- Night Elf
        '540870',
        '540947',
        '1316209',
        '1304872',
        -- Orc
        '541157',
        '541239',
        -- Pandaren
        '636621',
        '630296',
        '630298',
        -- Tauren
        '542818',
        '542896',
        -- Troll
        '543085',
        '543093',
        -- Undead
        '542526',
        '542600',
        -- Worgen
        '542035',
        '542206',
        '541463',
        '541601',
        -- Dark Iron
        '1902030',
        '1902543',
        -- Highmount
        '1730534',
        '1730908',
        -- Kul Tiran
        '2531204',
        '2491898',
        -- Lightforg
        '1731282',
        '1731656',
        -- MagharOrc
        '1951457',
        '1951458',
        -- Mechagnom
        '3107651',
        '3107182',
        -- Nightborn
        '1732030',
        '1732405',
        -- Void Elf
        '1732785',
        '1733163',
        -- Vulpera
        '3106252',
        '3106717',
        -- Zandalari
        '1903049',
        '1903522',

        -- Smolderheart
        '2066602',
        '2066605',
    }

    function M:MuteAnnoyingSounds()
        for _, soundID in pairs(soundsList) do
            MuteSoundFile(soundID)
        end
    end
end

-- faster movie skip
do
    local function skipOnKeyDown(self, key)
        if not C.DB.General.FasterMovieSkip then
            return
        end

        if key == 'ESCAPE' then
            if self:IsShown() and self.closeDialog and self.closeDialog.confirmButton then
                self.closeDialog:Hide()
            end
        end
    end

    local function skipOnKeyUp(self, key)
        if not C.DB.General.FasterMovieSkip then
            return
        end

        if key == 'SPACE' or key == 'ESCAPE' or key == 'ENTER' then
            if self:IsShown() and self.closeDialog and self.closeDialog.confirmButton then
                self.closeDialog.confirmButton:Click()
            end
        end
    end

    function M:FasterMovieSkip()
        _G.MovieFrame.closeDialog = _G.MovieFrame.CloseDialog
        _G.MovieFrame.closeDialog.confirmButton = _G.MovieFrame.CloseDialog.ConfirmButton
        _G.CinematicFrame.closeDialog.confirmButton = _G.CinematicFrameCloseDialogConfirmButton

        _G.MovieFrame:HookScript('OnKeyDown', skipOnKeyDown)
        _G.MovieFrame:HookScript('OnKeyUp', skipOnKeyUp)
        _G.CinematicFrame:HookScript('OnKeyDown', skipOnKeyDown)
        _G.CinematicFrame:HookScript('OnKeyUp', skipOnKeyUp)
    end
end

-- ensure max camera distance
do
    local function SetMaxZoomFactor()
        if C_CVar.GetCVar('cameraDistanceMaxZoomFactor') ~= '2.6' then
            C_CVar.SetCVar('cameraDistanceMaxZoomFactor', '2.6')
        end

        C_Timer.After(60, function()
            if C_CVar.GetCVar('cameraDistanceMaxZoomFactor') ~= '2.6' then
                C_CVar.SetCVar('cameraDistanceMaxZoomFactor', '2.6')
            end
        end)

        F:UnregisterEvent('PLAYER_ENTERING_WORLD', SetMaxZoomFactor)
    end

    F:RegisterEvent('PLAYER_ENTERING_WORLD', SetMaxZoomFactor)
end

-- change the color of the current trader's name
-- red stranger / blue guild / green friend
do
    local infoText = F.CreateFS(_G.TradeFrame, C.Assets.Font.Bold, 14, true)
    infoText:ClearAllPoints()
    infoText:SetPoint('TOP', _G.TradeFrameRecipientNameText, 'BOTTOM', 0, -5)

    local function updateColor()
        local r, g, b = F:UnitColor('NPC')
        _G.TradeFrameRecipientNameText:SetTextColor(r, g, b)

        local guid = UnitGUID('NPC')
        if not guid then
            return
        end
        local text = C.RED_COLOR .. L['Stranger']
        if C_BattleNet.GetGameAccountInfoByGUID(guid) or C_FriendList.IsFriend(guid) then
            text = C.GREEN_COLOR .. _G.FRIEND
        elseif IsGuildMember(guid) then
            text = C.BLUE_COLOR .. _G.GUILD
        end
        infoText:SetText(text)
    end

    hooksecurefunc('TradeFrame_Update', updateColor)
end

-- kill blizzard tutorials
do
    local function onEvent()
        local lastInfoFrame = C_CVar.GetCVarBitfield('closedInfoFrames', _G.NUM_LE_FRAME_TUTORIALS)
        if not lastInfoFrame then
            C_CVar.SetCVar('showTutorials', 0)
            C_CVar.SetCVar('showNPETutorials', 0)
            C_CVar.SetCVar('hideAdventureJournalAlerts', 1)
            -- help plates
            for i = 1, _G.NUM_LE_FRAME_TUTORIALS do
                C_CVar.SetCVarBitfield('closedInfoFrames', i, true)
            end
            for i = 1, _G.NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
                C_CVar.SetCVarBitfield('closedInfoFramesAccountWide', i, true)
            end
        end

        -- hide talent alert
        function _G.MainMenuMicroButton_AreAlertsEnabled()
            return false
        end

        -- disable spells are automatically added to actionbar
        _G.IconIntroTracker:UnregisterEvent('SPELL_PUSHED_TO_ACTIONBAR')
    end

    -- if you're in Exile's Reach and level 1 this cvar gets automatically enabled
    hooksecurefunc('NPE_CheckTutorials', function()
        if C_PlayerInfo.IsPlayerNPERestricted() and UnitLevel('player') == 1 then
            SetCVar('showTutorials', 0)
            _G.NewPlayerExperience:Shutdown()
            -- for some reason this window still shows up
            _G.NPE_TutorialKeyboardMouseFrame_Frame:Hide()
        end
    end)

    F:RegisterEvent('ADDON_LOADED', onEvent)

    for i = 1, _G.NUM_LE_FRAME_TUTORIALS do
        C_CVar.SetCVarBitfield('closedInfoFrames', i, true)
    end

    for i = 1, _G.NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
        C_CVar.SetCVarBitfield('closedInfoFramesAccountWide', i, true)
    end
end

-- weekly lottery
do
    local function OnMouseUp(self)
        self:Hide()

        PlaySound(SOUNDKIT.UI_LEGENDARY_LOOT_TOAST)
    end

    local function AddMask(frame)
        local mask = CreateFrame('Frame', nil, frame)
        mask:SetAllPoints()
        mask:SetFrameLevel(99)

        mask.tex = mask:CreateTexture()
        mask.tex:SetAllPoints()
        mask.tex:SetColorTexture(0, 0, 0)

        mask:SetScript('OnMouseUp', OnMouseUp)
    end

    F:HookAddOn('Blizzard_WeeklyRewards', function()
        if C_WeeklyRewards.HasAvailableRewards() then
            for _, frame in pairs(_G.WeeklyRewardsFrame.Activities) do
                AddMask(frame)
            end
        end
    end)
end

function M:OnLogin()
    M:ForceWarning()
    M:MuteAnnoyingSounds()
    M:FasterMovieSkip()
end
