local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local function PostUpdatePower(power, unit, cur, max, min)
	local self = power:GetParent()
	local style = self.unitStyle

	if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		power:SetValue(0)
	end

	if C.MyClass == 'DEMONHUNTER' and C.classmod.havocFury and style == 'player' then
		local spec, cp = GetSpecialization() or 0, UnitPower(unit)
		if spec == 1 and cp < 15 then
			power:SetStatusBarColor(.5, .5, .5)
		elseif spec == 1 and cp < 40 then
			power:SetStatusBarColor(1, 0, 0)
		end
	end
end

function UNITFRAME:AddPowerBar(self)
	local power = CreateFrame('StatusBar', nil, self)
	power:SetPoint('LEFT')
	power:SetPoint('RIGHT')
	power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -C.Mult)
	power:SetStatusBarTexture(C.Assets.Textures.statusbar)
	power:SetHeight(cfg.power_bar_height)
	F:SmoothBar(power)
	power.frequentUpdates = true

	self.Power = power

	local line = power:CreateTexture(nil, 'OVERLAY')
	line:SetHeight(C.Mult)
	line:SetPoint('TOPLEFT', 0, C.Mult)
	line:SetPoint('TOPRIGHT', 0, C.Mult)
	line:SetTexture(C.Assets.Textures.backdrop)
	line:SetVertexColor(0, 0, 0)

	local bg = power:CreateTexture(nil, 'BACKGROUND')
	bg:SetAllPoints()
	bg:SetTexture(C.Assets.Textures.backdrop)
	bg.multiplier = .2
	power.bg = bg

	power.colorTapping = true
	power.colorDisconnected = true
	power.colorReaction = true
	--power.colorSelection = true

	if self.unitStyle == 'pet' then
		power.colorPower = true
	elseif cfg.transparency then
		if self.unitStyle == 'player' then
			power.colorPower = true
		else
			power.colorClass = true
		end
	else
		power.colorPower = true
	end

	self.Power.PostUpdate = PostUpdatePower
end