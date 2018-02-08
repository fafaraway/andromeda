-- daftUIFade by tonyis3l33t

local F, C, L = unpack(select(2, ...))

if not C.appearance.uiFader then return end

local addonName, addonTable = ... ;

addonTable.TIMETOFADEIN = 1.0;
addonTable.FADEIN = 1.0;

addonTable.TIMETOFADEOUT = 3.0;
addonTable.FADEOUT = 0.00;

local addon = CreateFrame("Frame");

addon:SetScript("OnUpdate", function()

	if UnitAffectingCombat("Player")
	or InCombatLockdown() then
		UIParent:SetAlpha(addonTable.FADEIN); -- UIFrameFadeIn causes access violation in combat
		return;
	end;

	MouseFrame = false;
	if GetMouseFocus() then
		MouseFrame = GetMouseFocus():GetName();
	end;

	if ChatFrame1EditBox:IsShown()
	or WorldMapFrame:IsShown()
	or MailFrame:IsShown()
	or GossipFrame:IsShown()
	or GameMenuFrame:IsShown()
	or StaticPopup1:IsShown()
	or MirrorTimer1:IsShown()
	or LFGDungeonReadyPopup:IsShown()
	or LFDRoleCheckPopup:IsShown()
	or LevelUpDisplay:IsShown()
	or RolePollPopup:IsShown()
	or ReadyCheckFrame:IsShown()
	or BonusRollFrame:IsShown()
	or QuestLogPopupDetailFrame:IsShown()
	or GameTooltipTextLeft1:GetText()
	or UnitCastingInfo("Player")
	or UnitCastingInfo("Vehicle")
	or UnitChannelInfo("Player")
	or UnitChannelInfo("Vehicle")
	or UnitExists("Target")
	or MouseIsOver(ChatFrame1)
	or MouseIsOver(ChatFrame2)
	or MouseIsOver(ChatFrame3)
	or MouseFrame ~= "WorldFrame"
	or MouseIsOver(ChatFrame4) then
		UIFrameFadeIn(UIParent, addonTable.TIMETOFADEIN, UIParent:GetAlpha(), addonTable.FADEIN);
	else
		UIFrameFadeOut(UIParent, addonTable.TIMETOFADEOUT, UIParent:GetAlpha(), addonTable.FADEOUT);
	end;
end);
