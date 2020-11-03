local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	-- [[ Bank ]]

	BankSlotsFrame:DisableDrawLayer("BORDER")
	BankPortraitTexture:Hide()
	BankFrameMoneyFrameInset:Hide()
	BankFrameMoneyFrameBorder:Hide()

	-- "item slots" and "bag slots" text
	select(9, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY")
	select(10, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY")

	F.ReskinPortraitFrame(BankFrame)
	F.Reskin(BankFramePurchaseButton)
	F.ReskinTab(BankFrameTab1)
	F.ReskinTab(BankFrameTab2)
	F.ReskinInput(BankItemSearchBox)

	local function styleBankButton(bu)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu.searchOverlay:SetOutside()

		bu.icon:SetTexCoord(unpack(C.TexCoord))
		bu.bg = F.CreateBDFrame(bu.icon, .25)
		F.ReskinIconBorder(bu.IconBorder)

		local questTexture = bu.IconQuestTexture
		questTexture:SetDrawLayer("BACKGROUND")
		questTexture:SetSize(1, 1)
	end

	for i = 1, 28 do
		styleBankButton(_G["BankFrameItem"..i])
	end

	for i = 1, 7 do
		local bag = BankSlotsFrame["Bag"..i]
		bag:SetNormalTexture("")
		bag:SetPushedTexture("")
		bag:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bag.SlotHighlightTexture:SetColorTexture(1, .8, 0, .25)
		bag.searchOverlay:SetOutside()

		bag.icon:SetTexCoord(unpack(C.TexCoord))
		bag.bg = F.CreateBDFrame(bag.icon, .25)
		F.ReskinIconBorder(bag.IconBorder)
	end

	BankItemAutoSortButton:GetNormalTexture():SetTexCoord(.17, .83, .17, .83)
	BankItemAutoSortButton:GetPushedTexture():SetTexCoord(.17, .83, .17, .83)
	F.CreateBDFrame(BankItemAutoSortButton)
	local highlight = BankItemAutoSortButton:GetHighlightTexture()
	highlight:SetColorTexture(1, 1, 1, .25)
	highlight:SetAllPoints(BankItemAutoSortButton)

	hooksecurefunc("BankFrameItemButton_Update", function(button)
		if not button.isBag and button.IconQuestTexture:IsShown() then
			button.IconBorder:SetVertexColor(1, 1, 0)
		end
	end)

	-- [[ Reagent bank ]]

	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("BORDER")
	ReagentBankFrame:DisableDrawLayer("ARTWORK")

	F.Reskin(ReagentBankFrame.DespositButton)
	F.Reskin(ReagentBankFrameUnlockInfoPurchaseButton)

	-- make button more visible
	F.StripTextures(ReagentBankFrameUnlockInfo)
	ReagentBankFrameUnlockInfoBlackBG:SetColorTexture(.1, .1, .1)

	local reagentButtonsStyled = false
	ReagentBankFrame:HookScript("OnShow", function()
		if not reagentButtonsStyled then
			for i = 1, 98 do
				local button = _G["ReagentBankFrameItem"..i]
				styleBankButton(button)
				BankFrameItemButton_Update(button)
			end
			reagentButtonsStyled = true
		end
	end)
end)
