local F, C = unpack(select(2, ...))

C.Themes["Blizzard_GuildControlUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.SetBD(GuildControlUI)

	for i = 1, 9 do
		select(i, GuildControlUI:GetRegions()):Hide()
	end

	for i = 1, 8 do
		select(i, GuildControlUIRankBankFrameInset:GetRegions()):Hide()
	end

	GuildControlUIRankSettingsFrameOfficerBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameRosterBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameBankBg:SetAlpha(0)
	GuildControlUITopBg:Hide()
	GuildControlUIHbar:Hide()
	GuildControlUIRankBankFrameInsetScrollFrameTop:SetAlpha(0)
	GuildControlUIRankBankFrameInsetScrollFrameBottom:SetAlpha(0)

	do
		local function updateGuildRanks()
			for i = 1, GuildControlGetNumRanks() do
				local rank = _G["GuildControlUIRankOrderFrameRank"..i]
				if not rank.styled then
					rank.upButton.icon:Hide()
					rank.downButton.icon:Hide()
					rank.deleteButton.icon:Hide()

					F.ReskinArrow(rank.upButton, "up")
					F.ReskinArrow(rank.downButton, "down")
					F.ReskinClose(rank.deleteButton)

					F.ReskinInput(rank.nameBox, 20)

					rank.styled = true
				end
			end
		end

		local f = CreateFrame("Frame")
		f:RegisterEvent("GUILD_RANKS_UPDATE")
		f:SetScript("OnEvent", updateGuildRanks)
		hooksecurefunc("GuildControlUI_RankOrder_Update", updateGuildRanks)
	end

	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
		for i = 1, GetNumGuildBankTabs() + 1 do
			local tab = "GuildControlBankTab"..i
			local bu = _G[tab]
			if bu and not bu.styled then
				local ownedTab = bu.owned

				_G[tab.."Bg"]:Hide()
				F.ReskinIcon(ownedTab.tabIcon)
				F.CreateBDFrame(bu, .25)
				F.Reskin(bu.buy.button)
				F.ReskinInput(ownedTab.editBox)

				for _, ch in pairs({ownedTab.viewCB, ownedTab.depositCB, ownedTab.infoCB}) do
					-- can't get a backdrop frame to appear behind the checked texture for some reason
					ch:SetNormalTexture("")
					ch:SetPushedTexture("")
					ch:SetHighlightTexture(C.Assets.bd_tex)

					local check = ch:GetCheckedTexture()
					check:SetDesaturated(true)
					check:SetVertexColor(r, g, b)

					local bg = F.CreateBDFrame(ch, 0, true)
					bg:SetInside(ch, 4, 4)

					local hl = ch:GetHighlightTexture()
					hl:SetInside(bg)
					hl:SetVertexColor(r, g, b, .25)
				end

				bu.styled = true
			end
		end
	end)

	F.ReskinCheck(GuildControlUIRankSettingsFrameOfficerCheckbox)
	for i = 1, 20 do
		local checbox = _G["GuildControlUIRankSettingsFrameCheckbox"..i]
		if checbox then
			F.ReskinCheck(checbox)
		end
	end

	F.Reskin(GuildControlUIRankOrderFrameNewButton)
	F.ReskinClose(GuildControlUICloseButton)
	F.ReskinScroll(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
	F.ReskinDropDown(GuildControlUINavigationDropDown)
	F.ReskinDropDown(GuildControlUIRankSettingsFrameRankDropDown)
	F.ReskinDropDown(GuildControlUIRankBankFrameRankDropDown)
	F.ReskinInput(GuildControlUIRankSettingsFrameGoldBox, 20)
end
