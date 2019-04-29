local _, ns = ...
local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg, oUF = F:GetModule('Unitframe'), C.unitframe, ns.oUF


local function OnUpdate(timer, elapsed)
	local timeLeft = timer.timeLeft - elapsed
	timer.remaining:SetText((timeLeft > 0) and module.FormatTime(timeLeft))
	timer.timeLeft = timeLeft
	local r, g, b = oUF:ColorGradient(timeLeft, timer.duration, 1, 0, 0, 1, 1, 0, 0, 1, 0)
	timer.border:SetBackdropBorderColor(r, g, b)
end

local function UpdateTimer(timer, duration, expiration, barID, auraID)
	local _, _, texture = GetSpellInfo(auraID)
	timer.icon:SetTexture(texture)
	timer.timeLeft = expiration - GetTime()
end

function module:AddPlayerBuffTimer(self)
	local timers = {}
	for i = 1, 2 do
		local button = CreateFrame('Button', nil, self)
		button:SetSize(32, 32)
		button:SetPoint("BOTTOMLEFT", self, "TOPLEFT", (i - 1) * (32 + 5), 65)

		local icon = button:CreateTexture(nil, 'BORDER')
		icon:SetTexCoord(unpack(C.TexCoord))
		icon:SetAllPoints()
		button.icon = icon

		button.border = F.CreateBDFrame(button)

		button.glow = F.CreateSD(button, .35)

		button.remaining = F.CreateFS(button, 'pixel', '', nil, nil, true, 'CENTER', 2, 0)

		button.UpdateTimer = UpdateTimer
		button:SetScript('OnUpdate', OnUpdate)

		timers[i] = button
	end

	self.PlayerBuffTimers = timers
end

