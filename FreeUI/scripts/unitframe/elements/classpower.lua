local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe


local function PostUpdateClassPower(element, power, maxPower, diff, powerType)
	if(diff) then
		for index = 1, maxPower do
			local Bar = element[index]
			local maxWidth, gap = cfg.player_width, 3

			Bar:SetWidth((maxWidth - (maxPower - 1) * gap) / maxPower)

			if(index > 1) then
				Bar:ClearAllPoints()
				Bar:SetPoint('LEFT', element[index - 1], 'RIGHT', gap, 0)
			end
		end
	end
end

local function UpdateClassPowerColor(element)
	local _, playerClass = UnitClass('player')
	local r, g, b = 1, 1, 2/5
	if(not UnitHasVehicleUI('player')) then
		if(playerClass == 'MONK') then
			r, g, b = 0, 4/5, 3/5
		elseif(playerClass == 'WARLOCK') then
			r, g, b = 2/3, 1/3, 2/3
		elseif(playerClass == 'PALADIN') then
			r, g, b = 238/255, 220/255, 127/255
		elseif(playerClass == 'MAGE') then
			r, g, b = 5/6, 1/2, 5/6
		elseif(playerClass == 'ROGUE') then
			r, g, b = 221/255, 0, 55/255
		end
	end

	for index = 1, #element do
		local Bar = element[index]
		Bar:SetStatusBarColor(r, g, b)
		Bar.bg:SetBackdropColor(r * 1/3, g * 1/3, b * 1/3)
	end
end

function module:AddClassPower(self)
	local classPower = {}
	classPower.UpdateColor = UpdateClassPowerColor
	classPower.PostUpdate = PostUpdateClassPower

	for index = 1, 6 do 
		local Bar = CreateFrame('StatusBar', nil, self)
		Bar:SetHeight(cfg.classPower_height)
		Bar:SetStatusBarTexture(C.media.sbTex)
		Bar:SetBackdropColor(0, 0, 0)

		Bar.bg = F.CreateBDFrame(Bar)

		if(index == 1) then
			Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
		end

		local function MoveClassPowerBar()
			if(index == 1) then
				if self.AlternativePower:IsShown() then
					Bar:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', 0,-3)
				else
					Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
				end
			end
		end
		self.AlternativePower:HookScript('OnShow', MoveClassPowerBar)
		self.AlternativePower:HookScript('OnHide', MoveClassPowerBar)
		MoveClassPowerBar()

		classPower[index] = Bar	
	end

	self.ClassPower = classPower
end