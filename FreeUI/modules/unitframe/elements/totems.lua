local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local TotemsColor = {
	{ 0.71, 0.29, 0.13 }, -- red    181 /  73 /  33
	{ 0.26, 0.71, 0.13 }, -- green   67 / 181 /  33
	{ 0.13, 0.55, 0.71 }, -- blue    33 / 141 / 181
	{ 0.58, 0.13, 0.71 }, -- violet 147 /  33 / 181
	{ 0.71, 0.58, 0.13 }, -- yellow 181 / 147 /  33
}

function UNITFRAME:AddTotems(self)
	if not cfg.totems_bar then return end
	
	local totems = {}
	local maxTotems = 5

	local width, spacing = self:GetWidth(), 3

	width = (self:GetWidth() - (maxTotems + 1) * spacing) / maxTotems
	spacing = width + spacing

	for slot = 1, maxTotems do
		local totem = CreateFrame('StatusBar', nil, self)
		local color = TotemsColor[slot]
		local r, g, b = color[1], color[2], color[3]
		totem:SetStatusBarTexture(C.Assets.Textures.statusbar)
		totem:SetStatusBarColor(r, g, b)
		totem:SetSize(width, cfg.totems_bar_height)

		F.CreateBDFrame(totem)

		local function MoveTotemsBar()
			if(index == 1) then
				if self.AlternativePower:IsShown() then
					Bar:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', (slot - 1) * spacing + 1, -3)
				else
					Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', (slot - 1) * spacing + 1, -3)
				end
			end
		end
		self.AlternativePower:HookScript('OnShow', MoveTotemsBar)
		self.AlternativePower:HookScript('OnHide', MoveTotemsBar)
		MoveTotemsBar()

		totems[slot] = totem
	end

	self.CustomTotems = totems
end