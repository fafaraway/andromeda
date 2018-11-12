local F, C, L = unpack(select(2, ...))

local module = F:RegisterModule('blizzard')

function module:OnLogin()
	self:FontStyle()
	self:PetBattleUI()
	self:EnhanceColorPicker()
	self:PositionUIWidgets()
	self:QuestTracker()

	-- Remove Boss Banner
	if C.blizzard.hideBossBanner then
		BossBanner:UnregisterAllEvents()
	end

	-- Fix patch 27326
	GuildControlUIRankSettingsFrameRosterLabel = CreateFrame("Frame", nil, F.HiddenFrame)
end


do
	-- Prevents spells from being automatically added to your action bar
	IconIntroTracker.RegisterEvent = function() end
	IconIntroTracker:UnregisterEvent('SPELL_PUSHED_TO_ACTIONBAR')

	local iit = CreateFrame('frame')
	iit:SetScript('OnEvent', function(self, event, spellID, slotIndex, slotPos)
		if not InCombatLockdown() then
			ClearCursor()
			PickupAction(slotIndex)
			ClearCursor()
		end
	end)
	iit:RegisterEvent('SPELL_PUSHED_TO_ACTIONBAR')
end


-- reposition alert popup
local function alertFrameMover(self, ...)
	_G.AlertFrame:ClearAllPoints()
	_G.AlertFrame:SetPoint(unpack(C.blizzard.alertPos))
end

hooksecurefunc(_G.AlertFrame, "UpdateAnchors", alertFrameMover)


-- remove talent alert
function MainMenuMicroButton_AreAlertsEffectivelyEnabled()
	return false
end
function TalentMicroButtonAlert:Show()
	TalentMicroButtonAlert:Hide();
end


-- remove talking head
do
	local hth = CreateFrame("Frame")
	function hth:OnEvent(event, addon)
		if C.blizzard.hideTalkingHead then
			if addon == "Blizzard_TalkingHeadUI" then
				hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
					TalkingHeadFrame:Hide()
				end)
				self:UnregisterEvent(event)
			end
		end
	end
	hth:RegisterEvent("ADDON_LOADED")
	hth:SetScript("OnEvent", hth.OnEvent)
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


-- Clean up Loss Of Control
do
	local frame = _G.LossOfControlFrame
	frame.RedLineTop:SetTexture(nil)
	frame.RedLineBottom:SetTexture(nil)
	frame.blackBg:SetTexture(nil)

	F.ReskinIcon(frame.Icon)
	F.CreateBDFrame(frame.Icon)
	F.CreateSD(frame.Icon)
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
	local function fixBlizz(event, addon)
		if event == "ADDON_LOADED" and addon == "Blizzard_Collections" then
			CollectionsJournal:HookScript("OnShow", function()
				if not done then
					if InCombatLockdown() then
						F:RegisterEvent("PLAYER_REGEN_ENABLED", fixBlizz)
					else
						F.CreateMF(CollectionsJournal)
					end
					done = true
				end
			end)
			F:UnregisterEvent(event, fixBlizz)
		elseif event == "PLAYER_REGEN_ENABLED" then
			F.CreateMF(CollectionsJournal)
			F:UnregisterEvent(event, fixBlizz)
		end
	end

	F:RegisterEvent("ADDON_LOADED", fixBlizz)
end