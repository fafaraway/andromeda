local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe




function UNITFRAME:RegisterDebuff(_, instID, _, spellID, level)
	local instName = EJ_GetInstanceInfo(instID)
	if not instName then print('Invalid instance ID: '..instID) return end

	if not C.RaidDebuffs[instName] then C.RaidDebuffs[instName] = {} end
	if level then
		if level > 6 then level = 6 end
	else
		level = 2
	end

	C.RaidDebuffs[instName][spellID] = level
end

local function buttonOnEnter(self)
	if not self.index then return end
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	GameTooltip:ClearLines()
	GameTooltip:SetUnitAura(self.__owner.unit, self.index, self.filter)
	GameTooltip:Show()
end

function UNITFRAME:AddRaidDebuffs(self)
	if not cfg.raid_debuffs then return end

	local bu = CreateFrame('Frame', nil, self)
	bu:Size(self:GetHeight() * .6)
	bu:SetPoint('CENTER')
	bu:SetFrameLevel(self.Health:GetFrameLevel() + 6)
	bu.bg = F.CreateBDFrame(bu)
	bu.glow = F.CreateSD(bu.bg, .35)
	bu:Hide()

	bu.icon = bu:CreateTexture(nil, 'ARTWORK')
	bu.icon:SetAllPoints()
	bu.icon:SetTexCoord(unpack(C.TexCoord))
	bu.count = F.CreateFS(bu, C.Assets.Fonts.Number, 11, 'OUTLINE', '', nil, nil, 'TOPRIGHT', 2, 4)
	bu.timer = F.CreateFS(bu, C.Assets.Fonts.Number, 11, 'OUTLINE', '', nil, nil, 'BOTTOMLEFT', 2, -4)

	if not cfg.raid_debuffs_click_through then
		bu:SetScript('OnEnter', buttonOnEnter)
		bu:SetScript('OnLeave', F.HideTooltip)
	end

	bu.ShowDispellableDebuff = true
	bu.ShowDebuffBorder = true
	bu.FilterDispellableDebuff = true

	bu.Debuffs = C.RaidDebuffs

	self.RaidDebuffs = bu
end