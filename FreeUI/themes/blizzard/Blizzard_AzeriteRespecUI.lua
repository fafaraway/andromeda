local F, C = unpack(select(2, ...))

local function reskinReforgeUI(frame, index)
	F.StripTextures(frame, index)
	F.CreateBDFrame(frame.Background)
	F.SetBD(frame)
	F.ReskinClose(frame.CloseButton)
	F.ReskinIcon(frame.ItemSlot.Icon)

	local buttonFrame = frame.ButtonFrame
	F.StripTextures(buttonFrame)
	buttonFrame.MoneyFrameEdge:SetAlpha(0)
	local bg = F.CreateBDFrame(buttonFrame, .25)
	bg:SetPoint("TOPLEFT", buttonFrame.MoneyFrameEdge, 3, 0)
	bg:SetPoint("BOTTOMRIGHT", buttonFrame.MoneyFrameEdge, 0, 2)
	if buttonFrame.AzeriteRespecButton then F.Reskin(buttonFrame.AzeriteRespecButton) end
	if buttonFrame.ActionButton then F.Reskin(buttonFrame.ActionButton) end
	if buttonFrame.Currency then F.ReskinIcon(buttonFrame.Currency.icon) end
end

C.Themes["Blizzard_AzeriteRespecUI"] = function()
	reskinReforgeUI(AzeriteRespecFrame, 15)
end

C.Themes["Blizzard_ItemInteractionUI"] = function()
	reskinReforgeUI(ItemInteractionFrame)
end