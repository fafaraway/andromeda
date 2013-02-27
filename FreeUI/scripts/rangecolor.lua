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
local buttonsToUpdate = {}

local colors = {
	normal = {1, 1, 1},
	oor = {1, 0.3, 0.1},
	oom = {0.1, 0.3, 1},
	ooh = {0.45, 0.45, 1}
}

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

--[[ Actions ]]--

function Range:Update()
	return self:UpdateButtons(UPDATE_DELAY)
end

function Range:UpdateActive()
	if next(buttonsToUpdate) then
		if not self:Active() then
			self:Start()
		end
	else
		self:Stop()
	end
end

function Range:UpdateButtons(elapsed)
	if next(buttonsToUpdate) then
		for button in pairs(buttonsToUpdate) do
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
		buttonsToUpdate[button] = true
	else
		buttonsToUpdate[button] = nil
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

hooksecurefunc('ActionButton_OnUpdate', Range.RegisterButton)
hooksecurefunc('ActionButton_UpdateUsable', Range.OnUpdateButtonUsable)
hooksecurefunc('ActionButton_Update', Range.OnButtonUpdate)

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
		elseif PLAYER_IS_PALADIN and isHolyPowerAbility(action) and not(UnitPower('player', SPELL_POWER_HOLY_POWER) >= 3 or UnitBuff('player', HAND_OF_LIGHT)) then
			Range.SetButtonColor(button, 'ooh')
		--in range
		else
			Range.SetButtonColor(button, 'normal')
		end
	--out of mana
	elseif notEnoughMana then
		Range.SetButtonColor(button, 'oom')
	--unusable
	else
		button.RangeColor = 'unusuable'
	end
end

function Range.SetButtonColor(button, colorType)
	if button.RangeColor ~= colorType then
		button.RangeColor = colorType

		local r, g, b = colors[colorType][1], colors[colorType][2], colors[colorType][3]

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