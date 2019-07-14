local F, C, L = unpack(select(2, ...))


local strsplit, ipairs, wipe = string.split, ipairs, table.wipe

local toggle = 0

local shadeFrame = CreateFrame('Frame')
local shadeTexture = shadeFrame:CreateTexture(nil, 'BACKGROUND', nil, -8)

shadeFrame:SetFrameStrata('BACKGROUND')
shadeFrame:SetWidth(GetScreenWidth() * UIParent:GetEffectiveScale())
shadeFrame:SetHeight(GetScreenHeight() * UIParent:GetEffectiveScale())
shadeTexture:SetAllPoints(shadeFrame)
shadeFrame:SetPoint('CENTER', 0, 0)

local crosshairFrameNS = CreateFrame('Frame')
local crosshairTextureNS = crosshairFrameNS:CreateTexture(nil, 'TOOLTIP')

crosshairFrameNS:SetFrameStrata('TOOLTIP')
crosshairFrameNS:SetWidth(1)
crosshairFrameNS:SetHeight(GetScreenHeight() * UIParent:GetEffectiveScale())
crosshairTextureNS:SetAllPoints(crosshairFrameNS)
crosshairTextureNS:SetColorTexture(0, 0, 0, 1)

local crosshairFrameEW = CreateFrame('Frame')
local crosshairTextureEW = crosshairFrameEW:CreateTexture(nil, 'TOOLTIP')

crosshairFrameEW:SetFrameStrata('TOOLTIP')
crosshairFrameEW:SetWidth(GetScreenWidth() * UIParent:GetEffectiveScale())
crosshairFrameEW:SetHeight(1)
crosshairTextureEW:SetAllPoints(crosshairFrameEW)
crosshairTextureEW:SetColorTexture(0, 0, 0, 1)

local function clear()
	shadeFrame:Hide()
	crosshairFrameNS:Hide()
	crosshairFrameEW:Hide()
end

local function shade(r, g, b, a)
	shadeTexture:SetColorTexture(r, g, b, a)
	shadeFrame:Show()
end

local function follow()
	local mouseX, mouseY = GetCursorPosition()
	crosshairFrameNS:SetPoint('TOPLEFT', mouseX, 0)
	crosshairFrameEW:SetPoint('BOTTOMLEFT', 0, mouseY)
end

local function crosshair(arg)
	local mouseX, mouseY = GetCursorPosition()
	crosshairFrameNS:SetPoint('TOPLEFT', mouseX, 0)
	crosshairFrameEW:SetPoint('BOTTOMLEFT', 0, mouseY)
	crosshairFrameNS:Show()
	crosshairFrameEW:Show()
	if arg == 'follow' then
		crosshairFrameNS:SetScript('OnUpdate', follow)
	else
		crosshairFrameNS:SetScript('OnUpdate', nil)
	end
end



local MoverList, BackupTable, f = {}, {}

function F:Mover(text, value, anchor, width, height)
	local key = 'mover'
	if not FreeUIConfig[key] then FreeUIConfig[key] = {} end

	local mover = CreateFrame('Frame', nil, UIParent)
	mover:SetWidth(width or self:GetWidth())
	mover:SetHeight(height or self:GetHeight())
	F.CreateBD(mover)
	F.CreateSD(mover)

	F.CreateFS(mover, (C.isCNClient and {C.font.normal, 11}) or 'pixel', text, nil, 'yellow', true)

	tinsert(MoverList, mover)

	if not FreeUIConfig[key][value] then 
		mover:SetPoint(unpack(anchor))
	else
		mover:SetPoint(unpack(FreeUIConfig[key][value]))
	end
	mover:EnableMouse(true)
	mover:SetMovable(true)
	mover:SetClampedToScreen(true)
	mover:SetFrameStrata('HIGH')
	mover:RegisterForDrag('LeftButton')
	mover:SetScript('OnDragStart', function() mover:StartMoving() end)
	mover:SetScript('OnDragStop', function()
		mover:StopMovingOrSizing()
		local orig, _, tar, x, y = mover:GetPoint()
		FreeUIConfig[key][value] = {orig, 'UIParent', tar, x, y}
	end)
	mover:Hide()
	self:ClearAllPoints()
	self:SetPoint('TOPLEFT', mover)

	return mover
end

local function UnlockElements()
	for i = 1, #MoverList do
		local mover = MoverList[i]
		if not mover:IsShown() then
			mover:Show()
		end
	end
	F.CopyTable(FreeUIConfig['mover'], BackupTable)
	f:Show()
end

local function LockElements()
	for i = 1, #MoverList do
		local mover = MoverList[i]
		mover:Hide()
	end
	f:Hide()
	--SlashCmdList['TOGGLEGRID']('1')
	toggle = 0
	clear()
end

local function CreateConsole()
	if f then return end

	f = CreateFrame('Frame', nil, UIParent)
	f:SetPoint('TOP', 0, -150)
	f:SetSize(296, 65)
	F.CreateBD(f)
	F.CreateSD(f)
	F.CreateMF(f)
	F.CreateFS(f, {C.font.normal, 14}, L['MOVER_PANEL'], nil, 'yellow', true, 'TOP', 0, -10)
	local bu, text = {}, {LOCK, CANCEL, L['MOVER_GRID'], RESET}
	for i = 1, 4 do
		bu[i] = F.CreateButton(f, 70, 28, text[i])
		F.Reskin(bu[i])
		if i == 1 then
			bu[i]:SetPoint('BOTTOMLEFT', 5, 5)
		else
			bu[i]:SetPoint('LEFT', bu[i-1], 'RIGHT', 2, 0)
		end
	end

	-- Lock
	bu[1]:SetScript('OnClick', LockElements)
	-- Cancel
	bu[2]:SetScript('OnClick', function()
		StaticPopup_Show('FREEUI_MOVER_CANCEL')
	end)
	-- Grids
	bu[3]:SetScript('OnClick', function()
		--SlashCmdList['TOGGLEGRID']('64')
		if toggle == 0 then
		shade(1, 1, 1, 0.85)
		crosshairTextureNS:SetColorTexture(0, 0, 0, 1)
		crosshairTextureEW:SetColorTexture(0, 0, 0, 1)
		crosshair('follow')
		toggle = 1
		else
			toggle = 0
		clear()
		end
	end)
	-- Reset
	bu[4]:SetScript('OnClick', function()
		StaticPopup_Show('FREEUI_MOVER_RESET')
	end)


	local function showLater(event)
		if event == 'PLAYER_REGEN_DISABLED' then
			if f:IsShown() then
				LockElements()
				F:RegisterEvent('PLAYER_REGEN_ENABLED', showLater)
			end
		else
			UnlockElements()
			F:UnregisterEvent(event, showLater)
		end
	end
	F:RegisterEvent('PLAYER_REGEN_DISABLED', showLater)
end


function F:MoverConsole()
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT)
		return
	end
	CreateConsole()
	UnlockElements()
end

--[[SlashCmdList['FREEUI_MOVER'] = function()
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT)
		return
	end
	CreateConsole()
	UnlockElements()
end
SLASH_FREEUI_MOVER1 = '/mover']]






