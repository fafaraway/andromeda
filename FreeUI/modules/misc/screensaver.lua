local F, C, L = unpack(select(2, ...))
local MISC = F.MISC


local afkStart
function MISC:UpdateTimer(...)
	if _G.UnitIsAFK("player") then
		if not afkStart then
			afkStart = _G.GetServerTime()
			MISC.frame.alphaIn:Play()
		end

		if _G.UnitAffectingCombat("player") then
			_G.PlaySound(15262, "MASTER")
		end
	else
		afkStart = nil
		MISC.frame.alphaOut:Play()
	end
end

function MISC:CreateFrames()
	local frame = _G.CreateFrame("Frame", "FreeUIScreenSaver", _G.UIParent, 'BackdropTemplate')
	frame:SetPoint("TOPLEFT", 0, -300)
	frame:SetPoint("TOPRIGHT", 0, -300)
	frame:SetHeight(50)

	F.CreateBD(frame, .25)
	MISC.frame = frame

	frame:SetScript("OnUpdate", function(this, elapsed)
		if afkStart then
			local timeStr = _G.SecondsToClock(_G.GetServerTime() - afkStart)
			this.time:SetText(timeStr)
		end
	end)

	local alphaIn = frame:CreateAnimationGroup()
	alphaIn:SetScript("OnPlay", function(this)
		frame:Show()
	end)
	alphaIn:SetScript("OnFinished", function(this)
		frame:SetAlpha(1)
	end)
	local animIn = alphaIn:CreateAnimation("Alpha")
	animIn:SetDuration(0.5)
	animIn:SetFromAlpha(0)
	animIn:SetToAlpha(1)
	frame.alphaIn = alphaIn

	local alphaOut = frame:CreateAnimationGroup()
	alphaOut:SetScript("OnPlay", function(this)
		frame.time:SetText("")
	end)
	alphaOut:SetScript("OnFinished", function(this)
		frame:SetAlpha(0)
		frame:Hide()
	end)
	local animOut = alphaOut:CreateAnimation("Alpha")
	animOut:SetDuration(0.5)
	animOut:SetFromAlpha(1)
	animOut:SetToAlpha(0)
	frame.alphaOut = alphaOut

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetColorTexture(0, 0, 0, 0.5)
	bg:SetAllPoints(_G.UIParent)

	frame.text = F.CreateFS(frame, C.Assets.Fonts.Header, 42, 'OUTLINE', 'You are now away', 'GREY', true, 'CENTER', 0, 0)
	frame.time = F.CreateFS(frame, C.Assets.Fonts.Header, 36, 'OUTLINE', '', 'CLASS', true, 'CENTER', 0, -60)
end

function MISC:RefreshMod()
	MISC:UpdateTimer("Refresh")
end

function MISC:ScreenSaver()
		MISC:CreateFrames()
		MISC:RefreshMod()

	if C.DB.misc.screen_saver then
		F:RegisterEvent("PLAYER_FLAGS_CHANGED", MISC.UpdateTimer)
		F:RegisterEvent("PLAYER_REGEN_ENABLED", MISC.UpdateTimer)
		F:RegisterEvent("PLAYER_REGEN_DISABLED", MISC.UpdateTimer)
	else
		F:UnregisterEvent("PLAYER_FLAGS_CHANGED", MISC.UpdateTimer)
		F:UnregisterEvent("PLAYER_REGEN_ENABLED", MISC.UpdateTimer)
		F:UnregisterEvent("PLAYER_REGEN_DISABLED", MISC.UpdateTimer)
	end
end
MISC:RegisterMisc('ScreenSaver', MISC.ScreenSaver)
