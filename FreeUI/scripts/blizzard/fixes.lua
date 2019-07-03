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


--	FrameStackGlobalizer(by Gethe)
local FrameStackFix = CreateFrame("Frame")
FrameStackFix:RegisterEvent("ADDON_LOADED")
FrameStackFix:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_DebugTools" then
		local EnumerateFrames = _G.EnumerateFrames
		local tostring = _G.tostring

		local ignore = {}
		local frames = {}
		local function FindFrame(hash)
			if ignore[hash] then return end

			if frames[hash] then
				return frames[hash]
			else
				local frame = EnumerateFrames()
				while frame do
					local frameHash = tostring(frame)
					if frameHash:find(hash) then
						frames[hash] = frame
						return frame
					end
					frame = EnumerateFrames(frame)
				end
			end

			ignore[hash] = true
		end

		local matchPattern, subPattern = "%s%%.(%%x*)%%.?", "(%s%%.%%x*)"
		local function TransformText(text)
			local parent = text:match("%s+([%w_]+)%.")
			if parent then
				local hash = text:match(matchPattern:format(parent))
				if hash and #hash > 5 then
					local frame = FindFrame(hash:upper())
					if frame and frame:GetName() then
						text = text:gsub(subPattern:format(parent), frame:GetName())
						return TransformText(text)
					end
				end
			end

			return text
		end

		_G.hooksecurefunc(_G.FrameStackTooltip, "SetFrameStack", function(self)
			for i = 1, self:NumLines() do
				local line = _G["FrameStackTooltipTextLeft"..i]
				local text = line:GetText()
				if text and text:find("<%d+>") then
					line:SetText(TransformText(text))
				end
			end
		end)
	end
end)