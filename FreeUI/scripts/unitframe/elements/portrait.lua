local F, C, L = unpack(select(2, ...))

local module = F:GetModule('Unitframe')

local cfg = C.unitframe


local function PostUpdatePortrait(element, unit)
	element:SetDesaturation(1)
end

function module:AddPortrait(self)
	if not cfg.portrait then return end

	local portrait = CreateFrame('PlayerModel', nil, self)
	portrait:SetAllPoints(self)
	portrait:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	portrait:SetAlpha(.1)
	portrait.PostUpdate = PostUpdatePortrait
	self.Portrait = portrait
end