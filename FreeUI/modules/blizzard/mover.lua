local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

-- #TODO
local f = CreateFrame('Frame')

local frames = {
	['AddonList'] = false,
	['AudioOptionsFrame'] = false,
	['AzeriteReforgerFrame'] = false,
	['BankFrame'] = false,
	['BonusRollFrame'] = true,
	['BonusRollLootWonFrame'] = true,
	['BonusRollMoneyWonFrame'] = true,
	['CharacterFrame'] = false,
	['ChatConfigFrame'] = false,
	['DressUpFrame'] = false,
	['FriendsFrame'] = false,
	['FriendsFriendsFrame'] = false,
	['GameMenuFrame'] = false,
	['GossipFrame'] = false,
	['GuildInviteFrame'] = false,
	['GuildRegistrarFrame'] = false,
	['HelpFrame'] = false,
	['InterfaceOptionsFrame'] = false,
	['ItemTextFrame'] = false,
	['LFDRoleCheckPopup'] = false,
	['LFGDungeonReadyDialog'] = false,
	['LFGDungeonReadyStatus'] = false,
	['LFGPVPReadyDialog'] = false,
	['LFGPVPReadyStatus'] = false,
	['LootFrame'] = false,
	['LudwigFrame'] = false,
	['MailFrame'] = false,
	['MerchantFrame'] = false,
	['CollectionFrame'] = true,
	['OpenMailFrame'] = false,
	['PVEFrame'] = false,
	['PetStableFrame'] = false,
	['PetitionFrame'] = false,
	['PVPReadyDialog'] = false,
	['QuestFrame'] = false,
	['QuestLogPopupDetailFrame'] = false,
	['RaidBrowserFrame'] = false,
	['RaidInfoFrame'] = false,
	['RaidParentFrame'] = false,
	['ReadyCheckFrame'] = false,
	['ReportCheatingDialog'] = false,
	['RolePollPopup'] = false,
	['ScrollOfResurrectionSelectionFrame'] = false,
	['ShopJournalFrame'] = false,
	['SpellBookFrame'] = false,
	['SplashFrame'] = false,
	['StackSplitFrame'] = false,
	['StaticPopup1'] = false,
	['StaticPopup2'] = false,
	['StaticPopup3'] = false,
	['StaticPopup4'] = false,
	['TabardFrame'] = false,
	['TaxiFrame'] = false,
	['TimeManagerFrame'] = false,
	['TokenFrame'] = false,
	['TradeFrame'] = false,
	['TutorialFrame'] = false,
	['VideoOptionsFrame'] = false,
	--['WorldMapFrame'] = false,
}

local lodFrames = {
	Blizzard_AchievementUI = { ['AchievementFrame'] = false, ['AchievementFrameHeader'] = true, ['AchievementFrameCategoriesContainer'] = false, ['AchievementFrame'] = false },
	Blizzard_AlliedRacesUI = { ['AlliedRacesFrame'] = false },
	Blizzard_ArchaeologyUI = { ['ArchaeologyFrame'] = false },
	Blizzard_AuctionHouseUI = { ['AuctionHouseFrame'] = false },
	Blizzard_AuctionUI = { ['AuctionFrame'] = false },
	Blizzard_AzeriteUI = { ['AzeriteEmpoweredItemUI'] = false },
	Blizzard_AzeriteReforgerUI = { ['AzeriteReforgerFrame'] = false },
	Blizzard_BarberShopUI = { ['BarberShopFrame'] = false },
	Blizzard_BindingUI = { ['KeyBindingFrame'] = false },
	Blizzard_BlackMarketUI = { ['BlackMarketFrame'] = false },
	Blizzard_Calendar = { ['CalendarCreateEventFrame'] = false, ['CalendarFrame'] = false, ['CalendarViewEventFrame'] = false, ['CalendarViewHolidayFrame'] = false },
	Blizzard_ChallengesUI = { ['ChallengesKeystoneFrame'] = false },
	Blizzard_Collections = { ['CollectionsJournal'] = false },
	Blizzard_Shop = { ['ShopJournalFrame'] = false, ['ShopJournalFrameHeader'] = true, ['ShopJournalFrameCategoriesContainer'] = false, ['ShopJournalFrame'] = false },
	Blizzard_Communities = { ['CommunitiesFrame'] = false },
	Blizzard_EncounterJournal = { ['EncounterJournal'] = false },
	Blizzard_GarrisonUI = { ['GarrisonLandingPage'] = false, ['GarrisonMissionFrame'] = false, ['GarrisonCapacitiveDisplayFrame'] = false, ['GarrisonBuildingFrame'] = false, ['GarrisonRecruiterFrame'] = false, ['GarrisonRecruitSelectFrame'] = false, ['GarrisonShipyardFrame'] = false },
	Blizzard_GMChatUI = { ['GMChatStatusFrame'] = false },
	Blizzard_GMSurveyUI = { ['GMSurveyFrame'] = false },
	Blizzard_GuildBankUI = { ['GuildBankFrame'] = false },
	Blizzard_GuildControlUI = { ['GuildControlUI'] = false },
	Blizzard_GuildUI = { ['GuildFrame'] = false, ['GuildLogFrame'] = false },
	Blizzard_InspectUI = { ['InspectFrame'] = false },
	Blizzard_ItemAlterationUI = { ['TransmogrifyFrame'] = false },
	Blizzard_ItemSocketingUI = { ['ItemSocketingFrame'] = false },
	Blizzard_ItemUpgradeUI = { ['ItemUpgradeFrame'] = false },
	Blizzard_LookingForGuildUI = { ['LookingForGuildFrame'] = false },
	Blizzard_MacroUI = { ['MacroFrame'] = false },
	Blizzard_OrderHallUI = { ['OrderHallTalentFrame'] = false },
	Blizzard_QuestChoice = { ['QuestChoiceFrame'] = false },
	Blizzard_ScrappingMachineUI = { ['ScrappingMachineFrame'] = false },
	Blizzard_TalentUI = { ['PlayerTalentFrame'] = false },
	Blizzard_TokenUI = { ['TokenFrame'] = true },
	Blizzard_TradeSkillUI = { ['TradeSkillFrame'] = false },
	Blizzard_TrainerUI = { ['ClassTrainerFrame'] = false },
	Blizzard_VoidStorageUI = { ['VoidStorageFrame'] = false },
	Blizzard_QuestFrame = { ['GossipFrame'] = false },
	Blizzard_GossipFrame = { ['QuestFrame'] = false },
	Blizzard_GameMenuFrame = { ['VideoOptionsFrame'] = false, ['InterfaceOptionsFrame'] = false, ['HelpFrame'] = false },
	Blizzard_VideoOptionsFrame = { ['GameMenuFrame'] = false },
	Blizzard_InterfaceOptionsFrame = { ['GameMenuFrame'] = false },
	Blizzard_HelpFrame = { ['GameMenuFrame'] = false },
}

local parentFrame = {}
local hooked = {}

function f:PLAYER_LOGIN()
	self:HookFrames(frames)
end

function f:ADDON_LOADED(name)
	local frameList = lodFrames[name]
	if frameList then
		self:HookFrames(frameList)
	end
end

local function MouseDownHandler(frame, button)
	frame = parentFrame[frame] or frame
	if frame and button == 'LeftButton' then
		frame:StartMoving()
		frame:SetUserPlaced(false)
	end
end

local function MouseUpHandler(frame, button)
	frame = parentFrame[frame] or frame
	if frame and button == 'LeftButton' then
		frame:StopMovingOrSizing()
	end
end

function f:HookFrames(list)
	for name, child in pairs(list) do
		self:HookFrame(name, child)
	end
end

function f:HookFrame(name, moveParent)
	local frame = _G
	local s
	for s in string.gmatch(name, '%w+') do
	if frame then
		frame = frame[s]
	end
	end

	if frame == _G then
		frame = nil
	end

	local parent
	if frame and not hooked[name] then
		if moveParent then
			if type(moveParent) == 'string' then
				parent = _G[moveParent]
			else
				parent = frame:GetParent()
			end
			if not parent then
				print('Parent frame not found: ' .. name)
				return
			end
			parentFrame[frame] = parent
		end
		if parent then
			parent:SetMovable(true)
			parent:SetClampedToScreen(false)
		end
		frame:EnableMouse(true)
		frame:SetMovable(true)
		frame:SetClampedToScreen(false)
		self:HookScript(frame, 'OnMouseDown', MouseDownHandler)
		self:HookScript(frame, 'OnMouseUp', MouseUpHandler)
		hooked[name] = true
	end
end

function f:HookScript(frame, script, handler)
	if not frame.GetScript then return end

	local oldHandler = frame:GetScript(script)
	if oldHandler then
		frame:SetScript(script, function(...)
			handler(...)
			oldHandler(...)
		end)
	else
		frame:SetScript(script, handler)
	end
end

f:SetScript('OnEvent', function(f, e, ...) f[e](f, ...) end)
f:RegisterEvent('PLAYER_LOGIN')
f:RegisterEvent('ADDON_LOADED')
