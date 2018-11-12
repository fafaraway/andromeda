local F, C, L = unpack(select(2, ...))
local module = F:GetModule("infobar")
if not C.infoBar.enable then return end

local FreeUIGarrisonButton = module.FreeUIGarrisonButton

FreeUIGarrisonButton = module:addButton(GARRISON_LANDING_PAGE_TITLE, module.POSITION_RIGHT, GarrisonLandingPage_Toggle)
FreeUIGarrisonButton:Hide()

GarrisonLandingPageMinimapButton:SetSize(1, 1)
GarrisonLandingPageMinimapButton:SetAlpha(0)
GarrisonLandingPageMinimapButton:EnableMouse(false)
GarrisonLandingPageMinimapButton:HookScript("OnEvent", function(self, event)
	if event == "GARRISON_SHOW_LANDING_PAGE" and not FreeUIGarrisonButton:IsShown() then
		module:showButton(FreeUIGarrisonButton)
	elseif event == "GARRISON_HIDE_LANDING_PAGE" then
		module:hideButton(FreeUIGarrisonButton)
	end
end)
if C.appearance.usePixelFont then
	FreeUIGarrisonButton.Text:SetFont(unpack(C.font.pixel))
elseif C.Client == "zhCN" or C.Client == "zhTW" then
	FreeUIGarrisonButton.Text:SetFont(C.font.normal, 11)
end