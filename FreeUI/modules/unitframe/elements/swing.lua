local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


function UNITFRAME:AddSwingSpark(self)
	if not cfg.swing_spark then return end

	local bar = CreateFrame("StatusBar", nil, self)
	bar:SetSize(self:GetWidth(), 6)
	bar:SetPoint("BOTTOM", self, "BOTTOM", 0, -3)

	local twoHand = CreateFrame("StatusBar", nil, bar)
	twoHand:Hide()
	twoHand:SetAllPoints()

	twoHand:SetStatusBarTexture(C.Assets.Textures.statusbar)
	twoHand:SetStatusBarColor(0, 0, 0, 0)
	twoHand.Spark = twoHand:CreateTexture(nil, 'OVERLAY')
	twoHand.Spark:SetTexture(C.Assets.Textures.spark)
	twoHand.Spark:SetVertexColor(1, 1, 1)
	twoHand.Spark:SetBlendMode('ADD')
	twoHand.Spark:SetAlpha(.5)
	twoHand.Spark:SetPoint('TOPLEFT', twoHand:GetStatusBarTexture(), 'TOPRIGHT', -4, 4)
	twoHand.Spark:SetPoint('BOTTOMRIGHT', twoHand:GetStatusBarTexture(), 'BOTTOMRIGHT', 4, -4)

	self.Swing = bar
	self.Swing.Twohand = twoHand
	self.Swing.hideOoc = true
end