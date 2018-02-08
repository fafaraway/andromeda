-- modified tullaRange by Tuller
local F, C, L = unpack(select(2, ...))

if not C.actionbars.enable then return end
if not C.actionbars.enableStyle then return end

--locals and speed
local Addon = {}
local _G = _G
local next = next
local pairs = pairs

local UPDATE_DELAY = 0.15
local ATTACK_BUTTON_FLASH_TIME = _G['ATTACK_BUTTON_FLASH_TIME']

local ActionHasRange = _G['ActionHasRange']
local IsActionInRange = _G['IsActionInRange']
local IsUsableAction = _G['IsUsableAction']
local HasAction = _G['HasAction']
local GetTime = _G['GetTime']
local Timer_After = _G['C_Timer'].After

--[[
	The main thing
--]]

function Addon:Load()
	self.buttonColors = {}
	self.buttonsToUpdate = {}

	local f = CreateFrame("Frame")

	f:SetScript('OnEvent', function(frame, ...)
		self:OnEvent(...)
	end)

	f:RegisterEvent('PLAYER_LOGIN')
end


--[[
	Frame Events
--]]

function Addon:OnEvent(event, ...)
	local action = self[event]

	if action then
		action(self, event, ...)
	end
end

function Addon:PLAYER_LOGIN()
	self.sets = {
		normal = {1, 1, 1},
		oor = {237/255, 33/255, 77/255},
		oom = {0.1, 0.3, 1},
		unusable = {0.4, 0.4, 0.4}
	}

	self:HookActionEvents()
end

--[[
	Button Hooking
--]]

do
	local function button_UpdateStatus(button)
		Addon:UpdateButtonStatus(button)
	end

	local function button_UpdateUsable(button)
		Addon:UpdateButtonUsable(button, true)
	end

	local function button_Register(button)
		Addon:Register(button)
	end

	function Addon:HookActionEvents()
		hooksecurefunc('ActionButton_OnUpdate', button_Register)
		hooksecurefunc('ActionButton_UpdateUsable', button_UpdateUsable)
		hooksecurefunc('ActionButton_Update', button_UpdateStatus)
	end

	function Addon:Register(button)
		button:HookScript('OnShow', button_UpdateStatus)
		button:HookScript('OnHide', button_UpdateStatus)
		button:SetScript('OnUpdate', nil)

		self:UpdateButtonStatus(button)
	end
end


--[[
	Actions
--]]

function Addon:RequestUpdate()
	if not next(self.buttonsToUpdate) then return end

	if not self.timerDone then
		self.timerDone = function()
			local elapsed = GetTime() - self.started
			self.started = nil

			if self:UpdateButtons(elapsed) then
				self:RequestUpdate()
			end
		end
	end

	if not self.started then
		self.started = GetTime()

		Timer_After(UPDATE_DELAY, self.timerDone)
	end
end

function Addon:UpdateButtons(elapsed)
	if not next(self.buttonsToUpdate) then
		return false
	end

	for button in pairs(self.buttonsToUpdate) do
		self:UpdateButton(button, elapsed)
	end

	return true
end

function Addon:UpdateButton(button, elapsed)
	self:UpdateButtonUsable(button)
	self:UpdateButtonFlash(button, elapsed)
end

function Addon:UpdateButtonUsable(button, force)
	if force then
		self.buttonColors[button] = nil
	end

	local action = button.action
	local isUsable, notEnoughMana = IsUsableAction(action)

	--usable (ignoring target information)
	if isUsable then
		local inRange = IsActionInRange(action)

		--but out of range
		if inRange == false then
			self:SetButtonColor(button, 'oor')
		else
			self:SetButtonColor(button, 'normal')
		end
	--out of mana
	elseif notEnoughMana then
		self:SetButtonColor(button, 'oom')
	--unusable
	else
		self:SetButtonColor(button, 'unusable')
	end
end

function Addon:UpdateButtonFlash(button, elapsed)
	if button.flashing ~= 1 then return end

	local flashtime = button.flashtime - elapsed

	if flashtime <= 0 then
		local overtime = -flashtime

		if overtime >= ATTACK_BUTTON_FLASH_TIME then
			overtime = 0
		end

		flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

		local flashTexture = button.Flash
		if flashTexture:IsShown() then
			flashTexture:Hide()
		else
			flashTexture:Show()
		end
	end

	button.flashtime = flashtime
end

function Addon:UpdateButtonStatus(button)
	local action = button.action

	if action and button:IsVisible() and HasAction(action) then
		self.buttonsToUpdate[button] = true
	else
		self.buttonsToUpdate[button] = nil
	end

	self:RequestUpdate()
end

function Addon:SetButtonColor(button, colorIndex)
	if self.buttonColors[button] == colorIndex then return end

	self.buttonColors[button] = colorIndex

	local r, g, b = self:GetColor(colorIndex)
	button.icon:SetVertexColor(r, g, b)
end


--[[
	Configuration
--]]

function Addon:GetColor(index)
	local color = self.sets[index]

	return color[1], color[2], color[3]
end

--[[ Load The Thing ]]--
Addon:Load()