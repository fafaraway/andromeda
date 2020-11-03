local F, C = unpack(select(2, ...))

local function ReskinQuestHeader(header, isCalling)
	if header.styled then return end

	header.Background:SetAlpha(.7)
	if header.Divider then header.Divider:Hide() end
	if header.TopFiligree then header.TopFiligree:Hide() end

	local collapseButton = isCalling and header or header.CollapseButton
	if collapseButton then
		collapseButton:GetPushedTexture():SetAlpha(0)
		collapseButton:GetHighlightTexture():SetAlpha(0)
		F.ReskinCollapse(collapseButton, true)
		collapseButton.bg:SetFrameLevel(6)
	end

	header.styled = true
end

local function ReskinSessionDialog(_, dialog)
	if not dialog.styled then
		F.StripTextures(dialog)
		F.SetBD(dialog)
		F.Reskin(dialog.ButtonContainer.Confirm)
		F.Reskin(dialog.ButtonContainer.Decline)
		if dialog.MinimizeButton then
			F.ReskinArrow(dialog.MinimizeButton, "down")
		end

		dialog.styled = true
	end
end

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	-- Quest frame

	local QuestMapFrame = QuestMapFrame
	QuestMapFrame.VerticalSeparator:SetAlpha(0)
	QuestMapFrame.Background:SetAlpha(0)

	local QuestScrollFrame = QuestScrollFrame
	QuestScrollFrame.DetailFrame.TopDetail:SetAlpha(0)
	QuestScrollFrame.DetailFrame.BottomDetail:SetAlpha(0)
	QuestScrollFrame.Contents.Separator:SetAlpha(0)
	ReskinQuestHeader(QuestScrollFrame.Contents.StoryHeader)
	F.ReskinScroll(QuestScrollFrame.ScrollBar)

	local campaignOverview = QuestMapFrame.CampaignOverview
	campaignOverview.BG:SetAlpha(0)
	ReskinQuestHeader(campaignOverview.Header)
	F.ReskinScroll(campaignOverview.ScrollFrame.ScrollBar)

	-- Quest details

	local DetailsFrame = QuestMapFrame.DetailsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

	F.StripTextures(DetailsFrame)
	F.StripTextures(DetailsFrame.RewardsFrame)
	F.StripTextures(DetailsFrame.ShareButton)
	DetailsFrame.SealMaterialBG:SetAlpha(0)

	F.Reskin(DetailsFrame.BackButton)
	F.Reskin(DetailsFrame.AbandonButton)
	F.Reskin(DetailsFrame.ShareButton)
	F.Reskin(DetailsFrame.TrackButton)
	F.ReskinScroll(QuestMapDetailsScrollFrame.ScrollBar)

	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("BOTTOMLEFT", DetailsFrame, -1, 0)
	DetailsFrame.AbandonButton:SetWidth(95)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("LEFT", DetailsFrame.AbandonButton, "RIGHT", 1, 0)
	DetailsFrame.ShareButton:SetWidth(94)

	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 1, 0)
	DetailsFrame.TrackButton:SetWidth(96)

	-- Scroll frame

	hooksecurefunc("QuestLogQuests_Update", function()
		for button in QuestScrollFrame.headerFramePool:EnumerateActive() do
			if button.ButtonText then
				if not button.styled then
					F.ReskinCollapse(button, true)
					button:GetPushedTexture():SetAlpha(0)
					button:GetHighlightTexture():SetAlpha(0)

					button.styled = true
				end
			end
		end

		for header in QuestScrollFrame.campaignHeaderFramePool:EnumerateActive() do
			ReskinQuestHeader(header)
		end

		for header in QuestScrollFrame.covenantCallingsHeaderFramePool:EnumerateActive() do
			ReskinQuestHeader(header, true)
		end
	end)

	-- Complete quest frame
	F.StripTextures(CompleteQuestFrame)
	F.StripTextures(CompleteQuestFrame.CompleteButton)
	F.Reskin(CompleteQuestFrame.CompleteButton)

	-- [[ Quest log popup detail frame ]]

	local QuestLogPopupDetailFrame = QuestLogPopupDetailFrame

	F.ReskinPortraitFrame(QuestLogPopupDetailFrame)
	F.ReskinScroll(QuestLogPopupDetailFrameScrollFrameScrollBar)
	F.Reskin(QuestLogPopupDetailFrame.AbandonButton)
	F.Reskin(QuestLogPopupDetailFrame.TrackButton)
	F.Reskin(QuestLogPopupDetailFrame.ShareButton)

	-- Show map button

	local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton

	ShowMapButton.Texture:SetAlpha(0)
	ShowMapButton.Highlight:SetTexture("")
	ShowMapButton.Highlight:SetTexture("")

	ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)
	ShowMapButton.Text:ClearAllPoints()
	ShowMapButton.Text:SetPoint("CENTER", 1, 0)

	ShowMapButton:ClearAllPoints()
	ShowMapButton:SetPoint("TOPRIGHT", QuestLogPopupDetailFrame, -30, -25)

	F.Reskin(ShowMapButton)

	ShowMapButton:HookScript("OnEnter", function(self)
		self.Text:SetTextColor(1, 1, 1)
	end)

	ShowMapButton:HookScript("OnLeave", function(self)
		self.Text:SetTextColor(1, .8, 0)
	end)

	-- Bottom buttons

	QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
	QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)

	-- Party Sync button

	local sessionManagement = QuestMapFrame.QuestSessionManagement
	sessionManagement.BG:Hide()
	F.CreateBDFrame(sessionManagement, .25)

	hooksecurefunc(QuestSessionManager, "NotifyDialogShow", ReskinSessionDialog)

	local executeSessionCommand = sessionManagement.ExecuteSessionCommand
	F.Reskin(executeSessionCommand)

	local icon = executeSessionCommand:CreateTexture(nil, "ARTWORK")
	icon:SetInside()
	executeSessionCommand.normalIcon = icon

	local sessionCommandToButtonAtlas = {
		[_G.Enum.QuestSessionCommand.Start] = "QuestSharing-DialogIcon",
		[_G.Enum.QuestSessionCommand.Stop] = "QuestSharing-Stop-DialogIcon"
	}

	hooksecurefunc(QuestMapFrame.QuestSessionManagement, "UpdateExecuteCommandAtlases", function(self, command)
		self.ExecuteSessionCommand:SetNormalTexture("")
		self.ExecuteSessionCommand:SetPushedTexture("")
		self.ExecuteSessionCommand:SetDisabledTexture("")

		local atlas = sessionCommandToButtonAtlas[command]
		if atlas then
			self.ExecuteSessionCommand.normalIcon:SetAtlas(atlas)
		end
	end)
end)
