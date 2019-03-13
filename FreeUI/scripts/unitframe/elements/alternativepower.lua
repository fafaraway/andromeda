local _, ns = ...
local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module = F:GetModule('Unitframe')
local oUF = ns.oUF
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

local function PostUpdateAltPower(element, _, cur, _, max)
	if cur and max then
		local self = element.__owner
		local value = self.AlternativePower.value
		local perc = math.floor((cur/max)*100)
		
		if perc < 35 then
			element:SetStatusBarColor(0, 1, 0)
			value:SetTextColor(0, 1, 0)
		elseif perc < 70 then
			element:SetStatusBarColor(1, 1, 0)
			value:SetTextColor(1, 1, 0)
		else
			element:SetStatusBarColor(1, 0, 0)
			value:SetTextColor(1, 0, 0)
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

	altPower.value = F.CreateFS(altPower, 'pixel', '', 'CENTER', nil, true)
	altPower.value:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	self:Tag(altPower.value, '[free:altpower]')

	altPower.UpdateTooltip = UpdateTooltip
	altPower:SetScript('OnEnter', OnEnter)

	self.AlternativePower = altPower
	self.AlternativePower.PostUpdate = PostUpdateAltPower
end