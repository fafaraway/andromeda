local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe



function module:AddQuakeTimer(self)
	local bar = CreateFrame('StatusBar', nil, self)
	bar:SetSize(cfg.quakeTimer_width, cfg.quakeTimer_height)
	F.CreateSB(bar, true, 0, 1, 0)
	bar:Hide()

	--bar.SpellName = F.CreateFS(bar, 'pixel', '', nil, nil, true, 'LEFT', 2, 0)
	bar.Text = F.CreateFS(bar, 'pixel', '', nil, nil, true, 'CENTER', 0, 0)
	module:createBarMover(bar, 'Quake Timer', 'QuakeTimerBar', {'CENTER', UIParent, 'CENTER', 0, 200})

	local icon = bar:CreateTexture(nil, 'ARTWORK')
	icon:SetSize(cfg.quakeTimer_height + 4, cfg.quakeTimer_height + 4)
	icon:SetPoint('RIGHT', bar, 'LEFT', -4, 0)
	icon:SetTexCoord(unpack(C.TexCoord))

	local iconBG = F.CreateBDFrame(icon)
	F.CreateSD(iconBG)
	
	bar.Icon = icon

	self.QuakeTimer = bar
end