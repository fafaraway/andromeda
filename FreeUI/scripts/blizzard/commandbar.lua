local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

-- Order Hall Command Bar by Paojy

local OrderHall_eframe = CreateFrame('Frame')
OrderHall_eframe:SetScript('OnEvent', function(self, event, arg1)
	if event == 'ADDON_LOADED' and arg1 == 'Blizzard_OrderHallUI' then
		OrderHall_eframe:RegisterEvent('DISPLAY_SIZE_CHANGED')
		OrderHall_eframe:RegisterEvent('UI_SCALE_CHANGED')
		OrderHall_eframe:RegisterEvent('GARRISON_FOLLOWER_CATEGORIES_UPDATED')
		OrderHall_eframe:RegisterEvent('GARRISON_FOLLOWER_ADDED')
		OrderHall_eframe:RegisterEvent('GARRISON_FOLLOWER_REMOVED')

		OrderHallCommandBar:HookScript('OnShow', function()
			if not OrderHallCommandBar.styled then
				OrderHallCommandBar:EnableMouse(false)
				OrderHallCommandBar.Background:SetAtlas(nil)

				OrderHallCommandBar.ClassIcon:ClearAllPoints()
				OrderHallCommandBar.ClassIcon:SetPoint('TOPLEFT', 30, -30)
				OrderHallCommandBar.ClassIcon:SetSize(40,20)
				OrderHallCommandBar.ClassIcon:SetAlpha(1)
				local bg = F.CreateBDFrame(OrderHallCommandBar.ClassIcon, 0)
				F.CreateBD(bg, 1)

				OrderHallCommandBar.AreaName:ClearAllPoints()
				OrderHallCommandBar.AreaName:SetPoint('LEFT', OrderHallCommandBar.ClassIcon, 'RIGHT', 5, 0)
				OrderHallCommandBar.AreaName:SetFont(C.font.normal, 14, 'OUTLINE')
				OrderHallCommandBar.AreaName:SetTextColor(1, 1, 1)
				OrderHallCommandBar.AreaName:SetShadowOffset(0, 0)

				OrderHallCommandBar.CurrencyIcon:ClearAllPoints()
				OrderHallCommandBar.CurrencyIcon:SetPoint('LEFT', OrderHallCommandBar.AreaName, 'RIGHT', 5, 0)
				OrderHallCommandBar.Currency:ClearAllPoints()
				OrderHallCommandBar.Currency:SetPoint('LEFT', OrderHallCommandBar.CurrencyIcon, 'RIGHT', 5, 0)
				OrderHallCommandBar.Currency:SetFont(C.font.normal, 14, 'OUTLINE')
				OrderHallCommandBar.Currency:SetTextColor(1, 1, 1)
				OrderHallCommandBar.Currency:SetShadowOffset(0, 0)

				OrderHallCommandBar.WorldMapButton:Hide()

				OrderHallCommandBar.styled = true
			end
		end)
	elseif event ~= 'ADDON_LOADED' then
		local index = 1
		C_Timer.After(0.1, function()
			for i, child in ipairs({OrderHallCommandBar:GetChildren()}) do
				if child.Icon and child.Count and child.TroopPortraitCover then
					child:SetPoint('TOPLEFT', OrderHallCommandBar.ClassIcon, 'BOTTOMLEFT', -5, -index*25+20)
					child.TroopPortraitCover:Hide()

					child.Icon:SetSize(40,20)
					local bg = F.CreateBDFrame(child.Icon, 0)
					F.CreateBD(bg, 1)

					child.Count:SetFont(C.font.normal, 14, 'OUTLINE')
					child.Count:SetTextColor(1, 1, 1)
					child.Count:SetShadowOffset(0, 0)

					index = index + 1
				end
			end
		end)
	end
end)

function BLIZZARD:ReskinCommandBar()
	OrderHall_eframe:RegisterEvent('ADDON_LOADED')
end
