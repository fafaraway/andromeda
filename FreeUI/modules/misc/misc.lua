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
		if name and type(func) == "function" then
			func()
		end
	end

	MISC:BlowMyWhistle()
	MISC:ForceWarning()
	MISC:FasterCamera()
	--MISC:UpdateScreenShot()
	MISC:QuestRewardHighlight()
	MISC:UpdateQuestCompletedSound()
	MISC:BuyStack()
	MISC:SetRole()
end

-- Plays a soundbite from Whistle - Flo Rida after Flight Master's Whistle
function MISC:BlowMyWhistle()
	if not C.DB.misc.blow_my_whistle then
		return
	end

	local whistleSound = "Interface\\AddOns\\FreeUI\\assets\\sound\\whistle.ogg"
	local whistle_SpellID1 = 227334
	-- for some reason the whistle is two spells which results in dirty events being called
	-- where spellID2 fires SUCCEEDED on spell cast start and spellID1 comes in later as the real SUCCEEDED
	local whistle_SpellID2 = 253937

	local casting = false

	local f = CreateFrame("frame")
	f:SetScript(
		"OnEvent",
		function(self, event, ...)
			self[event](self, ...)
		end
	)

	function f:UNIT_SPELLCAST_SUCCEEDED(unit, lineID, spellID)
		if (unit == "player" and (spellID == whistle_SpellID1 or spellID == whistle_SpellID2)) then
			if casting then
				casting = false
				return
			end

			PlaySoundFile(whistleSound)
			casting = false
		end
	end

	function f:UNIT_SPELLCAST_START(event, castGUID, spellID)
		if spellID == whistle_SpellID1 then
			casting = true
		end
	end
	f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	f:RegisterEvent("UNIT_SPELLCAST_START")
end

function MISC:ForceWarning()
	local f = CreateFrame("Frame")
	f:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
	f:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")
	f:RegisterEvent("LFG_PROPOSAL_SHOW")
	f:RegisterEvent("RESURRECT_REQUEST")
	f:SetScript(
		"OnEvent",
		function(_, event)
			if event == "UPDATE_BATTLEFIELD_STATUS" then
				for i = 1, GetMaxBattlefieldID() do
					local status = GetBattlefieldStatus(i)
					if status == "confirm" then
						PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, "Master")
						break
					end
					i = i + 1
				end
			elseif event == "PET_BATTLE_QUEUE_PROPOSE_MATCH" then
				PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, "Master")
			elseif event == "LFG_PROPOSAL_SHOW" then
				PlaySound(SOUNDKIT.READY_CHECK, "Master")
			elseif event == "RESURRECT_REQUEST" then
				PlaySound(37, "Master")
			end
		end
	)
end

local ShowReadyCheckHook = function(_, initiator)
	if initiator ~= "player" then
		PlaySound(SOUNDKIT.READY_CHECK, "Master")
	end
end
hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)

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

--[[ Highlight high value reward ]]
do
	local function CreateHighlight(reward)
		if not MISC.rewardHighlightFrame then
			MISC.rewardHighlightFrame =
				CreateFrame("Frame", "QuesterRewardHighlight", QuestInfoRewardsFrame, "AutoCastShineTemplate")
			MISC.rewardHighlightFrame:SetScript(
				"OnHide",
				function(frame)
					AutoCastShine_AutoCastStop(frame)
				end
			)
		end

		MISC.rewardHighlightFrame:ClearAllPoints()
		MISC.rewardHighlightFrame:SetAllPoints(reward)
		MISC.rewardHighlightFrame:Show()

		AutoCastShine_AutoCastStart(MISC.rewardHighlightFrame)
	end

	local function UpdateHighlight()
		if MISC.rewardHighlightFrame then
			MISC.rewardHighlightFrame:Hide()
		end

		local bestprice, bestitem = 0, 0
		for i = 1, GetNumQuestChoices() do
			local link, _, _, qty = GetQuestItemLink("choice", i), GetQuestItemInfo("choice", i)
			local price = link and select(11, GetItemInfo(link))
			if not price then
				return
			end

			price = price * (qty or 1)

			if price > bestprice then
				bestprice = price
				bestitem = i
			end
		end

		local rewardButton = _G["QuestInfoRewardsFrameQuestInfoItem" .. bestitem]

		if bestitem > 0 then
			CreateHighlight(_G[("QuestInfoRewardsFrameQuestInfoItem%dIconTexture"):format(bestitem)])

			_G.QuestInfoFrame.itemChoice = rewardButton:GetID()
		end
	end

	function MISC:QuestRewardHighlight()
		if C.DB.misc.reward_highlight then
			F:RegisterEvent("QUEST_COMPLETE", UpdateHighlight)
		else
			F:UnregisterEvent("QUEST_COMPLETE", UpdateHighlight)
		end
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
					PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3, "Master")
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
				PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3, "Master")
				completedQuest[questID] = true
			end
		end
	end

	function MISC:UpdateQuestCompletedSound()
		if C.DB.misc.quest_completed_sound then
			F:RegisterEvent("QUEST_LOG_UPDATE", MISC.FindQuestComplete)
			F:RegisterEvent("QUEST_TURNED_IN", MISC.FindWorldQuestComplete)
		else
			wipe(completedQuest)
			F:UnregisterEvent("QUEST_LOG_UPDATE", MISC.FindQuestComplete)
			F:UnregisterEvent("QUEST_TURNED_IN", MISC.FindWorldQuestComplete)
		end
	end
end

--[[ Auto take screenshot ]]
do
	function MISC:ScreenShotOnEvent()
		MISC.ScreenShotFrame.delay = 1
		MISC.ScreenShotFrame:Show()
	end

	function MISC:UpdateScreenShot()
		if not MISC.ScreenShotFrame then
			MISC.ScreenShotFrame = CreateFrame("Frame")
			MISC.ScreenShotFrame:Hide()
			MISC.ScreenShotFrame:SetScript(
				"OnUpdate",
				function(self, elapsed)
					self.delay = self.delay - elapsed
					if self.delay < 0 then
						Screenshot()
						self:Hide()
					end
				end
			)
		end

		if C.DB.misc.auto_screenshot then
			F:RegisterEvent("ACHIEVEMENT_EARNED", MISC.ScreenShotOnEvent)
			F:RegisterEvent("PLAYER_LEVEL_UP", MISC.ScreenShotOnEvent)
			F:RegisterEvent("PLAYER_DEAD", MISC.ScreenShotOnEvent)
			F:RegisterEvent("CHALLENGE_MODE_COMPLETED", MISC.ScreenShotOnEvent)
		else
			MISC.ScreenShotFrame:Hide()
			F:UnregisterEvent("ACHIEVEMENT_EARNED", MISC.ScreenShotOnEvent)
			F:UnregisterEvent("PLAYER_LEVEL_UP", MISC.ScreenShotOnEvent)
			F:UnregisterEvent("PLAYER_DEAD", MISC.ScreenShotOnEvent)
			F:UnregisterEvent("CHALLENGE_MODE_COMPLETED", MISC.ScreenShotOnEvent)
		end
	end

	F:RegisterEvent(
		"ACHIEVEMENT_EARNED",
		function(event, ...)
			local achievementID, alreadyEarned = ...

			F.Debug(achievementID)
			F.Debug(alreadyEarned)

			if alreadyEarned then
				return
			end

			F.Delay(
				1,
				function()
					F.Debug("taking screenshot")

					_G.Screenshot()

					F.Debug("screenshot taken")
				end
			)
		end
	)
end

--[[ Auto select current event boss from LFD tool ]]
do
	local firstLFD
	LFDParentFrame:HookScript(
		"OnShow",
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

function MISC:BuyStack()
	if not C.DB.misc.buy_stack then
		return
	end

	local cache = {}
	local itemLink, id

	StaticPopupDialogs["FREEUI_BUY_STACK"] = {
		text = L.GUI.MISC.BUY_STACK,
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
						"FREEUI_BUY_STACK",
						" ",
						" ",
						{
							["texture"] = texture,
							["name"] = name,
							["color"] = {r, g, b, 1},
							["link"] = itemLink,
							["index"] = id,
							["count"] = maxStack
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

do
	local prev = 0
	local function SetRole()
		if C.MyLevel >= 10 and not InCombatLockdown() and IsInGroup() and not IsPartyLFG() then
			local spec = GetSpecialization()
			if spec then
				local role = GetSpecializationRole(spec)
				if UnitGroupRolesAssigned("player") ~= role then
					local t = GetTime()
					if t - prev > 2 then
						prev = t
						UnitSetRole("player", role)
					end
				end
			else
				UnitSetRole("player", "No Role")
			end
		end
	end

	function MISC:SetRole()
		F:RegisterEvent("PLAYER_TALENT_UPDATE", SetRole)
		F:RegisterEvent("GROUP_ROSTER_UPDATE", SetRole)

		RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN")
	end
end
