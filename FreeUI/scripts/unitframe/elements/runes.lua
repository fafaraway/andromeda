local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe


local function PostUpdateRune(element, runemap)
	local maxRunes = 6
	for index, runeID in next, runemap do
		local Bar = element[index]
		local runeReady = select(3, GetRuneCooldown(runeID))
		local maxWidth, gap = cfg.player_width, 3
		if Bar:IsShown() and not runeReady then
			Bar:SetAlpha(.45)
		else
			Bar:SetAlpha(1)
		end

		Bar:SetWidth((maxWidth - (maxRunes - 1) * gap) / maxRunes)

		if(index > 1) then
			Bar:ClearAllPoints()
			Bar:SetPoint('LEFT', element[index - 1], 'RIGHT', gap, 0)
		end
	end
end

function module:AddRunes(self)
	local runes = {}
	local maxRunes = 6

	for index = 1, maxRunes do
		local Bar = CreateFrame('StatusBar', nil, self)
		Bar:SetHeight(cfg.classPower_height)
		Bar:SetStatusBarTexture(C.media.sbTex)

		F.CreateBDFrame(Bar)

		if(index == 1) then
			Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
		end

		local function MoveRunesBar()
			if(index == 1) then
				if self.AlternativePower:IsShown() then
					Bar:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', 0,-3)
				else
					Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
				end
			end
		end
		self.AlternativePower:HookScript('OnShow', MoveRunesBar)
		self.AlternativePower:HookScript('OnHide', MoveRunesBar)
		MoveRunesBar()

		local Background = Bar:CreateTexture(nil, 'BORDER')
		Background:SetAllPoints()
		Bar.bg = Background

		runes[index] = Bar
	end

	runes.colorSpec = true
	runes.sortOrder = 'asc'
	runes.PostUpdate = PostUpdateRune
	self.Runes = runes
end