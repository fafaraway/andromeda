local F, C = unpack(select(2, ...))

if not C.isDeveloper then
	return
end

do
	local function SetCam(cmd)
		ConsoleExec('ActionCam ' .. cmd)
	end

	F:RegisterEvent(
		'PLAYER_ENTERING_WORLD',
		function()
			UIParent:UnregisterEvent('EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED')
			SetCam('basic')
		end
	)
end

do -- Prevents spells from being automatically added to your action bar
	IconIntroTracker.RegisterEvent = function()
	end
	IconIntroTracker:UnregisterEvent('SPELL_PUSHED_TO_ACTIONBAR')

	-- local f = CreateFrame('frame')
	-- f:SetScript('OnEvent', function(self, event, spellID, slotIndex, slotPos)
	-- 	if not InCombatLockdown() then
	-- 		ClearCursor()
	-- 		PickupAction(slotIndex)
	-- 		ClearCursor()
	-- 	end
	-- end)
	-- f:RegisterEvent('SPELL_PUSHED_TO_ACTIONBAR')
end

-- Hide tutorial
-- Credit ketho
-- https://github.com/ketho-wow/HideTutorial
do
	local function OnEvent(self, event, addon)
		if event == 'ADDON_LOADED' and addon == 'HideTutorial' then
			local tocVersion = select(4, GetBuildInfo())
			if not C.DB.toc_version or C.DB.toc_version < tocVersion then
				-- only do this once per character
				C.DB.toc_version = tocVersion
			end
		elseif event == 'VARIABLES_LOADED' then
			local lastInfoFrame = C_CVar.GetCVarBitfield('closedInfoFrames', NUM_LE_FRAME_TUTORIALS)
			if C.DB.installation.complete or not lastInfoFrame then
				C_CVar.SetCVar('showTutorials', 0)
				C_CVar.SetCVar('showNPETutorials', 0)
				C_CVar.SetCVar('hideAdventureJournalAlerts', 1)
				-- help plates
				for i = 1, NUM_LE_FRAME_TUTORIALS do
					C_CVar.SetCVarBitfield('closedInfoFrames', i, true)
				end
				for i = 1, NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
					C_CVar.SetCVarBitfield('closedInfoFramesAccountWide', i, true)
				end
			end

			function MainMenuMicroButton_AreAlertsEnabled()
				return false
			end
		end
	end

	local f = CreateFrame('Frame')
	f:RegisterEvent('ADDON_LOADED')
	f:RegisterEvent('VARIABLES_LOADED')
	f:SetScript('OnEvent', OnEvent)
end

-- Get visual id and source id from WardrobeCollectionFrame
-- Credit silverwind
-- https://github.com/silverwind/idTip
do
	local kinds = {
		item = 'ItemID',
		visual = 'VisualID',
		source = 'SourceID'
	}

	local function contains(table, element)
		for _, value in pairs(table) do
			if value == element then
				return true
			end
		end
		return false
	end

	local function addLine(tooltip, id, kind)
		if not id or id == '' then
			return
		end
		if type(id) == 'table' and #id == 1 then
			id = id[1]
		end

		-- Check if we already added to this tooltip. Happens on the talent frame
		local frame, text
		for i = 1, 15 do
			frame = _G[tooltip:GetName() .. 'TextLeft' .. i]
			if frame then
				text = frame:GetText()
			end
			if text and string.find(text, kind .. ':') then
				return
			end
		end

		local left, right
		if type(id) == 'table' then
			left = NORMAL_FONT_COLOR_CODE .. kind .. 's:' .. FONT_COLOR_CODE_CLOSE
			right = HIGHLIGHT_FONT_COLOR_CODE .. table.concat(id, ', ') .. FONT_COLOR_CODE_CLOSE
		else
			left = NORMAL_FONT_COLOR_CODE .. kind .. ':' .. FONT_COLOR_CODE_CLOSE
			right = HIGHLIGHT_FONT_COLOR_CODE .. id .. FONT_COLOR_CODE_CLOSE
		end


		tooltip:AddDoubleLine(left, right)
		tooltip:Show()
	end

	local f = CreateFrame('frame')
	f:RegisterEvent('ADDON_LOADED')
	f:SetScript(
		'OnEvent',
		function(_, _, what)
			if what == 'Blizzard_Collections' then
				hooksecurefunc(
					'WardrobeCollectionFrame_SetAppearanceTooltip',
					function(self, sources)
						local visualIDs = {}
						local sourceIDs = {}
						local itemIDs = {}

						for i = 1, #sources do
							if sources[i].visualID and not contains(visualIDs, sources[i].visualID) then
								table.insert(visualIDs, sources[i].visualID)
							end
							if sources[i].sourceID and not contains(visualIDs, sources[i].sourceID) then
								table.insert(sourceIDs, sources[i].sourceID)
							end
							if sources[i].itemID and not contains(visualIDs, sources[i].itemID) then
								table.insert(itemIDs, sources[i].itemID)
							end
						end

						GameTooltip:AddLine(' ')

						if #visualIDs ~= 0 then
							addLine(GameTooltip, visualIDs, kinds.visual)
						end
						if #sourceIDs ~= 0 then
							addLine(GameTooltip, sourceIDs, kinds.source)
						end
						if #itemIDs ~= 0 then
							addLine(GameTooltip, itemIDs, kinds.item)
						end
					end
				)
			end
		end
	)
end
