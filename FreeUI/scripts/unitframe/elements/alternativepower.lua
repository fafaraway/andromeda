local F, C, L = unpack(select(2, ...))

local module = F:GetModule('Unitframe')

local cfg = C.unitframe

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

local function OnValueChanged(_, value)
	local min, max = altPower:GetMinMaxValues()
	local r, g, b = self.ColorGradient(value, max, unpack(self.colors.smooth))
	altPower:SetStatusBarColor(r, g, b)
	altPowerCount:SetTextColor(r, g, b)
end

local function PostUpdateAltPower(element, _, cur, _, max)
	if cur and max then
		local perc = math.floor((cur/max)*100)
		if perc < 35 then
			element:SetStatusBarColor(0, 1, 0)
		elseif perc < 70 then
			element:SetStatusBarColor(1, 1, 0)
		else
			element:SetStatusBarColor(1, 0, 0)
		end
	end
end

function module:AddAlternativePower(self)
	local altPower = CreateFrame('StatusBar', nil, self)
	altPower:SetStatusBarTexture(C.media.sbTex)
	altPower:SetPoint('TOP', self, 'BOTTOM', 0, -3*C.Mult)
	altPower:SetSize(self:GetWidth(), cfg.altpower_height*C.Mult)
	altPower:EnableMouse(true)
	F.SmoothBar(altPower)
	altPower.bg = F.CreateBDFrame(altPower)

	local altPowerCount = F.CreateFS(altPower, 'pixel', '', 'CENTER', nil, true)
	altPowerCount:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	self:Tag(altPowerCount, '[free:altpower]')

	altPower.colorSmooth = true
	altPower.UpdateTooltip = UpdateTooltip
	altPower:HookScript('OnEnter', OnEnter)
	altPower:HookScript('OnValueChanged', OnValueChanged)

	self.AlternativePower = altPower
	--self.AlternativePower.PostUpdate = PostUpdateAltPower
end