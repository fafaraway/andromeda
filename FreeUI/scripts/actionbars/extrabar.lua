local F, C = unpack(select(2, ...))
local Bar = F:GetModule("actionbars")
local cfg = C.actionbars

function Bar:CreateExtrabar()

	local num = 1
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_ExtraActionBar", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*cfg.buttonSizeHuge + (num-1)*cfg.margin + 2*cfg.padding)
	frame:SetHeight(cfg.buttonSizeHuge + 2*cfg.padding)
	frame:SetPoint(unpack(C.actionbars.extraButtonPos))
	frame:SetScale(1)

	--move the buttons into position and reparent them
	ExtraActionBarFrame:SetParent(frame)
	ExtraActionBarFrame:EnableMouse(false)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
	ExtraActionBarFrame.ignoreFramePositionManager = true

	--the extra button
	local button = ExtraActionButton1
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.buttonSizeHuge, cfg.buttonSizeHuge)

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[extrabar] show; hide"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)


	--zone ability
	ZoneAbilityFrame:ClearAllPoints()
	ZoneAbilityFrame.ignoreFramePositionManager = true
	ZoneAbilityFrameNormalTexture:SetAlpha(0)
	ZoneAbilityFrame:SetPoint(unpack(C.actionbars.zoneAbilityPos))

	local spellButton = ZoneAbilityFrame.SpellButton
	spellButton:SetSize(cfg.buttonSizeHuge, cfg.buttonSizeHuge)
	spellButton.Style:SetAlpha(0)
	spellButton.Icon:SetTexCoord(unpack(C.texCoord))
	spellButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.CreateBDFrame(spellButton.Icon)
	F.CreateSD(spellButton.Icon)
end