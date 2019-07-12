local F, C = unpack(select(2, ...))
local NOTIFICATION = F:RegisterModule('Notification')


local playSounds = C.notification.playSounds
local animations = C.notification.animations
local timeShown = C.notification.timeShown

local bannerWidth = 300
local interval = 0.1

local f = CreateFrame('Frame', 'FreeUINotifications', UIParent)
f:SetFrameStrata('FULLSCREEN_DIALOG')
f:SetSize(bannerWidth, 50)
f:SetPoint('TOP', UIParent, 'TOP', 0, -60)
f:Hide()
f:SetAlpha(0.1)
f:SetScale(0.1)

local icon = f:CreateTexture(nil, 'OVERLAY')
icon:SetSize(32, 32)
icon:SetPoint('LEFT', f, 'LEFT', 9, 0)

local sep = f:CreateTexture(nil, 'BACKGROUND')
sep:SetSize(1, 50)
sep:SetPoint('LEFT', icon, 'RIGHT', 9, 0)
sep:SetColorTexture(0, 0, 0)

local title = f:CreateFontString(nil, 'OVERLAY')
title:SetFont(C.font.normal, 14)
title:SetShadowOffset(1, -1)
title:SetPoint('TOPLEFT', sep, 'TOPRIGHT', 9, -9)
title:SetPoint('RIGHT', f, -9, 0)
title:SetJustifyH('LEFT')

local text = f:CreateFontString(nil, 'OVERLAY')
text:SetFont(C.font.normal, 12)
text:SetShadowOffset(1, -1)
text:SetPoint('BOTTOMLEFT', sep, 'BOTTOMRIGHT', 9, 9)
text:SetPoint('RIGHT', f, -9, 0)
text:SetJustifyH('LEFT')


local bannerShown = false

local function hideBanner()
	if animations then
		local scale
		f:SetScript('OnUpdate', function(self)
			scale = self:GetScale() - interval
			if scale <= 0.1 then
				self:SetScript('OnUpdate', nil)
				self:Hide()
				bannerShown = false
				return
			end
			self:SetScale(scale)
			self:SetAlpha(scale)
		end)
	else
		f:Hide()
		f:SetScale(0.1)
		f:SetAlpha(0.1)
		bannerShown = false
	end
end

local function fadeTimer()
	local last = 0
	f:SetScript('OnUpdate', function(self, elapsed)
		local width = f:GetWidth()
		if width > bannerWidth then
			self:SetWidth(width - (interval*100))
		end
		last = last + elapsed
		if last >= timeShown then
			self:SetWidth(bannerWidth)
			self:SetScript('OnUpdate', nil)
			hideBanner()
		end
	end)
end

local function showBanner()
	bannerShown = true
	if animations then
		f:Show()
		local scale
		f:SetScript('OnUpdate', function(self)
			scale = self:GetScale() + interval
			self:SetScale(scale)
			self:SetAlpha(scale)
			if scale >= 1 then
				self:SetScale(1)
				self:SetScript('OnUpdate', nil)
				fadeTimer()
			end
		end)
	else
		f:SetScale(1)
		f:SetAlpha(1)
		f:Show()
		fadeTimer()
	end
end

local function display(name, message, clickFunc, texture, ...)
	if type(clickFunc) == 'function' then
		f.clickFunc = clickFunc
	else
		f.clickFunc = nil
	end

	if type(texture) == 'string' then
		icon:SetTexture(texture)

		if ... then
			icon:SetTexCoord(...)
		else
			icon:SetTexCoord(unpack(C.TexCoord))
		end
	else
		icon:SetTexture('Interface\\Icons\\achievement_general')
		icon:SetTexCoord(unpack(C.TexCoord))
	end

	title:SetText(name)
	text:SetText(message)

	showBanner()

	if playSounds then
		PlaySoundFile('Interface\\AddOns\\FreeUI\\assets\\sound\\notification.mp3')
	end
end



local handler = CreateFrame('Frame')
local incoming = {}
local processing = false

local function handleIncoming()
	processing = true
	local i = 1

	handler:SetScript('OnUpdate', function(self)
		if incoming[i] == nil then
			self:SetScript('OnUpdate', nil)
			incoming = {}
			processing = false
			return
		else
			if not bannerShown then
				display(unpack(incoming[i]))
				i = i + 1
			end
		end
	end)
end

F.Notification = function(name, message, clickFunc, texture, ...)
	if UnitIsAFK('player') then
		tinsert(incoming, {name, message, clickFunc, texture, ...})
		handler:RegisterEvent('PLAYER_FLAGS_CHANGED')
	elseif bannerShown or #incoming ~= 0 then
		tinsert(incoming, {name, message, clickFunc, texture, ...})
		if not processing then
			handleIncoming()
		end
	else
		display(name, message, clickFunc, texture, ...)
	end
end

local function expand(self)
	local width = self:GetWidth()

	if text:IsTruncated() and width < (GetScreenWidth() / 1.5) then
		self:SetWidth(width+(interval*100))
	else
		self:SetScript('OnUpdate', nil)
	end
end


function NOTIFICATION:OnLogin()
	if not C.notification.enableBanner then return end

	F.CreateBD(f)
	F.CreateSD(f)
	F.CreateBG(icon)

	handler:SetScript('OnEvent', function(self, _, unit)
		if unit == 'player' and not UnitIsAFK('player') then
			handleIncoming()
			self:UnregisterEvent('PLAYER_FLAGS_CHANGED')
		end
	end)

	f:SetScript('OnEnter', function(self)
		self:SetScript('OnUpdate', nil)
		self:SetScale(1)
		self:SetAlpha(1)
		self:SetScript('OnUpdate', expand)
	end)

	f:SetScript('OnLeave', fadeTimer)

	f:SetScript('OnMouseUp', function(self, button)
		self:SetScript('OnUpdate', nil)
		self:Hide()
		self:SetScale(0.1)
		self:SetAlpha(0.1)
		bannerShown = false

		if button ~= 'RightButton' and f.clickFunc then
			f.clickFunc()
		end

		if IsShiftKeyDown() then
			handler:SetScript('OnUpdate', nil)
			incoming = {}
			processing = false
		end
	end)

	self:Events()
	self:Interrupt()
	self:Dispel()
	self:Spell()
	self:Resurrect()
	self:Sapped()
	self:Rare()
	self:QuestNotifier()
end