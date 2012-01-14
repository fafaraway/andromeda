-- Range by Tuller, modified.

--locals and speed
local _G = _G
local UPDATE_DELAY = 0.15
local ATTACK_BUTTON_FLASH_TIME = ATTACK_BUTTON_FLASH_TIME
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER
local ActionButton_GetPagedID = ActionButton_GetPagedID
local ActionButton_IsFlashing = ActionButton_IsFlashing
local ActionHasRange = ActionHasRange
local IsActionInRange = IsActionInRange
local IsUsableAction = IsUsableAction
local HasAction = HasAction


--code for handling defaults
local function removeDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(tbl[k]) == 'table' and type(v) == 'table' then
			removeDefaults(tbl[k], v)
			if next(tbl[k]) == nil then
				tbl[k] = nil
			end
		elseif tbl[k] == v then
			tbl[k] = nil
		end
	end
	return tbl
end

local function copyDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(v) == 'table' then
			tbl[k] = copyDefaults(tbl[k] or {}, v)
		elseif tbl[k] == nil then
			tbl[k] = v
		end
	end
	return tbl
end

local function timer_Create(parent, interval)
	local updater = parent:CreateAnimationGroup()
	updater:SetLooping('NONE')
	updater:SetScript('OnFinished', function(self)
		if parent:Update() then
			parent:Start(interval)
		end
	end)

	local a = updater:CreateAnimation('Animation'); a:SetOrder(1)

	parent.Start = function(self)
		self:Stop()
		a:SetDuration(interval)
		updater:Play()
		return self
	end

	parent.Stop = function(self)
		if updater:IsPlaying() then
			updater:Stop()
		end
		return self
	end

	parent.Active = function(self)
		return updater:IsPlaying()
	end

	return parent
end

--stuff for holy power detection
local PLAYER_IS_PALADIN = select(2, UnitClass('player')) == 'PALADIN'
local HAND_OF_LIGHT = GetSpellInfo(90174)
local isHolyPowerAbility
do
	local HOLY_POWER_SPELLS = {
		[85256] = GetSpellInfo(85256), --Templar's Verdict
--		[53385] = GetSpellInfo(53385), --Divine Storm
		[53600] = GetSpellInfo(53600), --Shield of the Righteous
--		[84963] = GetSpellInfo(84963), --Inquisition
--		[85673] = GetSpellInfo(85673), --Word of Glory (Not included: linear increase per holy power)
--		[85222] = GetSpellInfo(85222), --Light of Dawn (Not included: linear increase per holy power)
	}

	isHolyPowerAbility = function(actionId)
		local actionType, id = GetActionInfo(actionId)
		if actionType == 'macro' then
			local macroSpell = GetMacroSpell(id)
			if macroSpell then
				for spellId, spellName in pairs(HOLY_POWER_SPELLS) do
					if macroSpell == spellName then
						return true
					end
				end
			end
		else
			return HOLY_POWER_SPELLS[id]
		end
		return false
	end
end


--[[ The main thing ]]--

local Range = timer_Create(CreateFrame('Frame', 'Range'), UPDATE_DELAY)

function Range:Load()
	self:SetScript('OnEvent', self.OnEvent)
	self:RegisterEvent('PLAYER_LOGIN')
	self:RegisterEvent('PLAYER_LOGOUT')
end


--[[ Frame Events ]]--

function Range:OnEvent(event, ...)
	local action = self[event]
	if action then
		action(self, event, ...)
	end
end

--[[ Game Events ]]--

function Range:PLAYER_LOGIN()
	if not Range_COLORS then
		Range_COLORS = {}
	end
	self.sets = copyDefaults(Range_COLORS, self:GetDefaults())

	--add options loader
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	f:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)
		LoadAddOn('Range_Config')
	end)

	self.buttonsToUpdate = {}

	hooksecurefunc('ActionButton_OnUpdate', self.RegisterButton)
	hooksecurefunc('ActionButton_UpdateUsable', self.OnUpdateButtonUsable)
	hooksecurefunc('ActionButton_Update', self.OnButtonUpdate)
end

function Range:PLAYER_LOGOUT()
	removeDefaults(Range_COLORS, self:GetDefaults())
end


--[[ Actions ]]--

function Range:Update()
	return self:UpdateButtons(UPDATE_DELAY)
end

function Range:ForceColorUpdate()
	for button in pairs(self.buttonsToUpdate) do
		Range.OnUpdateButtonUsable(button)
	end
end

function Range:UpdateActive()
	if next(self.buttonsToUpdate) then
		if not self:Active() then
			self:Start()
		end
	else
		self:Stop()
	end
end

function Range:UpdateButtons(elapsed)
	if next(self.buttonsToUpdate) then
		for button in pairs(self.buttonsToUpdate) do
			self:UpdateButton(button, elapsed)
		end
		return true
	end
	return false
end

function Range:UpdateButton(button, elapsed)
	Range.UpdateButtonUsable(button)
	Range.UpdateFlash(button, elapsed)
end

function Range:UpdateButtonStatus(button)
	local action = ActionButton_GetPagedID(button)
	if button:IsVisible() and action and HasAction(action) and ActionHasRange(action) then
		self.buttonsToUpdate[button] = true
	else
		self.buttonsToUpdate[button] = nil
	end
	self:UpdateActive()
end



--[[ Button Hooking ]]--

function Range.RegisterButton(button)
	button:HookScript('OnShow', Range.OnButtonShow)
	button:HookScript('OnHide', Range.OnButtonHide)
	button:SetScript('OnUpdate', nil)

	Range:UpdateButtonStatus(button)
end

function Range.OnButtonShow(button)
	Range:UpdateButtonStatus(button)
end

function Range.OnButtonHide(button)
	Range:UpdateButtonStatus(button)
end

function Range.OnUpdateButtonUsable(button)
	button.RangeColor = nil
	Range.UpdateButtonUsable(button)
end

function Range.OnButtonUpdate(button)
	 Range:UpdateButtonStatus(button)
end


--[[ Range Coloring ]]--

function Range.UpdateButtonUsable(button)
	local action = ActionButton_GetPagedID(button)
	local isUsable, notEnoughMana = IsUsableAction(action)

	--usable
	if isUsable then
		--but out of range
		if IsActionInRange(action) == 0 then
			Range.SetButtonColor(button, 'oor')
		--a holy power abilty, and we're less than 3 Holy Power
		elseif PLAYER_IS_PALADIN and isHolyPowerAbility(action) and not(UnitPower('player', SPELL_POWER_HOLY_POWER) >= Range:GetHolyPowerThreshold() or UnitBuff('player', HAND_OF_LIGHT)) then
			Range.SetButtonColor(button, 'ooh')
		--in range
		else
			Range.SetButtonColor(button, 'normal')
		end
	--out of mana
	elseif notEnoughMana then
		--a holy power abilty, and we're less than 3 Holy Power
		if PLAYER_IS_PALADIN and isHolyPowerAbility(action) and not(UnitPower('player', SPELL_POWER_HOLY_POWER) >= Range:GetHolyPowerThreshold() or UnitBuff('player', HAND_OF_LIGHT)) then
			Range.SetButtonColor(button, 'ooh')
		else
			Range.SetButtonColor(button, 'oom')
		end
	--unusable
	else
		button.RangeColor = 'unusuable'
	end
end

function Range.SetButtonColor(button, colorType)
	if button.RangeColor ~= colorType then
		button.RangeColor = colorType

		local r, g, b = Range:GetColor(colorType)

		local icon =  _G[button:GetName() .. 'Icon']
		icon:SetVertexColor(r, g, b)
	end
end

function Range.UpdateFlash(button, elapsed)
	if ActionButton_IsFlashing(button) then
		local flashtime = button.flashtime - elapsed

		if flashtime <= 0 then
			local overtime = -flashtime
			if overtime >= ATTACK_BUTTON_FLASH_TIME then
				overtime = 0
			end
			flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

			local flashTexture = _G[button:GetName() .. 'Flash']
			if flashTexture:IsShown() then
				flashTexture:Hide()
			else
				flashTexture:Show()
			end
		end

		button.flashtime = flashtime
	end
end


--[[ Configuration ]]--

function Range:GetDefaults()
	return {
		normal = {1, 1, 1},
		oor = {1, 0.3, 0.1},
		oom = {0.1, 0.3, 1},
		ooh = {0.45, 0.45, 1},
		holyPowerThreshold = 3
	}
end

function Range:Reset()
	Range_COLORS = {}
	self.sets = copyDefaults(Range_COLORS, self:GetDefaults())

	self:ForceColorUpdate()
end

function Range:SetColor(index, r, g, b)
	local color = self.sets[index]
	color[1] = r
	color[2] = g
	color[3] = b

	self:ForceColorUpdate()
end

function Range:GetColor(index)
	local color = self.sets[index]
	return color[1], color[2], color[3]
end

function Range:SetHolyPowerThreshold(value)
	self.sets.holyPowerThreshold = value
end

function Range:GetHolyPowerThreshold()
	return self.sets.holyPowerThreshold
end

--[[ Load The Thing ]]--

Range:Load()