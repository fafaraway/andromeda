local F, C, L = unpack(select(2, ...))
local COMBAT = F:GetModule('COMBAT')


local menuList = {
	{text = RAID_TARGET_NONE, func = function() SetRaidTarget('target', 0) end},
	{text = F.RGBToHex(1, .92, 0)..RAID_TARGET_1..' '..ICON_LIST[1]..'12|t', func = function() SetRaidTarget('target', 1) end},
	{text = F.RGBToHex(.98, .57, 0)..RAID_TARGET_2..' '..ICON_LIST[2]..'12|t', func = function() SetRaidTarget('target', 2) end},
	{text = F.RGBToHex(.83, .22, .9)..RAID_TARGET_3..' '..ICON_LIST[3]..'12|t', func = function() SetRaidTarget('target', 3) end},
	{text = F.RGBToHex(.04, .95, 0)..RAID_TARGET_4..' '..ICON_LIST[4]..'12|t', func = function() SetRaidTarget('target', 4) end},
	{text = F.RGBToHex(.7, .82, .875)..RAID_TARGET_5..' '..ICON_LIST[5]..'12|t', func = function() SetRaidTarget('target', 5) end},
	{text = F.RGBToHex(0, .71, 1)..RAID_TARGET_6..' '..ICON_LIST[6]..'12|t', func = function() SetRaidTarget('target', 6) end},
	{text = F.RGBToHex(1, .24, .168)..RAID_TARGET_7..' '..ICON_LIST[7]..'12|t', func = function() SetRaidTarget('target', 7) end},
	{text = F.RGBToHex(.98, .98, .98)..RAID_TARGET_8..' '..ICON_LIST[8]..'12|t', func = function() SetRaidTarget('target', 8) end},
}


function COMBAT:Marker()
	if not C.DB.combat.easy_mark then return end

	WorldFrame:HookScript('OnMouseDown', function(_, btn)
		if btn == 'LeftButton' and IsAltKeyDown() and UnitExists('mouseover') then
			if not IsInGroup() or (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
				local ricon = GetRaidTargetIndex('mouseover')
				for i = 1, 8 do
					if ricon == i then
						menuList[i+1].checked = true
					else
						menuList[i+1].checked = false
					end
				end
				EasyMenu(menuList, F.EasyMenu, 'cursor', 0, 0, 'MENU', 1)
			end
		end
	end)
end


