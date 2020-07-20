local F, C = unpack(select(2, ...))
local UNITFRAME, cfg, oUF = F:GetModule('Unitframe'), C.Unitframe, F.oUF


local format, min, max, floor = string.format, math.min, math.max, math.floor

local function OnEnter(altPower)
	if (not altPower:IsVisible()) then return end

	GameTooltip:SetOwner(altPower, 'ANCHOR_BOTTOMRIGHT')
	altPower:UpdateTooltip()
end

local function UpdateTooltip(altPower)
	local value = altPower:GetValue()
	local min, max = altPower:GetMinMaxValues()
	GameTooltip:SetText(altPower.powerName, 1, 1, 1)
	GameTooltip:AddLine(altPower.powerTooltip, nil, nil, nil, true)
	GameTooltip:AddLine(format('\n%d (%d%%)', value, (value - min) / (max - min) * 100), 1, 1, 1)
	GameTooltip:Show()
end

local function PostUpdateAltPower(element, _, cur, _, max)
	if cur and max then
		local self = element.__owner
		local value = self.AlternativePowerValue
		local r, g, b = ColorGradient(cur, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)

		element:SetStatusBarColor(r, g, b)
		value:SetTextColor(r, g, b)
		
		--[[ local perc = math.floor((cur/max)*100)
		if perc < 35 then
			element:SetStatusBarColor(0, 1, 0)
			value:SetTextColor(0, 1, 0)
		elseif perc < 70 then
			element:SetStatusBarColor(1, 1, 0)
			value:SetTextColor(1, 1, 0)
		else
			element:SetStatusBarColor(1, 0, 0)
			value:SetTextColor(1, 0, 0)
		end ]]
	end
end

function UNITFRAME:AddAlternativePowerBar(self)
	local altPower = CreateFrame('StatusBar', nil, self)
	altPower:SetStatusBarTexture(C.Assets.Textures.statusbar)
	altPower:Point('TOP', self.Power, 'BOTTOM', 0, -2)
	altPower:Size(self:GetWidth(), cfg.alternative_power_height)
	altPower:EnableMouse(true)
	F:SmoothBar(altPower)
	altPower.bg = F.CreateBDFrame(altPower)

	altPower.UpdateTooltip = UpdateTooltip
	altPower:SetScript('OnEnter', OnEnter)

	self.AlternativePower = altPower
	self.AlternativePower.PostUpdate = PostUpdateAltPower
end