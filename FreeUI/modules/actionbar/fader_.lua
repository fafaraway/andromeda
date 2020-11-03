local F, C = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR


local buttonsList = {}
local SpellFlyout = SpellFlyout


local function CheckCondition(frame)
	if (frame.faderConfig.arena and (GetZonePVPInfo() == 'arena')) then return true end
	if (frame.faderConfig.instance and (IsInInstance() == true)) then return true end

	if (frame.faderConfig.combat and UnitAffectingCombat('player')) then return true end
	if (frame.faderConfig.target and UnitExists('target')) then return true end
	if (frame.faderConfig.hover and MouseIsOver(frame)) then return true end

	if (frame.faderConfig.vehicle and UnitHasVehicleUI('player')) then return true end

	if not SpellFlyout:IsShown() then return false end
	if not SpellFlyout.__faderParent then return false end
	if SpellFlyout.__faderParent == frame and MouseIsOver(SpellFlyout) then return true end

	return false
end

local function FrameHandler(frame)
	if not frame.faderConfig.enable then return end

	if CheckCondition(frame) then
		if C.DB.actionbar.fade_smooth then
			F:UIFrameFadeIn(frame, C.DB.actionbar.fade_in_duration, frame:GetAlpha(), frame.faderConfig.fadeInAlpha or 1)
		else
			frame:SetAlpha(frame.faderConfig.fadeInAlpha or 1)
		end


	else
		if C.DB.actionbar.fade_smooth then
			F:UIFrameFadeOut(frame, C.DB.actionbar.fade_out_duration, frame:GetAlpha(), frame.faderConfig.fadeOutAlpha or 0)
		else
			frame:SetAlpha(frame.faderConfig.fadeOutAlpha or 1)
		end
	end
end

local function OffFrameHandler(self)
	if not self.__faderParent then return end
	FrameHandler(self.__faderParent)
end

local function SpellFlyoutOnShow(self)
	local frame = self:GetParent():GetParent():GetParent()
	if not frame.fader then return end

	self.__faderParent = frame
	if not self.__faderHook then
		SpellFlyout:HookScript('OnEnter', OffFrameHandler)
		SpellFlyout:HookScript('OnLeave', OffFrameHandler)
		self.__faderHook = true
	end

	for i = 1, 13 do
		local button = _G['SpellFlyoutButton'..i]
		if not button then break end
		button.__faderParent = frame
		if not button.__faderHook then
			button:HookScript('OnEnter', OffFrameHandler)
			button:HookScript('OnLeave', OffFrameHandler)
			button.__faderHook = true
		end
	end
end
SpellFlyout:HookScript('OnShow', SpellFlyoutOnShow)



local function CreateFrameFader(frame, faderConfig)
	if frame.faderConfig then return end

	frame.faderConfig = faderConfig

	frame:EnableMouse(true)

	frame:HookScript('OnEnter', FrameHandler)
	frame:HookScript('OnLeave', FrameHandler)

	FrameHandler(frame)
end



function ACTIONBAR:CreateButtonFrameFader(buttonList, faderConfig)
	CreateFrameFader(self, faderConfig)

	for _, button in next, buttonList do
		if not button.__faderParent then
			button.__faderParent = self

			button:HookScript('OnEnter', OffFrameHandler)
			button:HookScript('OnLeave', OffFrameHandler)

			tinsert(buttonsList, button)
		end
	end
end

local function UpdateFader()
	for _, button in pairs(buttonsList) do
		OffFrameHandler(button)
	end
end

F:RegisterEvent('PLAYER_REGEN_ENABLED', UpdateFader)
F:RegisterEvent('PLAYER_REGEN_DISABLED', UpdateFader)
F:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateFader)
F:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateFader)
F:RegisterEvent('ZONE_CHANGED_NEW_AREA', UpdateFader)
