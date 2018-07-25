local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("misc")

function module:OnLogin()

	self:AddAlerts()

	self:ShowItemLevel()
	self:Expbar()
	self:flashCursor()
	self:questRewardHighlight()


	-- Remove Boss Banner
	if C.general.bossBanner == true then
		BossBanner:UnregisterAllEvents()
	end
end



-- Remove Talking Head Frame
if C.general.talkingHead == true then
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(self, event, addon)
		if addon == "Blizzard_TalkingHeadUI" then
			hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
				TalkingHeadFrame:Hide()
			end)
			self:UnregisterEvent(event)
		end
	end)
end

-- ALT + Right Click to buy a stack
local old_MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
local cache = {}
function MerchantItemButton_OnModifiedClick(self, ...)
	if IsAltKeyDown() then
		local id = self:GetID()
		local itemLink = GetMerchantItemLink(id)
		if not itemLink then return end
		local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
		if ( maxStack and maxStack > 1 ) then
			if not cache[itemLink] then
				StaticPopupDialogs["BUY_STACK"] = {
					text = "Stack Buying Check",
					button1 = YES,
					button2 = NO,
					OnAccept = function()
						BuyMerchantItem(id, GetMerchantItemMaxStack(id))
						cache[itemLink] = true
					end,
					hideOnEscape = 1,
					hasItemFrame = 1,
				}
				local r, g, b = GetItemQualityColor(quality or 1)
				StaticPopup_Show("BUY_STACK", " ", " ", {["texture"] = texture, ["name"] = name, ["color"] = {r, g, b, 1}, ["link"] = itemLink, ["index"] = id, ["count"] = maxStack})
			else
				BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			end
		end
	end
	old_MerchantItemButton_OnModifiedClick(self, ...)
end

-- Quickjoin for worldquests
do
	hooksecurefunc("BonusObjectiveTracker_OnBlockClick", function(self, button)
		if self.module.ShowWorldQuests then
			if button == "MiddleButton" then
				LFGListUtil_FindQuestGroup(self.TrackedQuest.questID)
			end
		end
	end)

	for i = 1, 10 do
		local bu = _G["LFGListSearchPanelScrollFrameButton"..i]
		if bu then
			bu:HookScript("OnDoubleClick", function()
				if LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
					LFGListFrame.SearchPanel.SignUpButton:Click()
				end
				if LFGListApplicationDialog:IsShown() and LFGListApplicationDialog.SignUpButton:IsEnabled() then
					LFGListApplicationDialog.SignUpButton:Click()
				end
			end)
		end
	end

	hooksecurefunc("LFGListEntryCreation_Show", function(self)
		local searchBox = LFGListFrame.SearchPanel.SearchBox
		if searchBox:GetText() ~= "" then
			C_LFGList.CreateListing(16, searchBox:GetText(), 0, 0, "", searchBox:GetText(), true)
			searchBox:SetText("")
		end
	end)
end

-- Fix blizz LFGList error in zhCN
if GetLocale() == "zhCN" then
	StaticPopupDialogs["LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS"] = {
		text = " 针对此项活动，你的队伍人数已满，将被移出列表。",
		button1 = OKAY,
		timeout = 0,
		whileDead = 1,
	}
end
hooksecurefunc("StaticPopup_Show", function(which)
		if which == "LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS" then
			C_Timer.After(1, function()
				StaticPopup_Hide(which)
			end)
		end
end)

-- Select target when click on raid units
do
	local function fixRaidGroupButton()
		for i = 1, 40 do
			local bu = _G["RaidGroupButton"..i]
			if bu and bu.unit and not bu.clickFixed then
				bu:SetAttribute("type", "target")
				bu:SetAttribute("unit", bu.unit)

				bu.clickFixed = true
			end
		end
	end

	local EventFrame = CreateFrame( 'Frame' )
	EventFrame:RegisterEvent("ADDON_LOADED")
	EventFrame:SetScript("OnEvent", function(self, event, addon)
		if event == "ADDON_LOADED" and addon == "Blizzard_RaidUI" then
			if not InCombatLockdown() then
				fixRaidGroupButton()
				self:UnregisterAllEvents()
			else
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		elseif event == "PLAYER_REGEN_ENABLED" then
			if RaidGroupButton1 and RaidGroupButton1:GetAttribute("type") ~= "target" then
				fixRaidGroupButton()
				self:UnregisterAllEvents()
			end
		end
	end)
end

-- Ctrl + left click to report spamer
local _ChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow;
function ChatFrame_OnHyperlinkShow (chatframe,link,text,button)
	if IsControlKeyDown() then
		local line = string.match(link,"player:[^:]+:(%d+):");
			if line then
				ReportPlayer("spam",line);
			return;
		end
	end
	return _ChatFrame_OnHyperlinkShow (chatframe,link,text,button);
end

-- Hide friendly player/pet names while in raid and/or party group.
if C.general.hideRaidNames then


	local HRN = function()
		local name, type, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()
		-- print(name.. " ".. type .." ".. difficulty)	
		-- if type == "raid" or type == "party" and GetNumGroupMembers() > 3 then
		if type == "raid" then
			SetCVar("UnitNameFriendlyPlayerName", 0)
			SetCVar("UnitNameFriendlyPetName", 0)
			-- print("|cffff6060Hiding.")
			-- print(GetNumGroupMembers())	
		else
			SetCVar("UnitNameFriendlyPlayerName", 1)
			SetCVar("UnitNameFriendlyPetName", 1)
			-- print("|cff00ccffShowing.")
		end
	end

	local f = CreateFrame("Frame")
	f:SetScript("OnEvent", HRN)
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("RAID_ROSTER_UPDATE")
	f:RegisterEvent("GROUP_ROSTER_UPDATE")
end



-- Clean up Loss Of Control
local frame = _G.LossOfControlFrame
frame.RedLineTop:SetTexture(nil)
frame.RedLineBottom:SetTexture(nil)
frame.blackBg:SetTexture(nil)

F.ReskinIcon(frame.Icon)
F.CreateBG(frame.Icon)

-- ncShadow
if C.appearance.vignette then
	local f = CreateFrame("Frame", "ShadowBackground")
	f:SetPoint("TOPLEFT")
	f:SetPoint("BOTTOMRIGHT")
	f:SetFrameLevel(0)
	f:SetFrameStrata("BACKGROUND")
	f.tex = f:CreateTexture()
	f.tex:SetTexture([[Interface\Addons\FreeUI\assets\shadow.tga]])
	f.tex:SetAllPoints(f)

	f:SetAlpha(C.appearance.vignetteAlpha)
	
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
end


-- Auto enables the ActionCam on login
if C.general.autoActionCam then
	local aac = CreateFrame("Frame", "AutoActionCam")

	aac:RegisterEvent("PLAYER_LOGIN")
	UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")

	function SetCam(cmd)
		ConsoleExec("ActionCam " .. cmd)
	end

	function aac:OnEvent(event, ...)
		if event == "PLAYER_LOGIN" then
			SetCam("basic")
		end
	end
	aac:SetScript("OnEvent", aac.OnEvent)
end


-- Hide talent alert
function MainMenuMicroButton_AreAlertsEffectivelyEnabled()
	return false
end


-- Temporary taint fix
do
	InterfaceOptionsFrameCancel:SetScript("OnClick", function()
		InterfaceOptionsFrameOkay:Click()
	end)

	-- https://www.townlong-yak.com/bugs/Kjq4hm-DisplayModeCommunitiesTaint
	if (UIDROPDOWNMENU_OPEN_PATCH_VERSION or 0) < 1 then
		UIDROPDOWNMENU_OPEN_PATCH_VERSION = 1
		hooksecurefunc("UIDropDownMenu_InitializeHelper", function(frame)
			if UIDROPDOWNMENU_OPEN_PATCH_VERSION ~= 1 then return end

			if UIDROPDOWNMENU_OPEN_MENU and UIDROPDOWNMENU_OPEN_MENU ~= frame and not issecurevariable(UIDROPDOWNMENU_OPEN_MENU, "displayMode") then
				UIDROPDOWNMENU_OPEN_MENU = nil
				local t, f, prefix, i = _G, issecurevariable, " \0", 1
				repeat
					i, t[prefix .. i] = i+1
				until f("UIDROPDOWNMENU_OPEN_MENU")
			end
		end)
	end
end



-- Fix Drag Collections taint
do
	local done
	local function setupMisc(event, addon)
		if event == "ADDON_LOADED" and addon == "Blizzard_Collections" then
			CollectionsJournal:HookScript("OnShow", function()
				if not done then
					if InCombatLockdown() then
						F:RegisterEvent("PLAYER_REGEN_ENABLED", setupMisc)
					else
						F.CreateMF(CollectionsJournal)
					end
					done = true
				end
			end)
			F:UnregisterEvent(event, setupMisc)
		elseif event == "PLAYER_REGEN_ENABLED" then
			F.CreateMF(CollectionsJournal)
			F:UnregisterEvent(event, setupMisc)
		end
	end

	F:RegisterEvent("ADDON_LOADED", setupMisc)
end


-- Remove Boss Emote spam during BG
local BATTLEGROUNDS = {
	["Wintergrasp"] = true,
	["Tol Barad"] = true,
	["Isle of Conquest"] = true,
	["Strand of the Ancients"] = true,
	["Alterac Valley"] = true,
	["Warsong Gulch"] = true,
	["Twin Peaks"] = true,
	["Arathi Basin"] = true,
	["Eye of the Storm"] = true,
	["Battle for Gilneas"] = true,
	["Deepwind Gorge"] = true,
	["Silvershard Mines"] = true,
	["The Battle for Gilneas"] = true,
	["Temple of Kotmogu"] = true,
}

local BGSpam = _G.CreateFrame("Frame")
local RaidBossEmoteFrame, spamDisabled = _G.RaidBossEmoteFrame
local function ToggleBossEmotes()
	if BATTLEGROUNDS[GetZoneText()] then 
		RaidBossEmoteFrame:UnregisterEvent("RAID_BOSS_EMOTE")
		spamDisabled = true
	elseif spamDisabled then
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_EMOTE")
		spamDisabled = false
	end
end

BGSpam:RegisterEvent("PLAYER_ENTERING_WORLD")
BGSpam:RegisterEvent("ZONE_CHANGED_NEW_AREA")
BGSpam:SetScript("OnEvent", ToggleBossEmotes)



-- undress button on dress up frame
local undress = CreateFrame("Button", "DressUpFrameUndressButton", DressUpFrame, "UIPanelButtonTemplate")
undress:SetSize(80, 22)
undress:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT", -1, 0)
undress:SetText("Undress")
undress:SetScript("OnClick", function()
	DressUpModel:Undress()
end)

local sideUndress = CreateFrame("Button", "SideDressUpModelUndressButton", SideDressUpModel, "UIPanelButtonTemplate")
sideUndress:SetSize(80, 22)
sideUndress:SetPoint("TOP", SideDressUpModelResetButton, "BOTTOM", 0, -5)
sideUndress:SetText("Undress")
sideUndress:SetScript("OnClick", function()
	SideDressUpModel:Undress()
end)

F.Reskin(undress)
F.Reskin(sideUndress)




--

function module:questRewardHighlight()

	local f = CreateFrame("Frame")
	local highlightFunc

	local last = 0
	local startIndex = 1

	local maxPrice = 0
	local maxPriceIndex = 0

	local function onUpdate(self, elapsed)
		last = last + elapsed
		if last >= .05 then
			self:SetScript("OnUpdate", nil)
			last = 0

			if QuestInfoRewardsFrameQuestInfoItem1:IsVisible() then -- protection in case frame is closed early
				highlightFunc()
			end
		end
	end

	highlightFunc = function()
		local numChoices = GetNumQuestChoices()
		if numChoices < 2 then return end

		for i = startIndex, numChoices do
			local link = GetQuestItemLink("choice", i)
			if link then
				local _, _, _, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(link)

				if vendorPrice > maxPrice then
					maxPrice = vendorPrice
					maxPriceIndex = i
				end
			else
				startIndex = i
				f:SetScript("OnUpdate", onUpdate)
				return
			end
		end

		if maxPriceIndex > 0 then
			local infoItem = _G["QuestInfoRewardsFrameQuestInfoItem"..maxPriceIndex]

			QuestInfoItemHighlight:ClearAllPoints()
			QuestInfoItemHighlight:SetPoint("TOP", infoItem)
			QuestInfoItemHighlight:Show()

			-- infoItem.bg:SetBackdropColor(0.89, 0.88, 0.06, .2)
		end

		startIndex = 1
		maxPrice = 0
		maxPriceIndex = 0
	end

	f:SetScript("OnEvent", highlightFunc)

	f:RegisterEvent("QUEST_COMPLETE")
	

end