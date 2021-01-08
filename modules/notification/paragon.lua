local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F.NOTIFICATION

local idList = {
	-- [questID] = {factionID}
	-- Legion
	[48976] = {2170}, -- Argussian Reach
	[46777] = {2045}, -- Armies of Legionfall
	[48977] = {2165}, -- Army of the Light
	[46745] = {1900}, -- Court of Farondis
	[46747] = {1883}, -- Dreamweavers
	[46743] = {1828}, -- Highmountain Tribes
	[46748] = {1859}, -- The Nightfallen
	[46749] = {1894}, -- The Wardens
	[46746] = {1948}, -- Valarjar
	-- Battle for Azeroth
	-- Neutral
	[54453] = {2164}, -- Champions of Azeroth
	[58096] = {2415}, -- Rajani
	[55348] = {2391}, -- Rustbolt Resistance
	[54451] = {2163}, -- Tortollan Seekers
	[58097] = {2417}, -- Uldum Accord
	-- Horde
	[54460] = {2156}, -- Talanji's Expedition
	[54455] = {2157}, -- The Honorbound
	[53982] = {2373}, -- The Unshackled
	[54461] = {2158}, -- Voldunai
	[54462] = {2103}, -- Zandalari Empire
	-- Alliance
	[54456] = {2161}, -- Order of Embers
	[54458] = {2160}, -- Proudmoore Admiralty
	[54457] = {2162}, -- Storm's Wake
	[54454] = {2159}, -- The 7th Legion
	[55976] = {2400}, -- Waveblade Ankoan
	-- Shadowlands
	[61100] = {2413}, -- Court of Harvesters
	[61097] = {2407}, -- The Ascended
	[61095] = {2410}, -- The Undying Army
	[61098] = {2465} -- The Wild Hunt
}

local function ParagonNotification(event, questID)
	if not idList[questID] then
		return
	end

	local name = GetFactionInfoByID(idList[questID][1]) or UNKNOWN
	local text = GetQuestLogCompletionText(C_QuestLog.GetLogIndexForQuestID(questID))

	F:CreateNotification(name, C.BlueColor .. text, nil, 'Interface\\ICONS\\Achievement_Quests_Completed_08')
end

function NOTIFICATION:ParagonReputation()
	if not C.DB.notification.paragon_reputation then return end

	F:RegisterEvent('QUEST_ACCEPTED', ParagonNotification)
end
