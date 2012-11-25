-- Originally based on aBags by Alza.

local F, C, L = unpack(select(2, ...))
local _G = _G

--[[ Get the number of bag and bank container slots used ]]

local function CheckSlots()
	for i = 4, 1, -1 do
		if GetContainerNumSlots(i) ~= 0 then
			return i + 1
		end
	end
	return 1
end

-- [[ Function to reskin buttons and hide default bags]]

local ReskinButton = function(buName)
	local bu = _G[buName]

	bu:SetSize(C.general.bags_size, C.general.bags_size)

	if bu.reskinned then return end

	local co = _G[buName.."Count"]

	bu:SetNormalTexture("")
	bu:SetPushedTexture("")
	bu:SetFrameStrata("HIGH")

	co:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	co:ClearAllPoints()
	co:SetPoint("TOP", bu, 1, -2)

	_G[buName.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
	_G[buName.."IconQuestTexture"]:SetAlpha(0)

	bu.reskinned = true
end

local HideBag = function(bagName)
	local bag = _G[bagName]

	if bag.reskinned then return end

	bag:EnableMouse(false)
	_G[bagName.."CloseButton"]:Hide()
	_G[bagName.."PortraitButton"]:EnableMouse(false)
	for i = 1, 7 do
		select(i, bag:GetRegions()):SetAlpha(0)
	end

	bag.reskinned = true
end

-- [[ Local stuff ]]

local Spacing = 4
local bu, con, bag, col, row
local buttons, bankbuttons = {}, {}

--[[ Function to move buttons ]]

local MoveButtons = function(table, frame)
	local columns = ceil(sqrt(#table))
	local iconSize = C.general.bags_size

	col, row = 0, 0
	for i = 1, #table do
		bu = _G[table[i]]
		bu:ClearAllPoints()
		bu:SetPoint("TOPLEFT", frame, "TOPLEFT", col * (iconSize + Spacing) + 3, -1 * row * (iconSize + Spacing) - 3)
		if(col > (columns - 2)) then
			col = 0
			row = row + 1
		else
			col = col + 1
		end
	end

	frame:SetHeight((row + (col==0 and 0 or 1)) * (iconSize + Spacing) + 19)
	frame:SetWidth(columns * iconSize + Spacing * (columns - 1) + 6)
	col, row = 0, 0
end

--[[ Bags ]]

local holder = CreateFrame("Button", "BagsHolder", UIParent)
holder:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -49, 49)
holder:SetFrameStrata("HIGH")
holder:Hide()
F.CreateBD(holder, .6)

local ReanchorButtons = function()
	table.wipe(buttons)
	for f = 1, CheckSlots() do
		con = "ContainerFrame"..f
		HideBag(con)

		for i = GetContainerNumSlots(f-1), 1, -1  do
			bu = con.."Item"..i
			ReskinButton(bu)
			tinsert(buttons, bu)
		end
	end

	MoveButtons(buttons, holder)
	holder:Show()
end

local money = _G["ContainerFrame1MoneyFrame"]
money:SetFrameStrata("DIALOG")
money:SetParent(holder)
money:ClearAllPoints()
money:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", 12, 2)

--[[ Bank ]]

local bankholder = CreateFrame("Button", "BagsBankHolder", UIParent)
bankholder:SetPoint("BOTTOMRIGHT", "BagsHolder", "BOTTOMLEFT", -10 , 0)
bankholder:SetFrameStrata("HIGH")
bankholder:Hide()
F.CreateBD(bankholder, .6)

local purchase = F.CreateFS(bankholder, 8)
purchase:SetPoint("BOTTOMLEFT", bankholder, "BOTTOMLEFT", 4, 4)
purchase:SetText("Buy slots: /freeui purchase")

local ReanchorBankButtons = function()
	table.wipe(bankbuttons)
	for i = 1, 28 do
		bu = "BankFrameItem"..i
		ReskinButton(bu)
		tinsert(bankbuttons, bu)
	end

	for f = CheckSlots() + 1, CheckSlots() + GetNumBankSlots() + 1, 1 do
		con = "ContainerFrame"..f

		HideBag(con)
		_G[con]:SetScale(1)

		for i = GetContainerNumSlots(f-1), 1, -1  do
			bu = con.."Item"..i
			ReskinButton(bu)
			tinsert(bankbuttons, bu)
		end
	end
	local _, full = GetNumBankSlots()
	if full then purchase:Hide() end

	MoveButtons(bankbuttons, bankholder)
	bankholder:Show()
end

local money = _G["BankFrameMoneyFrame"]
money:SetFrameStrata("DIALOG")
money:ClearAllPoints()
money:SetPoint("BOTTOMRIGHT", bankholder, "BOTTOMRIGHT", 12, 2)

--[[ Misc. frames ]]

BankFramePurchaseInfo:Hide()
BankFramePurchaseInfo.Show = F.dummy
BankFrame:EnableMouse(false)
BankFrameCloseButton:Hide()
BankFrame:DisableDrawLayer("BACKGROUND")
BankFrame:DisableDrawLayer("BORDER")
BankFrame:DisableDrawLayer("OVERLAY")
BankPortraitTexture:Hide()
BankFrameMoneyFrameInset:Hide()
BankFrameMoneyFrameBorder:Hide()

local bankbagholder = CreateFrame("Frame", nil, BankFrame)
bankbagholder:SetSize(289, 43)
bankbagholder:SetPoint("BOTTOM", bankholder, "TOP", 0, -1)
F.CreateBD(bankbagholder, .6)
bankbagholder:SetAlpha(0)

local bagholder = CreateFrame("Frame", nil, ContainerFrame1)
bagholder:SetSize(130, 35)
bagholder:SetPoint("BOTTOM", holder, "TOP", 0, -1)

local showBags = function()
	for i = 0, 3 do
		_G["CharacterBag"..i.."Slot"]:SetAlpha(1)
	end
end

local hideBags = function()
	for i = 0, 3 do
		_G["CharacterBag"..i.."Slot"]:SetAlpha(0)
	end
end

local bankBagAlpha = 0

local setBankBagAlpha = function()
	bankBagAlpha = 1 - bankBagAlpha

	bankbagholder:SetAlpha(bankBagAlpha)
	for i = 1, 7 do
		_G["BankFrameBag"..i]:SetAlpha(bankBagAlpha)
	end
end

bagholder:SetScript("OnEnter", showBags)
bagholder:SetScript("OnLeave", hideBags)
bankbagholder:SetScript("OnEnter", setBankBagAlpha)
bankbagholder:SetScript("OnLeave", setBankBagAlpha)

for i = 0, 3 do
	local bag = _G["CharacterBag"..i.."Slot"]
	local ic = _G["CharacterBag"..i.."SlotIconTexture"]

	bag:SetParent(holder)
	bag:ClearAllPoints()

	if i == 0 then
		bag:SetPoint("BOTTOM", holder, "TOP", -46, 1)
	else
		bag:SetPoint("LEFT", _G["CharacterBag"..(i-1).."Slot"], "RIGHT", 1, 0)
	end

	bag:SetNormalTexture("")
	bag:SetCheckedTexture("")
	bag:SetPushedTexture("")

	ic:SetTexCoord(.08, .92, .08, .92)
	ic:SetPoint("TOPLEFT", 1, -1)
	ic:SetPoint("BOTTOMRIGHT", -1, 1)
	F.CreateBD(bag)

	bag:SetAlpha(0)
	bag:HookScript("OnEnter", showBags)
	bag:HookScript("OnLeave", hideBags)
end

for i = 1, 7 do
	local bag = _G["BankFrameBag"..i]
	local ic = _G["BankFrameBag"..i.."IconTexture"]
	_G["BankFrameBag"..i.."HighlightFrame"]:Hide()

	bag:SetParent(bankholder)
	bag:ClearAllPoints()

	if i == 1 then
		bag:SetPoint("BOTTOM", bankholder, "TOP", -123, 2)
	else
		bag:SetPoint("LEFT", _G["BankFrameBag"..i-1], "RIGHT", 4, 0)
	end

	bag:SetNormalTexture("")
	bag:SetPushedTexture("")

	ic:SetTexCoord(.08, .92, .08, .92)

	bag:SetAlpha(0)
	bag:HookScript("OnEnter", setBankBagAlpha)
	bag:HookScript("OnLeave", setBankBagAlpha)
end

local moneytext = {"ContainerFrame1MoneyFrameGoldButtonText", "ContainerFrame1MoneyFrameSilverButtonText", "ContainerFrame1MoneyFrameCopperButtonText", "BankFrameMoneyFrameGoldButtonText", "BankFrameMoneyFrameSilverButtonText", "BankFrameMoneyFrameCopperButtonText", "BackpackTokenFrameToken1Count", "BackpackTokenFrameToken2Count", "BackpackTokenFrameToken3Count"}

for i = 1, 9 do
	_G[moneytext[i]]:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
end

--[[ Show & Hide functions etc ]]

local CloseBags = function()
	bankholder:Hide()
	holder:Hide()
	for i = 0, 11 do
		CloseBag(i)
	end
end

local CloseBags2 = function()
	bankholder:Hide()
	holder:Hide()
	CloseBankFrame()
end

local OpenBags = function()
	for i = 0, 11 do
		OpenBag(i)
	end
end

local ToggleBags = function()
	if(IsBagOpen(0)) then
		CloseBankFrame()
		CloseBags()
	else
		OpenBags()
	end
end

for i = 1, 5 do
	local bag = _G["ContainerFrame"..i]
	hooksecurefunc(bag, "Show", ReanchorButtons)
	hooksecurefunc(bag, "Hide", CloseBags2)
	bag.SetScale = F.dummy
end
hooksecurefunc(BankFrame, "Show", function()
	OpenBags()
	ReanchorBankButtons()
end)
hooksecurefunc(BankFrame, "Hide", CloseBags)

ToggleBackpack = ToggleBags
ToggleBag = ToggleBags
OpenAllBags = OpenBags
OpenBackpack = OpenBags
CloseAllBags = CloseBags

-- [[ Currency ]]

BackpackTokenFrame:GetRegions():Hide()
BackpackTokenFrameToken1:ClearAllPoints()
BackpackTokenFrameToken1:SetPoint("BOTTOMLEFT", holder, "BOTTOMLEFT", 0, 2)
for i = 1, 3 do
	local bu = _G["BackpackTokenFrameToken"..i]
	local ic = _G["BackpackTokenFrameToken"..i.."Icon"]
	_G["BackpackTokenFrameToken"..i.."Count"]:SetShadowOffset(0, 0)

	bu:SetFrameStrata("DIALOG")
	ic:SetDrawLayer("OVERLAY")
	ic:SetTexCoord(.08, .92, .08, .92)

	F.CreateBG(ic)
end

-- [[ Search ]]

BankItemSearchBox:Hide()
BankItemSearchBox.Show = F.dummy

BagItemSearchBoxLeft:Hide()
BagItemSearchBoxMiddle:Hide()
BagItemSearchBoxRight:Hide()

BagItemSearchBox:SetHeight(18)
BagItemSearchBox:ClearAllPoints()
BagItemSearchBox:SetPoint("TOPLEFT", holder, "BOTTOMLEFT", 0, 1)
BagItemSearchBox:SetPoint("TOPRIGHT", holder, "BOTTOMRIGHT", 0, 1)
BagItemSearchBox.SetPoint = F.dummy
BagItemSearchBox:SetWidth(holder:GetWidth())
BagItemSearchBox:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
BagItemSearchBox:SetShadowColor(0, 0, 0, 0)
BagItemSearchBox:SetJustifyH("CENTER")
BagItemSearchBox:SetAlpha(0)
F.CreateBD(BagItemSearchBox, .6)

BagItemSearchBoxSearchIcon:SetPoint("LEFT", BagItemSearchBox, "LEFT", 4, -2)

local HideSearch = function()
	BagItemSearchBox:SetAlpha(0)
end

BagItemSearchBox:HookScript("OnEditFocusGained", function(self)
	self:SetScript("OnLeave", nil)
	self:SetTextColor(1, 1, 1)
	BagItemSearchBoxSearchIcon:SetVertexColor(1, 1, 1)
end)

BagItemSearchBox:HookScript("OnEditFocusLost", function(self)
	self:SetScript("OnLeave", HideSearch)
	self.clearButton:Click()
	HideSearch()
	self:SetText(SEARCH)
	self:SetTextColor(.5, .5, .5)
	BagItemSearchBoxSearchIcon:SetVertexColor(.6, .6, .6)
end)

BagItemSearchBox:HookScript("OnEnter", function(self)
	self:SetAlpha(1)
end)
BagItemSearchBox:HookScript("OnLeave", HideSearch)

local function updateFilter(frame)
	local id = frame:GetID();
	local name = frame:GetName().."Item";
	local itemButton;
	local _, isFiltered;

	for i=1, frame.size, 1 do
		itemButton = _G[name..i];
		_, _, _, _, _, _, _, isFiltered = GetContainerItemInfo(id, itemButton:GetID());
		if itemButton.glow then
			if ( isFiltered ) then
				itemButton.glow:SetAlpha(0);
			else
				itemButton.glow:SetAlpha(1);
			end
		end
	end
end

hooksecurefunc("ContainerFrame_UpdateSearchResults", updateFilter)
hooksecurefunc("ContainerFrame_Update", updateFilter)

-- [[ Money ]]

local function Format(money)
	return format("%s\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t", BreakUpLargeNumbers(floor((money / 10000) + .5)))
end

local name = UnitName("player")
local realm = GetRealmName()
local r, g, b = unpack(C.class)
local keys = {}
local tableFilled = false

local function ShowMoney()
	GameTooltip:SetOwner(ContainerFrame1MoneyFrameGoldButton, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMRIGHT", BagsHolder, "BOTTOMLEFT", -1, 0)

	local total = 0
	local goldlist = FreeUIGlobalConfig[realm].gold

	for k, v in pairs(goldlist) do
		total = total + v
	end

	-- create a sorted table of goldlist where keys are index numbers and values are goldlist keys
	-- only way to properly sort key-value tables
	if not tableFilled then
		for n in pairs(goldlist) do
			table.insert(keys, n)
		end
		table.sort(keys)
		tableFilled = true
	end

	GameTooltip:AddDoubleLine(realm, Format(total), r, g, b, 1, 1, 1)
	GameTooltip:AddLine(" ")
	for _, k in pairs(keys) do
		local class = FreeUIGlobalConfig[realm].class[k]
		local v = goldlist[k]
		if v and v >= 10000 then
			GameTooltip:AddDoubleLine(k, Format(v), C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b, 1, 1, 1)
		end
	end

	GameTooltip:Show()
end

ContainerFrame1MoneyFrameGoldButton:HookScript("OnEnter", ShowMoney)
ContainerFrame1MoneyFrameSilverButton:HookScript("OnEnter", ShowMoney)
ContainerFrame1MoneyFrameCopperButton:HookScript("OnEnter", ShowMoney)
ContainerFrame1MoneyFrameGoldButton:HookScript("OnLeave", GameTooltip_Hide)
ContainerFrame1MoneyFrameSilverButton:HookScript("OnLeave", GameTooltip_Hide)
ContainerFrame1MoneyFrameCopperButton:HookScript("OnLeave", GameTooltip_Hide)