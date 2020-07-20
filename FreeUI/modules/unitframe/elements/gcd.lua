local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


function UNITFRAME:AddGCDSpark(self)
	if not cfg.gcd_spark then return end

	self.GCD = CreateFrame('Frame', nil, self)
	self.GCD:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 0)
	self.GCD:SetFrameLevel(self.Health:GetFrameLevel() + 4)
	self.GCD:SetWidth(self:GetWidth())
	self.GCD:SetHeight(6)

	self.GCD.Color = {C.r, C.g, C.b}
	self.GCD.Height = 6
	self.GCD.Width = 6
end