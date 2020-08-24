local F, C, L = unpack(select(2, ...))
local MISC = F:GetModule('MISC')


local _G = getfenv(0)


local MISC_LIST = {}

function MISC:RegisterMisc(name, func)
	if not MISC_LIST[name] then
		MISC_LIST[name] = func
	end
end

function MISC:OnLogin()
	for name, func in next, MISC_LIST do
		if name and type(func) == 'function' then
			func()
		end
	end


	self:InstantLoot()

	self:BlowMyWhistle()

	self:ForceWarning()
	self:FasterCamera()
	self:CombatCamera()

	_G.BINDING_HEADER_FREEUI = '|cffe6e6e6Free|r'..C.MyColor..'UI|r'

	-- Registering fonts in LibSharedMedia
	local LSM = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0', true)
	if not LSM then return end

	local LOCALE_MASK = 0
	if C.Client == 'koKR' then
		LOCALE_MASK = 1
	elseif C.Client == 'ruRU' then
		LOCALE_MASK = 2
	elseif C.Client == 'zhCN' then
		LOCALE_MASK = 4
	elseif C.Client == 'zhTW' then
		LOCALE_MASK = 8
	else
		LOCALE_MASK = 128
	end

	LSM:Register(LSM.MediaType.FONT, '!Free_normal', C.Assets.Fonts.Normal, LOCALE_MASK)
	LSM:Register(LSM.MediaType.FONT, '!Free_number', C.Assets.Fonts.Number, LOCALE_MASK)
	LSM:Register(LSM.MediaType.FONT, '!Free_chat', C.Assets.Fonts.Chat, LOCALE_MASK)
	LSM:Register(LSM.MediaType.FONT, '!Free_header', C.Assets.Fonts.Header, LOCALE_MASK)
	LSM:Register(LSM.MediaType.FONT, '!Free_combat', C.Assets.Fonts.Combat, LOCALE_MASK)

	LSM:Register(LSM.MediaType.STATUSBAR, '!Free_norm', C.AssetsPath..'textures\\norm_tex')
	LSM:Register(LSM.MediaType.STATUSBAR, '!Free_grad', C.Assets.grad_tex)
	LSM:Register(LSM.MediaType.STATUSBAR, '!Free_flat', C.Assets.flat_tex)
end






-- Plays a soundbite from Whistle - Flo Rida after Flight Master's Whistle
function MISC:BlowMyWhistle()
	if not FreeDB['blow_my_whistle'] then return end

	local whistleSound = 'Interface\\AddOns\\FreeUI\\assets\\sound\\whistle.ogg'
	local whistle_SpellID1 = 227334;
	-- for some reason the whistle is two spells which results in dirty events being called
	-- where spellID2 fires SUCCEEDED on spell cast start and spellID1 comes in later as the real SUCCEEDED
	local whistle_SpellID2 = 253937;

	local casting = false;

	local f = CreateFrame('frame')
	f:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end);

	function f:UNIT_SPELLCAST_SUCCEEDED(unit,lineID,spellID)
		if (unit == 'player' and (spellID == whistle_SpellID1 or spellID == whistle_SpellID2)) then
			if casting then
				casting = false
				return
			end

			PlaySoundFile(whistleSound)
			casting = false
		end
	end

	function f:UNIT_SPELLCAST_START(event, castGUID, spellID)
		if spellID == whistle_SpellID1 then
			casting = true
		end
	end
	f:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
	f:RegisterEvent('UNIT_SPELLCAST_START')
end



function MISC:ForceWarning()
	local f = CreateFrame('Frame')
	f:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
	f:RegisterEvent('PET_BATTLE_QUEUE_PROPOSE_MATCH')
	f:RegisterEvent('LFG_PROPOSAL_SHOW')
	f:RegisterEvent('RESURRECT_REQUEST')
	f:SetScript('OnEvent', function(_, event)
		if event == 'UPDATE_BATTLEFIELD_STATUS' then
			for i = 1, GetMaxBattlefieldID() do
				local status = GetBattlefieldStatus(i)
				if status == 'confirm' then
					PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
					break
				end
				i = i + 1
			end
		elseif event == 'PET_BATTLE_QUEUE_PROPOSE_MATCH' then
			PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
		elseif event == 'LFG_PROPOSAL_SHOW' then
			PlaySound(SOUNDKIT.READY_CHECK, 'Master')
		elseif event == 'RESURRECT_REQUEST' then
			PlaySound(37, 'Master')
		end
	end)
end

local ShowReadyCheckHook = function(_, initiator)
	if initiator ~= 'player' then
		PlaySound(SOUNDKIT.READY_CHECK, 'Master')
	end
end
hooksecurefunc('ShowReadyCheck', ShowReadyCheckHook)


function MISC:FasterCamera()
	if not FreeDB['faster_camera'] then return end

	local oldZoomIn = CameraZoomIn
	local oldZoomOut = CameraZoomOut
	local oldVehicleZoomIn = VehicleCameraZoomIn
	local oldVehicleZoomOut = VehicleCameraZoomOut
	local newZoomSpeed = 4

	function CameraZoomIn(distance)
		oldZoomIn(newZoomSpeed)
	end

	function CameraZoomOut(distance)
		oldZoomOut(newZoomSpeed)
	end

	function VehicleCameraZoomIn(distance)
		oldVehicleZoomIn(newZoomSpeed)
	end

	function VehicleCameraZoomOut(distance)
		oldVehicleZoomOut(newZoomSpeed)
	end
end

UIParent:UnregisterEvent('EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED')
local function SetCam(cmd)
	ConsoleExec('ActionCam ' .. cmd)
end
function MISC:CombatCamera()
	SetCam(FreeDB['action_camera'] and 'basic' or 'off')
end



local lootDelay = 0
local function instantLoot()
	if GetTime() - lootDelay >= 0.3 then
		lootDelay = GetTime()
		if GetCVarBool('autoLootDefault') ~= IsModifiedClick('AUTOLOOTTOGGLE') then
			for i = GetNumLootItems(), 1, -1 do
				LootSlot(i)
			end
			lootDelay = GetTime()
		end
	end
end

function MISC:InstantLoot()
	if FreeDB['instant_loot'] then
		F:RegisterEvent('LOOT_READY', instantLoot)
	else
		F:UnregisterEvent('LOOT_READY', instantLoot)
	end
end




-- auto select current event boss from LFD tool
do
	local firstLFD
	LFDParentFrame:HookScript('OnShow', function()
		if not firstLFD then
			firstLFD = 1
			for i = 1, GetNumRandomDungeons() do
				local id = GetLFGRandomDungeonInfo(i)
				local isHoliday = select(15, GetLFGDungeonInfo(id))
				if isHoliday and not GetLFGDungeonRewards(id) then
					LFDQueueFrame_SetType(id)
				end
			end
		end
	end)
end
