local F, C = unpack(select(2, ...))

if not C.misc.alreadyKnown then return end

-- Colorizes recipes/mounts/pets/toys that is already known
-- Already Known by ahak

local knownTable = {}
local db
local questItems = { -- Quest items and matching quests
	-- Equipment Blueprint: Tuskarr Fishing Net
	[128491] = 39359, -- Alliance
	[128251] = 39359, -- Horde
	-- Equipment Blueprint: Unsinkable
	[128250] = 39358, -- Alliance
	[128489] = 39358, -- Horde
}
local specialItems = { -- Items needing special treatment
	-- Krokul Flute -> Flight Master's Whistle
	[152964] = { 141605, 11, 269 } -- 269 for Flute applied Whistle, 257 (or anything else than 269) for pre-apply Whistle
}


local S_PET_KNOWN = strmatch(_G.ITEM_PET_KNOWN, "[^%(]+")

local scantip = CreateFrame("GameTooltip", "AKScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

local function _checkIfKnown(itemLink)
	if knownTable[itemLink] then
		return true
	end
	local itemID = tonumber(itemLink:match("item:(%d+)"))
	if itemID and questItems[itemID] then
		if IsQuestFlaggedCompleted(questItems[itemID]) then
			knownTable[itemLink] = true
			return true
		end
		return false
	elseif itemID and specialItems[itemID] then
		local specialData = specialItems[itemID]
		local _, specialLink = GetItemInfo(specialData[1])
		if specialLink then
			local specialTbl = { strsplit(":", specialLink) }
			local specialInfo = tonumber(specialTbl[specialData[2]])
			if specialInfo == specialData[3] then
				knownTable[itemLink] = true
				return true
			end
		end
		return false
	end

	if itemLink:match("|H(.-):") == "battlepet" then
		local _, battlepetID = strsplit(":", itemLink)
		if C_PetJournal.GetNumCollectedInfo(battlepetID) > 0 then
			knownTable[itemLink] = true
			return true
		end
		return false
	end

	scantip:ClearLines()
	scantip:SetHyperlink(itemLink)

	local lines = scantip:NumLines()
	for i = 2, lines do
		local text = _G["AKScanningTooltipTextLeft"..i]:GetText()
		if text == _G.ITEM_SPELL_KNOWN or strmatch(text, S_PET_KNOWN) then
			if lines - i <= 3 then
				knownTable[itemLink] = true
			end
		elseif text == _G.TOY and _G["AKScanningTooltipTextLeft"..i + 2] and _G["AKScanningTooltipTextLeft"..i + 2]:GetText() == _G.ITEM_SPELL_KNOWN then
			knownTable[itemLink] = true
		end
	end
	
	return knownTable[itemLink] and true or false
end

local function _hookAH()
	local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

	for i=1, _G.NUM_BROWSE_TO_DISPLAY do
		if (_G["BrowseButton"..i.."Item"] and _G["BrowseButton"..i.."ItemIconTexture"]) or _G["BrowseButton"..i].id then -- Something to do with ARL?
			local itemLink
			if _G["BrowseButton"..i].id then
				itemLink = GetAuctionItemLink('list', _G["BrowseButton"..i].id)
			else
				itemLink = GetAuctionItemLink('list', offset + i)
			end

			if itemLink and _checkIfKnown(itemLink) then
				if _G["BrowseButton"..i].id then
					_G["BrowseButton"..i].Icon:SetVertexColor(.1, 1, .1)
				else
					_G["BrowseButton"..i.."ItemIconTexture"]:SetVertexColor(.1, 1, .1)
				end
			else
				if _G["BrowseButton"..i].id then
					_G["BrowseButton"..i].Icon:SetVertexColor(1, 1, 1)
					_G["BrowseButton"..i].Icon:SetDesaturated(false)
				else
					_G["BrowseButton"..i.."ItemIconTexture"]:SetVertexColor(1, 1, 1)
					_G["BrowseButton"..i.."ItemIconTexture"]:SetDesaturated(false)
				end
			end
		end
	end
end

local function _hookMerchant()
	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local index = (((MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE) + i)
		local itemButton = _G["MerchantItem"..i.."ItemButton"]
		local merchantButton = _G["MerchantItem"..i]
		local itemLink = GetMerchantItemLink(index)

		local r, g, b = .1, 1, .1
		if itemLink and _checkIfKnown(itemLink) then
			SetItemButtonNameFrameVertexColor(merchantButton, r, g, b)
			SetItemButtonSlotVertexColor(merchantButton, r, g, b)
			SetItemButtonTextureVertexColor(itemButton, .8*r, .8*g, .8*b)
			SetItemButtonNormalTextureVertexColor(itemButton, .8*r, .8*g, .8*b)
		else
			_G["MerchantItem"..i.."ItemButtonIconTexture"]:SetDesaturated(false)
		end
	end
end


hooksecurefunc("MerchantFrame_UpdateMerchantInfo", _hookMerchant)

if IsAddOnLoaded("Blizzard_AuctionUI") then
	hooksecurefunc("AuctionFrameBrowse_Update", _hookAH)
else
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" and (...) == "Blizzard_AuctionUI" then
			self:UnregisterEvent(event)
			hooksecurefunc("AuctionFrameBrowse_Update", _hookAH)
		end
	end)
end


