local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe



local totemsColor = {
	{ 0.71, 0.29, 0.13 }, -- red    181 /  73 /  33
	{ 0.26, 0.71, 0.13 }, -- green   67 / 181 /  33
	{ 0.13, 0.55, 0.71 }, -- blue    33 / 141 / 181
	{ 0.58, 0.13, 0.71 }, -- violet 147 /  33 / 181
	{ 0.71, 0.58, 0.13 }, -- yellow 181 / 147 /  33
}


function module:AddTotems(self)
	local totems = {}
	local maxTotems = 5

	local width, spacing = self:GetWidth(), 3

	width = (self:GetWidth() - (maxTotems + 1) * spacing) / maxTotems
	spacing = width + spacing

	for slot = 1, maxTotems do
		local totem = CreateFrame('StatusBar', nil, self)
		local color = totemsColor[slot]
		local r, g, b = color[1], color[2], color[3]
		totem:SetStatusBarTexture(C.media.sbTex)
		totem:SetStatusBarColor(r, g, b)
		totem:SetSize(width, cfg.classPower_height)
		totem:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', (slot - 1) * spacing + 1, 16)

		local bg = F.CreateBDFrame(totem)

		totems[slot] = totem
	end

	self.CustomTotems = totems
end