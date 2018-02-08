local F, C = unpack(select(2, ...))

local _G = _G

BgSpecIcon = CreateFrame ("Frame", nil, UIParent)
local BGS = BgSpecIcon
BGS:Hide ()

---------------------------------------------------------------------------

local L = {}
local gameLocale = GetLocale()
if gameLocale == "enGB" then
	gameLocale = "enUS"
end

-- Following borrowed from LibBabble-TalentTree
if gameLocale == "zhCN" then
	L["Affliction"] = "痛苦"
	L["Arcane"] = "奥术"
	L["Arms"] = "武器"
	L["Assassination"] = "刺杀"
	L["Balance"] = "平衡"
	L["Beast Mastery"] = "野兽控制"
	L["Blood"] = "鲜血"
	L["Brewmaster"] = "酒仙"
	L["Outlaw"] = "狂徒"
	L["Demonology"] = "恶魔学识"
	L["Destruction"] = "毁灭"
	L["Discipline"] = "戒律"
	L["Elemental"] = "元素"
	L["Enhancement"] = "增强"
	L["Feral"] = "野性"
	L["Feral Combat"] = "野性战斗"
	L["Fire"] = "火焰"
	L["Frost"] = "冰霜"
	L["Fury"] = "狂怒"
	L["Guardian"] = "守护"
	L["Havoc"] = "浩劫"
	L["Holy"] = "神圣"
	L["Hybrid"] = "混合"
	L["Marksmanship"] = "射击"
	L["Mistweaver"] = "织雾"
	L["Protection"] = "防护"
	L["Restoration"] = "恢复"
	L["Retribution"] = "惩戒"
	L["Shadow"] = "暗影"
	L["Subtlety"] = "敏锐"
	L["Survival"] = "生存"
	L["Unholy"] = "邪恶"
	L["Vengeance"] = "复仇"
	L["Windwalker"] = "踏风"
elseif gameLocale == "zhTW" then
	L["Affliction"] = "痛苦"
	L["Arcane"] = "秘法"
	L["Arms"] = "武器"
	L["Assassination"] = "刺殺"
	L["Balance"] = "平衡"
	L["Beast Mastery"] = "野獸控制"
	L["Blood"] = "血魄"
	L["Brewmaster"] = "釀酒"
	L["Outlaw"] = "暴徒"
	L["Demonology"] = "惡魔學識"
	L["Destruction"] = "毀滅"
	L["Discipline"] = "戒律"
	L["Elemental"] = "元素"
	L["Enhancement"] = "增強"
	L["Feral"] = "野性戰鬥"
	L["Feral Combat"] = "野性戰鬥"
	L["Fire"] = "火焰"
	L["Frost"] = "冰霜"
	L["Fury"] = "狂怒"
	L["Guardian"] = "守護者"
	L["Havoc"] = "災虐"
	L["Holy"] = "神聖"
	L["Hybrid"] = "混合"
	L["Marksmanship"] = "射擊"
	L["Mistweaver"] = "織霧"
	L["Protection"] = "防護"
	L["Restoration"] = "恢復"
	L["Retribution"] = "懲戒"
	L["Shadow"] = "暗影"
	L["Subtlety"] = "敏銳"
	L["Survival"] = "生存"
	L["Unholy"] = "穢邪"
	L["Vengeance"] = "復仇"
	L["Windwalker"] = "御風"
end

local SpecIcons = {
	["PRIEST"] = {
		["Discipline"] = "Interface\\Icons\\Spell_Holy_PowerWordShield",
		["Holy"] = "Interface\\Icons\\Spell_Holy_GuardianSpirit",
		["Shadow"] = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
	},
	["MAGE"] = {
		["Arcane"] = "Interface\\Icons\\Spell_Holy_MagicalSentry",
		["Fire"] = "Interface\\Icons\\Spell_Fire_FireBolt02",
		["Frost"] = "Interface\\Icons\\Spell_Frost_FrostBolt02",
	},
	["WARLOCK"] = {
		["Affliction"] = "Interface\\Icons\\Spell_Shadow_DeathCoil",
		["Demonology"] = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
		["Destruction"] = "Interface\\Icons\\Spell_Shadow_RainOfFire",
	},
	["ROGUE"] = {
		["Assassination"] = "Interface\\Icons\\Ability_Rogue_Deadlybrew",
		["Outlaw"] = "Interface\\Icons\\inv_sword_30",
		["Subtlety"] = "Interface\\Icons\\Ability_Stealth",
	},
	["DRUID"] = {
		["Balance"] = "Interface\\Icons\\Spell_Nature_StarFall",
		["Restoration"] = "Interface\\Icons\\Spell_Nature_HealingTouch",
		["Feral"] = "Interface\\Icons\\Ability_Druid_CatForm",
		["Guardian"] = "Interface\\Icons\\Ability_Racial_BearForm",
	},
	["HUNTER"] = {
		["Beast Mastery"] = "Interface\\Icons\\ability_hunter_bestialdiscipline",
		["Marksmanship"] = "Interface\\Icons\\Ability_Marksmanship",
		["Survival"] = "Interface\\Icons\\ability_hunter_camouflage",
	},
	["SHAMAN"] = {
		["Elemental"] = "Interface\\Icons\\Spell_Nature_Lightning",
		["Enhancement"] = "Interface\\Icons\\Spell_Nature_LightningShield",
		["Restoration"] = "Interface\\Icons\\Spell_Nature_MagicImmunity",
	},
	["WARRIOR"] = {
		["Arms"] = "Interface\\Icons\\Ability_Warrior_SavageBlow",
		["Fury"] = "Interface\\Icons\\Ability_Warrior_InnerRage",
		["Protection"] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
	},
	["PALADIN"] = {
		["Holy"] = "Interface\\Icons\\Spell_Holy_HolyBolt",
		["Protection"] = "Interface\\Icons\\Ability_Paladin_ShieldoftheTemplar",
		["Retribution"] = "Interface\\Icons\\Spell_Holy_AuraOfLight",
	},
	["DEATHKNIGHT"] = {
		["Blood"] = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
		["Frost"] = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
		["Unholy"] = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
	},
	["MONK"] = {
		["Brewmaster"] = "Interface\\Icons\\spell_monk_brewmaster_spec",
		["Mistweaver"] = "Interface\\Icons\\spell_monk_mistweaver_spec",
		["Windwalker"] = "Interface\\Icons\\spell_monk_windwalker_spec",
	},
	["DEMONHUNTER"] = {
		["Havoc"] = "Interface\\Icons\\ability_demonhunter_specdps",
		["Vengeance"] = "Interface\\Icons\\ability_demonhunter_spectank",
	},
}
function GetSpecIcon (class, spec)
	local enspec = spec
	for k, v in pairs (L) do
		if v == spec then
			enspec = k
		end
	end
	if SpecIcons[class] then
		return SpecIcons[class][enspec]
	end
	return nil
end

---------------------------------------------------------------------------

function BGS.OnUpdate ()
	local scrollOffset = FauxScrollFrame_GetOffset (WorldStateScoreScrollFrame)
	local numScores = GetNumBattlefieldScores ()
	for i = 1, MAX_WORLDSTATE_SCORE_BUTTONS do
		local index = scrollOffset + i
		if index <= numScores then
			local scoreButton = _G["WorldStateScoreButton" .. i]
			local name, _, _, _, _, _, _, _, classToken, _, _, _, _, _, _, talentSpec = GetBattlefieldScore (index)
			scoreButton.name.text:SetText ("x   " .. name)
			if scoreButton.spec == nil then
				scoreButton.spec = scoreButton.name:CreateTexture (nil, "ARTWORK")
				scoreButton.spec:SetPoint ("LEFT", scoreButton.name.text, 0, 0)
				scoreButton.spec:SetWidth (14)
				scoreButton.spec:SetHeight (14)
			end
			local icon = GetSpecIcon (classToken, talentSpec)
			if icon then
				scoreButton.spec:SetTexture (icon)
				scoreButton.spec:Show ()
			else
				scoreButton.spec:Hide ()
			end
		end
	end
end
function BGS:SetUpHooks ()
	hooksecurefunc ("WorldStateScoreFrame_Update", self.OnUpdate)
end

--------------------------------------------------------------------------

function BGS:OnEvent (event, ...)
	if self[event] then
		self[event] (self, ...)
	end
end
function BGS:ADDON_LOADED (addon)
	if addon == "FreeUI" then
		self:SetUpHooks ()
	end
end

BGS:SetScript ("OnEvent", BGS.OnEvent)
BGS:RegisterEvent ("ADDON_LOADED")