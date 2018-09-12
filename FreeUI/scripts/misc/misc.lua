local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("misc")

function module:OnLogin()

	self:AddAlerts()

	self:ShowItemLevel()
	self:Expbar()
	self:flashCursor()
	self:QuickJoin()
	self:Focuser()
	self:MissingStats()
	self:fasterLooting()
	self:vignette()

	-- Remove Boss Banner
	if not C.misc.bossBanner then
		BossBanner:UnregisterAllEvents()
	end

	-- Fix patch 27326
	GuildControlUIRankSettingsFrameRosterLabel = CreateFrame("Frame", nil, F.HiddenFrame)
end



-- Remove Talking Head Frame
do
	local function NoTalkingHeads()
		hooksecurefunc(TalkingHeadFrame, "Show", function(self)
			self:Hide()
		end)
		TalkingHeadFrame.ignoreFramePositionManager = true
	end

	local function setupMisc(event, addon)
		if C.misc.talkingHead then
			F:UnregisterEvent(event, setupMisc)
			return
		end

		if event == "PLAYER_ENTERING_WORLD" then
			F:UnregisterEvent(event, setupMisc)
			if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
				NoTalkingHeads()
				F:UnregisterEvent("ADDON_LOADED", setupMisc)
			end
		elseif event == "ADDON_LOADED" and addon == "Blizzard_TalkingHeadUI" then
			NoTalkingHeads()
			F:UnregisterEvent(event, setupMisc)
		end
	end

	F:RegisterEvent("PLAYER_ENTERING_WORLD", setupMisc)
	F:RegisterEvent("ADDON_LOADED", setupMisc)
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
--[[local _ChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow;
function ChatFrame_OnHyperlinkShow (chatframe,link,text,button)
	if IsControlKeyDown() then
		local line = string.match(link,"player:[^:]+:(%d+):");
			if line then
				C_ChatInfo.ReportPlayer("spam",line);
			return;
		end
	end
	return _ChatFrame_OnHyperlinkShow (chatframe,link,text,button);
end]]


-- Hide friendly player/pet names while in raid and/or party group.
--[[if C.misc.hideRaidNames then
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
end]]



-- Clean up Loss Of Control
local frame = _G.LossOfControlFrame
frame.RedLineTop:SetTexture(nil)
frame.RedLineBottom:SetTexture(nil)
frame.blackBg:SetTexture(nil)

F.ReskinIcon(frame.Icon)
F.CreateBDFrame(frame.Icon)
F.CreateSD(frame.Icon)



-- adding a shadowed border to the UI window
function module:vignette()
	if not C.appearance.vignette then return end

	self.f = CreateFrame("Frame", "ShadowBackground")
	self.f:SetPoint("TOPLEFT")
	self.f:SetPoint("BOTTOMRIGHT")
	self.f:SetFrameLevel(0)
	self.f:SetFrameStrata("BACKGROUND")
	self.f.tex = self.f:CreateTexture()
	self.f.tex:SetTexture([[Interface\Addons\FreeUI\assets\shadow.tga]])
	self.f.tex:SetAllPoints(f)

	self.f:SetAlpha(C.appearance.vignetteAlpha)
end


-- Auto enables the ActionCam on login
if C.misc.autoActionCam then
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


-- HonorFrame.type can be tainted through UIDropDownMenu
-- https://www.townlong-yak.com/bugs/afKy4k-HonorFrameLoadTaint
if (UIDROPDOWNMENU_VALUE_PATCH_VERSION or 0) < 2 then
    UIDROPDOWNMENU_VALUE_PATCH_VERSION = 2
    hooksecurefunc("UIDropDownMenu_InitializeHelper", function()
        if UIDROPDOWNMENU_VALUE_PATCH_VERSION ~= 2 then
            return
        end
        for i=1, UIDROPDOWNMENU_MAXLEVELS do
            for j=1, UIDROPDOWNMENU_MAXBUTTONS do
                local b = _G["DropDownList" .. i .. "Button" .. j]
                if not (issecurevariable(b, "value") or b:IsShown()) then
                    b.value = nil
                    repeat
                        j, b["fx" .. j] = j+1
                    until issecurevariable(b, "value")
                end
            end
        end
    end)
end


-- UIDropDown displayMode taints Communities UI
-- https://www.townlong-yak.com/bugs/Kjq4hm-DisplayModeCommunitiesTaint
if (UIDROPDOWNMENU_OPEN_PATCH_VERSION or 0) < 1 then
    UIDROPDOWNMENU_OPEN_PATCH_VERSION = 1
    hooksecurefunc("UIDropDownMenu_InitializeHelper", function(frame)
        if UIDROPDOWNMENU_OPEN_PATCH_VERSION ~= 1 then
            return
        end
        if UIDROPDOWNMENU_OPEN_MENU and UIDROPDOWNMENU_OPEN_MENU ~= frame
           and not issecurevariable(UIDROPDOWNMENU_OPEN_MENU, "displayMode") then
            UIDROPDOWNMENU_OPEN_MENU = nil
            local t, f, prefix, i = _G, issecurevariable, " \0", 1
            repeat
                i, t[prefix .. i] = i + 1
            until f("UIDROPDOWNMENU_OPEN_MENU")
        end
    end)
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
if C.misc.undressButton then
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
end


-- Instant delete
do
	hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(self)
		self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	end)
end


-- Faster Looting
function module:fasterLooting()
	local faster = CreateFrame("Frame")
	faster:RegisterEvent("LOOT_READY")
	faster:SetScript("OnEvent",function()
		local tDelay = 0
		if GetTime() - tDelay >= 0.3 then
			tDelay = GetTime()
			if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
				for i = GetNumLootItems(), 1, -1 do
					LootSlot(i)
				end
				tDelay = GetTime()
			end
		end
	end)
end










-- reposition alert popup
local function alertFrameMover(self, ...)
	_G.AlertFrame:ClearAllPoints()
	_G.AlertFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
end

hooksecurefunc(_G.AlertFrame, "UpdateAnchors", alertFrameMover)



