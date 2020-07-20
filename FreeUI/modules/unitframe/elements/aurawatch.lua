local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local CornerBuffsAnchor = {
	TOPLEFT = {6, 1},
	TOPRIGHT = {-6, 1},
	BOTTOMLEFT = {6, 1},
	BOTTOMRIGHT = {-6, 1},
	LEFT = {6, 1},
	RIGHT = {-6, 1},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

function UNITFRAME:CreateCornerBuffIcon(icon)
	F.CreateBDFrame(icon)
	icon.icon:Point('TOPLEFT', 1, -1)
	icon.icon:Point('BOTTOMRIGHT', -1, 1)
	icon.icon:SetTexCoord(unpack(C.TexCoord))
	icon.icon:SetDrawLayer('ARTWORK')

	if (icon.cd) then
		icon.cd:SetHideCountdownNumbers(true)
		icon.cd:SetReverse(true)
	end

	icon.overlay:SetTexture()
end

function UNITFRAME:AddCornerBuff(self)
	if not cfg.corner_buffs then return end

	local Auras = CreateFrame('Frame', nil, self)
	Auras:SetPoint('TOPLEFT', self.Health, 2, -2)
	Auras:SetPoint('BOTTOMRIGHT', self.Health, -2, 2)
	Auras:SetFrameLevel(self.Health:GetFrameLevel() + 5)
	Auras.presentAlpha = 1
	Auras.missingAlpha = 0
	Auras.icons = {}
	Auras.PostCreateIcon = UNITFRAME.CreateCornerBuffIcon
	Auras.strictMatching = true
	Auras.hideCooldown = true

	local buffs = {}

	if (C.CornerBuffs['ALL']) then
		for key, value in pairs(C.CornerBuffs['ALL']) do
			tinsert(buffs, value)
		end
	end

	if (C.CornerBuffs[C.MyClass]) then
		for key, value in pairs(C.CornerBuffs[C.MyClass]) do
			tinsert(buffs, value)
		end
	end

	if buffs then
		for key, spell in pairs(buffs) do
			local Icon = CreateFrame('Frame', nil, Auras)
			Icon.spellID = spell[1]
			Icon.anyUnit = spell[4]
			Icon:Size(6)
			Icon:SetPoint(spell[2], 0, 0)

			local Texture = Icon:CreateTexture(nil, 'OVERLAY')
			Texture:SetAllPoints(Icon)
			Texture:SetTexture(C.Assets.Textures.backdrop)

			if (spell[3]) then
				Texture:SetVertexColor(unpack(spell[3]))
			else
				Texture:SetVertexColor(0.8, 0.8, 0.8)
			end

			local Count = F.CreateFS(Icon, C.Assets.Fonts.Number, 11, 'OUTLINE')
			Count:SetPoint('CENTER', unpack(CornerBuffsAnchor[spell[2]]))
			Icon.count = Count

			Auras.icons[spell[1]] = Icon
		end
	end

	self.AuraWatch = Auras
end
