local F, C, L = unpack(select(2, ...))
local GUI = F.GUI


local function ResetUrlBox(self)
	self:SetText(self.url)
	--self:HighlightText()
end

local function CreateUrlBox(parent, text, url, index)
	F.CreateFS(parent, C.Assets.Fonts.Regular, 14, nil, text, 'YELLOW', true, 'TOP', 0, -50 - (index-1) * 60)
	local box = F.CreateEditBox(parent, 250, 24)
	box:SetPoint('TOP', 0, -70 - (index-1) * 60)
	box.url = url
	ResetUrlBox(box)
	box:SetScript('OnTextChanged', ResetUrlBox)
	box:SetScript('OnCursorChanged', ResetUrlBox)
end

function GUI:CreateCreditsFrame(parent)
	local credit = CreateFrame('Frame', nil, parent)
	credit:SetSize(360, 200)
	credit:SetPoint('TOP', 0, -20)

	F.CreateFS(credit, C.Assets.Fonts.Bold, 14, nil, L.GUI.CREDITS.CREDITS, nil, true, 'TOP', 0, -10)
	local cll = F.SetGradient(credit, 'H', .7, .7, .7, 0, .5, 160, C.Mult)
	cll:SetPoint('TOP', -80, -32)
	local clr = F.SetGradient(credit, 'H', .7, .7, .7, .5, 0, 160, C.Mult)
	clr:SetPoint('TOP', 80, -32)

	F.CreateFS(credit, C.Assets.Fonts.Bold, 22, nil, L.GUI.CREDITS.PRIMARY, 'BLUE', true, 'TOP', 0, -50)
	F.CreateFS(credit, C.Assets.Fonts.Regular, 16, nil, L.GUI.CREDITS.SECONDARY, 'GREEN', true, 'TOP', 0, -90)

	local feedback = CreateFrame('Frame', nil, parent)
	feedback:SetSize(360, 200)
	feedback:SetPoint('TOP', 0, -260)

	F.CreateFS(feedback, C.Assets.Fonts.Bold, 14, nil, L.GUI.CREDITS.FEEDBACK, nil, true, 'TOP', 0, -10)
	local fll = F.SetGradient(feedback, 'H', .7, .7, .7, 0, .5, 160, C.Mult)
	fll:SetPoint('TOP', -80, -32)
	local flr = F.SetGradient(feedback, 'H', .7, .7, .7, .5, 0, 160, C.Mult)
	flr:SetPoint('TOP', 80, -32)

	CreateUrlBox(feedback, 'GitHub', 'https://github.com/Solor/FreeUI', 1)
	CreateUrlBox(feedback, 'Discord', 'https://discord.gg/Uu28KQq', 2)
end
