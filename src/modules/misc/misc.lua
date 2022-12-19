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
        '2066603',
        '2066604',
        '2066605',

        -- Mimiron Mount
        '568252',
        '595100',
        '555364',
        '595103',
        '595097',

        -- Dragon Riding Mount
        '540108',
        '540119',
        '540182',
        '540188',
        '540197',
        '540211',
        '540213',
        '540218',
        '540221',
        '540243',
        '547436',
        '547714',
        '547715',
        '547716',
        '597932',
        '597968',
        '597986',
        '597989',
        '597998',
        '598004',
        '598010',
        '598016',
        '598028',
        '803545',
        '803547',
        '803549',
        '803551',
        '1489052',
        '1489053',
        '1563054',
        '1563055',
        '1563058',
        '3014246',
        '3014247',
        '4337227',
        '4543973',
        '4543977',
        '4543979',
        '4550997',
        '4550999',
        '4551001',
        '4551003',
        '4551005',
        '4551007',
        '4551009',
        '4551011',
        '4551013',
        '4551015',
        '4551017',
        '4627086',
        '4627088',
        '4627090',
        '4627092',
        '4633292',
        '4633294',
        '4633296',
        '4633298',
        '4633300',
        '4633302',
        '4633304',
        '4633306',
        '4633308',
        '4633310',
        '4633312',
        '4633314',
        '4633338',
        '4633340',
        '4633342',
        '4633344',
        '4633346',
        '4633348',
        '4633350',
        '4633354',
        '4633356',
        '4633370',
        '4633372',
        '4633374',
        '4633376',
        '4633378',
        '4633382',
        '4633392',
        '4634009',
        '4634011',
        '4634013',
        '4634015',
        '4634017',
        '4634019',
        '4634021',
        '4634908',
        '4634910',
        '4634912',
        '4634914',
        '4634916',
        '4634924',
        '4634926',
        '4634928',
        '4634930',
        '4634932',
        '4634942',
        '4634944',
        '4634946',
        '4663454',
        '4663456',
        '4663458',
        '4663460',
        '4663462',
        '4663464',
        '4663466',
        '4674593',
        '4674595',
        '4674599',
    }

    function M:MuteAnnoyingSounds()
        if C.DB.General.MuteAnnoyingSounds then
            for _, soundID in pairs(soundsList) do
                MuteSoundFile(soundID)
            end
        else
            for _, soundID in pairs(soundsList) do
                UnmuteSoundFile(soundID)
            end
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
    local infoText = F.CreateFS(_G.TradeFrame, C.Assets.Fonts.Bold, 14, true)
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
