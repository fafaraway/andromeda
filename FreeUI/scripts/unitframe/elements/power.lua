local F, C, L = unpack(select(2, ...))

local module = F:GetModule('Unitframe')

local cfg = C.unitframe



local function PostUpdatePower(power, unit, cur, max, min)
	local self = power:GetParent()
	if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		power:SetValue(0)
	end

	if self.Power.Text then
		self.Power.Text:SetTextColor(power:GetStatusBarColor())
	end

	if C.Class == 'DEMONHUNTER' and C.classmod.havocFury and self.unitStyle == 'player' then
		local spec, cp = GetSpecialization() or 0, UnitPower(unit)
		if spec == 1 and cp < 15 then
			power:SetStatusBarColor(.5, .5, .5)
		elseif spec == 1 and cp < 40 then
			power:SetStatusBarColor(1, 0, 0)
		end
	end
end

function module:AddPowerBar(self)
	local power = CreateFrame('StatusBar', nil, self)
	power:SetPoint('LEFT')
	power:SetPoint('RIGHT')
	power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -C.Mult)
	power:SetStatusBarTexture(C.media.sbTex)
	power:SetHeight(cfg.power_height*C.Mult)

	power.frequentUpdates = true
	F.SmoothBar(power)

	local line = power:CreateTexture(nil, 'OVERLAY')
	line:SetHeight(C.Mult)
	line:SetPoint('TOPLEFT', 0, C.Mult)
	line:SetPoint('TOPRIGHT', 0, C.Mult)
	line:SetTexture(C.media.backdrop)
	line:SetVertexColor(0, 0, 0)

	local bg = power:CreateTexture(nil, 'BACKGROUND')
	bg:SetAllPoints()
	bg:SetTexture(C.media.backdrop)
	bg.multiplier = .1
	power.bg = bg

	power.colorReaction = true

	if cfg.transMode then
		if self.unitStyle == 'player' then
			power.colorPower = true
		else
			power.colorClass = true
		end
	else
		power.colorPower = true
	end

	power.PostUpdate = PostUpdatePower
	self.Power = power
end