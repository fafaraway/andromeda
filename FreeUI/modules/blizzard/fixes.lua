local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')


-- Fix Drag Collections taint
do
	local done
	local function setupMisc(event, addon)
		if event == 'ADDON_LOADED' and addon == 'Blizzard_Collections' then
			CollectionsJournal:HookScript('OnShow', function()
				if not done then
					if InCombatLockdown() then
						F:RegisterEvent('PLAYER_REGEN_ENABLED', setupMisc)
					else
						F.CreateMF(CollectionsJournal)
					end
					done = true
				end
			end)
			F:UnregisterEvent(event, setupMisc)
		elseif event == 'PLAYER_REGEN_ENABLED' then
			F.CreateMF(CollectionsJournal)
			F:UnregisterEvent(event, setupMisc)
		end
	end

	F:RegisterEvent('ADDON_LOADED', setupMisc)
end

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
			if COMMUNITY_UIDD_REFRESH_PATCH_VERSION ~= 1 then
				return
			end
			local f, f2 = FriendsFrame, FriendsTabHeader
			local s = f:IsShown()
			f:Hide()
			f:Show()
			if not f2:IsShown() then
				f2:Show()
				f2:Hide()
			end
			if not s then
				f:Hide()
			end
		end
		hooksecurefunc('Communities_LoadUI', CleanDropdowns)
		hooksecurefunc('SetCVar', function(n)
			if n == 'lastSelectedClubId' then
				CleanDropdowns()
			end
		end)
	end

	-- https://www.townlong-yak.com/bugs/Mx7CWN-RefreshOverread
	if (UIDD_REFRESH_OVERREAD_PATCH_VERSION or 0) < 1 then
		UIDD_REFRESH_OVERREAD_PATCH_VERSION = 1
		local function drop(t, k)
			local c = 42
			t[k] = nil
			while not issecurevariable(t, k) do
				if t[c] == nil then
					t[c] = nil
				end
				c = c + 1
			end
		end
		hooksecurefunc('UIDropDownMenu_InitializeHelper', function()
			if UIDD_REFRESH_OVERREAD_PATCH_VERSION ~= 1 then
				return
			end
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local d = _G['DropDownList'..i]
				if d and d.numButtons then
					for j = d.numButtons+1, UIDROPDOWNMENU_MAXBUTTONS do
						local b, _ = _G['DropDownList'..i..'Button'..j]
						_ = issecurevariable(b, 'checked') or drop(b, 'checked')
						_ = issecurevariable(b, 'notCheckable') or drop(b, 'notCheckable')
					end
				end
			end
		end)
	end
end

-- Select target when click on raid units
do
	local function fixRaidGroupButton()
		for i = 1, 40 do
			local bu = _G['RaidGroupButton'..i]
			if bu and bu.unit and not bu.clickFixed then
				bu:SetAttribute('type', 'target')
				bu:SetAttribute('unit', bu.unit)

				bu.clickFixed = true
			end
		end
	end

	local function setupMisc(event, addon)
		if event == 'ADDON_LOADED' and addon == 'Blizzard_RaidUI' then
			if not InCombatLockdown() then
				fixRaidGroupButton()
			else
				F:RegisterEvent('PLAYER_REGEN_ENABLED', setupMisc)
			end
			F:UnregisterEvent(event, setupMisc)
		elseif event == 'PLAYER_REGEN_ENABLED' then
			if RaidGroupButton1 and RaidGroupButton1:GetAttribute('type') ~= 'target' then
				fixRaidGroupButton()
				F:UnregisterEvent(event, setupMisc)
			end
		end
	end

	F:RegisterEvent('ADDON_LOADED', setupMisc)
end

-- Fix blizz guild news hyperlink error
do
	local function fixGuildNews(event, addon)
		if addon ~= 'Blizzard_GuildUI' then return end

		local _GuildNewsButton_OnEnter = GuildNewsButton_OnEnter
		function GuildNewsButton_OnEnter(self)
			if not (self.newsInfo and self.newsInfo.whatText) then return end
			_GuildNewsButton_OnEnter(self)
		end

		F:UnregisterEvent(event, fixGuildNews)
	end

	local function fixCommunitiesNews(event, addon)
		if addon ~= 'Blizzard_Communities' then return end

		local _CommunitiesGuildNewsButton_OnEnter = CommunitiesGuildNewsButton_OnEnter
		function CommunitiesGuildNewsButton_OnEnter(self)
			if not (self.newsInfo and self.newsInfo.whatText) then return end
			_CommunitiesGuildNewsButton_OnEnter(self)
		end

		F:UnregisterEvent(event, fixCommunitiesNews)
	end

	F:RegisterEvent('ADDON_LOADED', fixGuildNews)
	F:RegisterEvent('ADDON_LOADED', fixCommunitiesNews)
end

-- Fix blizz bug in addon list
do
	local _AddonTooltip_Update = AddonTooltip_Update
	function AddonTooltip_Update(owner)
		if not owner then return end
		if owner:GetID() < 1 then return end
		_AddonTooltip_Update(owner)
	end
end


-- Fix Trade Skill Search
hooksecurefunc('ChatEdit_InsertLink', function(text) -- shift-clicked
	-- change from SearchBox:HasFocus to :IsShown again
	if text and TradeSkillFrame and TradeSkillFrame:IsShown() then
		local spellId = strmatch(text, 'enchant:(%d+)')
		local spell = GetSpellInfo(spellId)
		local item = GetItemInfo(strmatch(text, 'item:(%d+)') or 0)
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
		if button == 'LeftButton' then
			StackSplitFrame:Hide()
		end
	end
end
hooksecurefunc('ContainerFrameItemButton_OnModifiedClick', hideSplitFrame)
hooksecurefunc('MerchantItemButton_OnModifiedClick', hideSplitFrame)
