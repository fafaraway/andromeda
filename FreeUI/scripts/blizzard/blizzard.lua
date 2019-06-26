local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:RegisterModule('Blizzard')


function BLIZZARD:OnLogin()
	self:Fonts()
	self:BuffFrame()
	self:ReskinPetBattleUI()
	self:ColourPicker()
	self:RepositionUIWidgets()
	self:QuestTracker()
	self:Cooldown()
	self:RemoveTalkingHead()
	self:RemoveBossBanner()
	self:SkipAzeriteAnimation()
	self:Errors()
	self:ReskinDigBar()
	self:Loot()
	self:RaidManager()
	self:DurabilityIndicator()
	self:VehicleIndicator()
	self:QuickJoin()

	-- Unregister talent event
	if PlayerTalentFrame then
		PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	else
		hooksecurefunc('TalentFrame_LoadUI', function()
			PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		end)
	end
end


-- Reposition durability indicator
function BLIZZARD:DurabilityIndicator()
	hooksecurefunc(DurabilityFrame, 'SetPoint', function(_, _, parent)
		if parent ~= UIParent then
			DurabilityFrame:SetScale(1)
			DurabilityFrame:ClearAllPoints()
			DurabilityFrame:SetClampedToScreen(true)
			DurabilityFrame:SetPoint('TOP', UIParent, 'TOP', 0, -200)
		end
	end)
end

-- Reposition vehicle indicator
function BLIZZARD:VehicleIndicator()
	local frame = CreateFrame('Frame', 'FreeUIVehicleIndicatorMover', UIParent)
	frame:SetSize(125, 125)
	local mover = F.Mover(frame, L['MOVER_VEHICLE_INDICATOR'], 'VehicleIndicator', {'BOTTOMRIGHT', Minimap, 'TOPRIGHT', 0, 0})

	hooksecurefunc(VehicleSeatIndicator, 'SetPoint', function(self, _, parent)
		if parent == 'MinimapCluster' or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint('TOPLEFT', frame)
			self:SetScale(.7)
		end
	end)
end

-- Remove talking head
function BLIZZARD:RemoveTalkingHead()
	local f = CreateFrame('Frame')
	function f:OnEvent(event, addon)
		if C.general.hideTalkingHead then
			if addon == 'Blizzard_TalkingHeadUI' then
				hooksecurefunc('TalkingHeadFrame_PlayCurrent', function()
					TalkingHeadFrame:Hide()
				end)
				self:UnregisterEvent(event)
			end
		end
	end
	f:RegisterEvent('ADDON_LOADED')
	f:SetScript('OnEvent', f.OnEvent)
end

-- Remove Boss Banner
function BLIZZARD:RemoveBossBanner()
	if C.general.hideBossBanner then
		BossBanner:UnregisterAllEvents()
	end
end

-- Reposition UIWidgets
function BLIZZARD:RepositionUIWidgets()
	local function topCenterPosition(self, _, b)
		local holder = _G.TopCenterContainerHolder
		if b and (b ~= holder) then
			self:ClearAllPoints()
			self:SetPoint('CENTER', holder)
			self:SetParent(holder)
		end
	end

	local function belowMinimapPosition(self, _, b)
		local holder = _G.BelowMinimapContainerHolder
		if b and (b ~= holder) then
			self:ClearAllPoints()
			self:SetPoint('CENTER', holder, 'CENTER')
			self:SetParent(holder)
		end
	end

	local topCenterContainer = _G.UIWidgetTopCenterContainerFrame
	local belowMiniMapcontainer = _G.UIWidgetBelowMinimapContainerFrame

	local topCenterHolder = CreateFrame('Frame', 'TopCenterContainerHolder', UIParent)
	topCenterHolder:SetPoint('TOP', UIParent, 'TOP', 0, -30)
	topCenterHolder:SetSize(10, 58)

	local belowMiniMapHolder = CreateFrame('Frame', 'BelowMinimapContainerHolder', UIParent)
	belowMiniMapHolder:SetPoint('TOP', UIParent, 'TOP', 0, -120)
	belowMiniMapHolder:SetSize(128, 40)

	topCenterContainer:ClearAllPoints()
	topCenterContainer:SetPoint('CENTER', topCenterHolder)

	belowMiniMapcontainer:ClearAllPoints()
	belowMiniMapcontainer:SetPoint('CENTER', belowMiniMapHolder, 'CENTER')

	hooksecurefunc(topCenterContainer, 'SetPoint', topCenterPosition)
	hooksecurefunc(belowMiniMapcontainer, 'SetPoint', belowMinimapPosition)
end


-- Select target when click on raid units
do
	local function fixRaidGroupButton()
		for i = 1, 40 do
			local bu = _G['RaidGroupButton'..i]
			if bu and bu.unit and not bu.clickFixed then
				bu:SetAttribute('type', 'target')
				bu:SetAttribute('unit', bu.unit)

				bu.clickFixed = true
			end
		end
	end

	local EventFrame = CreateFrame( 'Frame' )
	EventFrame:RegisterEvent('ADDON_LOADED')
	EventFrame:SetScript('OnEvent', function(self, event, addon)
		if event == 'ADDON_LOADED' and addon == 'Blizzard_RaidUI' then
			if not InCombatLockdown() then
				fixRaidGroupButton()
				self:UnregisterAllEvents()
			else
				self:RegisterEvent('PLAYER_REGEN_ENABLED')
			end
		elseif event == 'PLAYER_REGEN_ENABLED' then
			if RaidGroupButton1 and RaidGroupButton1:GetAttribute('type') ~= 'target' then
				fixRaidGroupButton()
				self:UnregisterAllEvents()
			end
		end
	end)
end


function BLIZZARD:SkipAzeriteAnimation()
	if not (IsAddOnLoaded('Blizzard_AzeriteUI')) then
    	UIParentLoadAddOn('Blizzard_AzeriteUI')
    end
	hooksecurefunc(AzeriteEmpoweredItemUI,'OnItemSet',function(self)
		local itemLocation = self.azeriteItemDataSource:GetItemLocation()
		if self:IsAnyTierRevealing() then
			C_Timer.After(0.7,function() 
				OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation)
			end)
		end
	end)
end


function BLIZZARD:ReskinDigBar()
	local frame, xpBar
	local customPosition = false

	local function setPosition()
		frame:SetPoint("TOP", UIParent, "TOP", 0, -50)
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, _, addon)
		if addon ~= "Blizzard_ArchaeologyUI" then return end
		self:UnregisterEvent("ADDON_LOADED")

		frame = ArcheologyDigsiteProgressBar
		local bar = frame.FillBar

		frame.Shadow:Hide()
		frame.BarBackground:Hide()
		frame.BarBorderAndOverlay:Hide()

		if C.Client == 'zhCN' or C.Client == 'zhTW' then
			frame.BarTitle:SetFont(C.font.normal, 11, "OUTLINE")
		else
			F.SetFS(frame.BarTitle)
		end

		frame.BarTitle:SetPoint("CENTER", 0, 16)

		local width = C.unitframe.player_width
		bar:SetWidth(width)
		frame.Flash:SetWidth(width + 22)

		bar:SetStatusBarTexture(C.media.sbTex)
		bar:SetStatusBarColor(221/255, 197/255, 162/255)

		F.CreateBDFrame(bar)
		F.CreateSD(bar)

		--xpBar = FreeUIExpBar:GetParent()

		frame:HookScript("OnShow", setPosition)
		--xpBar:HookScript("OnShow", setPosition)
		--xpBar:HookScript("OnHide", setPosition)

		hooksecurefunc(frame, "SetPoint", function()
			if not customPosition then
				customPosition = true
				setPosition()
				customPosition = false
			end
		end)
	end)
end