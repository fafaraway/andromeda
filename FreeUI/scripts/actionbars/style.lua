local F, C = unpack(select(2, ...))


local class = select(2, UnitClass("player"))
local r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b



local showHotKey = C.actionbars.hotKey
local showMacroName = C.actionbars.macroName

F.AddOptionsCallback("actionbars", "hotKey", function()
	showHotKey = C.actionbars.hotKey

	for k, frame in pairs(ActionBarButtonEventsFrame.frames) do
		ActionButton_UpdateHotkeys(frame, frame.buttonType)
	end

	for i = 1, NUM_PET_ACTION_SLOTS do
		PetActionButton_SetHotkeys(_G["PetActionButton"..i])
	end
end)

local function updateHotkey(self, actionButtonType)
	local ho = _G[self:GetName().."HotKey"]
	if ho and ho:IsShown() and not showHotKey then
		ho:Hide()
		return
	end

	local text = ho:GetText()
	if not text then return end

	local replaces = {
		{"(Mouse Button)", "M"},
		{"(鼠标按键)", "M"},
		{"(滑鼠按鍵)", "M"},
		{"(a%-)", "a"},
		{"(c%-)", "c"},
		{"(s%-)", "s"},
		{KEY_BUTTON3, "M3"},
		{KEY_MOUSEWHEELUP, "MU"},
		{KEY_MOUSEWHEELDOWN, "MD"},
		{KEY_SPACE, "Sp"},
		{CAPSLOCK_KEY_TEXT, "CL"},
	}
	for _, value in pairs(replaces) do
		text = gsub(text, value[1], value[2])
	end
	if ho:GetText() == RANGE_INDICATOR then
        ho:SetText("")
    else
        ho:SetText(text)
	end
	
	if not self.styledHotkey then
		ho:ClearAllPoints()
		ho:SetWidth(0)
		ho:SetPoint("TOPLEFT", 1, 0)
		F.SetFS(ho)
		ho:SetJustifyH("RIGHT")
		ho:SetDrawLayer("OVERLAY", 1)
		self.styledHotkey = true
	end
end

local function applyBackground(bu)
	if bu:GetFrameLevel() < 7 then bu:SetFrameLevel(7) end

	bu.bg = F.CreateBDFrame(bu)
	bu.sd = F.CreateSD(bu.bg, .5)

	bu.bg = true
end

local function styleExtraActionButton(bu)
	if not bu or (bu and bu.styled) then return end

	local name = bu:GetName()
	local ho = _G[name.."HotKey"]

	-- remove the style background theme
	bu.style:SetTexture(nil)
	hooksecurefunc(bu.style, "SetTexture", function(self, texture)
		if texture then
			self:SetTexture(nil)
		end
	end)

	-- icon
	bu.icon:SetTexCoord(.08, .92, .08, .92)
	bu.icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	bu.icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	-- cooldown
	bu.cooldown:SetAllPoints(bu.icon)

	-- hotkey
	updateHotkey(bu)

	-- add button normal texture
	bu:SetPushedTexture(C.media.backdrop)
	bu:SetCheckedTexture(C.media.backdrop)
	bu:SetNormalTexture("")
	bu:SetHighlightTexture("")

	-- bu.HL = bu:CreateTexture(nil, "HIGHLIGHT")
	-- bu.HL:SetColorTexture(1, 1, 1, .3)
	-- bu.HL:SetAllPoints(bu.icon)

	local ch = bu:GetCheckedTexture()
	ch:SetVertexColor(r, g, b, .4)
	ch:SetDrawLayer("ARTWORK")
	ch:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ch:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	local pu = bu:GetPushedTexture()
	pu:SetVertexColor(1, 1, 1, .4)
	pu:SetDrawLayer("ARTWORK")
	pu:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	pu:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	-- apply background
	if not bu.bg then applyBackground(bu) end

	bu.styled = true
end

local function styleActionButton(bu)
	if not bu or (bu and bu.styled) then return end

	local name = bu:GetName()
	local ic= _G[name.."Icon"]
	local co= _G[name.."Count"]
	local bo= _G[name.."Border"]
	local cd= _G[name.."Cooldown"]
	local na= _G[name.."Name"]
	local fl= _G[name.."Flash"]
	local nt= _G[name.."NormalTexture"]
	local fbg= _G[name.."FloatingBG"]
	local fob = _G[name.."FlyoutBorder"]
	local fobs = _G[name.."FlyoutBorderShadow"]

	if fbg then fbg:Hide() end

	_G[name.."Name"]:Hide()
	_G[name.."Border"]:SetTexture("")

	-- hotkey
	updateHotkey(bu)

	-- macroname
	F.SetFS(na)
    na:ClearAllPoints()
    na:SetPoint("BOTTOMLEFT", bu, 0, 0)
	na:SetPoint("BOTTOMRIGHT", bu, 0, 0)
	if not showMacroName then na:Hide() end

	-- count
	F.SetFS(co)
	co:ClearAllPoints()
	co:SetPoint("TOPRIGHT", -1, -1)
	co:SetDrawLayer("OVERLAY")

	-- adjust the cooldown frame
	cd:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	-- applying the textures
	fl:SetTexture("")

	bu:SetPushedTexture(C.media.backdrop)
	bu:SetCheckedTexture(C.media.backdrop)
	bu:SetNormalTexture("")
	bu:SetHighlightTexture("")

	-- bu.HL = bu:CreateTexture(nil, "HIGHLIGHT")
	-- bu.HL:SetColorTexture(1, 1, 1, .3)
	-- bu.HL:SetAllPoints(ic)

	if not nt then
		-- fix the non existent texture problem (no clue what is causing this)
		nt = bu:GetNormalTexture()
	end

	local ch = bu:GetCheckedTexture()
	ch:SetVertexColor(1, 1, 1, .4)
	ch:SetDrawLayer("ARTWORK")
	ch:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ch:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	local pu = bu:GetPushedTexture()
	pu:SetVertexColor(r, g, b, .4)
	pu:SetDrawLayer("ARTWORK")
	pu:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	pu:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)


	-- cut the default border of the icons and make them shiny
	ic:SetTexCoord(.08, .92, .08, .92)
	-- ic:SetDrawLayer("OVERLAY")
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	-- make the normaltexture match the buttonsize
	-- nt:SetAllPoints(bu)
	-- nt:SetTexCoord(.08, .92, .08, .92)

	if not bu.bg then applyBackground(bu) end

	bu.styled = true
end

local function stylePetButton(bu)
	if not bu or (bu and bu.styled) then return end

	local name = bu:GetName()
	local ic  = _G[name.."Icon"]

	_G[name.."NormalTexture2"]:SetAllPoints(bu)
	_G[name.."AutoCastable"]:SetAlpha(0)

	bu:SetPushedTexture(C.media.backdrop)
	bu:SetCheckedTexture(C.media.backdrop)
	bu:SetNormalTexture("")
	bu:SetHighlightTexture("")

	hooksecurefunc(bu, "SetNormalTexture", function(self, texture)
		if texture and texture ~= "" then
			self:SetNormalTexture("")
		end
	end)

	local ch = bu:GetCheckedTexture()
	ch:SetVertexColor(r, g, b)
	ch:SetDrawLayer("ARTWORK")
	ch:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ch:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	ic:SetTexCoord(.08, .92, .08, .92)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
	-- ic:SetDrawLayer("OVERLAY")

	updateHotkey(bu)

	if not bu.bg then applyBackground(bu) end

	bu.styled = true
end

local function styleStanceButton(bu)
	if not bu or (bu and bu.styled) then return end

	local name = bu:GetName()
	local ic= _G[name.."Icon"]
	local fl= _G[name.."Flash"]

	bu:SetPushedTexture(C.media.backdrop)
	bu:SetCheckedTexture(C.media.backdrop)
	bu:SetNormalTexture("")
	bu:SetHighlightTexture("")

	local ch = bu:GetCheckedTexture()
	ch:SetVertexColor(r/2, g/2, b/2)
	ch:SetDrawLayer("ARTWORK")
	ch:SetPoint("TOPLEFT", bu, 0, 0)
	ch:SetPoint("BOTTOMRIGHT", bu, 0, 0)

	local pu = bu:GetPushedTexture()
	pu:SetVertexColor(r, g, b, .4)
	pu:SetDrawLayer("ARTWORK")
	pu:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	pu:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	ic:SetTexCoord(.08, .92, .08, .92)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
	-- ic:SetDrawLayer("OVERLAY")

	if not bu.bg then applyBackground(bu) end
	bu.styled = true
end

local numFlyoutButtons = 0
local function flyoutbutton()
	for i = 1, numFlyoutButtons do
		local bu = _G["SpellFlyoutButton"..i]
		if bu and not bu.styled then
			styleActionButton(bu)

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
			numFlyoutButtons = numSlots
			break
		end
	end
end

--zone ability
--ZoneAbilityFrame:ClearAllPoints()
ZoneAbilityFrame.ignoreFramePositionManager = true
ZoneAbilityFrameNormalTexture:SetAlpha(0)

local spellButton = ZoneAbilityFrame.SpellButton
spellButton.Style:SetAlpha(0)
spellButton.Icon:SetTexCoord(.08, .92, .08, .92)
spellButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .3)
F.CreateBDFrame(spellButton.Icon)
F.CreateSD(spellButton.Icon, .5)

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

	-- for i = 1, 6 do
	-- 	styleActionButton(OverrideActionBar["SpellButton"..i])
	-- end
	for i = 1, 6 do
		styleActionButton(_G["OverrideActionBarButton"..i])
	end

	applyBackground(OverrideActionBarLeaveFrameLeaveButton)
	OverrideActionBarLeaveFrameLeaveButton:SetHighlightTexture("")

	local nt = OverrideActionBarLeaveFrameLeaveButton:GetNormalTexture()
	nt:SetPoint("TOPLEFT", 1, -1)
	nt:SetPoint("BOTTOMRIGHT", -1, 1)
	nt:SetTexCoord(0.0959375, 0.1579688, 0.369375, 0.4314063)

	for i = 1, NUM_PET_ACTION_SLOTS do
		stylePetButton(_G["PetActionButton"..i])
	end

	for i = 1, NUM_STANCE_SLOTS do
		styleStanceButton(_G["StanceButton"..i])
	end

	for i = 1, NUM_POSSESS_SLOTS do
		styleStanceButton(_G["PossessButton"..i])
	end

	styleExtraActionButton(ExtraActionButton1)

	hooksecurefunc("ActionButton_OnEvent", function(self, event, ...) if event == "PLAYER_ENTERING_WORLD" then ActionButton_UpdateHotkeys(self, self.buttonType) end end)
	hooksecurefunc("ActionButton_UpdateHotkeys", updateHotkey)
	hooksecurefunc("PetActionButton_SetHotkeys", updateHotkey)
	hooksecurefunc("ActionButton_UpdateFlyout", styleflyout)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", init)