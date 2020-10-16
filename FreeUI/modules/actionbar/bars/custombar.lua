local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR


function ACTIONBAR:CreateCustomBar(anchor)
	local padding = FreeDB.actionbar.custom_bar_padding
	local margin = FreeDB.actionbar.custom_bar_margin
	local size = FreeDB.actionbar.custom_bar_button_size
	local num = 12
	local name = 'FreeUI_CustomBar'
	local page = 8

	local frame = CreateFrame('Frame', name, UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(num*size + (num-1)*margin + 2*padding)
	frame:SetHeight(size + 2*padding)
	frame:SetPoint(unpack(anchor))
	frame.mover = F.Mover(frame, L['ACTIONBAR_CUSTOM_BAR'], 'CustomBar', anchor)
	frame.buttons = {}

	RegisterStateDriver(frame, 'visibility', '[petbattle] hide; show')
	RegisterStateDriver(frame, 'page', page)

	local buttonList = {}
	for i = 1, num do
		local button = CreateFrame('CheckButton', '$parentButton'..i, frame, 'ActionBarButtonTemplate')
		button:SetSize(size, size)
		button.id = (page-1)*12 + i
		button.isCustomButton = true
		button.commandName = L['ACTIONBAR_CUSTOM_BAR']..i
		button:SetAttribute('action', button.id)
		frame.buttons[i] = button
		tinsert(buttonList, button)
		tinsert(ACTIONBAR.buttons, button)
	end

	if FreeDB.actionbar.custom_bar and FreeDB.actionbar.custom_bar_fade then
		frame.fader = {
			enable = FreeDB.actionbar.custom_bar_fade,
			fadeInAlpha = FreeDB.actionbar.custom_bar_fade_in_alpha,
			fadeOutAlpha = FreeDB.actionbar.custom_bar_fade_out_alpha,
			arena = FreeDB.actionbar.custom_bar_fade_arena,
			instance = FreeDB.actionbar.custom_bar_fade_instance,
			combat = FreeDB.actionbar.custom_bar_fade_combat,
			target = FreeDB.actionbar.custom_bar_fade_target,
			hover = FreeDB.actionbar.custom_bar_fade_hover,
		}

		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, frame.fader)
	end

	ACTIONBAR:UpdateCustomBar()
end

function ACTIONBAR:UpdateCustomBar()
	local frame = _G.FreeUI_CustomBar
	if not frame then return end

	local padding = FreeDB.actionbar.custom_bar_padding
	local margin = FreeDB.actionbar.custom_bar_margin
	local size = FreeDB.actionbar.custom_bar_button_size
	local num = FreeDB.actionbar.custom_bar_button_number
	local perRow = FreeDB.actionbar.custom_bar_button_per_row
	for i = 1, num do
		local button = frame.buttons[i]
		button:SetSize(size, size)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPLEFT', frame, padding, -padding)
		elseif mod(i-1, perRow) ==  0 then
			button:SetPoint('TOP', frame.buttons[i-perRow], 'BOTTOM', 0, -margin)
		else
			button:SetPoint('LEFT', frame.buttons[i-1], 'RIGHT', margin, 0)
		end
		button:SetAttribute('statehidden', false)
		button:Show()
	end

	for i = num+1, 12 do
		local button = frame.buttons[i]
		button:SetAttribute('statehidden', true)
		button:Hide()
	end

	local column = min(num, perRow)
	local rows = ceil(num/perRow)
	frame:SetWidth(column*size + (column-1)*margin + 2*padding)
	frame:SetHeight(size*rows + (rows-1)*margin + 2*padding)
	frame.mover:SetSize(frame:GetSize())
end

function ACTIONBAR:CustomBar()
	if FreeDB.inventory.custom_bar then
		ACTIONBAR:CreateCustomBar({'BOTTOM', UIParent, 'BOTTOM', 0, 140})
	end
end
