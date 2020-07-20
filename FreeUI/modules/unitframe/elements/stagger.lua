local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


function UNITFRAME:AddStagger(self)
	if not cfg.stagger_bar then return end
	
	local stagger = CreateFrame('StatusBar', nil, self)
	stagger:SetSize(self:GetWidth(), cfg.stagger_bar_height)
	stagger:SetStatusBarTexture(C.Assets.Textures.statusbar)

	local bg = F.CreateBDFrame(stagger)

	local function MoveStaggerBar()
		if self.AlternativePower:IsShown() then
			stagger:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', 0, -3)
		else
			stagger:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
		end
	end
	self.AlternativePower:HookScript('OnShow', MoveStaggerBar)
	self.AlternativePower:HookScript('OnHide', MoveStaggerBar)
	MoveStaggerBar()

	local text = F.CreateFS(stagger, C.Assets.Fonts.Number, 11, 'OUTLINE', '', nil, true)
	text:SetPoint('TOP', stagger, 'BOTTOM', 0, -4)
	self:Tag(text, '[free:stagger]')

	self.Stagger = stagger
end