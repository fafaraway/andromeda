local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe



function module:AddStagger(self)
	local stagger = CreateFrame('StatusBar', nil, self)
	stagger:SetSize(self:GetWidth(), cfg.classPower_height)
	stagger:SetStatusBarTexture(C.media.sbTex)

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

	local text = F.CreateFS(stagger, 'pixel', '', nil, nil, true)
	text:SetPoint('TOP', stagger, 'BOTTOM', 0, -4)
	self:Tag(text, '[free:stagger]')

	self.Stagger = stagger
end