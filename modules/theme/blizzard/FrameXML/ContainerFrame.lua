local F, C = unpack(select(2, ...))

local MAX_CONTAINER_ITEMS = 36

local function replaceSortTexture(texture)
	texture:SetTexture("Interface\\Icons\\INV_Pet_Broom") -- HD version
	texture:SetTexCoord(unpack(C.TexCoord))
end

local backpackTexture = "Interface\\Buttons\\Button-Backpack-Up"
local bagIDToInvID = {
	[1] = 20,
	[2] = 21,
	[3] = 22,
	[4] = 23,
	[5] = 80,
	[6] = 81,
	[7] = 82,
	[8] = 83,
	[9] = 84,
	[10] = 85,
	[11] = 86,
}

local function createBagIcon(frame, index)
	if not frame.bagIcon then
		frame.bagIcon = frame.PortraitButton:CreateTexture()
		F.ReskinIcon(frame.bagIcon)
		frame.bagIcon:SetPoint("TOPLEFT", 5, -3)
		frame.bagIcon:SetSize(32, 32)
	end
	if index == 1 then
		frame.bagIcon:SetTexture(backpackTexture) -- backpack
	end
end

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	BackpackTokenFrame:GetRegions():Hide()

	for i = 1, 12 do
		local con = _G["ContainerFrame"..i]
		local name = _G["ContainerFrame"..i.."Name"]

		F.StripTextures(con, true)
		con.PortraitButton.Highlight:SetTexture("")
		createBagIcon(con, i)

		name:ClearAllPoints()
		name:SetPoint("TOP", 0, -10)

		for k = 1, MAX_CONTAINER_ITEMS do
			local item = "ContainerFrame"..i.."Item"..k
			local button = _G[item]
			local questTexture = _G[item.."IconQuestTexture"]

			questTexture:SetDrawLayer("BACKGROUND")
			questTexture:SetSize(1, 1)

			button:SetNormalTexture("")
			button:SetPushedTexture("")
			button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

			button.icon:SetTexCoord(unpack(C.TexCoord))
			button.bg = F.CreateBDFrame(button.icon, .25)

			button.searchOverlay:SetOutside()
			F.ReskinIconBorder(button.IconBorder)
		end

		local f = F.SetBD(con)
		f:SetPoint("TOPLEFT", 8, -4)
		f:SetPoint("BOTTOMRIGHT", -4, 3)

		F.ReskinClose(_G["ContainerFrame"..i.."CloseButton"])
	end

	for i = 1, 3 do
		local ic = _G["BackpackTokenFrameToken"..i.."Icon"]
		F.ReskinIcon(ic)
	end

	F.ReskinInput(BagItemSearchBox)

	hooksecurefunc("ContainerFrame_Update", function(frame)
		local id = frame:GetID()
		local name = frame:GetName()

		if id == 0 then
			BagItemSearchBox:ClearAllPoints()
			BagItemSearchBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 50, -35)
			BagItemAutoSortButton:ClearAllPoints()
			BagItemAutoSortButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -9, -31)
		end

		for i = 1, frame.size do
			local itemButton = _G[name.."Item"..i]

			if _G[name.."Item"..i.."IconQuestTexture"]:IsShown() then
				itemButton.IconBorder:SetVertexColor(1, 1, 0)
			end
		end

		if frame.bagIcon then
			local invID = bagIDToInvID[id]
			if invID then
				local icon = GetInventoryItemTexture("player", invID)
				frame.bagIcon:SetTexture(icon or backpackTexture)
			end
		end
	end)

	replaceSortTexture(BagItemAutoSortButton:GetNormalTexture())
	replaceSortTexture(BagItemAutoSortButton:GetPushedTexture())
	F.CreateBDFrame(BagItemAutoSortButton)

	local highlight = BagItemAutoSortButton:GetHighlightTexture()
	highlight:SetColorTexture(1, 1, 1, .25)
	highlight:SetAllPoints(BagItemAutoSortButton)
end)