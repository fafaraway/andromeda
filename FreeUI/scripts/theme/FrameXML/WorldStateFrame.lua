local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	-- PvP score frame

	select(2, WorldStateScoreScrollFrame:GetRegions()):Hide()
	select(3, WorldStateScoreScrollFrame:GetRegions()):Hide()

	WorldStateScoreFrameTab1:ClearAllPoints()
	WorldStateScoreFrameTab1:SetPoint("TOPLEFT", WorldStateScoreFrame, "BOTTOMLEFT", 5, 2)
	WorldStateScoreFrameTab2:SetPoint("LEFT", WorldStateScoreFrameTab1, "RIGHT", -15, 0)
	WorldStateScoreFrameTab3:SetPoint("LEFT", WorldStateScoreFrameTab2, "RIGHT", -15, 0)
	--WorldStateScoreFrame.XPBar.Frame:Hide()

	for i = 1, 3 do
		F.ReskinTab(_G["WorldStateScoreFrameTab"..i])
	end

	F.ReskinPortraitFrame(WorldStateScoreFrame)
	F.Reskin(WorldStateScoreFrameQueueButton)
	F.Reskin(WorldStateScoreFrameLeaveButton)
	F.ReskinScroll(WorldStateScoreScrollFrameScrollBar)

end)