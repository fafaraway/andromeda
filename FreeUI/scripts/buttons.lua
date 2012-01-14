-- rActionButtonStyler by Roth, modified.

local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

local function applyBackground(bu)
	if bu:GetFrameLevel() < 1 then bu:SetFrameLevel(1) end

	bu.bg = CreateFrame("Frame", nil, bu)
	bu.bg:SetAllPoints(bu)
	bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)

	bu.bg:SetBackdrop({
		edgeFile = C.media.backdrop,
		edgeSize = 1,
	})
	bu.bg:SetBackdropBorderColor(0, 0, 0)
end

local function stylebars(self)
	if self.styled then return end

	local name = self:GetName()
	local bu  = _G[name]
	local bo  = _G[name.."Border"]
	local ic  = _G[name.."Icon"]
	local co  = _G[name.."Count"]
	local ho  = _G[name.."HotKey"]
	local nt  = _G[name.."NormalTexture"]
	local na  = _G[name.."Name"]
	local fl  = _G[name.."FloatingBG"]

	if not nt and not name:match("SpellFlyoutButton") and not name:match("ExtraActionButton") then
		self.styled = true
		return
	end

	if bo then
		bo:SetTexture(nil)
	end

	co:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	co:ClearAllPoints()
	co:SetPoint("TOP", 1, -2)
	co:SetDrawLayer("OVERLAY")

	if C.general.hotkey == true then
		ho:ClearAllPoints()
		ho:SetPoint("BOTTOM", 0, 1)
		ho:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
		ho:SetDrawLayer("OVERLAY")
	else
		ho:Hide()
	end

	if na then na:Hide() end

	bu:SetNormalTexture("")
	bu:SetPushedTexture("")
	bu:SetHighlightTexture("")
	bu:SetCheckedTexture(C.media.backdrop)

	local ch = bu:GetCheckedTexture()
	ch:SetVertexColor(r, g, b)
	ch:SetDrawLayer("ARTWORK")
	ch:SetAllPoints(bu)

	ic:SetTexCoord(.08, .92, .08, .92)
	ic:SetDrawLayer("OVERLAY")
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)

	if fl then
		fl:Hide()
	end

	applyBackground(bu)

	self.styled = true
end

local function updateHotkey(self, actionButtonType)
	local ho = _G[self:GetName() .. "HotKey"]
	if C.general.hotkey == false then
		ho:Hide()
	end
end

hooksecurefunc("ActionButton_UpdateHotkeys", updateHotkey)

local function fixpet(bu, texture)
	if texture ~= "" then
		bu:SetNormalTexture("")
	end
end

local function stylepet()
	for i = 1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local bu  = _G[name]

		if bu.styled then return end

		local ic  = _G[name.."Icon"]
		local nt  = _G[name.."NormalTexture2"]

		nt:SetHeight(bu:GetHeight())
		nt:SetWidth(bu:GetWidth())
		nt:SetPoint("Center", 0, 0)

		bu:SetNormalTexture("")
		bu:SetCheckedTexture(C.media.checked)
		bu:SetPushedTexture("")

		ic:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
		ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)

		hooksecurefunc(bu, "SetNormalTexture", fixpet)

		bu.styled = true
	end  
end

for i=1, NUM_PET_ACTION_SLOTS do
	local name = "PetActionButton"..i
	local bu  = _G[name]

	_G[name.."AutoCastable"]:SetAlpha(0)
	_G[name.."Icon"]:SetDrawLayer("OVERLAY")

	applyBackground(bu)
end

hooksecurefunc("ActionButton_Update", stylebars)
hooksecurefunc("PetActionBar_Update", stylepet)

local buttons = 0
local function flyoutbutton()
	for i = 1, buttons do
		local bu = _G["SpellFlyoutButton"..i]
		if bu and not bu.styled then
			stylebars(bu)

			if bu:GetChecked() then
				bu:SetChecked(nil)
			end
			bu.styled = true
		end
	end
end

SpellFlyout:HookScript("OnShow", flyoutbutton)

local function styleflyout(self)
	if not self.reskinned then
		if not self.FlyoutArrow then return end
		self.FlyoutBorder:SetAlpha(0)
		self.FlyoutBorderShadow:SetAlpha(0)

		SpellFlyoutHorizontalBackground:SetAlpha(0)
		SpellFlyoutVerticalBackground:SetAlpha(0)
		SpellFlyoutBackgroundEnd:SetAlpha(0)

		self.reskinned = true
	end

	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end
end

hooksecurefunc("ActionButton_UpdateFlyout", styleflyout)

if C.general.shapeshift == true then
	local bu, ic

	local function styleshift()
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			bu  = _G["ShapeshiftButton"..i]

			if bu:IsShown() and not bu.reskinned then
				ic  = _G["ShapeshiftButton"..i.."Icon"]

				bu:SetNormalTexture("")
				bu:SetPushedTexture("")
				bu:SetCheckedTexture(C.media.checked)

				F.CreateBG(bu)

				ic:SetDrawLayer("ARTWORK")
				ic:SetTexCoord(0.08, 0.92, 0.08, 0.92)

				bu.reskinned = true
			end
		end
	end

	hooksecurefunc("ShapeshiftBar_Update", styleshift)
	hooksecurefunc("ShapeshiftBar_UpdateState", styleshift)
end