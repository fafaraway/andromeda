-- rActionButtonStyler by Roth, modified.

local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

local _G = _G

local function applyBackground(bu)
	if bu:GetFrameLevel() < 1 then bu:SetFrameLevel(1) end

	bu.bg = CreateFrame("Frame", nil, bu)
	bu.bg:SetAllPoints(bu)
	bu.bg:SetFrameLevel(0)

	bu.bg:SetBackdrop({
		edgeFile = C.media.backdrop,
		edgeSize = 1,
	})
	bu.bg:SetBackdropBorderColor(0, 0, 0)
end

local function styleExtraActionButton(bu)
	if not bu or (bu and bu.styled) then return end

	bu.style:SetTexture(nil)

	hooksecurefunc(bu.style, "SetTexture", function(self, texture)
		if texture and string.sub(texture, 1, 9) == "Interface" then
			self:SetTexture(nil)
		end
	end)

	bu:SetPushedTexture("")

	bu.icon:SetTexCoord(.08, .92, .08, .92)
	bu.icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	bu.icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)

	bu.cooldown:SetAllPoints()

	if not bu.bg then applyBackground(bu) end

	bu.styled = true
end

local function styleActionButton(bu)
	if not bu or (bu and bu.styled) then return end

	local name = bu:GetName()
	local bo  = _G[name.."Border"]
	local ic  = _G[name.."Icon"]
	local co  = _G[name.."Count"]
	local ho  = _G[name.."HotKey"]
	local nt  = _G[name.."NormalTexture"]
	local na  = _G[name.."Name"]
	local fl  = _G[name.."FloatingBG"]

	na:Hide()

	bo:SetTexture(nil)

	co:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	co:ClearAllPoints()
	co:SetPoint("TOP", 1, -2)
	co:SetDrawLayer("OVERLAY")

	if C.general.hotkey == true then
		ho:SetAllPoints()
		ho:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
		ho:SetJustifyH("CENTER")
		ho:SetDrawLayer("OVERLAY")
	else
		ho:Hide()
	end

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

	if not bu.bg then applyBackground(bu) end

	bu.styled = true
end

local function stylePetButton(bu)
	if not bu or (bu and bu.styled) then return end

	local name = bu:GetName()
	local ic  = _G[name.."Icon"]
	
	_G[name.."NormalTexture2"]:SetAllPoints(bu)
	_G[name.."AutoCastable"]:SetAlpha(0)

	bu:SetNormalTexture("")
	bu:SetCheckedTexture(C.media.checked)
	bu:SetPushedTexture("")

	hooksecurefunc(bu, "SetNormalTexture", function(self, texture)
		if texture and texture ~= "" then
			self:SetNormalTexture("")
		end
	end)

	ic:SetTexCoord(.08, .92, .08, .92)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)
	ic:SetDrawLayer("OVERLAY")

	if not bu.bg then applyBackground(bu) end

	bu.styled = true
end

if C.general.shapeshift == true then
	local ic

	local function styleShapeShiftButton(bu)
		if not bu or (bu and bu.styled) then return end

		ic  = _G[bu:GetName().."Icon"]

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:SetCheckedTexture(C.media.checked)

		F.CreateBG(bu)

		ic:SetDrawLayer("ARTWORK")
		ic:SetTexCoord(0.08, 0.92, 0.08, 0.92)

		bu.styled = true
	end
end

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

local function updateHotkey(self, actionButtonType)
	local ho = _G[self:GetName() .. "HotKey"]
	if ho and C.general.hotkey == false then
		ho:Hide()
	end
end


local function init()
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		styleActionButton(_G["ActionButton"..i])
		styleActionButton(_G["VehicleMenuBarActionButton"..i])
		styleActionButton(_G["BonusActionButton"..i])
		styleActionButton(_G["MultiBarBottomLeftButton"..i])
		styleActionButton(_G["MultiBarBottomRightButton"..i])
		styleActionButton(_G["MultiBarRightButton"..i])
		styleActionButton(_G["MultiBarLeftButton"..i])
	end

	for i = 1, NUM_PET_ACTION_SLOTS do
		stylePetButton(_G["PetActionButton"..i])
	end

	if C.general.shapeshift == true then
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			styleShapeShiftButton(_G["ShapeshiftButton"..i])
		end
	end

	styleExtraActionButton(_G["ExtraActionButton1"])

	hooksecurefunc("ActionButton_UpdateHotkeys", updateHotkey)
	hooksecurefunc("ActionButton_UpdateFlyout", styleflyout)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", init)