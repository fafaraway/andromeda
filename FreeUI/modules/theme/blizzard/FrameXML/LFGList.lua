local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	local r, g, b = C.r, C.g, C.b

	local LFGListFrame = LFGListFrame
	LFGListFrame.NothingAvailable.Inset:Hide()

	-- [[ Category selection ]]

	local CategorySelection = LFGListFrame.CategorySelection

	F.Reskin(CategorySelection.FindGroupButton)
	F.Reskin(CategorySelection.StartGroupButton)
	CategorySelection.Inset:Hide()
	CategorySelection.CategoryButtons[1]:SetNormalFontObject(GameFontNormal)

	hooksecurefunc("LFGListCategorySelection_AddButton", function(self, btnIndex)
		local bu = self.CategoryButtons[btnIndex]
		if bu and not bu.styled then
			bu.Cover:Hide()
			bu.Icon:SetTexCoord(.01, .99, .01, .99)
			F.CreateBDFrame(bu.Icon)

			bu.styled = true
		end
	end)

	hooksecurefunc("LFGListSearchEntry_Update", function(self)
		local cancelButton = self.CancelButton
		if not cancelButton.styled then
			F.Reskin(cancelButton)
			cancelButton.styled = true
		end
	end)

	-- [[ Search panel ]]

	local SearchPanel = LFGListFrame.SearchPanel

	F.Reskin(SearchPanel.RefreshButton)
	F.Reskin(SearchPanel.BackButton)
	F.Reskin(SearchPanel.SignUpButton)
	F.Reskin(SearchPanel.ScrollFrame.StartGroupButton)
	F.ReskinInput(SearchPanel.SearchBox)
	F.ReskinScroll(SearchPanel.ScrollFrame.scrollBar)

	SearchPanel.RefreshButton:SetSize(24, 24)
	SearchPanel.RefreshButton.Icon:SetPoint("CENTER")
	SearchPanel.ResultsInset:Hide()
	F.StripTextures(SearchPanel.AutoCompleteFrame)

	local function resultOnEnter(self)
		self.hl:Show()
	end

	local function resultOnLeave(self)
		self.hl:Hide()
	end

	local numResults = 1
	hooksecurefunc("LFGListSearchPanel_UpdateAutoComplete", function(self)
		local AutoCompleteFrame = self.AutoCompleteFrame

		for i = numResults, #AutoCompleteFrame.Results do
			local result = AutoCompleteFrame.Results[i]

			if numResults == 1 then
				result:SetPoint("TOPLEFT", AutoCompleteFrame.LeftBorder, "TOPRIGHT", -8, 1)
				result:SetPoint("TOPRIGHT", AutoCompleteFrame.RightBorder, "TOPLEFT", 5, 1)
			else
				result:SetPoint("TOPLEFT", AutoCompleteFrame.Results[i-1], "BOTTOMLEFT", 0, 1)
				result:SetPoint("TOPRIGHT", AutoCompleteFrame.Results[i-1], "BOTTOMRIGHT", 0, 1)
			end

			result:SetNormalTexture("")
			result:SetPushedTexture("")
			result:SetHighlightTexture("")

			local bg = F.CreateBDFrame(result, .5)
			local hl = result:CreateTexture(nil, "BACKGROUND")
			hl:SetInside(bg)
			hl:SetTexture(C.Assets.bd_tex)
			hl:SetVertexColor(r, g, b, .25)
			hl:Hide()
			result.hl = hl

			result:HookScript("OnEnter", resultOnEnter)
			result:HookScript("OnLeave", resultOnLeave)

			numResults = numResults + 1
		end
	end)

	-- [[ Application viewer ]]

	local ApplicationViewer = LFGListFrame.ApplicationViewer
	ApplicationViewer.InfoBackground:Hide()
	ApplicationViewer.Inset:Hide()

	local function headerOnEnter(self)
		self.hl:Show()
	end

	local function headerOnLeave(self)
		self.hl:Hide()
	end

	for _, headerName in pairs({"NameColumnHeader", "RoleColumnHeader", "ItemLevelColumnHeader"}) do
		local header = ApplicationViewer[headerName]
		F.StripTextures(header)
		header.Label:SetFont(C.Assets.Fonts.Regular, 14, "OUTLINE")
		header.Label:SetShadowColor(0, 0, 0, 0)
		header:SetHighlightTexture("")

		local bg = F.CreateBDFrame(header, .25)
		local hl = header:CreateTexture(nil, "BACKGROUND")
		hl:SetInside(bg)
		hl:SetTexture(C.Assets.bd_tex)
		hl:SetVertexColor(r, g, b, .25)
		hl:Hide()
		header.hl = hl

		header:HookScript("OnEnter", headerOnEnter)
		header:HookScript("OnLeave", headerOnLeave)
	end

	ApplicationViewer.RoleColumnHeader:SetPoint("LEFT", ApplicationViewer.NameColumnHeader, "RIGHT", 1, 0)
	ApplicationViewer.ItemLevelColumnHeader:SetPoint("LEFT", ApplicationViewer.RoleColumnHeader, "RIGHT", 1, 0)

	F.Reskin(ApplicationViewer.RefreshButton)
	F.Reskin(ApplicationViewer.RemoveEntryButton)
	F.Reskin(ApplicationViewer.EditButton)
	F.ReskinScroll(LFGListApplicationViewerScrollFrameScrollBar)

	ApplicationViewer.RefreshButton:SetSize(24, 24)
	ApplicationViewer.RefreshButton.Icon:SetPoint("CENTER")

	hooksecurefunc("LFGListApplicationViewer_UpdateApplicant", function(button)
		if not button.styled then
			F.Reskin(button.DeclineButton)
			F.Reskin(button.InviteButton)

			button.styled = true
		end
	end)

	-- [[ Entry creation ]]

	local EntryCreation = LFGListFrame.EntryCreation
	EntryCreation.Inset:Hide()
	F.StripTextures(EntryCreation.Description)
	F.Reskin(EntryCreation.ListGroupButton)
	F.Reskin(EntryCreation.CancelButton)
	F.ReskinInput(EntryCreation.Description)
	F.ReskinInput(EntryCreation.Name)
	F.ReskinInput(EntryCreation.ItemLevel.EditBox)
	F.ReskinInput(EntryCreation.VoiceChat.EditBox)
	F.ReskinDropDown(EntryCreation.CategoryDropDown)
	F.ReskinDropDown(EntryCreation.GroupDropDown)
	F.ReskinDropDown(EntryCreation.ActivityDropDown)
	F.ReskinCheck(EntryCreation.ItemLevel.CheckButton)
	F.ReskinCheck(EntryCreation.VoiceChat.CheckButton)
	F.ReskinCheck(EntryCreation.PrivateGroup.CheckButton)
	F.ReskinCheck(LFGListFrame.ApplicationViewer.AutoAcceptButton)

	-- [[ Role count ]]

	hooksecurefunc("LFGListGroupDataDisplayRoleCount_Update", function(self)
		if not self.styled then
			F.ReskinRole(self.TankIcon, "TANK")
			F.ReskinRole(self.HealerIcon, "HEALER")
			F.ReskinRole(self.DamagerIcon, "DPS")

			self.styled = true
		end
	end)

	-- Activity finder

	local ActivityFinder = EntryCreation.ActivityFinder

	ActivityFinder.Background:SetTexture("")
	F.StripTextures(ActivityFinder.Dialog)
	F.ReskinInput(ActivityFinder.Dialog)
	F.Reskin(ActivityFinder.Dialog.SelectButton)
	F.Reskin(ActivityFinder.Dialog.CancelButton)
	F.ReskinInput(ActivityFinder.Dialog.EntryBox)
	F.ReskinScroll(LFGListEntryCreationSearchScrollFrameScrollBar)

	-- [[ Application dialog ]]

	local LFGListApplicationDialog = LFGListApplicationDialog

	F.StripTextures(LFGListApplicationDialog)
	F.SetBD(LFGListApplicationDialog)
	F.StripTextures(LFGListApplicationDialog.Description)
	F.CreateBDFrame(LFGListApplicationDialog.Description, .25)
	F.Reskin(LFGListApplicationDialog.SignUpButton)
	F.Reskin(LFGListApplicationDialog.CancelButton)

	-- [[ Invite dialog ]]

	local LFGListInviteDialog = LFGListInviteDialog

	F.StripTextures(LFGListInviteDialog)
	F.SetBD(LFGListInviteDialog)
	F.Reskin(LFGListInviteDialog.AcceptButton)
	F.Reskin(LFGListInviteDialog.DeclineButton)
	F.Reskin(LFGListInviteDialog.AcknowledgeButton)

	local roleIcon = LFGListInviteDialog.RoleIcon
	roleIcon:SetTexture(C.Assets.roles_icon)
	F.CreateBDFrame(roleIcon)

	hooksecurefunc("LFGListInviteDialog_Show", function(self, resultID)
		local role = select(5, C_LFGList.GetApplicationInfo(resultID))
		self.RoleIcon:SetTexCoord(F.GetRoleTexCoord(role))
	end)
end)
