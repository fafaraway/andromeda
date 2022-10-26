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
	An infotext-module which can display several things based on tags.

	Supported tags:
		space - specify a formatstring as arg #1, using "free" / "max" / "used"
		item - count of the item in arg #1 (itemID, itemLink, itemName)
			shards - "sub-tag" of item, displays soul shard info
		ammo - count of ammo slot
		currency - displays the currency with id arg #1
			currencies - displays all tracked currencies
		money - formatted money display

	The space-tag still needs .bags defined in the plugin!
	e.g. tagDisplay.bags = cargBags:ParseBags("backpack+bags")

DEPENDENCIES
	mixins/api-common.lua

CALLBACKS
	:OnTagUpdate(event) - When the tag is updated
]]
local _, ns = ...
local cargBags = ns.cargBags

local GetContainerNumFreeSlots = ns[2].IS_BETA and C_Container.GetContainerNumFreeSlots or GetContainerNumFreeSlots

local tagPool, tagEvents, object = {}, {}
local function tagger(tag, ...) return object.tags[tag] and object.tags[tag](object, ...) or "" end

-- Update the space display
local function updater(self, event)
	object = self
	self:SetText(self.tagString:gsub("%[([^%]:]+):?(.-)%]", tagger))

	if(self.OnTagUpdate) then self:OnTagUpdate(event) end
end

local function setTagString(self, tagString)
	self.tagString = tagString
	for tag in tagString:gmatch("%[([^%]:]+):?.-]") do
		if(self.tagEvents[tag]) then
			for _, event in pairs(self.tagEvents[tag]) do
				self.implementation:RegisterEvent(event, self, updater)
			end
		end
	end
end

cargBags:RegisterPlugin("TagDisplay", function(self, tagString, parent)
	parent = parent or self
	tagString = tagString or ""

	local plugin = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	plugin.implementation = self.implementation
	plugin.SetTagString = setTagString
	plugin.tags = tagPool
	plugin.tagEvents = tagEvents
	plugin.iconValues = "16:16:0:0"
	plugin.forceEvent = function(event) updater(plugin, event) end

	setTagString(plugin, tagString)

	self.implementation:RegisterEvent("BAG_UPDATE", plugin, updater)
	return plugin
end)

local function createIcon(icon, iconValues)
	if(type(iconValues) == "table") then
		iconValues = table.concat(iconValues, ":")
	end
	return ("|T%s:%s|t"):format(icon, iconValues)
end


-- Tags
local function GetNumFreeSlots(name)
	if name == "Bag" then
		if ns[2].IS_NEW_PATCH then
			local totalFree, freeSlots, bagFamily = 0
			for i = 0, 4 do -- reagent bank excluded
				freeSlots, bagFamily = GetContainerNumFreeSlots(i)
				if bagFamily == 0 then
					totalFree = totalFree + freeSlots
				end
			end
			return totalFree
		else
			return CalculateTotalNumberOfFreeBagSlots()
		end
	elseif name == "Bank" then
		local numFreeSlots = GetContainerNumFreeSlots(-1)
		if ns[2].IS_NEW_PATCH then
			for bagID = 6, 12 do
				numFreeSlots = numFreeSlots + GetContainerNumFreeSlots(bagID)
			end
		else
			for bagID = 5, 11 do
				numFreeSlots = numFreeSlots + GetContainerNumFreeSlots(bagID)
			end
		end
		return numFreeSlots
	elseif name == "Reagent" then
		return GetContainerNumFreeSlots(-3)
	end
end

tagPool["space"] = function(self)
	local str = GetNumFreeSlots(self.__name)
	return str
end

tagPool["item"] = function(self, item)
	local bags = GetItemCount(item, nil)
	local total = GetItemCount(item, true)
	local bank = total-bags

	if(total > 0) then
		return bags .. (bank and " ("..bank..")") .. createIcon(GetItemIcon(item), self.iconValues)
	end
end

tagPool["currency"] = function(self, id)
	local _, count, icon = GetBackpackCurrencyInfo(id)

	if(count) then
		return count .. createIcon(icon, self.iconValues)
	end
end
tagEvents["currency"] = { "CURRENCY_DISPLAY_UPDATE" }

tagPool["currencies"] = function(self)
	local watchedCurrencies = {}

	for i = 1, GetNumWatchedTokens() do
		local info = C_CurrencyInfo.GetBackpackCurrencyInfo(i)
		local name, count, icon = info.name, info.quantity, info.iconFileID

		if name and count then
			local iconTexture = " |T"..icon..":12:12:0:0:50:50:4:46:4:46|t "
			local str = iconTexture .. count

			table.insert(watchedCurrencies, str)
		end
	end

	return table.concat(watchedCurrencies, " ")
end
tagEvents["currencies"] = tagEvents["currency"]

local atlasCache = {}
local function createAtlasCoin(coin)
	local str = atlasCache[coin]
	if not str then
		local info = C_Texture.GetAtlasInfo("coin-"..coin)
		if info then
			str = ns[1]:GetTextureStrByAtlas(info, 14, 14)
			atlasCache[coin] = str
		end
	end
	return str
end

tagPool["money"] = function(self)
	local money = GetMoney() or 0
	local str = ""
	local gold, silver, copper = floor(money/1e4), floor(money/100) % 100, money % 100

	if gold > 0 then str = str..gold..createAtlasCoin("gold").." " end
	if silver > 0 then str = str..silver..createAtlasCoin("silver").." " end
	if copper > 0 then str = str..copper..createAtlasCoin("copper").." " end

	return str
end
tagEvents["money"] = { "PLAYER_MONEY" }
