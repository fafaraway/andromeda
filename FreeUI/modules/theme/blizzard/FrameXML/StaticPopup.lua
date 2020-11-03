local F, C = unpack(select(2, ...))

local function colorMinimize(f)
	if f:IsEnabled() then
		f.minimize:SetVertexColor(r, g, b)
	end
end

local function clearMinimize(f)
	f.minimize:SetVertexColor(1, 1, 1)
end

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	local r, g, b = C.r, C.g, C.b

	for i = 1, 4 do
		local frame = _G["StaticPopup"..i]
		local bu = _G["StaticPopup"..i.."ItemFrame"]
		local icon = _G["StaticPopup"..i.."ItemFrameIconTexture"]
		local close = _G["StaticPopup"..i.."CloseButton"]

		local gold = _G["StaticPopup"..i.."MoneyInputFrameGold"]
		local silver = _G["StaticPopup"..i.."MoneyInputFrameSilver"]
		local copper = _G["StaticPopup"..i.."MoneyInputFrameCopper"]

		_G["StaticPopup"..i.."ItemFrameNameFrame"]:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")
		bu:SetPushedTexture("")
		bu.bg = F.ReskinIcon(icon)
		F.ReskinIconBorder(bu.IconBorder)

		silver:SetPoint("LEFT", gold, "RIGHT", 1, 0)
		copper:SetPoint("LEFT", silver, "RIGHT", 1, 0)

		frame.Border:Hide()
		F.SetBD(frame)
		for j = 1, 4 do
			F.Reskin(frame["button"..j])
		end
		F.Reskin(frame.extraButton)
		F.ReskinClose(close)

		close.minimize = close:CreateTexture(nil, "OVERLAY")
		close.minimize:SetSize(9, C.Mult)
		close.minimize:SetPoint("CENTER")
		close.minimize:SetTexture(C.Assets.bd_tex)
		close.minimize:SetVertexColor(1, 1, 1)
		close:HookScript("OnEnter", colorMinimize)
		close:HookScript("OnLeave", clearMinimize)

		F.ReskinInput(_G["StaticPopup"..i.."EditBox"], 20)
		F.ReskinInput(gold)
		F.ReskinInput(silver)
		F.ReskinInput(copper)
	end

	hooksecurefunc("StaticPopup_Show", function(which, _, _, data)
		local info = StaticPopupDialogs[which]

		if not info then return end

		local dialog = nil
		dialog = StaticPopup_FindVisible(which, data)

		if not dialog then
			local index = 1
			if info.preferredIndex then
				index = info.preferredIndex
			end
			for i = index, STATICPOPUP_NUMDIALOGS do
				local frame = _G["StaticPopup"..i]
				if not frame:IsShown() then
					dialog = frame
					break
				end
			end

			if not dialog and info.preferredIndex then
				for i = 1, info.preferredIndex do
					local frame = _G["StaticPopup"..i]
					if not frame:IsShown() then
						dialog = frame
						break
					end
				end
			end
		end

		if not dialog then return end

		if info.closeButton then
			local closeButton = _G[dialog:GetName().."CloseButton"]

			closeButton:SetNormalTexture("")
			closeButton:SetPushedTexture("")

			if info.closeButtonIsHide then
				closeButton.__texture:Hide()
				closeButton.minimize:Show()
			else
				closeButton.__texture:Show()
				closeButton.minimize:Hide()
			end
		end
	end)

	-- Pet battle queue popup

	F.SetBD(PetBattleQueueReadyFrame)
	F.CreateBDFrame(PetBattleQueueReadyFrame.Art)
	PetBattleQueueReadyFrame.Border:Hide()
	F.Reskin(PetBattleQueueReadyFrame.AcceptButton)
	F.Reskin(PetBattleQueueReadyFrame.DeclineButton)

	-- PlayerReportFrame
	PlayerReportFrame:HookScript("OnShow", function(self)
		if not self.styled then
			F.StripTextures(self)
			F.SetBD(self)
			F.StripTextures(self.Comment)
			F.ReskinInput(self.Comment)
			F.Reskin(self.ReportButton)
			F.Reskin(self.CancelButton)

			self.styled = true
		end
	end)
end)
