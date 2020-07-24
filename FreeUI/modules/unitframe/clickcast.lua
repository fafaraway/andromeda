local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe

if not cfg.enable_module then return end
if not cfg.click_cast then return end

local SpellBinder = CreateFrame('Frame', 'SpellBinder', SpellBookFrame, 'ButtonFrameTemplate')
SpellBinder:SetPoint('TOPLEFT', SpellBookFrame, 'TOPRIGHT', 40, 0)
SpellBinder:SetWidth(300)
SpellBinder.title = F.CreateFS(SpellBinder, C.Assets.Fonts.Normal, 14, true, L['UNITFRAME_SPELL_BINDER'], 'YELLOW', nil, 'TOP', 0, -20)

SpellBinderCloseButton:SetPoint('TOPRIGHT', self, -6, -16)
SpellBinder:Hide()

SpellBinder.sbOpen = false
SpellBinder.spellbuttons = {}

local DB
ClickCastFrames = _G.ClickCastFrames or {}
for _, v in pairs({
	'PlayerFrame', 'PetFrame',
	-- Party members
	'PartyMemberFrame1', 'PartyMemberFrame2', 'PartyMemberFrame3', 'PartyMemberFrame4', 'PartyMemberFrame5',
	-- Party pets
	'PartyMemberFrame1PetFrame', 'PartyMemberFrame2PetFrame', 'PartyMemberFrame3PetFrame', 'PartyMemberFrame4PetFrame', 'PartyMemberFrame5PetFrame',
	-- Compact party member frame
	'CompactPartyFrameMemberSelf', 'CompactPartyFrameMemberSelfBuff1', 'CompactPartyFrameMemberSelfBuff2', 'CompactPartyFrameMemberSelfBuff3', 'CompactPartyFrameMemberSelfDebuff1', 'CompactPartyFrameMemberSelfDebuff2', 'CompactPartyFrameMemberSelfDebuff3',
	'CompactPartyFrameMember1Buff1', 'CompactPartyFrameMember1Buff2', 'CompactPartyFrameMember1Buff3', 'CompactPartyFrameMember1Debuff1', 'CompactPartyFrameMember1Debuff2', 'CompactPartyFrameMember1Debuff3',
	'CompactPartyFrameMember2Buff1', 'CompactPartyFrameMember2Buff2', 'CompactPartyFrameMember2Buff3', 'CompactPartyFrameMember2Debuff1', 'CompactPartyFrameMember2Debuff2', 'CompactPartyFrameMember2Debuff3',
	'CompactPartyFrameMember3Buff1', 'CompactPartyFrameMember3Buff2', 'CompactPartyFrameMember3Buff3', 'CompactPartyFrameMember3Debuff1', 'CompactPartyFrameMember3Debuff2', 'CompactPartyFrameMember3Debuff3',
	'CompactPartyFrameMember4Buff1', 'CompactPartyFrameMember4Buff2', 'CompactPartyFrameMember4Buff3', 'CompactPartyFrameMember4Debuff1', 'CompactPartyFrameMember4Debuff2', 'CompactPartyFrameMember4Debuff3',
	'CompactPartyFrameMember5Buff1', 'CompactPartyFrameMember5Buff2', 'CompactPartyFrameMember5Buff3', 'CompactPartyFrameMember5Debuff1', 'CompactPartyFrameMember5Debuff2', 'CompactPartyFrameMember5Debuff3',
	-- Target and focus frames
	'TargetFrame', 'TargetFrameToT',
	'FocusFrame', 'FocusFrameToT',
	-- Boss and arena frames
	'Boss1TargetFrame', 'Boss2TargetFrame', 'Boss3TargetFrame', 'Boss4TargetFrame',
	'ArenaEnemyFrame1', 'ArenaEnemyFrame2', 'ArenaEnemyFrame3', 'ArenaEnemyFrame4', 'ArenaEnemyFrame5',
}) do
	if _G[v] then ClickCastFrames[_G[v]] = true end
end

hooksecurefunc('CreateFrame', function(_, name, _, template)
	if template and template:find('SecureUnitButtonTemplate') then
		ClickCastFrames[_G[name]] = true
	end
end)

hooksecurefunc('CompactUnitFrame_SetUpFrame', function(frame)
	if frame.IsForbidden and frame:IsForbidden() then
		return
	end
	if frame and frame.GetName and frame:GetName():match('^NamePlate') then
		return
	end
	ClickCastFrames[frame] = true
end)

local ScrollSpells = CreateFrame('ScrollFrame', 'SpellBinderScrollFrameSpellList', _G['SpellBinderInset'], 'UIPanelScrollFrameTemplate')
ScrollSpells.child = CreateFrame('Frame', 'SpellBinderScrollFrameSpellListChild', ScrollSpells)
ScrollSpells:SetPoint('TOPLEFT', _G['SpellBinderInset'], 'TOPLEFT', 10, -5)
ScrollSpells:SetPoint('BOTTOMRIGHT', _G['SpellBinderInset'], 'BOTTOMRIGHT', -20, 5)
ScrollSpells:SetScrollChild(ScrollSpells.child)


SpellBinder.makeSpellsList = function(_, scroll, delete)
	local oldb
	scroll:SetPoint('TOPLEFT')
	scroll:SetSize(270, 300)

	if delete then
		local i = 1
		while _G[i..'_cbs'] do
			_G[i..'_fs']:SetText('')
			_G[i..'_texture']:SetTexture(nil)
			_G[i..'_cbs'].checked = false
			_G[i..'_cbs']:ClearAllPoints()
			_G[i..'_cbs']:Hide()
			i = i + 1
		end
	end

	for i, spell in ipairs(DB.spells) do
		local v = spell.spell
		if v then
			local bf = _G[i..'_cbs'] or CreateFrame('Button', i..'_cbs', scroll)
			spell.checked = spell.checked or false

			if i == 1 then
				bf:SetPoint('TOPLEFT', scroll, 'TOPLEFT', 10, -10)
				bf:SetPoint('BOTTOMRIGHT', scroll, 'TOPRIGHT', -10, -34)
			else
				bf:SetPoint('TOPLEFT', oldb, 'BOTTOMLEFT', 0, -20)
				bf:SetPoint('BOTTOMRIGHT', oldb, 'BOTTOMRIGHT', 0, -44)
			end

			bf:EnableMouse(true)

			bf.tex = bf.tex or bf:CreateTexture(i..'_texture', 'OVERLAY')
			bf.tex:SetSize(32, 32)
			bf.tex:SetPoint('LEFT')
			bf.tex:SetTexture(spell.texture)

			bf.tex:SetTexCoord(unpack(C.TexCoord))
			F.CreateBDFrame(bf.tex)


			bf.delete = bf.delete or CreateFrame('Button', i..'_delete', bf)
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
						_G[j..'_cbs']:SetBackdropColor(0, 0, 0, 0)
					end
				end
				spell.checked = not spell.checked
				SpellBinder.DeleteSpell()
			end)

			bf:SetScript('OnEnter', function(self) bf.delete:GetNormalTexture():SetVertexColor(1, 0, 0) self:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'}) self:SetBackdropColor(0.2, 0.2, 0.2, 0.7) end)
			bf:SetScript('OnLeave', function(self) bf.delete:GetNormalTexture():SetVertexColor(0.8, 0, 0) self:SetBackdrop(nil) end)

			bf.fs = bf.fs or bf:CreateFontString(i..'_fs', 'OVERLAY', 'GameFontNormal')
			bf.fs:SetText(spell.modifier..spell.origbutton)
			bf.fs:SetPoint('RIGHT', bf.delete, 'LEFT', -4, 0)

			if GetSpellInfo(v) then
				bf:SetAlpha(1)
				for frame in pairs(ClickCastFrames) do
					local f
					if frame and type(frame) == 'table' then f = frame:GetName() end
					if f and DB.frames[frame] then
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
		if cfg.click_cast_filter ~= true then
			if v then DB.frames[frame] = DB.frames[frame] or true end
		else
			if v ~= 'oUF_Target' and v ~= 'oUF_Player' then DB.frames[frame] = DB.frames[frame] or true end
		end
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
	SpellBinder:makeSpellsList(ScrollSpells.child, true)
	if SpellBinder:IsVisible() then SpellBinder.OpenButton:SetChecked(true) else SpellBinder.OpenButton:SetChecked(false) end
end

hooksecurefunc('SpellBookFrame_Update', function()
	if SpellBinder.sbOpen then
		SpellBinder:ToggleButtons()
	end
end)

SpellBinder.OpenButton = CreateFrame('CheckButton', 'SpellBinderOpenButton', _G['SpellBookSkillLineTab1'], 'SpellBookSkillLineTabTemplate')



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

_G['SpellBinderCloseButton']:SetScript('OnClick', function(self)
	SpellBinder:Hide()
	SpellBinder.sbOpen = false
	SpellBinder:ToggleButtons()
end)

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
		tab:SetCheckedTexture(C.Assets.Textures.check)
		tab:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		F.CreateBDFrame(tab)

		tab.styled = true
	end
end)

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
	SpellBinder:makeSpellsList(ScrollSpells.child, true)
end

local addSpell = function(self, button)
	if SpellBinder.sbOpen then
		local slot = SpellBook_GetSpellBookSlot(self:GetParent())
		local spellname = GetSpellBookItemName(slot, SpellBookFrame.bookType)
		local texture = GetSpellBookItemTexture(slot, SpellBookFrame.bookType)

		if spellname ~= 0 and ((SpellBookFrame.bookType == BOOKTYPE_PET) or (SpellBookFrame.selectedSkillLine > 1)) then
			local originalbutton = button
			local modifier = ''

			--if IsShiftKeyDown() then modifier = 'Shift-'..modifier end
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
			SpellBinder:makeSpellsList(ScrollSpells.child, false)
		end
	end
end

SpellBinder.UpdateAll = function()
	if InCombatLockdown() then
		SpellBinder:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	SpellBinder:makeFramesList()
	SpellBinder:makeSpellsList(ScrollSpells.child, true)
end


SpellBinder:RegisterEvent('PLAYER_LOGIN')
SpellBinder:RegisterEvent('PLAYER_ENTERING_WORLD')
SpellBinder:RegisterEvent('GROUP_ROSTER_UPDATE')
SpellBinder:RegisterEvent('ZONE_CHANGED')
SpellBinder:RegisterEvent('ZONE_CHANGED_NEW_AREA')
SpellBinder:RegisterEvent('PLAYER_TALENT_UPDATE')
SpellBinder:SetScript('OnEvent', function(self, event, ...)
	if event == 'PLAYER_LOGIN' then
		DB = FreeUIConfig['click_cast']
		DB.spells = DB.spells or {}
		DB.frames = DB.frames or {}
		DB.keys = DB.keys or {}
		SpellBinder:makeFramesList()
		SpellBinder:makeSpellsList(ScrollSpells.child, true)

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

		self:UnregisterEvent('PLAYER_LOGIN')
	elseif event == 'PLAYER_ENTERING_WORLD' or event == 'GROUP_ROSTER_UPDATE' or event == 'ZONE_CHANGED' or event == 'ZONE_CHANGED_NEW_AREA' then
		C_Timer.After(0.5, function() SpellBinder.UpdateAll() end)
	elseif event == "PLAYER_REGEN_ENABLED" then
		SpellBinder.UpdateAll()
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
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
			SpellBinder:makeSpellsList(ScrollSpells.child, true)
		end
	end
end)

F:RegisterEvent("PLAYER_ENTERING_WORLD", function()
	F.ReskinPortraitFrame(SpellBinder)
	F.ReskinScroll(SpellBinderScrollFrameSpellListScrollBar)
end)