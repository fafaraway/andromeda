local F, C, L = unpack(select(2, ...))
local MISC = F.MISC

local MISC_LIST = {}

function MISC:RegisterMisc(name, func)
	if not MISC_LIST[name] then
		MISC_LIST[name] = func
	end
end

function MISC:OnLogin()
	for name, func in next, MISC_LIST do
		if name and type(func) == 'function' then
			func()
		end
	end

	MISC:ForceWarning()
	MISC:FasterCamera()
	MISC:AutoScreenshot()
	MISC:QuestCompletedSound()
	MISC:BuyStack()
	MISC:SetRole()
	MISC:MawWidgetFrame()
end

function MISC:ForceWarning()
	local f = CreateFrame('Frame')
	f:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
	f:RegisterEvent('PET_BATTLE_QUEUE_PROPOSE_MATCH')
	f:RegisterEvent('LFG_PROPOSAL_SHOW')
	f:RegisterEvent('RESURRECT_REQUEST')
	f:SetScript(
		'OnEvent',
		function(_, event)
			if event == 'UPDATE_BATTLEFIELD_STATUS' then
				for i = 1, GetMaxBattlefieldID() do
					local status = GetBattlefieldStatus(i)
					if status == 'confirm' then
						PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
						break
					end
					i = i + 1
				end
			elseif event == 'PET_BATTLE_QUEUE_PROPOSE_MATCH' then
				PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
			elseif event == 'LFG_PROPOSAL_SHOW' then
				PlaySound(SOUNDKIT.READY_CHECK, 'Master')
			elseif event == 'RESURRECT_REQUEST' then
				PlaySound(37, 'Master')
			end
		end
	)
end

local ShowReadyCheckHook = function(_, initiator)
	if initiator ~= 'player' then
		PlaySound(SOUNDKIT.READY_CHECK, 'Master')
	end
end
hooksecurefunc('ShowReadyCheck', ShowReadyCheckHook)

function MISC:FasterCamera()
	if not C.DB.misc.faster_camera then
		return
	end

	local oldZoomIn = CameraZoomIn
	local oldZoomOut = CameraZoomOut
	local oldVehicleZoomIn = VehicleCameraZoomIn
	local oldVehicleZoomOut = VehicleCameraZoomOut
	local newZoomSpeed = 4

	function CameraZoomIn(distance)
		oldZoomIn(newZoomSpeed)
	end

	function CameraZoomOut(distance)
		oldZoomOut(newZoomSpeed)
	end

	function VehicleCameraZoomIn(distance)
		oldVehicleZoomIn(newZoomSpeed)
	end

	function VehicleCameraZoomOut(distance)
		oldVehicleZoomOut(newZoomSpeed)
	end
end


--[[ Sound alert for quest complete ]]
do
	local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
	local C_QuestLog_GetQuestIDForLogIndex = C_QuestLog.GetQuestIDForLogIndex
	local C_QuestLog_GetTitleForQuestID = C_QuestLog.GetTitleForQuestID
	local C_QuestLog_IsComplete = C_QuestLog.IsComplete
	local C_QuestLog_IsWorldQuest = C_QuestLog.IsWorldQuest
	local completedQuest, initComplete = {}

	function MISC:FindQuestComplete()
		for i = 1, C_QuestLog_GetNumQuestLogEntries() do
			local questID = C_QuestLog_GetQuestIDForLogIndex(i)
			local title = C_QuestLog_GetTitleForQuestID(questID)
			local isComplete = C_QuestLog_IsComplete(questID)
			local isWorldQuest = C_QuestLog_IsWorldQuest(questID)
			if title and isComplete and not completedQuest[questID] and not isWorldQuest then
				if initComplete then
					PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3, 'Master')
				end
				completedQuest[questID] = true
			end
		end
		initComplete = true
	end

	function MISC:FindWorldQuestComplete(questID)
		if C_QuestLog_IsWorldQuest(questID) then
			local title = C_QuestLog_GetTitleForQuestID(questID)
			if title and not completedQuest[questID] then
				PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3, 'Master')
				completedQuest[questID] = true
			end
		end
	end

	function MISC:QuestCompletedSound()
		if C.DB.misc.quest_completed_sound then
			F:RegisterEvent('QUEST_LOG_UPDATE', MISC.FindQuestComplete)
			F:RegisterEvent('QUEST_TURNED_IN', MISC.FindWorldQuestComplete)
		else
			wipe(completedQuest)
			F:UnregisterEvent('QUEST_LOG_UPDATE', MISC.FindQuestComplete)
			F:UnregisterEvent('QUEST_TURNED_IN', MISC.FindWorldQuestComplete)
		end
	end
end

--[[
	Achievement screenshot
]]
do
	local function AchievementEarned(...)
		if not C.DB.misc.auto_screenshot_achievement then
			return
		end

		local _, _, alreadyEarned = ...

		if alreadyEarned then
			return
		end

		F:Delay(1, _G.Screenshot)
	end

	local function ChallengeModeCompleted(...)
		if not C.DB.misc.auto_screenshot_challenge then
			return
		end

		F:Delay(2, _G.Screenshot)
	end

	function MISC:AutoScreenshot()
		if not C.DB.misc.auto_screenshot then
			return
		end

		F:RegisterEvent('ACHIEVEMENT_EARNED', AchievementEarned)
		F:RegisterEvent('CHALLENGE_MODE_COMPLETED', ChallengeModeCompleted)
	end
end

--[[
	Buy stack
]]
function MISC:BuyStack()
	local cache = {}
	local itemLink, id

	StaticPopupDialogs['FREEUI_BUY_STACK'] = {
		text = L['MISC_BUY_STACK'],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			if not itemLink then
				return
			end
			BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			cache[itemLink] = true
			itemLink = nil
		end,
		hideOnEscape = 1,
		hasItemFrame = 1
	}

	local _MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
	function MerchantItemButton_OnModifiedClick(self, ...)
		if IsAltKeyDown() then
			id = self:GetID()
			itemLink = GetMerchantItemLink(id)
			if not itemLink then
				return
			end
			local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
			if maxStack and maxStack > 1 then
				if not cache[itemLink] then
					local r, g, b = GetItemQualityColor(quality or 1)
					StaticPopup_Show(
						'FREEUI_BUY_STACK',
						' ',
						' ',
						{
							['texture'] = texture,
							['name'] = name,
							['color'] = {r, g, b, 1},
							['link'] = itemLink,
							['index'] = id,
							['count'] = maxStack
						}
					)
				else
					BuyMerchantItem(id, GetMerchantItemMaxStack(id))
				end
			end
		end

		_MerchantItemButton_OnModifiedClick(self, ...)
	end
end

--[[
	Set role
]]
do
	local prev = 0
	local function SetRole()
		if C.MyLevel >= 10 and not InCombatLockdown() and IsInGroup() and not IsPartyLFG() then
			local spec = GetSpecialization()
			if spec then
				local role = GetSpecializationRole(spec)
				if UnitGroupRolesAssigned('player') ~= role then
					local t = GetTime()
					if t - prev > 2 then
						prev = t
						UnitSetRole('player', role)
					end
				end
			else
				UnitSetRole('player', 'No Role')
			end
		end
	end

	function MISC:SetRole()
		F:RegisterEvent('PLAYER_TALENT_UPDATE', SetRole)
		F:RegisterEvent('GROUP_ROSTER_UPDATE', SetRole)

		RolePollPopup:UnregisterEvent('ROLE_POLL_BEGIN')
	end
end

--[[
	Maw threat bar
]]
do
	local maxValue = 1000
	local function GetMawBarValue()
		local widgetInfo = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo(2885)
		if widgetInfo and widgetInfo.shownState == 1 then
			local value = widgetInfo.progressVal
			return floor(value / maxValue), value % maxValue
		end
	end

	local MawRankColor = {
		[0] = {.6, .8, 1},
		[1] = {0, 1, 0},
		[2] = {0, .7, .3},
		[3] = {1, .8, 0},
		[4] = {1, .5, 0},
		[5] = {1, 0, 0}
	}
	function MISC:UpdateMawBarLayout()
		local bar = MISC.MawBar
		local rank, value = GetMawBarValue()
		if rank then
			bar:SetStatusBarColor(unpack(MawRankColor[rank]))
			if rank == 5 then
				bar.text:SetText('Lv' .. rank)
				bar:SetValue(maxValue)
			else
				bar.text:SetText('Lv' .. rank .. ' - ' .. value .. '/' .. maxValue)
				bar:SetValue(value)
			end
			bar:Show()
			UIWidgetTopCenterContainerFrame:Hide()
		else
			bar:Hide()
			UIWidgetTopCenterContainerFrame:Show()
		end
	end

	function MISC:MawWidgetFrame()
		if not C.DB.blizzard.maw_threat_bar then
			return
		end

		if MISC.MawBar then
			return
		end

		local bar = CreateFrame('StatusBar', nil, UIParent)
		bar:SetSize(200, 16)
		bar:SetMinMaxValues(0, maxValue)
		bar.text = F.CreateFS(bar, C.Assets.Fonts.Regular, 12, nil, nil, nil, true)
		F.CreateSB(bar)
		F:SmoothBar(bar)
		MISC.MawBar = bar

		F.Mover(bar, L.GUI.MOVER.MAW_THREAT_BAR, 'MawThreatBar', {'TOP', UIParent, 0, -80})

		bar:SetScript(
			'OnEnter',
			function(self)
				local rank = GetMawBarValue()
				local widgetInfo = rank and C_UIWidgetManager.GetTextureWithAnimationVisualizationInfo(2873 + rank)
				if widgetInfo and widgetInfo.shownState == 1 then
					GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -10)
					local header, nonHeader = SplitTextIntoHeaderAndNonHeader(widgetInfo.tooltip)
					if header then
						GameTooltip:AddLine(header, nil, nil, nil, 1)
					end
					if nonHeader then
						GameTooltip:AddLine(nonHeader, nil, nil, nil, 1)
					end
					GameTooltip:Show()
				end
			end
		)
		bar:SetScript('OnLeave', F.HideTooltip)

		MISC:UpdateMawBarLayout()
		F:RegisterEvent('PLAYER_ENTERING_WORLD', MISC.UpdateMawBarLayout)
		F:RegisterEvent('UPDATE_UI_WIDGET', MISC.UpdateMawBarLayout)
	end
end

--[[ Auto select current event boss from LFD tool ]]
do
	local firstLFD
	LFDParentFrame:HookScript(
		'OnShow',
		function()
			if not firstLFD then
				firstLFD = 1
				for i = 1, GetNumRandomDungeons() do
					local id = GetLFGRandomDungeonInfo(i)
					local isHoliday = select(15, GetLFGDungeonInfo(id))
					if isHoliday and not GetLFGDungeonRewards(id) then
						LFDQueueFrame_SetType(id)
					end
				end
			end
		end
	)
end
