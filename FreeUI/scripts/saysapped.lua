local F, C, L = unpack(select(2, ...))
if not C.general.saySapped then return end

local saySapped=CreateFrame("Frame")
local saySappedEventHandlers={}
local playerName=nil

local function saySappedRestingCheck()
	if IsResting() then
		if saySapped:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then saySapped:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end
		if saySapped:IsEventRegistered("PLAYER_REGEN_DISABLED") then saySapped:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if saySapped:IsEventRegistered("PLAYER_REGEN_ENABLED") then saySapped:UnregisterEvent("PLAYER_REGEN_ENABLED") end
	else
		if not saySapped:IsEventRegistered("PLAYER_REGEN_DISABLED") then saySapped:RegisterEvent("PLAYER_REGEN_DISABLED") end
		if not saySapped:IsEventRegistered("PLAYER_REGEN_ENABLED") then saySapped:RegisterEvent("PLAYER_REGEN_ENABLED") end
		if not InCombatLockdown() and not saySapped:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then saySapped:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end
	end
end

local function saySappedPlayerEnteringWorld()
	local _,instanceType,_,_,_,_,_,instanceMapID=GetInstanceInfo() --> Leaving InstanceMapID for edge cases if any ever arise.  Need to check on Ashran==1191 Tol Barad=732 >>> and not instanceMapID==1191 and not instanceMapID==732
	if instanceType=="scenario" or instanceType=="party" or instanceType=="raid" then --> Disables while in a scenario, dungeon, or a raid.
		if saySapped:IsEventRegistered("ZONE_CHANGED") then
			saySapped:UnregisterEvent("ZONE_CHANGED")
			saySapped:UnregisterEvent("ZONE_CHANGED_INDOORS")
			saySapped:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		end
		if saySapped:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then saySapped:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end
		if saySapped:IsEventRegistered("PLAYER_REGEN_DISABLED") then saySapped:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if saySapped:IsEventRegistered("PLAYER_REGEN_ENABLED") then saySapped:UnregisterEvent("PLAYER_REGEN_ENABLED") end
	elseif instanceType=="arena" or instanceType=="pvp" then --> Disables checking for resting state in arenas and battlegrounds.
		if saySapped:IsEventRegistered("ZONE_CHANGED") then
			saySapped:UnregisterEvent("ZONE_CHANGED")
			saySapped:UnregisterEvent("ZONE_CHANGED_INDOORS")
			saySapped:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		end
		if not saySapped:IsEventRegistered("PLAYER_REGEN_DISABLED") then saySapped:RegisterEvent("PLAYER_REGEN_DISABLED") end
		if not saySapped:IsEventRegistered("PLAYER_REGEN_ENABLED") then saySapped:RegisterEvent("PLAYER_REGEN_ENABLED") end
		if not InCombatLockdown() and not saySapped:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then saySapped:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end
	else --> Enables everywhere else and checks for resting state 5 seconds after changing zones or subzones.
		if not saySapped:IsEventRegistered("ZONE_CHANGED") then
			saySapped:RegisterEvent("ZONE_CHANGED")
			saySapped:RegisterEvent("ZONE_CHANGED_INDOORS")
			saySapped:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		end
		saySappedRestingCheck()
	end
end

local function saySapped_event_Handler(self,event,...)
	return saySappedEventHandlers[event](...)
end

function saySappedEventHandlers.COMBAT_LOG_EVENT_UNFILTERED(_,event,_,_,sourceName,_,_,_,destName,_,_,spellID)
	if spellID==6770 and destName==playerName and (event=="SPELL_AURA_APPLIED" or event=="SPELL_AURA_REFRESH") then
		if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
			SendChatMessage("{rt8} 我被闷棍！ {rt8}","SAY")
		else
			SendChatMessage("{rt8} Sapped! {rt8}","SAY")
		end
		if sourceName then
			DEFAULT_CHAT_FRAME:AddMessage("Sapped by: "..sourceName)
		end
	end
end

function saySappedEventHandlers.PLAYER_ENTERING_WORLD()
	saySappedPlayerEnteringWorld()
end

function saySappedEventHandlers.PLAYER_LOGIN()
	playerName=GetUnitName("player")
	saySapped:UnregisterEvent("PLAYER_LOGIN")
end

function saySappedEventHandlers.PLAYER_REGEN_DISABLED()
	saySapped:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function saySappedEventHandlers.PLAYER_REGEN_ENABLED()
	saySapped:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function saySappedEventHandlers.ZONE_CHANGED()
	C_Timer.After(5,saySappedRestingCheck)
end

function saySappedEventHandlers.ZONE_CHANGED_INDOORS()
	C_Timer.After(5,saySappedRestingCheck)
end

function saySappedEventHandlers.ZONE_CHANGED_NEW_AREA()
	C_Timer.After(5,saySappedRestingCheck)
end

saySapped:RegisterEvent("PLAYER_ENTERING_WORLD")
saySapped:RegisterEvent("PLAYER_LOGIN")
saySapped:SetScript("OnEvent",saySapped_event_Handler)