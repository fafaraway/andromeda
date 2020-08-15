local F, C, L = unpack(select(2, ...))
local MISC = F:GetModule('Misc')


local menuFrame = CreateFrame('Frame', nil, UIParent, 'UIDropDownMenuTemplate')
local menuList = {
	{text = L['AUTOMATION_MARK_CLEAR'], func = function() SetRaidTarget('target', 0) end},
	{text = L['AUTOMATION_MARK_SKULL'], func = function() SetRaidTarget('target', 8) end},
	{text = '|cffff0000'..L['AUTOMATION_MARK_CROSS'], func = function() SetRaidTarget('target', 7) end},
	{text = '|cff00ffff'..L['AUTOMATION_MARK_SQUARE'], func = function() SetRaidTarget('target', 6) end},
	{text = '|cffC7C7C7'..L['AUTOMATION_MARK_MOON'], func = function() SetRaidTarget('target', 5) end},
	{text = '|cff00ff00'..L['AUTOMATION_MARK_TRIANGLE'], func = function() SetRaidTarget('target', 4) end},
	{text = '|cff912CEE'..L['AUTOMATION_MARK_DIAMOND'], func = function() SetRaidTarget('target', 3) end},
	{text = '|cffFF8000'..L['AUTOMATION_MARK_CIRCLE'], func = function() SetRaidTarget('target', 2) end},
	{text = '|cffffff00'..L['AUTOMATION_MARK_STAR'], func = function() SetRaidTarget('target', 1) end},
}

function MISC:EasyMark()
	if not FreeUIConfigs['easy_mark'] then return end

	WorldFrame:HookScript('OnMouseDown', function(self, button)
		if button == 'LeftButton' and IsAltKeyDown() and UnitExists('mouseover') then
			local inRaid = IsInRaid()
			if (inRaid and (UnitIsGroupLeader('player') or UnitIsGroupAssistant('player'))) or not inRaid then
				EasyMenu(menuList, menuFrame, 'cursor', 0, 0, 'MENU', 1)
			end
		end
	end)
end

MISC:RegisterMisc('EasyMark', MISC.EasyMark)
