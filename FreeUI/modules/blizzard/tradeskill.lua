local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('BLIZZARD')


local pairs, unpack, tinsert, select = pairs, unpack, tinsert, select
local GetSpellCooldown, GetSpellInfo, GetItemCooldown, GetItemCount, GetItemInfo = GetSpellCooldown, GetSpellInfo, GetItemCooldown, GetItemCount, GetItemInfo
local IsPassiveSpell, IsCurrentSpell, CastSpell, IsPlayerSpell = IsPassiveSpell, IsCurrentSpell, CastSpell, IsPlayerSpell
local GetProfessions, GetProfessionInfo, GetSpellBookItemInfo = GetProfessions, GetProfessionInfo, GetSpellBookItemInfo
local PlayerHasToy, C_ToyBox_IsToyUsable, C_ToyBox_GetToyInfo = PlayerHasToy, C_ToyBox.IsToyUsable, C_ToyBox.GetToyInfo
local C_TradeSkillUI_GetOnlyShowSkillUpRecipes, C_TradeSkillUI_SetOnlyShowSkillUpRecipes = C_TradeSkillUI.GetOnlyShowSkillUpRecipes, C_TradeSkillUI.SetOnlyShowSkillUpRecipes
local C_TradeSkillUI_GetOnlyShowMakeableRecipes, C_TradeSkillUI_SetOnlyShowMakeableRecipes = C_TradeSkillUI.GetOnlyShowMakeableRecipes, C_TradeSkillUI.SetOnlyShowMakeableRecipes

local BOOKTYPE_PROFESSION = BOOKTYPE_PROFESSION
local RUNEFORGING_ID = 53428
local PICK_LOCK = 1804
local CHEF_HAT = 134020
local THERMAL_ANVIL = 87216
local tabList = {}

local onlyPrimary = {
	[171] = true, -- Alchemy
	[202] = true, -- Engineering
	[182] = true, -- Herbalism
	[393] = true, -- Skinning
	[356] = true, -- Fishing
}

function BLIZZARD:UpdateProfessions()
	local prof1, prof2, _, fish, cook = GetProfessions()
	local profs = {prof1, prof2, fish, cook}

	if C.MyClass == 'DEATHKNIGHT' then
		BLIZZARD:TradeTabs_Create(nil, RUNEFORGING_ID)
	elseif C.MyClass == 'ROGUE' and IsPlayerSpell(PICK_LOCK) then
		BLIZZARD:TradeTabs_Create(nil, PICK_LOCK)
	end

	local isCook
	for _, prof in pairs(profs) do
		local _, _, _, _, numSpells, spelloffset, skillLine = GetProfessionInfo(prof)
		if skillLine == 185 then isCook = true end

		numSpells = onlyPrimary[skillLine] and 1 or numSpells
		if numSpells > 0 then
			for i = 1, numSpells do
				local slotID = i + spelloffset
				if not IsPassiveSpell(slotID, BOOKTYPE_PROFESSION) then
					local spellID = select(2, GetSpellBookItemInfo(slotID, BOOKTYPE_PROFESSION))
					if i == 1 then
						BLIZZARD:TradeTabs_Create(slotID, spellID)
					else
						BLIZZARD:TradeTabs_Create(nil, spellID)
					end
				end
			end
		end
	end

	if isCook and PlayerHasToy(CHEF_HAT) and C_ToyBox_IsToyUsable(CHEF_HAT) then
		BLIZZARD:TradeTabs_Create(nil, nil, CHEF_HAT)
	end
	if GetItemCount(THERMAL_ANVIL) > 0 then
		BLIZZARD:TradeTabs_Create(nil, nil, nil, THERMAL_ANVIL)
	end
end

function BLIZZARD:TradeTabs_Update()
	for _, tab in pairs(tabList) do
		local spellID = tab.spellID
		local itemID = tab.itemID

		if IsCurrentSpell(spellID) then
			tab:SetChecked(true)
			tab.cover:Show()
		else
			tab:SetChecked(false)
			tab.cover:Hide()
		end

		local start, duration
		if itemID then
			start, duration = GetItemCooldown(itemID)
		else
			start, duration = GetSpellCooldown(spellID)
		end
		if start and duration and duration > 1.5 then
			tab.CD:SetCooldown(start, duration)
		end
	end
end

function BLIZZARD:TradeTabs_Reskin()
	if not FREE_ADB.reskin_blizz then return end

	for _, tab in pairs(tabList) do
		tab:SetCheckedTexture(C.Assets.button_checked)
		tab:GetRegions():Hide()
		F.CreateBDFrame(tab)
		local texture = tab:GetNormalTexture()
		if texture then texture:SetTexCoord(unpack(C.TexCoord)) end
	end
end

function BLIZZARD:TradeTabs_OnClick()
	CastSpell(self.slotID, BOOKTYPE_PROFESSION)
end

local index = 1
function BLIZZARD:TradeTabs_Create(slotID, spellID, toyID, itemID)
	local name, _, texture
	if toyID then
		_, name, texture = C_ToyBox_GetToyInfo(toyID)
	elseif itemID then
		name, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
	else
		name, _, texture = GetSpellInfo(spellID)
	end

	local tab = CreateFrame('CheckButton', nil, TradeSkillFrame, 'SpellBookSkillLineTabTemplate, SecureActionButtonTemplate')
	tab.tooltip = name
	tab.slotID = slotID
	tab.spellID = spellID
	tab.itemID = toyID or itemID
	tab.type = (toyID and 'toy') or (itemID and 'item') or 'spell'
	if slotID then
		tab:SetScript('OnClick', BLIZZARD.TradeTabs_OnClick)
	else
		tab:SetAttribute('type', tab.type)
		tab:SetAttribute(tab.type, name)
	end
	tab:SetNormalTexture(texture)
	tab:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	tab:Show()

	tab.CD = CreateFrame('Cooldown', nil, tab, 'CooldownFrameTemplate')
	tab.CD:SetAllPoints()

	tab.cover = CreateFrame('Frame', nil, tab)
	tab.cover:SetAllPoints()
	tab.cover:EnableMouse(true)

	tab:SetPoint('TOPLEFT', TradeSkillFrame, 'TOPRIGHT', 3, -index*42)
	tinsert(tabList, tab)
	index = index + 1
end

function BLIZZARD:TradeTabs_FilterIcons()
	local buttonList = {
		[1] = {'Atlas:bags-greenarrow', TRADESKILL_FILTER_HAS_SKILL_UP, C_TradeSkillUI_GetOnlyShowSkillUpRecipes, C_TradeSkillUI_SetOnlyShowSkillUpRecipes},
		[2] = {'Interface\\RAIDFRAME\\ReadyCheck-Ready', CRAFT_IS_MAKEABLE, C_TradeSkillUI_GetOnlyShowMakeableRecipes, C_TradeSkillUI_SetOnlyShowMakeableRecipes},
	}

	local function filterClick(self)
		local value = self.__value
		if value[3]() then
			value[4](false)
			self.bg:SetBackdropBorderColor(0, 0, 0)
		else
			value[4](true)
			self.bg:SetBackdropBorderColor(1, .8, 0)
		end
	end

	local buttons = {}
	for index, value in pairs(buttonList) do
		local bu = CreateFrame('Button', nil, TradeSkillFrame, 'BackdropTemplate')
		bu:SetSize(22, 22)
		bu:SetPoint('RIGHT', TradeSkillFrame.FilterButton, 'LEFT', -5 - (index-1)*27, 0)
		F.PixelIcon(bu, value[1], true)
		F.AddTooltip(bu, 'ANCHOR_TOP', value[2])
		bu.__value = value
		bu:SetScript('OnClick', filterClick)

		buttons[index] = bu
	end

	local function updateFilterStatus()
		for index, value in pairs(buttonList) do
			if value[3]() then
				buttons[index].bg:SetBackdropBorderColor(1, .8, 0)
			else
				buttons[index].bg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end
	F:RegisterEvent('TRADE_SKILL_LIST_UPDATE', updateFilterStatus)
end

function BLIZZARD:TradeTabs_OnLoad()
	BLIZZARD:UpdateProfessions()

	BLIZZARD:TradeTabs_Reskin()
	BLIZZARD:TradeTabs_Update()
	F:RegisterEvent('TRADE_SKILL_SHOW', BLIZZARD.TradeTabs_Update)
	F:RegisterEvent('TRADE_SKILL_CLOSE', BLIZZARD.TradeTabs_Update)
	F:RegisterEvent('CURRENT_SPELL_CAST_CHANGED', BLIZZARD.TradeTabs_Update)

	BLIZZARD:TradeTabs_FilterIcons()
end

function BLIZZARD.TradeTabs_OnEvent(event, addon)
	if event == 'ADDON_LOADED' and addon == 'Blizzard_TradeSkillUI' then
		F:UnregisterEvent(event, BLIZZARD.TradeTabs_OnEvent)

		if InCombatLockdown() then
			F:RegisterEvent('PLAYER_REGEN_ENABLED', BLIZZARD.TradeTabs_OnEvent)
		else
			BLIZZARD:TradeTabs_OnLoad()
		end
	elseif event == 'PLAYER_REGEN_ENABLED' then
		F:UnregisterEvent(event, BLIZZARD.TradeTabs_OnEvent)
		BLIZZARD:TradeTabs_OnLoad()
	end
end

function BLIZZARD:TradeTabs()
	if not C.DB.blizzard.tradeskill_tabs then return end

	F:RegisterEvent('ADDON_LOADED', BLIZZARD.TradeTabs_OnEvent)
end

BLIZZARD:RegisterBlizz('TradeTabs', BLIZZARD.TradeTabs)

