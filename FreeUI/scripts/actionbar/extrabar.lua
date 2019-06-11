local F, C = unpack(select(2, ...))
local Bar = F:GetModule('Actionbar')
local cfg = C.actionbar

function Bar:CreateExtrabar()

	local num = 1
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame('Frame', 'FreeUI_ExtraActionBar', UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(num*cfg.buttonSizeHuge + (num-1)*cfg.margin*C.Mult + 2*cfg.padding*C.Mult)
	frame:SetHeight(cfg.buttonSizeHuge*C.Mult + 2*cfg.padding*C.Mult)
	frame:SetPoint(unpack(C.actionbar.extraButtonPos))
	frame:SetScale(1)

	--move the buttons into position and reparent them
	ExtraActionBarFrame:SetParent(frame)
	ExtraActionBarFrame:EnableMouse(false)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint('CENTER', 0, 0)
	ExtraActionBarFrame.ignoreFramePositionManager = true

	--the extra button
	local button = ExtraActionButton1
	table.insert(buttonList, button) --add the button object to the list
	table.insert(self.activeButtons, button)
	
	button:SetSize(cfg.buttonSizeHuge*C.Mult, cfg.buttonSizeHuge*C.Mult)

	--show/hide the frame on a given state driver
	frame.frameVisibility = '[extrabar] show; hide'
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)


	--zone ability
	ZoneAbilityFrame:ClearAllPoints()
	ZoneAbilityFrame.ignoreFramePositionManager = true
	ZoneAbilityFrameNormalTexture:SetAlpha(0)
	ZoneAbilityFrame:SetPoint(unpack(C.actionbar.zoneAbilityPos))

	local spellButton = ZoneAbilityFrame.SpellButton
	spellButton:SetSize(cfg.buttonSizeHuge*C.Mult, cfg.buttonSizeHuge*C.Mult)
	spellButton.Style:SetAlpha(0)
	spellButton.Icon:SetTexCoord(unpack(C.TexCoord))
	spellButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.CreateBDFrame(spellButton.Icon)
	F.CreateSD(spellButton.Icon)
end