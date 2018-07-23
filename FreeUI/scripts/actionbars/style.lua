local F, C = unpack(select(2, ...))

-- rButtonTemplate by zork

local Bar = F:GetModule("actionbars")
local _G = getfenv(0)

--[[local function CallButtonFunctionByName(button, func, ...)
	if button and func and button[func] then
		button[func](button, ...)
	end
end

local function ResetNormalTexture(self, file)
	if not self.__normalTextureFile then return end
	if file == self.__normalTextureFile then return end
	self:SetNormalTexture(self.__normalTextureFile)
end

local function ResetTexture(self, file)
	if not self.__textureFile then return end
	if file == self.__textureFile then return end
	self:SetTexture(self.__textureFile)
end

local function ResetVertexColor(self, r, g, b, a)
	if not self.__vertexColor then return end
	local r2, g2, b2, a2 = unpack(self.__vertexColor)
	if not a2 then a2 = 1 end
	if r ~= r2 or g ~= g2 or b ~= b2 or a ~= a2 then
		self:SetVertexColor(r2, g2, b2, a2)
	end
end

local function ApplyPoints(self, points)
	if not points then return end
	self:ClearAllPoints()
	for _, point in next, points do
		self:SetPoint(unpack(point))
	end
end

local function ApplyTexCoord(texture, texCoord)
	if not texCoord then return end
	texture:SetTexCoord(unpack(texCoord))
end

local function ApplyVertexColor(texture, color)
	if not color then return end
	texture.__vertexColor = color
	texture:SetVertexColor(unpack(color))
	hooksecurefunc(texture, "SetVertexColor", ResetVertexColor)
end

local function ApplyAlpha(region, alpha)
	if not alpha then return end
	region:SetAlpha(alpha)
end

local function ApplyFont(fontString, font)
	if not font then return end
	fontString:SetFont(unpack(font))
end

local function ApplyHorizontalAlign(fontString, align)
	if not align then return end
	fontString:SetJustifyH(align)
end

local function ApplyVerticalAlign(fontString, align)
	if not align then return end
	fontString:SetJustifyV(align)
end

local function ApplyTexture(texture, file)
	if not file then return end
	texture.__textureFile = file
	texture:SetTexture(file)
	hooksecurefunc(texture, "SetTexture", ResetTexture)
end

local function ApplyNormalTexture(button, file)
	if not file then return end
	button.__normalTextureFile = file
	button:SetNormalTexture(file)
	hooksecurefunc(button, "SetNormalTexture", ResetNormalTexture)
end

local function SetupTexture(texture, cfg, func, button)
	if not texture or not cfg then return end
	ApplyTexCoord(texture, cfg.texCoord)
	ApplyPoints(texture, cfg.points)
	ApplyVertexColor(texture, cfg.color)
	ApplyAlpha(texture, cfg.alpha)
	if func == "SetTexture" then
		ApplyTexture(texture, cfg.file)
	elseif func == "SetNormalTexture" then
		ApplyNormalTexture(button, cfg.file)
	elseif cfg.file then
		CallButtonFunctionByName(button, func, cfg.file)
	end
end

local function SetupFontString(fontString, cfg)
	if not fontString or not cfg then return end
	ApplyPoints(fontString, cfg.points)
	ApplyFont(fontString, cfg.font)
	ApplyAlpha(fontString, cfg.alpha)
	ApplyHorizontalAlign(fontString, cfg.halign)
	ApplyVerticalAlign(fontString, cfg.valign)
end

local function SetupCooldown(cooldown, cfg)
	if not cooldown or not cfg then return end
	ApplyPoints(cooldown, cfg.points)
end

local function SetupBackdrop(button)
	local bg = F.CreateBDFrame(button)
	--F.CreateBD(bg)
	--F.CreateTex(bg)

	bg:SetBackdropColor(.2, .2, .2, .25)

end

local replaces = {
	{"(Mouse Button )", "M"},
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

function F:UpdateHotKey()
	local hotkey = _G[self:GetName().."HotKey"]
	if hotkey and hotkey:IsShown() and not C.actionbars.hotkey then
		hotkey:Hide()
		return
	end

	local text = hotkey:GetText()
	if not text then return end

	for _, value in pairs(replaces) do
		text = gsub(text, value[1], value[2])
	end

	if text == RANGE_INDICATOR then
		hotkey:SetText("")
	else
		hotkey:SetText(text)
	end
end

function F:StyleActionButton(button, cfg)
	if not button then return end
	if button.__styled then return end

	local buttonName = button:GetName()
	local icon = _G[buttonName.."Icon"]
	local flash = _G[buttonName.."Flash"]
	local flyoutBorder = _G[buttonName.."FlyoutBorder"]
	local flyoutBorderShadow = _G[buttonName.."FlyoutBorderShadow"]
	local hotkey = _G[buttonName.."HotKey"]
	local count = _G[buttonName.."Count"]
	local name = _G[buttonName.."Name"]
	local border = _G[buttonName.."Border"]
	local NewActionTexture = button.NewActionTexture
	local cooldown = _G[buttonName.."Cooldown"]
	local normalTexture = button:GetNormalTexture()
	local pushedTexture = button:GetPushedTexture()
	local highlightTexture = button:GetHighlightTexture()
	--normal buttons do not have a checked texture, but checkbuttons do and normal actionbuttons are checkbuttons
	local checkedTexture = nil
	if button.GetCheckedTexture then checkedTexture = button:GetCheckedTexture() end
	local floatingBG = _G[buttonName.."FloatingBG"]

	--hide stuff
	if floatingBG then floatingBG:Hide() end
	if NewActionTexture then NewActionTexture:SetTexture(nil) end

	--backdrop
	SetupBackdrop(button)

	--textures
	SetupTexture(icon, cfg.icon, "SetTexture", icon)
	SetupTexture(flash, cfg.flash, "SetTexture", flash)
	SetupTexture(flyoutBorder, cfg.flyoutBorder, "SetTexture", flyoutBorder)
	SetupTexture(flyoutBorderShadow, cfg.flyoutBorderShadow, "SetTexture", flyoutBorderShadow)
	SetupTexture(border, cfg.border, "SetTexture", border)
	SetupTexture(normalTexture, cfg.normalTexture, "SetNormalTexture", button)
	SetupTexture(pushedTexture, cfg.pushedTexture, "SetPushedTexture", button)
	SetupTexture(highlightTexture, cfg.highlightTexture, "SetHighlightTexture", button)
	SetupTexture(checkedTexture, cfg.checkedTexture, "SetCheckedTexture", button)
	highlightTexture:SetColorTexture(1, 1, 1, .3)

	--cooldown
	SetupCooldown(cooldown, cfg.cooldown)

	--no clue why but blizzard created count and duration on background layer, need to fix that
	local overlay = CreateFrame("Frame", nil, button)
	overlay:SetAllPoints()
	if count then count:SetParent(overlay) end
	if hotkey then hotkey:SetParent(overlay) end
	if name then name:SetParent(overlay) end

	--hotkey+count+name
	F.UpdateHotKey(button)
	SetupFontString(hotkey, cfg.hotkey)
	SetupFontString(count, cfg.count)
	SetupFontString(name, cfg.name)

	button.__styled = true
end

function F:StyleExtraActionButton(cfg)
	local button = ExtraActionButton1
	if button.__styled then return end

	local buttonName = button:GetName()
	local icon = _G[buttonName.."Icon"]
	--local flash = _G[buttonName.."Flash"] --wierd the template has two textures of the same name
	local hotkey = _G[buttonName.."HotKey"]
	local count = _G[buttonName.."Count"]
	local buttonstyle = button.style --artwork around the button
	local cooldown = _G[buttonName.."Cooldown"]

	local normalTexture = button:GetNormalTexture()
	local pushedTexture = button:GetPushedTexture()
	local highlightTexture = button:GetHighlightTexture()
	local checkedTexture = button:GetCheckedTexture()

	--backdrop
	SetupBackdrop(button)

	--textures
	SetupTexture(icon, cfg.icon, "SetTexture", icon)
	SetupTexture(buttonstyle, cfg.buttonstyle, "SetTexture", buttonstyle)
	SetupTexture(normalTexture, cfg.normalTexture, "SetNormalTexture", button)
	SetupTexture(pushedTexture, cfg.pushedTexture, "SetPushedTexture", button)
	SetupTexture(highlightTexture, cfg.highlightTexture, "SetHighlightTexture", button)
	SetupTexture(checkedTexture, cfg.checkedTexture, "SetCheckedTexture", button)
	highlightTexture:SetColorTexture(1, 1, 1, .3)

	--cooldown
	--SetupCooldown(cooldown, cfg.cooldown)

	--hotkey, count
	F.UpdateHotKey(button)
	SetupFontString(hotkey, cfg.hotkey)
	SetupFontString(count, cfg.count)

	button.__styled = true
end

function F:StyleAllActionButtons(cfg)
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		F:StyleActionButton(_G["ActionButton"..i], cfg)
		F:StyleActionButton(_G["MultiBarBottomLeftButton"..i], cfg)
		F:StyleActionButton(_G["MultiBarBottomRightButton"..i], cfg)
		F:StyleActionButton(_G["MultiBarRightButton"..i], cfg)
		F:StyleActionButton(_G["MultiBarLeftButton"..i], cfg)
	end
	for i = 1, 6 do
		F:StyleActionButton(_G["OverrideActionBarButton"..i], cfg)
	end
	--petbar buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		F:StyleActionButton(_G["PetActionButton"..i], cfg)
	end
	--stancebar buttons
	for i = 1, NUM_STANCE_SLOTS do
		F:StyleActionButton(_G["StanceButton"..i], cfg)
	end
	--possess buttons
	for i = 1, NUM_POSSESS_SLOTS do
		F:StyleActionButton(_G["PossessButton"..i], cfg)
	end
	--extra action button
	F:StyleExtraActionButton(cfg)
	--spell flyout
	SpellFlyoutBackgroundEnd:SetTexture(nil)
	SpellFlyoutHorizontalBackground:SetTexture(nil)
	SpellFlyoutVerticalBackground:SetTexture(nil)
	local function checkForFlyoutButtons()
		local i = 1
		local button = _G["SpellFlyoutButton"..i]
		while button and button:IsShown() do
			F:StyleActionButton(button, cfg)
			i = i + 1
			button = _G["SpellFlyoutButton"..i]
		end
	end
	SpellFlyout:HookScript("OnShow", checkForFlyoutButtons)
end

function Bar:ReskinBars()
	local cfg = {
		icon = {
			texCoord = C.texCoord,
			points = {
				{"TOPLEFT", 1, -1},
				{"BOTTOMRIGHT", -1, 1},
			},
		},
		flyoutBorder = {file = ""},
		flyoutBorderShadow = {file = ""},
		border = {file = ""},
		normalTexture = {
			file = C.media.abtex.normal,
			texCoord = C.texCoord,
			color = {.3, .3, .3},
			points = {
				{"TOPLEFT", 0, 0},
				{"BOTTOMRIGHT", 0, 0},
			},
		},
		flash = {file = C.media.abtex.flash},
		pushedTexture = {file = C.media.abtex.pushed},
		checkedTexture = {file = C.media.abtex.checked},
		highlightTexture = {
			file = "",
			points = {
				{"TOPLEFT", 1, -1},
				{"BOTTOMRIGHT", -1, 1},
			},
		},
		cooldown = {
			points = {
				{"TOPLEFT", 0, 0},
				{"BOTTOMRIGHT", 0, 0},
			},
		},
		name = {
			font = {C.font.pixel, 8, "OUTLINEMONOCHROME"},
			points = {
				{"BOTTOMLEFT", 0, 0},
				{"BOTTOMRIGHT", 0, 0},
			},
		},
		hotkey = {
			font = {C.font.pixel, 8, "OUTLINEMONOCHROME"},
			points = {
				{"TOPRIGHT", 0, 0},
				{"TOPLEFT", 0, 0},
			},
		},
		count = {
			font = {C.font.pixel, 8, "OUTLINEMONOCHROME"},
			points = {
				{"BOTTOMRIGHT", 2, 0},
			},
		},
		buttonstyle = { file = ""},
	}
	F:StyleAllActionButtons(cfg)
	hooksecurefunc("ActionButton_UpdateHotkeys", F.UpdateHotKey)
end]]












local class = select(2, UnitClass("player"))
local r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b
local locale = GetLocale()

local gsub = gsub

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
	bu.sd = F.CreateSD(bu.bg)
	--bu.bg = F.SetBD(bu)

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
	ch:SetVertexColor(r, g, b)
	ch:SetDrawLayer("ARTWORK")
	ch:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ch:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	local pu = bu:GetPushedTexture()
	pu:SetVertexColor(r, g, b, .4)
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
	ch:SetVertexColor(r, g, b)
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
--local function flyoutbutton()
--	for i = 1, numFlyoutButtons do
--		local bu = _G["SpellFlyoutButton"..i]
--		if bu and not bu.styled then
--			styleActionButton(bu)

--			if bu:GetChecked() then
--				bu:SetChecked(nil)
--			end
--			bu.styled = true
--		end
--	end
--end

local function flyoutbutton()
	local i = 1
	local bu = _G["SpellFlyoutButton"..i]
	while bu and bu:IsShown() do
		styleActionButton(bu)
		i = i + 1
		bu = _G["SpellFlyoutButton"..i]
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



--fix blizzard cooldown flash
hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, 'SetCooldown', function(self)
  if not self then return end
	if self:GetEffectiveAlpha() > 0 then
		self:Show()
	else
		self:Hide()
	end
end)