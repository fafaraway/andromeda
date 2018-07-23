local F, C = unpack(select(2, ...))

--if not C.actionbars.enable then return end

local A = ...


C.addonName       = A
C.addonColor      = "0000FF00"
C.addonShortcut   = "rab"



rActionBar = {}
rActionBar.addonName = A



local SpellFlyout = SpellFlyout

local function FaderOnFinished(self)
	self.__owner:SetAlpha(self.finAlpha)
end

local function FaderOnUpdate(self)
	self.__owner:SetAlpha(self.__animFrame:GetAlpha())
end

local function CreateFaderAnimation(frame)
	if frame.fader then return end
	local animFrame = CreateFrame("Frame", nil, frame)
	animFrame.__owner = frame
	frame.fader = animFrame:CreateAnimationGroup()
	frame.fader.__owner = frame
	frame.fader.__animFrame = animFrame
	frame.fader.direction = nil
	frame.fader.setToFinalAlpha = false --test if this will NOT apply the alpha to all regions
	frame.fader.anim = frame.fader:CreateAnimation("Alpha")
	frame.fader:HookScript("OnFinished", FaderOnFinished)
	frame.fader:HookScript("OnUpdate", FaderOnUpdate)
end

local function StartFadeIn(frame)
	if frame.fader.direction == "in" then return end
	frame.fader:Pause()
	frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeOutAlpha or 0)
	frame.fader.anim:SetToAlpha(frame.faderConfig.fadeInAlpha or 1)
	frame.fader.anim:SetDuration(frame.faderConfig.fadeInDuration or 0.3)
	frame.fader.anim:SetSmoothing(frame.faderConfig.fadeInSmooth or "OUT")
	--start right away
	frame.fader.anim:SetStartDelay(frame.faderConfig.fadeInDelay or 0)
	frame.fader.finAlpha = frame.faderConfig.fadeInAlpha
	frame.fader.direction = "in"
	frame.fader:Play()
end

local function StartFadeOut(frame)
	if frame.fader.direction == "out" then return end
	frame.fader:Pause()
	frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeInAlpha or 1)
	frame.fader.anim:SetToAlpha(frame.faderConfig.fadeOutAlpha or 0)
	frame.fader.anim:SetDuration(frame.faderConfig.fadeOutDuration or 0.3)
	frame.fader.anim:SetSmoothing(frame.faderConfig.fadeOutSmooth or "OUT")
	--wait for some time before starting the fadeout
	frame.fader.anim:SetStartDelay(frame.faderConfig.fadeOutDelay or 0)
	frame.fader.finAlpha = frame.faderConfig.fadeOutAlpha
	frame.fader.direction = "out"
	frame.fader:Play()
end

local function IsMouseOverFrame(frame)
	if MouseIsOver(frame) then return true end
	if not SpellFlyout:IsShown() then return false end
	if not SpellFlyout.__faderParent then return false end
	if SpellFlyout.__faderParent == frame and MouseIsOver(SpellFlyout) then return true end
	return false
end

local function FrameHandler(frame)
	if IsMouseOverFrame(frame) then
		StartFadeIn(frame)
	else
		StartFadeOut(frame)
	end
end

local function OffFrameHandler(self)
	if not self.__faderParent then return end
	FrameHandler(self.__faderParent)
end

local function SpellFlyoutOnShow(self)
	local frame = self:GetParent():GetParent():GetParent()
	if not frame.fader then return end
	--set new frame parent
	self.__faderParent = frame
	if not self.__faderHook then
		SpellFlyout:HookScript("OnEnter", OffFrameHandler)
		SpellFlyout:HookScript("OnLeave", OffFrameHandler)
		self.__faderHook = true
	end
	for i = 1, 13 do
		local button = _G["SpellFlyoutButton"..i]
		if not button then break end
		button.__faderParent = frame
		if not button.__faderHook then
			button:HookScript("OnEnter", OffFrameHandler)
			button:HookScript("OnLeave", OffFrameHandler)
			button.__faderHook = true
		end
	end
end
SpellFlyout:HookScript("OnShow", SpellFlyoutOnShow)

local function CreateFrameFader(frame, faderConfig)
	if frame.faderConfig then return end
	frame.faderConfig = faderConfig
	frame:EnableMouse(true)
	CreateFaderAnimation(frame)
	frame:HookScript("OnEnter", FrameHandler)
	frame:HookScript("OnLeave", FrameHandler)
	FrameHandler(frame)
end

function F:CreateButtonFrameFader(frame, buttonList, faderConfig)
	CreateFrameFader(frame, faderConfig)
	for i, button in next, buttonList do
		if not button.__faderParent then
			button.__faderParent = frame
			button:HookScript("OnEnter", OffFrameHandler)
			button:HookScript("OnLeave", OffFrameHandler)
		end
	end
end



-- Functions
-----------------------------

function F:GetButtonList(buttonName,numButtons)
	local buttonList = {}
	for i=1, numButtons do
		local button = _G[buttonName..i]
		if not button then break end
		table.insert(buttonList, button)
	end
	return buttonList
end

--points
--1. p1, f, fp1, fp2
--2. p2, rb-1, p3, bm1, bm2
--3. p4, b-1, p5, bm3, bm4
local function SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, p1, fp1, fp2, p2, p3, bm1, bm2, p4, p5, bm3, bm4)
	for index, button in next, buttonList do
		if not frame.__blizzardBar then
			button:SetParent(frame)
		end
		button:SetSize(buttonWidth, buttonHeight)
		button:ClearAllPoints()
		if index == 1 then
			button:SetPoint(p1, frame, fp1, fp2)
		elseif numCols == 1 or mod(index, numCols) == 1 then
			button:SetPoint(p2, buttonList[index-numCols], p3, bm1, bm2)
		else
			button:SetPoint(p4, buttonList[index-1], p5, bm3, bm4)
		end
	end
end

local function SetupButtonFrame(frame, framePadding, buttonList, buttonWidth, buttonHeight, buttonMargin, numCols, startPoint)
	local numButtons = # buttonList
	numCols = min(numButtons, numCols)
	local numRows = ceil(numButtons/numCols)
	local frameWidth = numCols*buttonWidth + (numCols-1)*buttonMargin + 2*framePadding
	local frameHeight = numRows*buttonHeight + (numRows-1)*buttonMargin + 2*framePadding
	frame:SetSize(frameWidth,frameHeight)
	--TOPLEFT
	--1. TL, f, p, -p
	--2. T, rb-1, B, 0, -m
	--3. L, b-1, R, m, 0
	if startPoint == "TOPLEFT" then
		SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, framePadding, -framePadding, "TOP", "BOTTOM", 0, -buttonMargin, "LEFT", "RIGHT", buttonMargin, 0)
		--end
		--TOPRIGHT
		--1. TR, f, -p, -p
		--2. T, rb-1, B, 0, -m
		--3. R, b-1, L, -m, 0
	elseif startPoint == "TOPRIGHT" then
		SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, -framePadding, -framePadding, "TOP", "BOTTOM", 0, -buttonMargin, "RIGHT", "LEFT", -buttonMargin, 0)
		--end
		--BOTTOMRIGHT
		--1. BR, f, -p, p
		--2. B, rb-1, T, 0, m
		--3. R, b-1, L, -m, 0
	elseif startPoint == "BOTTOMRIGHT" then
		SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, -framePadding, framePadding, "BOTTOM", "TOP", 0, buttonMargin, "RIGHT", "LEFT", -buttonMargin, 0)
		--end
		--BOTTOMLEFT
		--1. BL, f, p, p
		--2. B, rb-1, T, 0, m
		--3. L, b-1, R, m, 0
		--elseif startPoint == "BOTTOMLEFT" then
	else
		startPoint = "BOTTOMLEFT"
		SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, framePadding, framePadding, "BOTTOM", "TOP", 0, buttonMargin, "LEFT", "RIGHT", buttonMargin, 0)
	end
end

function F:CreateButtonFrame(cfg,buttonList,delaySetup)
	--create new parent frame for buttons
	local frame = CreateFrame("Frame", cfg.frameName, cfg.frameParent, cfg.frameTemplate)
	frame:SetPoint(unpack(cfg.framePoint))
	frame:SetScale(cfg.frameScale)
	frame.__blizzardBar = cfg.blizzardBar
	if delaySetup then
		local function OnLogin(...)
			SetupButtonFrame(frame, cfg.framePadding, buttonList, cfg.buttonWidth, cfg.buttonHeight, cfg.buttonMargin, cfg.numCols, cfg.startPoint)
		end
		--F:RegisterCallback("PLAYER_LOGIN", OnLogin)
	else
		SetupButtonFrame(frame, cfg.framePadding, buttonList, cfg.buttonWidth, cfg.buttonHeight, cfg.buttonMargin, cfg.numCols, cfg.startPoint)
	end
	--reparent the Blizzard bar
	if cfg.blizzardBar then
		cfg.blizzardBar:SetParent(frame)
		cfg.blizzardBar:EnableMouse(false)
	end
	--show/hide the frame on a given state driver
	if cfg.frameVisibility then
		frame.frameVisibility = cfg.frameVisibility
		frame.frameVisibilityFunc = cfg.frameVisibilityFunc
		RegisterStateDriver(frame, cfg.frameVisibilityFunc or "visibility", cfg.frameVisibility)
	end
	--hover animation
	if cfg.fader then
		F:CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
	return frame
end
