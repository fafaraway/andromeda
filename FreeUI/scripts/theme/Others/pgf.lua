local F, C = unpack(select(2, ...))
local module = F:GetModule('Theme')


function module:ReskinPGF()
	if not C.appearance.reskinPGF then return end
	if not IsAddOnLoaded("PremadeGroupsFilter") then return end

	local pairs = pairs
	local styled
	local tipStyled

	hooksecurefunc(PremadeGroupsFilter.Debug, "PopupMenu_Initialize", function()
		if tipStyled then return end
		for i = 1, 15 do
			local child = select(i, PremadeGroupsFilterDialog:GetChildren())
			if child and child.Shadow then
				F.ReskinTooltip(child)
				tipStyled = true
				break
			end
		end
	end)

	hooksecurefunc(PremadeGroupsFilterDialog, "SetPoint", function(self, _, parent)
		if parent ~= LFGListFrame then
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", LFGListFrame, "TOPRIGHT", 4, 0)
			self:SetPoint("BOTTOMLEFT", LFGListFrame, "BOTTOMRIGHT", 4, 0)
		end
	end)

	hooksecurefunc(PremadeGroupsFilterDialog, "Show", function(self)
		if styled then return end

		F.StripTextures(self)
		F.CreateBD(self)
		F.CreateSD(self)
		F.ReskinClose(self.CloseButton)
		F.Reskin(self.ResetButton)
		F.Reskin(self.RefreshButton)
		F.ReskinDropDown(self.Difficulty.DropDown)
		F.StripTextures(self.Advanced)
		F.StripTextures(self.Expression)
		F.CreateGradient(F.CreateBDFrame(self.Expression, .25))
		F.ReskinCheck(UsePFGButton)

		local names = {"Difficulty", "Ilvl", "Noilvl", "Defeated", "Members", "Tanks", "Heals", "Dps"}
		for _, name in pairs(names) do
			local check = self[name].Act
			if check then
				check:SetSize(26, 26)
				check:SetPoint("TOPLEFT", 5, -3)
				F.ReskinCheck(check)
			end
			local input = self[name].Min
			if input then
				F.ReskinInput(input)
				F.ReskinInput(self[name].Max)
			end
		end

		styled = true
	end)
end

