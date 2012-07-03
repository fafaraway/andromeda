local F, C, L = unpack(select(2, ...))

local font = C.media.font2

RaidWarningFrame.slot1:SetFont(font, 20, "OUTLINE")
RaidWarningFrame.slot2:SetFont(font, 20, "OUTLINE")
RaidBossEmoteFrame.slot1:SetFont(font, 20, "OUTLINE")
RaidBossEmoteFrame.slot2:SetFont(font, 20, "OUTLINE")

UIErrorsFrame:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
UIErrorsFrame:SetShadowOffset(0, 0)

HelpFrameKnowledgebaseNavBarHomeButtonText:SetFont(font, 12)

local Fonts = CreateFrame("Frame", nil, UIParent)
Fonts:RegisterEvent("ADDON_LOADED")
Fonts:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "FreeUI" then return end

	STANDARD_TEXT_FONT = font
	UNIT_NAME_FONT     = font
	DAMAGE_TEXT_FONT   = font
	NAMEPLATE_FONT     = font

	-- Base fonts
	GameTooltipHeader:SetFont(font, 14)
	NumberFont_OutlineThick_Mono_Small:SetFont(font, 12, "OUTLINE")
	NumberFont_Outline_Huge:SetFont(font, 30, "OUTLINE")
	NumberFont_Outline_Large:SetFont(font, 16, "OUTLINE")
	NumberFont_Outline_Med:SetFont(font, 14, "OUTLINE")
	NumberFont_Shadow_Med:SetFont(font, 14)
	NumberFont_Shadow_Small:SetFont(font, 12)
	QuestFont:SetFont(font, 13)
	QuestFont_Shadow_Small:SetFont(font, 14)
	QuestFont_Large:SetFont(font, 15)
	QuestFont_Shadow_Huge:SetFont(font, 17)
	QuestFont_Super_Huge:SetFont(font, 24)
	SubSpellFont:SetFont(font, 10)
	FriendsFont_UserText:SetFont(font, 11)
	SystemFont_InverseShadow_Small:SetFont(font, 10)
	SystemFont_Large:SetFont(font, 16)
	SystemFont_Huge1:SetFont(font, 20)
	SystemFont_Med1:SetFont(font, 12)
	SystemFont_Med2:SetFont(font, 13)
	SystemFont_Med3:SetFont(font, 14)
	SystemFont_OutlineThick_WTF:SetFont(font, 32, "THICKOUTLINE")
	SystemFont_OutlineThick_Huge2:SetFont(font, 22, "THICKOUTLINE")
	SystemFont_OutlineThick_Huge4:SetFont(font, 26, "THICKOUTLINE")
	SystemFont_Outline_Small:SetFont(font, 10, "OUTLINE")
	SystemFont_Outline:SetFont(font, 13, "OUTLINE")
	SystemFont_Shadow_Large:SetFont(font, 16)
	SystemFont_Shadow_Med1:SetFont(font, 12)
	SystemFont_Shadow_Med2:SetFont(font, 13)
	SystemFont_Shadow_Med3:SetFont(font, 14)
	SystemFont_Shadow_Outline_Huge2:SetFont(font, 22, "OUTLINE")
	SystemFont_Shadow_Huge1:SetFont(font, 20)
	SystemFont_Shadow_Huge3:SetFont(font, 25)
	SystemFont_Shadow_Small:SetFont(font, 10)
	SystemFont_Small:SetFont(font, 10)
	SystemFont_Tiny:SetFont(font, 9)
	SpellFont_Small:SetFont(font, 10)
	Tooltip_Med:SetFont(font, 12)
	Tooltip_Small:SetFont(font, 10)
	CombatTextFont:SetFont(font, 25)
	MailFont_Large:SetFont(font, 15)
	InvoiceFont_Small:SetFont(font, 10)
	InvoiceFont_Med:SetFont(font, 12)
	ReputationDetailFont:SetFont(font, 10)
	AchievementFont_Small:SetFont(font, 10)
	GameFont_Gigantic:SetFont(font, 32)
	CoreAbilityFont:SetFont(font, 32)
	CoreAbilityFont:SetShadowColor(0, 0, 0)
	CoreAbilityFont:SetShadowOffset(1, -1)

	self:SetScript("OnEvent", nil)
	self:UnregisterAllEvents()
	self = nil
end)