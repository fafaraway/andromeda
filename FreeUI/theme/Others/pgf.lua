local F, C = unpack(select(2, ...))
local module = F:GetModule('Theme')


function module:PGF()
	if not IsAddOnLoaded('PremadeGroupsFilter') then return end

	local dialog = PremadeGroupsFilterDialog
	F.StripTextures(dialog, true)
	F.StripTextures(dialog.Advanced, true)
	F.StripTextures(dialog.Expression, true)
	F.CreateBD(dialog)
	F.CreateSD(dialog)
	F.CreateBD(dialog.Expression)
	F.CreateSD(dialog.Expression)
	F.ReskinClose(dialog.CloseButton)
	F.Reskin(dialog.ResetButton)
	F.Reskin(dialog.RefreshButton)
	F.ReskinDropDown(dialog.Difficulty.DropDown)
	F.ReskinCheck(UsePFGButton)

	dialog:SetPoint('LEFT', GroupFinderFrame, 'RIGHT', 6, 0)

	dialog.Defeated.Title:ClearAllPoints()
	dialog.Defeated.Title:SetPoint('LEFT', dialog.Defeated.Act, 'RIGHT', 10, 0)
	dialog.Difficulty.DropDown:ClearAllPoints()
	dialog.Difficulty.DropDown:SetPoint('RIGHT', dialog.Difficulty, 'RIGHT', 13, -3)

	local rebtn = LFGListFrame.SearchPanel.RefreshButton
	UsePFGButton:SetSize(32, 32)
	UsePFGButton:ClearAllPoints()
	UsePFGButton:SetPoint('RIGHT', rebtn, 'LEFT', -55, 0)
	UsePFGButton.text:SetText(FILTER)
	UsePFGButton.text:SetWidth(UsePFGButton.text:GetStringWidth()+2)

	local buttons = {dialog.Defeated.Act, dialog.Difficulty.Act, dialog.Dps.Act, dialog.Heals.Act, dialog.Ilvl.Act, dialog.Members.Act, dialog.Noilvl.Act, dialog.Tanks.Act}
	for _, button in next, buttons do
		local p1, p2, p3, x, y = button:GetPoint()
		button:SetPoint(p1, p2, p3, 0, -3)
		button:SetSize(24, 24)
		F.ReskinCheck(button)
	end

	local inputs = {dialog.Defeated.Min, dialog.Dps.Min, dialog.Heals.Min, dialog.Ilvl.Min, dialog.Members.Min, dialog.Tanks.Min, dialog.Defeated.Max, dialog.Dps.Max, dialog.Heals.Max, dialog.Ilvl.Max, dialog.Members.Max, dialog.Tanks.Max}
	for _, input in next, inputs do
		F.ReskinInput(input)
	end
end

