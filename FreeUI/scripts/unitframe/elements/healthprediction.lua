local F, C, L = unpack(select(2, ...))

local module = F:GetModule('Unitframe')

local cfg = C.unitframe


function module:AddHealthPrediction(self)
	if cfg.healPrediction then 
		local myBar = CreateFrame('StatusBar', nil, self.Health)
		myBar:SetPoint('TOP')
		myBar:SetPoint('BOTTOM')
		myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		myBar:SetStatusBarTexture(C.media.sbTex)
		myBar:GetStatusBarTexture():SetBlendMode('BLEND')
		myBar:SetStatusBarColor(0, .8, .8, .6)
		myBar:SetWidth(self:GetWidth())

		local otherBar = CreateFrame('StatusBar', nil, self.Health)
		otherBar:SetPoint('TOP')
		otherBar:SetPoint('BOTTOM')
		otherBar:SetPoint('LEFT', myBar:GetStatusBarTexture(), 'RIGHT')
		otherBar:SetStatusBarTexture(C.media.sbTex)
		otherBar:GetStatusBarTexture():SetBlendMode('BLEND')
		otherBar:SetStatusBarColor(0, .6, .6, .6)
		otherBar:SetWidth(self:GetWidth())

		local absorbBar = CreateFrame('StatusBar', nil, self.Health)
		absorbBar:SetPoint('TOP')
		absorbBar:SetPoint('BOTTOM')
		absorbBar:SetPoint('LEFT', otherBar:GetStatusBarTexture(), 'RIGHT')
		absorbBar:SetStatusBarTexture('Interface\\AddOns\\FreeUI\\assets\\statusbar_striped')
		absorbBar:GetStatusBarTexture():SetBlendMode('BLEND')
		absorbBar:SetStatusBarColor(.8, .8, .8, .8)
		absorbBar:SetWidth(self:GetWidth())

		self.HealthPrediction = {
			myBar = myBar,
			otherBar = otherBar,
			absorbBar = absorbBar,
			maxOverflow = 1,
			frequentUpdates = true,
		}
	end
	
	if cfg.overAbsorb then
		local overAbsorb = self.Health:CreateTexture(nil, 'OVERLAY')
		overAbsorb:SetPoint('TOP', 0, 2)
		overAbsorb:SetPoint('BOTTOM', 0, -2)
		overAbsorb:SetPoint('LEFT', self.Health, 'RIGHT', -4, 0)
		if self.unitStyle == 'party' or self.unitStyle == 'raid' then
			overAbsorb:SetWidth(8)
		else
			overAbsorb:SetWidth(14)
		end
		self.HealthPrediction['overAbsorb'] = overAbsorb
	end
end