local F, C = unpack(select(2, ...))

if not C.unitframes.enable then return end

--[[ Element: Runes Bar

 Handle updating and visibility of the Death Knight's Rune indicators.

 Widget

 Runes - An array holding StatusBar's.

 Sub-Widgets

 .bg - A Texture which functions as a background. It will inherit the color of
       the main StatusBar.

 Notes

 The default StatusBar texture will be applied if the UI widget doesn't have a
             status bar texture or color defined.

 Sub-Widgets Options

 .multiplier - Defines a multiplier, which is used to tint the background based
               on the main widgets R, G and B values. Defaults to 1 if not
               present.

 Examples

   local Runes = {}
   for index = 1, 6 do
      -- Position and size of the rune bar indicators
      local Rune = CreateFrame('StatusBar', nil, self)
      Rune:SetSize(120 / 6, 20)
      Rune:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', index * 120 / 6, 0)

      Runes[index] = Rune
   end

   -- Register with oUF
   self.Runes = Runes

 Hooks

 Override(self)           - Used to completely override the internal update
                            function. Removing the table key entry will make the
                            element fall-back to its internal function again.

]]

if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then return end

local parent, ns = ...
local oUF = ns.oUF

local function onUpdate(self, elapsed)
	local duration = self.duration + elapsed
	self.duration = duration
	self:SetValue(duration)
end

local function UpdateColor(element, runeID)
	local spec = GetSpecialization() or 0

	local color
	-- if(spec ~= 0 and element.colorSpec) then
	-- 	color = element.__owner.colors.runes[spec]
	-- else
	-- 	color = element.__owner.colors.power.RUNES
	-- end

	if spec == 1 then
		color = {151/255, 25/255, 0}
	elseif spec == 2 then
		color = {65/255, 133/255, 215/255}
	elseif spec == 3 then
		color = {98/255, 153/255, 51/255}
	end

	local r, g, b = color[1], color[2], color[3]

	element[runeID]:SetStatusBarColor(r, g, b)

	local bg = element[runeID].bg
	if(bg) then
		local mu = bg.multiplier or 1
		bg:SetVertexColor(r * mu, g * mu, b * mu)
	end
end

local function Update(self, event, runeID, energized)
	local element = self.Runes
	local rune = element[runeID]
	if(not rune) then return end

	local start, duration, runeReady
	if(UnitHasVehicleUI('player')) then
		rune:Hide()
	else
		start, duration, runeReady = GetRuneCooldown(runeID)
		if(not start) then return end

		if(energized or runeReady) then
			rune:SetMinMaxValues(0, 1)
			rune:SetValue(1)
			rune:SetScript('OnUpdate', nil)
		else
			rune.duration = GetTime() - start
			rune.max = duration
			rune:SetMinMaxValues(0, duration)
			rune:SetValue(0)
			rune:SetScript('OnUpdate', onUpdate)
		end

		rune:Show()
	end

	--[[ Callback: Runes:PostUpdate(rune, runeID, start, duration, isReady)
	Called after the element has been updated.

	* self     - the Runes element
	* rune     - the updated rune (StatusBar)
	* runeID   - the index of the updated rune (number)
	* start    - the value of `GetTime()` when the rune cooldown started (0 for ready or energized runes) (number?)
	* duration - the duration of the rune's cooldown (number?)
	* isReady  - indicates if the rune is ready for use (boolean)
	--]]
	if(element.PostUpdate) then
		return element:PostUpdate(rune, runeID, energized and 0 or start, duration, energized or runeReady)
	end
end

local function Path(self, event, ...)
	local element = self.Runes
	--[[ Override: Runes.Override(self, event, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* ...   - the arguments accompanying the event
	--]]
	local UpdateMethod = element.Override or Update
	if(event == 'RUNE_POWER_UPDATE') then
		return UpdateMethod(self, event, ...)
	else
		--[[ Override: Runes:UpdateColor(powerType)
		Used to completely override the internal function for updating the widgets' colors.

		* self  - the Runes element
		* index - the index of the updated rune (number)
		--]]
		local UpdateColorMethod = element.UpdateColor or UpdateColor
		for index = 1, #element do
			UpdateColorMethod(element, index)
			UpdateMethod(self, event, index)
		end
	end
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self, unit)
	local element = self.Runes
	if(element and unit == 'player') then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		for i = 1, #element do
			local rune = element[i]
			if(rune:IsObjectType('StatusBar') and not rune:GetStatusBarTexture()) then
				rune:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', Path, true)
		self:RegisterEvent('RUNE_POWER_UPDATE', Path, true)

		return true
	end
end

local function Disable(self)
	local element = self.Runes
	if(element) then
		for i = 1, #element do
			element[i]:Hide()
		end

		self:UnregisterEvent('PLAYER_SPECIALIZATION_CHANGED', Path)
		self:UnregisterEvent('RUNE_POWER_UPDATE', Path)
	end
end

oUF:AddElement('Runes', Path, Enable, Disable)
