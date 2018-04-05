local F, C, L = unpack(select(2, ...))

-- Remove Boss Banner
if C.general.bossBanner == true then
	BossBanner.PlayBanner = function() end
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

-- Fix Drag Collections taint
CreateMF = function(f)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetUserPlaced(true)
	f:SetClampedToScreen(true)
	f:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	f:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
end

local EventFrame = CreateFrame( 'Frame' )
EventFrame:RegisterEvent( 'ADDON_LOADED' )
EventFrame:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "Blizzard_Collections" then
		CollectionsJournal:HookScript("OnShow", function()
			if not self.init then
				if InCombatLockdown() then
					self:RegisterEvent("PLAYER_REGEN_ENABLED")
				else
					CreateMF(CollectionsJournal)
					self:UnregisterAllEvents()
				end
				self.init = true
			end
		end)
	elseif event == "PLAYER_REGEN_ENABLED" then
		CreateMF(CollectionsJournal)
		self:UnregisterAllEvents()
	end
end)

-- Temporary PVP queue taint fix
InterfaceOptionsFrameCancel:SetScript("OnClick", function()
	InterfaceOptionsFrameOkay:Click()
end)

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

-- Fix blizz LFGList error in zhCN
if GetLocale() == "zhCN" then
	StaticPopupDialogs["LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS"] = {
		text = " 针对此项活动，你的队伍人数已满，将被移出列表。",
		button1 = OKAY,
		timeout = 0,
		whileDead = 1,
	}
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

-- Hide friendly player names while in raid and/or party group.
if C.general.hideRaidNames then
	-- local HRN = CreateFrame("Frame")
	-- HRN:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- HRN:SetScript("OnEvent", function(self, event)
	-- 	if event=="PLAYER_ENTERING_WORLD" then
	-- 		local _,instanceType = IsInInstance()
	-- 		if instanceType=="raid" then
	-- 			SetCVar("UnitNameFriendlyPlayerName",0);
	-- 		else
	-- 			SetCVar("UnitNameFriendlyPlayerName",1);
	-- 		end
	-- 	end
	-- end)

	local HFPN = function()
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
	f:SetScript("OnEvent", HFPN)
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("RAID_ROSTER_UPDATE")
	f:RegisterEvent("PARTY_MEMBERS_CHANGED")
end

-- Take screenshots of defined events
if C.general.autoScreenShot then
	local function OnEvent( self, event, ... )
		C_Timer.After( 1, function() Screenshot() end )
	end

	local EventFrame = CreateFrame( 'Frame' )
	EventFrame:RegisterEvent( 'ACHIEVEMENT_EARNED' )
	EventFrame:SetScript( 'OnEvent', OnEvent )
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
	f.tex:SetTexture([[Interface\Addons\FreeUI\media\shadow.tga]])
	f.tex:SetAllPoints(f)

	f:SetAlpha(C.appearance.vignetteAlpha)
	
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
end

-- rGroupFinder by zorker
-- Adds the group finder button to every quest
if C.general.GroupFinderButton then
	local function AddGroupFinderButton(block, questID)
		if IsQuestComplete(questID) then return end
		if wordQuestsOnly and not QuestUtils_IsQuestWorldQuest(questID) then return end
		if block.groupFinderButton and block.hasGroupFinderButton then return end
		if not block.hasGroupFinderButton then
			block.hasGroupFinderButton = true
		end
		if not block.groupFinderButton then
			block.groupFinderButton = QuestObjectiveFindGroup_AcquireButton(block, questID);
			QuestObjectiveSetupBlockButton_AddRightButton(block, block.groupFinderButton, block.module.buttonOffsets.groupFinder);
		end
	end
	hooksecurefunc("QuestObjectiveSetupBlockButton_FindGroup", AddGroupFinderButton)
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

