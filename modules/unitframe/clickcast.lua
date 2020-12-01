local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UNITFRAME')

-- #TODO need cleanup

local DB
ClickCastFrames = _G.ClickCastFrames or {}

local SpellBinder = CreateFrame('Frame', 'SpellBinder', SpellBookFrame, 'ButtonFrameTemplate')
SpellBinder:SetPoint('TOPLEFT', SpellBookFrame, 'TOPRIGHT', 40, 0)
SpellBinder:SetWidth(300)
local header = CreateFrame('Frame', nil, SpellBinder)
header:SetSize(260, 20)
header:SetPoint('TOP')
local text = F.CreateFS(header, C.Assets.Fonts.Regular, 12, true, L['UNITFRAME_CLICK_CAST_BINDING'], 'YELLOW', nil, 'TOP', 0, -10)
local tips = L['UNITFRAME_CLICK_CAST_DESC']
header.title = L['UNITFRAME_CLICK_CAST_TIP']
F.AddTooltip(header, 'ANCHOR_TOP', tips)



SpellBinder:Hide()

SpellBinder.sbOpen = false
SpellBinder.spellbuttons = {}


local ScrollSpells = CreateFrame('ScrollFrame', 'SpellBinderScrollFrameSpellList', _G['SpellBinder'], 'UIPanelScrollFrameTemplate')
ScrollSpells:SetPoint('TOPLEFT', _G['SpellBinder'], 10, -30)
ScrollSpells:SetPoint('BOTTOMRIGHT', _G['SpellBinder'], -30, 10)
ScrollSpells.child = CreateFrame('Frame', 'SpellBinderScrollFrameSpellListChild', ScrollSpells)
ScrollSpells.child:SetSize(270, 300)
ScrollSpells:SetScrollChild(ScrollSpells.child)


SpellBinder.makeSpellsList = function(_, delete)
	local oldb
	local scroll = ScrollSpells.child

	if delete then
		local i = 1
		while _G['SpellBinder'..i..'_cbs'] do
			_G['SpellBinder'..i..'_fs']:SetText('')
			_G['SpellBinder'..i..'_texture']:SetTexture(nil)
			_G['SpellBinder'..i..'_cbs'].checked = false
			_G['SpellBinder'..i..'_cbs']:ClearAllPoints()
			_G['SpellBinder'..i..'_cbs']:Hide()
			i = i + 1
		end
	end

	for i, spell in ipairs(DB.spells) do
		local v = spell.spell
		if v then
			local bf = _G['SpellBinder'..i..'_cbs'] or CreateFrame('Button', 'SpellBinder'..i..'_cbs', scroll, 'BackdropTemplate')
			spell.checked = spell.checked or false

			if i == 1 then
				bf:SetPoint('TOPLEFT', scroll, 'TOPLEFT', 10, -30)
				bf:SetPoint('BOTTOMRIGHT', scroll, 'TOPRIGHT', -20, -30)
			else
				bf:SetPoint('TOPLEFT', oldb, 'BOTTOMLEFT', 0, -40)
				bf:SetPoint('BOTTOMRIGHT', oldb, 'BOTTOMRIGHT', 0, -40)
			end

			bf:EnableMouse(true)

			bf.tex = bf.tex or bf:CreateTexture('SpellBinder'..i..'_texture', 'OVERLAY')
			bf.tex:SetSize(32, 32)
			bf.tex:SetPoint('LEFT')
			bf.tex:SetTexture(spell.texture)

			bf.tex:SetTexCoord(unpack(C.TexCoord))
			F.CreateBDFrame(bf.tex)


			bf.delete = bf.delete or CreateFrame('Button', 'SpellBinder'..i..'_delete', bf)
			bf.delete:SetSize(16, 16)
			bf.delete:SetPoint('RIGHT')
			bf.delete:SetNormalTexture('Interface\\BUTTONS\\UI-GroupLoot-Pass-Up')
			bf.delete:GetNormalTexture():SetVertexColor(0.8, 0, 0)
			bf.delete:SetPushedTexture('Interface\\BUTTONS\\UI-GroupLoot-Pass-Up')
			bf.delete:SetHighlightTexture('Interface\\BUTTONS\\UI-GroupLoot-Pass-Up')
			bf.delete:SetScript('OnClick', function()
				for j, k in ipairs(DB.spells) do
					if k ~= spell then
						k.checked = false
						_G['SpellBinder'..j..'_cbs']:SetBackdropColor(0, 0, 0, 0)
					end
				end
				spell.checked = not spell.checked
				SpellBinder.DeleteSpell()
			end)

			bf:SetScript('OnEnter', function(self) bf.delete:GetNormalTexture():SetVertexColor(1, 0, 0) self:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'}) self:SetBackdropColor(0.2, 0.2, 0.2, 0.7) end)
			bf:SetScript('OnLeave', function(self) bf.delete:GetNormalTexture():SetVertexColor(0.8, 0, 0) self:SetBackdrop(nil) end)

			bf.fs = bf.fs or bf:CreateFontString('SpellBinder'..i..'_fs', 'OVERLAY', 'GameFontNormal')
			bf.fs:SetText(spell.modifier..spell.origbutton)
			bf.fs:SetPoint('RIGHT', bf.delete, 'LEFT', -4, 0)

			if GetSpellInfo(v) then
				bf:SetAlpha(1)
				for frame in pairs(ClickCastFrames) do
					local f
					if frame and type(frame) == 'table' then f = frame:GetName() end
					if f and SpellBinder.frames[frame] then
						if _G[f]:CanChangeAttribute() or _G[f]:CanChangeProtectedState() then
							if _G[f]:GetAttribute(spell.modifier..'type'..spell.button) ~= 'menu' then
								_G[f]:RegisterForClicks('AnyDown')

								if spell.button:find('harmbutton') then
									_G[f]:SetAttribute(spell.modifier..spell.button, spell.spell)
									_G[f]:SetAttribute(spell.modifier..'type-'..spell.spell, 'spell')
									_G[f]:SetAttribute(spell.modifier..'spell-'..spell.spell, spell.spell)

									DB.keys[spell.modifier..spell.button] = spell.spell
									DB.keys[spell.modifier..'type-'..spell.spell] = 'spell'
									DB.keys[spell.modifier..'spell-'..spell.spell] = spell.spell
								else
									_G[f]:SetAttribute(spell.modifier..'type'..spell.button, 'spell')
									_G[f]:SetAttribute(spell.modifier..'spell'..spell.button, spell.spell)

									DB.keys[spell.modifier..'type'..spell.button] = 'spell'
									DB.keys[spell.modifier..'spell'..spell.button] = spell.spell
								end
							end
						end
					end
				end
			else
				bf:SetAlpha(0.3)
			end

			bf:Show()
			oldb = bf
		end
	end
end

SpellBinder.makeFramesList = function()
	for frame in pairs(ClickCastFrames) do
		local v
		if frame and type(frame) == 'table' then v = frame:GetName() end

		if v ~= 'oUF_Target' and v ~= 'oUF_Player' then SpellBinder.frames[frame] = SpellBinder.frames[frame] or true end
	end
end

SpellBinder.ToggleButtons = function()
	for i = 1, SPELLS_PER_PAGE do
		SpellBinder.spellbuttons[i]:Hide()
		if SpellBinder.sbOpen and SpellBookFrame.bookType ~= BOOKTYPE_PROFESSION then
			local slot = SpellBook_GetSpellBookSlot(SpellBinder.spellbuttons[i]:GetParent())

			if slot then
				local spellname = GetSpellBookItemName(slot, SpellBookFrame.bookType)

				if spellname then
					SpellBinder.spellbuttons[i]:Show()
					AutoCastShine_AutoCastStart(SpellBinder.spellbuttons[i])
				end
			end
		end
	end

	SpellBinder:makeFramesList()
	SpellBinder:makeSpellsList(true)

	if SpellBinder:IsVisible() then
		SpellBinder.OpenButton:SetChecked(true)
	else
		SpellBinder.OpenButton:SetChecked(false)
	end
end

SpellBinder.DeleteSpell = function()
	for i, spell in ipairs(DB.spells) do
		if spell.checked then
			for frame in pairs(ClickCastFrames) do
				local f
				if frame and type(frame) == 'table' then f = frame:GetName() end
				if f then
					if _G[f]:CanChangeAttribute() or _G[f]:CanChangeProtectedState() then
						if _G[f]:GetAttribute(spell.modifier..'type'..spell.button) ~= 'menu' then
							if spell.button:find('harmbutton') then
								_G[f]:SetAttribute(spell.modifier..spell.button, nil)
								_G[f]:SetAttribute(spell.modifier..'type-'..spell.spell, nil)
								_G[f]:SetAttribute(spell.modifier..'spell-'..spell.spell, nil)
							else
								_G[f]:SetAttribute(spell.modifier..'type'..spell.button, nil)
								_G[f]:SetAttribute(spell.modifier..'spell'..spell.button, nil)
							end
						end
					end
				end
			end
			tremove(DB.spells, i)
		end
	end
	SpellBinder:makeSpellsList(true)
end

local addSpell = function(self, button)
	if SpellBinder.sbOpen then
		local slot = SpellBook_GetSpellBookSlot(self:GetParent())
		local spellname = GetSpellBookItemName(slot, SpellBookFrame.bookType)
		local texture = GetSpellBookItemTexture(slot, SpellBookFrame.bookType)

		if spellname ~= 0 and ((SpellBookFrame.bookType == BOOKTYPE_PET) or (SpellBookFrame.selectedSkillLine > 1)) then
			local originalbutton = button
			local modifier = ''

			if IsShiftKeyDown() then modifier = 'Shift-'..modifier end
			if IsControlKeyDown() then modifier = 'Ctrl-'..modifier end
			if IsAltKeyDown() then modifier = 'Alt-'..modifier end

			if IsHarmfulSpell(slot, SpellBookFrame.bookType) then
				button = format('%s%d', 'harmbutton', SecureButton_GetButtonSuffix(button))
				originalbutton = '|cffff2222(harm)|r '..originalbutton
			else
				button = SecureButton_GetButtonSuffix(button)
			end

			for _, v in pairs(DB.spells) do if v.spell == spellname then return end end

			tinsert(DB.spells, {['id'] = slot, ['modifier'] = modifier, ['button'] = button, ['spell'] = spellname, ['texture'] = texture, ['origbutton'] = originalbutton,})
			SpellBinder:makeSpellsList(false)
		end
	end
end

SpellBinder.UpdateAll = function()
	if InCombatLockdown() then
		SpellBinder:RegisterEvent('PLAYER_REGEN_ENABLED')

		return
	end

	SpellBinder:makeFramesList()
	SpellBinder:makeSpellsList(true)
end


function UNITFRAME:ClickCast()
	if not C.DB.unitframe.enable then return end
	if not C.DB.unitframe.enable_group then return end
	if not C.DB.unitframe.group_click_cast then return end


	SpellBinder.OpenButton = CreateFrame('CheckButton', 'SpellBinderOpenButton', _G['SpellBookSkillLineTab1'], 'SpellBookSkillLineTabTemplate')

	hooksecurefunc('SpellBookFrame_Update', function()
		if SpellBinder.sbOpen then
			SpellBinder:ToggleButtons()
		end
	end)

	SpellBinder.OpenButton:SetScript('OnShow', function(self)
		if SpellBinder:IsVisible() then self:SetChecked(true) end
		local num = GetNumSpellTabs()
		local lastTab = _G['SpellBookSkillLineTab'..num]

		self:ClearAllPoints()
		self:SetPoint('TOPLEFT', lastTab, 'BOTTOMLEFT', 0, -40)

		self:SetScript('OnEnter', function(self) GameTooltip:ClearLines() GameTooltip:SetOwner(self, 'ANCHOR_RIGHT') GameTooltip:AddLine(L_MISC_BINDER_OPEN) GameTooltip:Show() end)
		self:SetScript('OnLeave', function() GameTooltip:Hide() end)
	end)

	SpellBinder.OpenButton:SetScript('OnClick', function()
		if InCombatLockdown() then SpellBinder:Hide() return end
		if SpellBinder:IsVisible() then
			SpellBinder:Hide()
			SpellBinder.sbOpen = false
		else
			SpellBinder:Show()
			SpellBinder.sbOpen = true
		end
		SpellBinder:ToggleButtons()
	end)
	SpellBinder.OpenButton:Show()

	hooksecurefunc(SpellBookFrame, 'Hide', function()
		SpellBinder:Hide()
		SpellBinder.sbOpen = false
		SpellBinder:ToggleButtons()
	end)

	hooksecurefunc(SpellBookFrame, 'Show', function()
		local tab = SpellBinder.OpenButton
		tab:SetNormalTexture('Interface\\ICONS\\Spell_Holy_Chastise')
		F.ReskinTab(tab)

		local nt = tab:GetNormalTexture()
		if nt then
			nt:SetTexCoord(unpack(C.TexCoord))
		end

		if not tab.styled then
			tab:GetRegions():Hide()
			tab:SetCheckedTexture(C.Assets.button_checked)
			tab:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			F.CreateBDFrame(tab)

			tab.styled = true
		end
	end)


	DB = FREE_SPELLBINDING
	DB.spells = DB.spells or {}
	DB.keys = DB.keys or {}
	SpellBinder.frames = SpellBinder.frames or {}
	SpellBinder:makeFramesList()
	SpellBinder:makeSpellsList(true)

	for i = 1, SPELLS_PER_PAGE do
		local parent = _G['SpellButton'..i]
		local button = CreateFrame('Button', 'SpellBinderFakeButton'..i, parent, 'AutoCastShineTemplate')
		button:SetID(parent:GetID())
		button:RegisterForClicks('AnyDown')
		button:SetAllPoints(parent)
		button:SetScript('OnClick', addSpell)

		button:Hide()
		SpellBinder.spellbuttons[i] = button
	end


	SpellBinder:RegisterEvent('PLAYER_ENTERING_WORLD')
	SpellBinder:RegisterEvent('GROUP_ROSTER_UPDATE')
	SpellBinder:RegisterEvent('ZONE_CHANGED')
	SpellBinder:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	SpellBinder:RegisterEvent('PLAYER_TALENT_UPDATE')
	SpellBinder:SetScript('OnEvent', function(self, event, ...)
		if event == 'PLAYER_ENTERING_WORLD' or event == 'GROUP_ROSTER_UPDATE' or event == 'ZONE_CHANGED' or event == 'ZONE_CHANGED_NEW_AREA' then
			C_Timer.After(0.5, function() SpellBinder.UpdateAll() end)
		elseif event == 'PLAYER_REGEN_ENABLED' then
			SpellBinder.UpdateAll()
			self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		elseif event == 'PLAYER_TALENT_UPDATE' then
			if DB then
				for _, spell in ipairs(DB.spells) do
					for frame in pairs(ClickCastFrames) do
						local f
						if frame and type(frame) == 'table' then f = frame:GetName() end
						if f then
							if _G[f]:CanChangeAttribute() or _G[f]:CanChangeProtectedState() then
								if _G[f]:GetAttribute(spell.modifier..'type'..spell.button) ~= 'menu' then
									if spell.button:find('harmbutton') then
										_G[f]:SetAttribute(spell.modifier..spell.button, nil)
										_G[f]:SetAttribute(spell.modifier..'type-'..spell.spell, nil)
										_G[f]:SetAttribute(spell.modifier..'spell-'..spell.spell, nil)
									else
										_G[f]:SetAttribute(spell.modifier..'type'..spell.button, nil)
										_G[f]:SetAttribute(spell.modifier..'spell'..spell.button, nil)
									end
								end
							end
						end
					end
				end

				SpellBinder:makeSpellsList(true)
			end
		end
	end)


	SpellBinderCloseButton:Hide()
	F.ReskinPortraitFrame(SpellBinder)
	F.CreateBDFrame(ScrollSpells, .3)
	F.ReskinScroll(SpellBinderScrollFrameSpellListScrollBar)
end
