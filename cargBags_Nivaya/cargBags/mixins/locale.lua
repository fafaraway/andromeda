 --[[
LICENSE
	cargBags: An inventory framework addon for World of Warcraft

	Copyright (C) 2010  Constantin "Cargor" Schomburg <xconstruct@gmail.com>

	cargBags is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	cargBags is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with cargBags; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

DESCRIPTION
	Provides translation-tables for the auction house categories

USAGE:
	local L = cargBags:GetLocalizedNames()
	OR local L = Implementation:GetLocalizedNames()

	L.ItemSubClass[englishName] returns localized name
]]
local _, ns = ...
local cargBags = ns.cargBags

local L

local GetItemClassInfo = GetItemClassInfo
local GetItemSubClassInfo = GetItemSubClassInfo

--[[!
	Fetches/creates a table of localized type names
	@return locale <table>
	
	*Edited for WoW Patch 4.0.6 by Lars "Goldpaw" Norberg
	*Edited for WoW Patch 5.0.4 by Lars "Goldpaw" Norberg
	*Edited for WoW Patch 6.0 by humfras
	*Edited for WoW Patch 7.0 by humfras
]]

-- https://www.townlong-yak.com/framexml/beta/Blizzard_AuctionUI/Blizzard_AuctionData.lua


-- 	NOTE: Subtract 1 so get the correct result from GetItemClassInfo
--	=> L.ItemSubClass["Consumable"] = GetItemClassInfo(1 - 1)
local Cats = {
	"Consumable", -- [1]
	"Container", -- [2]
	"Weapon", -- [3]
	"Gem", -- [4]
	"Armor", -- [5]
	"Reagent", -- [6]
	"Projectile", -- [7]
	"Tradeskill", -- [8]
	"Item Enhancement", -- [9]
	"Recipe", -- [10]
	"Money(OBSOLETE)", -- [11]
	"Quiver", -- [12]
	"Quest", -- [13]
	"Key", -- [14]
	"Permanent(OBSOLETE)", -- [15]
	"Miscellaneous", -- [16]
	"Glyph", -- [17]
	"Battle Pets", -- [18]
	"WoW Token", -- [19]
}
local CatID = {
	["Quiver"] = 11,
	["WoW Token"] = 18,
	["Recipe"] = 9,
	["Reagent"] = 5,
	["Key"] = 13,
	["Armor"] = 4,
	["Quest"] = 12,
	["Container"] = 1,
	["Tradeskill"] = 7,
	["Permanent(OBSOLETE)"] = 14,
	["Miscellaneous"] = 15,
	["Battle Pets"] = 17,
	["Consumable"] = 0,
	["Gem"] = 3,
	["Glyph"] = 16,
	["Projectile"] = 6,
	["Item Enhancement"] = 8,
	["Money(OBSOLETE)"] = 10,
	["Weapon"] = 2,
}

function cargBags:GetLocalizedTypes()
	if(L) then return L end

	L = {
		ItemClass = {},
		ItemSubClass = {}
	}

	--[[ disabled because some strings are incorrect for certain langugages
		L.ItemSubClass["Weapon"] = AUCTION_CATEGORY_WEAPONS
		L.ItemSubClass["Armor"] = AUCTION_CATEGORY_ARMOR
		L.ItemSubClass["Container"] = AUCTION_CATEGORY_CONTAINERS
		L.ItemSubClass["Consumable"] = AUCTION_CATEGORY_CONSUMABLES
		L.ItemSubClass["Glyph"] = AUCTION_CATEGORY_GLYPHS
		L.ItemSubClass["Trade Goods"] = AUCTION_CATEGORY_TRADE_GOODS
		L.ItemSubClass["Recipe"] = AUCTION_CATEGORY_RECIPES
		L.ItemSubClass["Gem"] = AUCTION_CATEGORY_GEMS
		L.ItemSubClass["Miscellaneous"] = AUCTION_CATEGORY_MISCELLANEOUS
		L.ItemSubClass["Quest"] = AUCTION_CATEGORY_QUEST_ITEMS
		L.ItemSubClass["Battle Pets"] = AUCTION_CATEGORY_BATTLE_PETS
		-- AUCTION_CATEGORY_ITEM_ENHANCEMENT
	]]
	
	L.ItemClass["Weapon"] = GetItemClassInfo(2)
	L.ItemClass["Armor"] = GetItemClassInfo(4)
	L.ItemClass["Container"] = GetItemClassInfo(1)
	L.ItemClass["Consumable"] = GetItemClassInfo(0)
	L.ItemClass["Glyph"] = GetItemClassInfo(16)
	L.ItemClass["Trade Goods"] = GetItemClassInfo(7)
	L.ItemClass["Recipe"] = GetItemClassInfo(9)
	L.ItemClass["Gem"] = GetItemClassInfo(3)
	L.ItemClass["Miscellaneous"] = GetItemClassInfo(15)
	L.ItemClass["Quest"] = GetItemClassInfo(12)
	L.ItemClass["Battle Pets"] = GetItemClassInfo(17)
	
	
	--Create subclasses
	
	--	Quiver
		L.ItemSubClass["Quiver(OBSOLETE)"] = GetItemSubClassInfo(11,0)
		L.ItemSubClass["Ammo Pouch"] = GetItemSubClassInfo(11,3)
		L.ItemSubClass["Bolt(OBSOLETE)"] = GetItemSubClassInfo(11,1)
		L.ItemSubClass["Quiver"] = GetItemSubClassInfo(11,2)
	--	WoW Token
		L.ItemSubClass["WoW Token"] = GetItemSubClassInfo(18,0)
	--	Recipe
		L.ItemSubClass["Blacksmithing"] = GetItemSubClassInfo(9,4)
		L.ItemSubClass["Alchemy"] = GetItemSubClassInfo(9,6)
		L.ItemSubClass["Tailoring"] = GetItemSubClassInfo(9,2)
		L.ItemSubClass["Engineering"] = GetItemSubClassInfo(9,3)
		L.ItemSubClass["Inscription"] = GetItemSubClassInfo(9,11)
		L.ItemSubClass["Fishing"] = GetItemSubClassInfo(9,9)
		L.ItemSubClass["Enchanting"] = GetItemSubClassInfo(9,8)
		L.ItemSubClass["First Aid"] = GetItemSubClassInfo(9,7)
		L.ItemSubClass["Cooking"] = GetItemSubClassInfo(9,5)
		L.ItemSubClass["Book"] = GetItemSubClassInfo(9,0)
		L.ItemSubClass["Jewelcrafting"] = GetItemSubClassInfo(9,10)
		L.ItemSubClass["Leatherworking"] = GetItemSubClassInfo(9,1)
	--	Reagent
		L.ItemSubClass["Keystone"] = GetItemSubClassInfo(5,1)
		L.ItemSubClass["Reagent"] = GetItemSubClassInfo(5,0)
	--	Key
		L.ItemSubClass["Key"] = GetItemSubClassInfo(13,0)
		L.ItemSubClass["Lockpick"] = GetItemSubClassInfo(13,1)
	--	Armor
		L.ItemSubClass["Cosmetic"] = GetItemSubClassInfo(4,5)
		L.ItemSubClass["Librams"] = GetItemSubClassInfo(4,7)
		L.ItemSubClass["Miscellaneous"] = GetItemSubClassInfo(4,0)
		L.ItemSubClass["Relic"] = GetItemSubClassInfo(4,11)
		L.ItemSubClass["Leather"] = GetItemSubClassInfo(4,2)
		L.ItemSubClass["Plate"] = GetItemSubClassInfo(4,4)
		L.ItemSubClass["Cloth"] = GetItemSubClassInfo(4,1)
		L.ItemSubClass["Sigils"] = GetItemSubClassInfo(4,10)
		L.ItemSubClass["Totems"] = GetItemSubClassInfo(4,9)
		L.ItemSubClass["Shields"] = GetItemSubClassInfo(4,6)
		L.ItemSubClass["Idols"] = GetItemSubClassInfo(4,8)
		L.ItemSubClass["Mail"] = GetItemSubClassInfo(4,3)
	--	Quest
		L.ItemSubClass["Quest"] = GetItemSubClassInfo(12,0)
	--	Container
		L.ItemSubClass["Enchanting Bag"] = GetItemSubClassInfo(1,3)
		L.ItemSubClass["Inscription Bag"] = GetItemSubClassInfo(1,8)
		L.ItemSubClass["Soul Bag"] = GetItemSubClassInfo(1,1)
		L.ItemSubClass["Bag"] = GetItemSubClassInfo(1,0)
		L.ItemSubClass["Mining Bag"] = GetItemSubClassInfo(1,6)
		L.ItemSubClass["Engineering Bag"] = GetItemSubClassInfo(1,4)
		L.ItemSubClass["Leatherworking Bag"] = GetItemSubClassInfo(1,7)
		L.ItemSubClass["Cooking Bag"] = GetItemSubClassInfo(1,10)
		L.ItemSubClass["Tackle Box"] = GetItemSubClassInfo(1,9)
		L.ItemSubClass["Herb Bag"] = GetItemSubClassInfo(1,2)
		L.ItemSubClass["Gem Bag"] = GetItemSubClassInfo(1,5)
	--	Tradeskill
		L.ItemSubClass["Herb"] = GetItemSubClassInfo(7,9)
		L.ItemSubClass["Enchanting"] = GetItemSubClassInfo(7,12)
		L.ItemSubClass["Explosives and Devices (OBSOLETE)"] = GetItemSubClassInfo(7,17)
		L.ItemSubClass["Inscription"] = GetItemSubClassInfo(7,16)
		L.ItemSubClass["Cloth"] = GetItemSubClassInfo(7,5)
		L.ItemSubClass["Item Enchantment (OBSOLETE)"] = GetItemSubClassInfo(7,14)
		L.ItemSubClass["Cooking"] = GetItemSubClassInfo(7,8)
		L.ItemSubClass["Jewelcrafting"] = GetItemSubClassInfo(7,4)
		L.ItemSubClass["Elemental"] = GetItemSubClassInfo(7,10)
		L.ItemSubClass["Other"] = GetItemSubClassInfo(7,11)
		L.ItemSubClass["Metal & Stone"] = GetItemSubClassInfo(7,7)
		L.ItemSubClass["Leather"] = GetItemSubClassInfo(7,6)
		L.ItemSubClass["Parts"] = GetItemSubClassInfo(7,1)
		L.ItemSubClass["Weapon Enchantment - Obsolete"] = GetItemSubClassInfo(7,15)
		L.ItemSubClass["Materials (OBSOLETE)"] = GetItemSubClassInfo(7,13)
		L.ItemSubClass["Trade Goods (OBSOLETE)"] = GetItemSubClassInfo(7,0)
		L.ItemSubClass["Devices (OBSOLETE)"] = GetItemSubClassInfo(7,3)
		L.ItemSubClass["Explosives (OBSOLETE)"] = GetItemSubClassInfo(7,2)
	--	Permanent(OBSOLETE)
		L.ItemSubClass["Permanent"] = GetItemSubClassInfo(14,0)
	--	Miscellaneous
		L.ItemSubClass["Companion Pets"] = GetItemSubClassInfo(15,2)
		L.ItemSubClass["Holiday"] = GetItemSubClassInfo(15,3)
		L.ItemSubClass["Other"] = GetItemSubClassInfo(15,4)
		L.ItemSubClass["Reagent"] = GetItemSubClassInfo(15,1)
		L.ItemSubClass["Mount"] = GetItemSubClassInfo(15,5)
		L.ItemSubClass["Junk"] = GetItemSubClassInfo(15,0)
	--	Battle Pets
		L.ItemSubClass["Dragonkin"] = GetItemSubClassInfo(17,1)
		L.ItemSubClass["Humanoid"] = GetItemSubClassInfo(17,0)
		L.ItemSubClass["Beast"] = GetItemSubClassInfo(17,7)
		L.ItemSubClass["Flying"] = GetItemSubClassInfo(17,2)
		L.ItemSubClass["Magic"] = GetItemSubClassInfo(17,5)
		L.ItemSubClass["Mechanical"] = GetItemSubClassInfo(17,9)
		L.ItemSubClass["Critter"] = GetItemSubClassInfo(17,4)
		L.ItemSubClass["Aquatic"] = GetItemSubClassInfo(17,8)
		L.ItemSubClass["Elemental"] = GetItemSubClassInfo(17,6)
		L.ItemSubClass["Undead"] = GetItemSubClassInfo(17,3)
	--	Consumable
		L.ItemSubClass["Potion"] = GetItemSubClassInfo(0,1)
		L.ItemSubClass["Elixir"] = GetItemSubClassInfo(0,2)
		L.ItemSubClass["Explosives and Devices"] = GetItemSubClassInfo(0,0)
		L.ItemSubClass["Flask"] = GetItemSubClassInfo(0,3)
		L.ItemSubClass["Vantus Runes"] = GetItemSubClassInfo(0,9)
		L.ItemSubClass["Item Enhancement (OBSOLETE)"] = GetItemSubClassInfo(0,6)
		L.ItemSubClass["Other"] = GetItemSubClassInfo(0,8)
		L.ItemSubClass["Food & Drink"] = GetItemSubClassInfo(0,5)
		L.ItemSubClass["Scroll (OBSOLETE)"] = GetItemSubClassInfo(0,4)
		L.ItemSubClass["Bandage"] = GetItemSubClassInfo(0,7)
	--	Gem
		L.ItemSubClass["Intellect"] = GetItemSubClassInfo(3,0)
		L.ItemSubClass["Other"] = GetItemSubClassInfo(3,9)
		L.ItemSubClass["Critical Strike"] = GetItemSubClassInfo(3,5)
		L.ItemSubClass["Agility"] = GetItemSubClassInfo(3,1)
		L.ItemSubClass["Haste"] = GetItemSubClassInfo(3,7)
		L.ItemSubClass["Stamina"] = GetItemSubClassInfo(3,3)
		L.ItemSubClass["Mastery"] = GetItemSubClassInfo(3,6)
		L.ItemSubClass["Artifact Relic"] = GetItemSubClassInfo(3,11)
		L.ItemSubClass["Strength"] = GetItemSubClassInfo(3,2)
		L.ItemSubClass["Spirit"] = GetItemSubClassInfo(3,4)
		L.ItemSubClass["Multiple Stats"] = GetItemSubClassInfo(3,10)
		L.ItemSubClass["Versatility"] = GetItemSubClassInfo(3,8)
	--	Glyph
		L.ItemSubClass["Demon Hunter"] = GetItemSubClassInfo(16,12)
		L.ItemSubClass["Mage"] = GetItemSubClassInfo(16,8)
		L.ItemSubClass["Priest"] = GetItemSubClassInfo(16,5)
		L.ItemSubClass["Warlock"] = GetItemSubClassInfo(16,9)
		L.ItemSubClass["Shaman"] = GetItemSubClassInfo(16,7)
		L.ItemSubClass["Paladin"] = GetItemSubClassInfo(16,2)
		L.ItemSubClass["Death Knight"] = GetItemSubClassInfo(16,6)
		L.ItemSubClass["Monk"] = GetItemSubClassInfo(16,10)
		L.ItemSubClass["Hunter"] = GetItemSubClassInfo(16,3)
		L.ItemSubClass["Warrior"] = GetItemSubClassInfo(16,1)
		L.ItemSubClass["Rogue"] = GetItemSubClassInfo(16,4)
		L.ItemSubClass["Druid"] = GetItemSubClassInfo(16,11)
	--	Projectile
		L.ItemSubClass["Arrow"] = GetItemSubClassInfo(6,2)
		L.ItemSubClass["Wand(OBSOLETE)"] = GetItemSubClassInfo(6,0)
		L.ItemSubClass["Thrown(OBSOLETE)"] = GetItemSubClassInfo(6,4)
		L.ItemSubClass["Bolt(OBSOLETE)"] = GetItemSubClassInfo(6,1)
		L.ItemSubClass["Bullet"] = GetItemSubClassInfo(6,3)
	--	Item Enhancement
		L.ItemSubClass["Hands"] = GetItemSubClassInfo(8,6)
		L.ItemSubClass["Wrist"] = GetItemSubClassInfo(8,5)
		L.ItemSubClass["Chest"] = GetItemSubClassInfo(8,4)
		L.ItemSubClass["Neck"] = GetItemSubClassInfo(8,1)
		L.ItemSubClass["Feet"] = GetItemSubClassInfo(8,9)
		L.ItemSubClass["Finger"] = GetItemSubClassInfo(8,10)
		L.ItemSubClass["Cloak"] = GetItemSubClassInfo(8,3)
		L.ItemSubClass["Legs"] = GetItemSubClassInfo(8,8)
		L.ItemSubClass["Two-Handed Weapon"] = GetItemSubClassInfo(8,12)
		L.ItemSubClass["Shoulder"] = GetItemSubClassInfo(8,2)
		L.ItemSubClass["Waist"] = GetItemSubClassInfo(8,7)
		L.ItemSubClass["Head"] = GetItemSubClassInfo(8,0)
		L.ItemSubClass["Weapon"] = GetItemSubClassInfo(8,11)
		L.ItemSubClass["Shield/Off-hand"] = GetItemSubClassInfo(8,13)
	--	Money(OBSOLETE)
		L.ItemSubClass["Money(OBSOLETE)"] = GetItemSubClassInfo(10,0)
	--	Weapon
		L.ItemSubClass["Spears"] = GetItemSubClassInfo(2,17)
		L.ItemSubClass["Warglaives"] = GetItemSubClassInfo(2,9)
		L.ItemSubClass["Bear Claws"] = GetItemSubClassInfo(2,11)
		L.ItemSubClass["One-Handed Swords"] = GetItemSubClassInfo(2,7)
		L.ItemSubClass["Polearms"] = GetItemSubClassInfo(2,6)
		L.ItemSubClass["Crossbows"] = GetItemSubClassInfo(2,18)
		L.ItemSubClass["Daggers"] = GetItemSubClassInfo(2,15)
		L.ItemSubClass["Two-Handed Axes"] = GetItemSubClassInfo(2,1)
		L.ItemSubClass["Guns"] = GetItemSubClassInfo(2,3)
		L.ItemSubClass["Thrown"] = GetItemSubClassInfo(2,16)
		L.ItemSubClass["Two-Handed Swords"] = GetItemSubClassInfo(2,8)
		L.ItemSubClass["Two-Handed Maces"] = GetItemSubClassInfo(2,5)
		L.ItemSubClass["Fishing Poles"] = GetItemSubClassInfo(2,20)
		L.ItemSubClass["Bows"] = GetItemSubClassInfo(2,2)
		L.ItemSubClass["Miscellaneous"] = GetItemSubClassInfo(2,14)
		L.ItemSubClass["CatClaws"] = GetItemSubClassInfo(2,12)
		L.ItemSubClass["Wands"] = GetItemSubClassInfo(2,19)
		L.ItemSubClass["One-Handed Maces"] = GetItemSubClassInfo(2,4)
		L.ItemSubClass["Fist Weapons"] = GetItemSubClassInfo(2,13)
		L.ItemSubClass["One-Handed Axes"] = GetItemSubClassInfo(2,0)
		L.ItemSubClass["Staves"] = GetItemSubClassInfo(2,10)

	return L
end

cargBags.classes.Implementation.GetLocalizedNames = cargBags.GetLocalizedNames
