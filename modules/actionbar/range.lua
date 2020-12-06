local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR


local next, pairs, unpack = next, pairs, unpack
local HasAction, IsUsableAction, IsActionInRange = HasAction, IsUsableAction, IsActionInRange

local UPDATE_DELAY = .2
local buttonColors, buttonsToUpdate = {}, {}
local updater = CreateFrame('Frame')

local colors = {
	['normal'] = {1, 1, 1},
	['oor'] = {.8, .1, .1},
	['oom'] = {.5, .5, 1},
	['unusable'] = {.3, .3, .3}
}

function ACTIONBAR:OnUpdateRange(elapsed)
	self.elapsed = (self.elapsed or UPDATE_DELAY) - elapsed
	if self.elapsed <= 0 then
		self.elapsed = UPDATE_DELAY

		if not ACTIONBAR:UpdateButtons() then
			self:Hide()
		end
	end
end
updater:SetScript('OnUpdate', ACTIONBAR.OnUpdateRange)

function ACTIONBAR:UpdateButtons()
	if next(buttonsToUpdate) then
		for button in pairs(buttonsToUpdate) do
			self.UpdateButtonUsable(button)
		end
		return true
	end

	return false
end

function ACTIONBAR:UpdateButtonStatus()
	local action = self.action

	if action and self:IsVisible() and HasAction(action) then
		buttonsToUpdate[self] = true
	else
		buttonsToUpdate[self] = nil
	end

	if next(buttonsToUpdate) then
		updater:Show()
	end
end

function ACTIONBAR:UpdateButtonUsable(force)
	if force then
		buttonColors[self] = nil
	end

	local action = self.action
	local isUsable, notEnoughMana = IsUsableAction(action)

	if isUsable then
		local inRange = IsActionInRange(action)
		if inRange == false then
			ACTIONBAR.SetButtonColor(self, 'oor')
		else
			ACTIONBAR.SetButtonColor(self, 'normal')
		end
	elseif notEnoughMana then
		ACTIONBAR.SetButtonColor(self, 'oom')
	else
		ACTIONBAR.SetButtonColor(self, 'unusable')
	end
end

function ACTIONBAR:SetButtonColor(colorIndex)
	if buttonColors[self] == colorIndex then return end
	buttonColors[self] = colorIndex

	local r, g, b = unpack(colors[colorIndex])
	self.icon:SetVertexColor(r, g, b)
end

function ACTIONBAR:Register()
	self:HookScript('OnShow', ACTIONBAR.UpdateButtonStatus)
	self:HookScript('OnHide', ACTIONBAR.UpdateButtonStatus)
	self:SetScript('OnUpdate', nil)
	ACTIONBAR.UpdateButtonStatus(self)
end

local function button_UpdateUsable(button)
	ACTIONBAR.UpdateButtonUsable(button, true)
end

function ACTIONBAR:RegisterButtonRange(button)
	if button.Update then
		ACTIONBAR.Register(button)
		hooksecurefunc(button, 'Update', ACTIONBAR.UpdateButtonStatus)
		hooksecurefunc(button, 'UpdateUsable', button_UpdateUsable)
	end
end
