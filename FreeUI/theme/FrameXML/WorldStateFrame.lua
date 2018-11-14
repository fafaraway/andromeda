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

	F.ReskinPortraitFrame(WorldStateScoreFrame, true)
	F.Reskin(WorldStateScoreFrameQueueButton)
	F.Reskin(WorldStateScoreFrameLeaveButton)
	F.ReskinScroll(WorldStateScoreScrollFrameScrollBar)

	-- Capture bar

	--hooksecurefunc("UIParent_ManageFramePositions", function()
	--	if not NUM_EXTENDED_UI_FRAMES then return end
	--	for i = 1, NUM_EXTENDED_UI_FRAMES do
	--		local bar = _G["WorldStateCaptureBar"..i]
	--		if bar and bar:IsVisible() then
	--			bar:ClearAllPoints()
				
	--			if i == 1 then
	--				bar:SetPoint("TOP", UIParent, "TOP", 0, -100)
	--			else
	--				bar:SetPoint("TOPLEFT", _G["WorldStateCaptureBar" .. i - 1], "TOPLEFT", 0, -45)
	--			end

	--			if not bar.skinned then
	--				local left = bar.LeftBar
	--				local right = bar.RightBar
	--				local middle = bar.MiddleBar
	--				select(4, bar:GetRegions()):Hide()
	--				bar.LeftLine:SetAlpha(0)
	--				bar.RightLine:SetAlpha(0)
	--				bar.LeftIconHighlight:SetAlpha(0)
	--				bar.RightIconHighlight:SetAlpha(0)

	--				left:SetTexture(C.media.sbTex)
	--				right:SetTexture(C.media.sbTex)
	--				middle:SetTexture(C.media.sbTex)

	--				left:SetVertexColor(0.2, 0.6, 1)
	--				right:SetVertexColor(0.9, 0.2, 0.2)
	--				middle:SetVertexColor(0.8, 0.8, 0.8)

	--				bar:CreateBackdrop("Default")
	--				bar.backdrop:SetPoint("TOPLEFT", left, -2, 2)
	--				bar.backdrop:SetPoint("BOTTOMRIGHT", right, 2, -2)

	--				bar.skinned = true
	--			end
	--		end
	--	end
	--end)
--[[
	hooksecurefunc(ExtendedUI["CAPTUREPOINT"], "update", function(id)
		local bar = _G["WorldStateCaptureBar"..id]
		if not (bar.newLeftFaction and bar.newRightFaction) then return end

		if bar.style == "LFD_BATTLEFIELD" then
			bar.newLeftFaction:SetTexture("Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2")
			bar.newRightFaction:SetTexture("Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2")
			bar.newRightFaction:SetDesaturated(true)
			bar.newRightFaction:SetVertexColor(.75, .5, 1)
		else
			bar.newLeftFaction:SetTexture("Interface\\WorldStateFrame\\AllianceFlag")
			bar.newRightFaction:SetTexture("Interface\\WorldStateFrame\\HordeFlag")
			bar.newRightFaction:SetDesaturated(false)
			bar.newRightFaction:SetVertexColor(1, 1, 1)
		end
	end)]]
end)