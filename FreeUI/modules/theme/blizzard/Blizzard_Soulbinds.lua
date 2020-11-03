local F, C = unpack(select(2, ...))

local function ReskinConduitList(frame)
	local header = frame.CategoryButton.Container
	if not header.styled then
		header:DisableDrawLayer("BACKGROUND")
		local bg = F.CreateBDFrame(header, .25)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", 15, 0)

		header.styled = true
	end

	for button in frame.pool:EnumerateActive() do
		if not button.styled then
			for _, element in ipairs(button.Hovers) do
				element:SetColorTexture(1, 1, 1, .25)
			end
			button.PendingBackground:SetColorTexture(1, .8, 0, .25)
			button.Spec.IconOverlay:Hide()
			F.ReskinIcon(button.Spec.Icon):SetFrameLevel(8)

			button.styled = true
		end
	end
end

C.Themes["Blizzard_Soulbinds"] = function()
	local SoulbindViewer = SoulbindViewer

	F.StripTextures(SoulbindViewer)
	SoulbindViewer.Background:SetAlpha(0)
	F.SetBD(SoulbindViewer)
	F.ReskinClose(SoulbindViewer.CloseButton)
	F.Reskin(SoulbindViewer.CommitConduitsButton)
	F.Reskin(SoulbindViewer.ActivateSoulbindButton)
	SoulbindViewer.ConduitList.BottomShadowContainer.BottomShadow:SetAlpha(0)

	local scrollBox = SoulbindViewer.ConduitList.ScrollBox
	for i = 1, 3 do
		hooksecurefunc(scrollBox.ScrollTarget.Lists[i], "UpdateLayout", ReskinConduitList)
	end
	select(2, scrollBox:GetChildren()):Hide()
end
