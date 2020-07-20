local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local function PostUpdatePortrait(element, unit)
	element:SetDesaturation(1)
end

function UNITFRAME:AddPortrait(self)
	if not cfg.portrait then return end

	local portrait = CreateFrame('PlayerModel', nil, self)
	portrait:SetAllPoints(self)
	portrait:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	portrait:SetAlpha(.1)
	portrait.PostUpdate = PostUpdatePortrait
	self.Portrait = portrait
end