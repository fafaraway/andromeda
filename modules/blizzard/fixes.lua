local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('BLIZZARD')


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

-- Fix WhoFrame level column width
do
	hooksecurefunc('WhoList_Update', function()
		local buttons = _G.WhoListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			local level = button.Level
			if level and not level.fontStyled then
				level:SetWidth(32)
				level:SetJustifyH('LEFT')
				level.fontStyled = true
			end
		end
	end)
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
