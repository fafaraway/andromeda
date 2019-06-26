local F, C, L = unpack(select(2, ...))


-- Temporary taint fix
do
	InterfaceOptionsFrameCancel:SetScript('OnClick', function()
		InterfaceOptionsFrameOkay:Click()
	end)

	-- https://www.townlong-yak.com/bugs/Kjq4hm-DisplayModeCommunitiesTaint
	if (UIDROPDOWNMENU_OPEN_PATCH_VERSION or 0) < 1 then
		UIDROPDOWNMENU_OPEN_PATCH_VERSION = 1
		hooksecurefunc('UIDropDownMenu_InitializeHelper', function(frame)
			if UIDROPDOWNMENU_OPEN_PATCH_VERSION ~= 1 then return end

			if UIDROPDOWNMENU_OPEN_MENU and UIDROPDOWNMENU_OPEN_MENU ~= frame and not issecurevariable(UIDROPDOWNMENU_OPEN_MENU, 'displayMode') then
				UIDROPDOWNMENU_OPEN_MENU = nil
				local t, f, prefix, i = _G, issecurevariable, ' \0', 1
				repeat
					i, t[prefix .. i] = i+1
				until f('UIDROPDOWNMENU_OPEN_MENU')
			end
		end)
	end

	-- https://www.townlong-yak.com/bugs/YhgQma-SetValueRefreshTaint
	if (COMMUNITY_UIDD_REFRESH_PATCH_VERSION or 0) < 1 then
		COMMUNITY_UIDD_REFRESH_PATCH_VERSION = 1
		local function CleanDropdowns()
			if COMMUNITY_UIDD_REFRESH_PATCH_VERSION ~= 1 then return end
			local f, f2 = FriendsFrame, FriendsTabHeader
			local s = f:IsShown()
			f:Hide()
			f:Show()
			if not f2:IsShown() then
				f2:Show()
				f2:Hide()
			end
			if not s then f:Hide() end
		end
		hooksecurefunc('Communities_LoadUI', CleanDropdowns)
		hooksecurefunc('SetCVar', function(n)
			if n == 'lastSelectedClubId' then
				CleanDropdowns()
			end
		end)
	end
end


-- Fix Drag Collections taint
do
	local done
	local function fixBlizz(event, addon)
		if event == 'ADDON_LOADED' and addon == 'Blizzard_Collections' then
			CollectionsJournal:HookScript('OnShow', function()
				if not done then
					if InCombatLockdown() then
						F:RegisterEvent('PLAYER_REGEN_ENABLED', fixBlizz)
					else
						F.CreateMF(CollectionsJournal)
					end
					done = true
				end
			end)
			F:UnregisterEvent(event, fixBlizz)
		elseif event == 'PLAYER_REGEN_ENABLED' then
			F.CreateMF(CollectionsJournal)
			F:UnregisterEvent(event, fixBlizz)
		end
	end

	F:RegisterEvent('ADDON_LOADED', fixBlizz)
end


-- Fix trade skill search
local pairs, tonumber, strmatch = pairs, tonumber, string.match

hooksecurefunc("ChatEdit_InsertLink", function(text) -- shift-clicked
	-- change from SearchBox:HasFocus to :IsShown again
	if text and TradeSkillFrame and TradeSkillFrame:IsShown() then
		local spellId = strmatch(text, "enchant:(%d+)")
		local spell = GetSpellInfo(spellId)
		local item = GetItemInfo(strmatch(text, "item:(%d+)") or 0)
		local search = spell or item
		if not search then return end

		-- search needs to be lowercase for .SetRecipeItemNameFilter
		TradeSkillFrame.SearchBox:SetText(search)

		-- jump to the recipe
		if spell then -- can only select recipes on the learned tab
			if PanelTemplates_GetSelectedTab(TradeSkillFrame.RecipeList) == 1 then
				TradeSkillFrame:SelectRecipe(tonumber(spellId))
			end
		elseif item then
			C_Timer.After(.1, function() -- wait a bit or we cant select the recipe yet
				for _, v in pairs(TradeSkillFrame.RecipeList.dataList) do
					if v.name == item then
						--TradeSkillFrame.RecipeList:RefreshDisplay() -- didnt seem to help
						TradeSkillFrame:SelectRecipe(v.recipeID)
						return
					end
				end
			end)
		end
	end
end)

-- make it only split stacks with shift-rightclick if the TradeSkillFrame is open
-- shift-leftclick should be reserved for the search box
local function hideSplitFrame(_, button)
	if TradeSkillFrame and TradeSkillFrame:IsShown() then
		if button == "LeftButton" then
			StackSplitFrame:Hide()
		end
	end
end
hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", hideSplitFrame)
hooksecurefunc("MerchantItemButton_OnModifiedClick", hideSplitFrame)