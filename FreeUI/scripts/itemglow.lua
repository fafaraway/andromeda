-- Based on oGlow by Haste

local F, C, L = unpack(select(2, ...))

local function UpdateGlow(button, id)
	local quality, texture, _
	local quest = _G[button:GetName().."IconQuestTexture"]
	if(id) then
		quality, _, _, _, _, _, _, texture = select(3, GetItemInfo(id))
	end

	local glow = button.glow
	if(not glow) then
		button.glow = glow
		glow = button:CreateTexture(nil, "BACKGROUND")
		glow:SetPoint("TOPLEFT", -1, 1)
		glow:SetPoint("BOTTOMRIGHT", 1, -1)
		glow:SetTexture(C.media.backdrop)
		button.glow = glow
	end

	if texture then
		local r, g, b
		if quest and quest:IsShown() then
			r, g, b = 1, 0, 0
		else
			r, g, b = GetItemQualityColor(quality)
			if (r == 1 and g == 1) then r, g, b = 0, 0, 0 end
		end
		glow:SetVertexColor(r, g, b)
		glow:Show()
	else
		glow:Hide()
	end
end

-- Bags and Bank

hooksecurefunc("ContainerFrame_Update", function(self)
	local name = self:GetName()
	local id = self:GetID()

	for i=1, self.size do
		local button = _G[name.."Item"..i]
		local itemID = GetContainerItemID(id, button:GetID())
		UpdateGlow(button, itemID)
	end
end)

hooksecurefunc("BankFrameItemButton_Update", function(self)
	UpdateGlow(self, GetInventoryItemID("player", self:GetInventorySlot()))
end)

-- Item slots for Character/Inspect Frame

local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", "Tabard",
}

-- Character Frame

local updatechar = function(self)
	if CharacterFrame:IsShown() then
		for i, slotName in ipairs(slots) do
			-- Ammo is located at 0.
			if i == 18 then i = 19 end
			local slotFrame = _G['Character' .. slotName .. 'Slot']
			local slotLink = GetInventoryItemLink('player', i)

			UpdateGlow(slotFrame, slotLink)
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:SetScript("OnEvent", updatechar)
CharacterFrame:HookScript('OnShow', updatechar)

-- Inspect Frame

local missing = {}

local pollFrame = CreateFrame("Frame")
pollFrame:Hide()
pollFrame:SetScript("OnUpdate", function(self, elapsed)
	local unit = InspectFrame.unit
	if not unit then
		self:Hide()
		table.wipe(missing)
	end

	for i, slotName in next, missing do
		local slotLink = GetInventoryItemLink(unit, i)
		if slotLink then
			local slotFrame = _G["Inspect"..slotName.."Slot"]
			UpdateGlow(slotFrame, slotLink)
			slotFrame:Show()
			missing[i] = nil
		end
	end

	if not next(missing) then
		self:Hide()
	end
end)

local updateInspect = function()
	if not InspectFrame or not InspectFrame:IsShown() then return end

	local unit = InspectFrame.unit

	for i, slotName in ipairs(slots) do
		if i == 18 then i = 19 end

		local slotFrame = _G["Inspect"..slotName.."Slot"]
		local slotLink = GetInventoryItemLink(unit, i)
		local slotTexture = GetInventoryItemTexture(unit, i)

		if slotTexture and not slotLink then
			missing[i] = slotName
			pollFrame:Show()
		elseif slotLink then
			slotFrame:Show()
		else
			slotFrame:Hide()
			pollFrame:Show()
		end
		UpdateGlow(slotFrame, slotLink)
	end
end

local g = CreateFrame("Frame")
g:RegisterEvent("ADDON_LOADED")
g:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		if ... ~= "Blizzard_InspectUI" then return end

		g:RegisterEvent("INSPECT_READY")
		g:RegisterEvent("UNIT_INVENTORY_CHANGED")

		self:UnregisterEvent("ADDON_LOADED")
	elseif event == "INSPECT_READY" then
		updateInspect()
	else
		if InspectFrame.unit == ... then
			updateInspect()
		end
	end
end)

-- Guild Bank Frame

local h = CreateFrame("Frame")
h:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED")
h:RegisterEvent("GUILDBANKFRAME_OPENED")
h:SetScript("OnEvent", function()
	if not IsAddOnLoaded("Blizzard_GuildBankUI") then return end

	local tab = GetCurrentGuildBankTab()
	for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
		local index = math.fmod(i, 14)
		if index == 0 then
			index = 14
		end
		local column = math.ceil((i-0.5)/14)

		local slotLink = GetGuildBankItemLink(tab, i)
		local slotFrame = _G["GuildBankColumn"..column.."Button"..index]

		UpdateGlow(slotFrame, slotLink)
	end
end)

-- Void Storage Frame

local void = CreateFrame("Frame")
void:RegisterEvent("ADDON_LOADED")
void:RegisterEvent("VOID_STORAGE_CONTENTS_UPDATE")
void:RegisterEvent("VOID_STORAGE_DEPOSIT_UPDATE")
void:RegisterEvent("VOID_TRANSFER_DONE")
void:RegisterEvent("VOID_STORAGE_OPEN")

local updateContents = function(self)
	if not IsAddOnLoaded("Blizzard_VoidStorageUI") then return end

	for slot = 1, VOID_WITHDRAW_MAX or 80 do
		local slotFrame =  _G["VoidStorageStorageButton"..slot]
		UpdateGlow(slotFrame, GetVoidItemInfo(slot))
	end

	for slot = 1, VOID_WITHDRAW_MAX or 9 do
		local slotFrame = _G["VoidStorageWithdrawButton"..slot]
		UpdateGlow(slotFrame, GetVoidTransferWithdrawalInfo(slot))
	end
end

local updateDeposit = function(self, event, slot)
	if not IsAddOnLoaded("Blizzard_VoidStorageUI") then return end

	local slotFrame = _G["VoidStorageDepositButton"..slot]
	UpdateGlow(slotFrame, GetVoidTransferDepositInfo(slot))
end

local update = function(self)
	if not IsAddOnLoaded("Blizzard_VoidStorageUI") then return end

	for slot = 1, VOID_DEPOSIT_MAX or 9 do
		updateDeposit(self, nil, slot)
	end

	return updateContents(self)
end

void:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		if ... == "Blizzard_VoidStorageUI" then
			self:UnregisterEvent("ADDON_LOADED")
			local last = 0
			self:SetScript("OnUpdate", function(self, elapsed)
				last = last + elapsed
				if last > 1 then
					self:SetScript("OnUpdate", nil)
					update(self)
				end
			end)
		end
	elseif event == "VOID_STORAGE_CONTENTS_UPDATE" then
		updateContents(self)
	elseif event == "VOID_STORAGE_DEPOSIT_UPDATE" then
		updateDeposit(self, event, ...)
	elseif event == "VOID_TRANSFER_DONE" or event == "VOID_STORAGE_OPEN" then
		update(self)
	end
end)