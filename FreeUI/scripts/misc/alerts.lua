local F, C, L = unpack(select(2, ...))
local MISC = F:GetModule('Misc')


local _G = getfenv(0)
local ipairs, tremove = ipairs, table.remove
local UIParent = _G.UIParent
local AlertFrame = _G.AlertFrame
local GroupLootContainer = _G.GroupLootContainer

local POSITION, ANCHOR_POINT, YOFFSET = 'TOP', 'BOTTOM', -10
local parentFrame

function MISC:AlertFrame_UpdateAnchor()
	local y = select(2, parentFrame:GetCenter())
	local screenHeight = UIParent:GetTop()
	if y > screenHeight/2 then
		POSITION = 'TOP'
		ANCHOR_POINT = 'BOTTOM'
		YOFFSET = -10
	else
		POSITION = 'BOTTOM'
		ANCHOR_POINT = 'TOP'
		YOFFSET = 10
	end

	self:ClearAllPoints()
	self:SetPoint(POSITION, parentFrame)
	GroupLootContainer:ClearAllPoints()
	GroupLootContainer:SetPoint(POSITION, parentFrame)
end

function MISC:UpdatGroupLootContainer()
	local lastIdx = nil

	for i = 1, self.maxIndex do
		local frame = self.rollFrames[i]
		if frame then
			frame:ClearAllPoints()
			frame:SetPoint('CENTER', self, POSITION, 0, self.reservedSize * (i-1 + 0.5) * YOFFSET/10)
			lastIdx = i
		end
	end

	if lastIdx then
		self:SetHeight(self.reservedSize * lastIdx)
		self:Show()
	else
		self:Hide()
	end
end

function MISC:AlertFrame_SetPoint(relativeAlert)
	self:ClearAllPoints()
	self:SetPoint(POSITION, relativeAlert, ANCHOR_POINT, 0, YOFFSET)
end

function MISC:AlertFrame_AdjustQueuedAnchors(relativeAlert)
	for alertFrame in self.alertFramePool:EnumerateActive() do
		MISC.AlertFrame_SetPoint(alertFrame, relativeAlert)
		relativeAlert = alertFrame
	end

	return relativeAlert
end

function MISC:AlertFrame_AdjustAnchors(relativeAlert)
	if self.alertFrame:IsShown() then
		MISC.AlertFrame_SetPoint(self.alertFrame, relativeAlert)
		return self.alertFrame
	end

	return relativeAlert
end

function MISC:AlertFrame_AdjustAnchorsNonAlert(relativeAlert)
	if self.anchorFrame:IsShown() then
		MISC.AlertFrame_SetPoint(self.anchorFrame, relativeAlert)
		return self.anchorFrame
	end

	return relativeAlert
end

function MISC:AlertFrame_AdjustPosition()
	if self.alertFramePool then
		self.AdjustAnchors = MISC.AlertFrame_AdjustQueuedAnchors
	elseif not self.anchorFrame then
		self.AdjustAnchors = MISC.AlertFrame_AdjustAnchors
	elseif self.anchorFrame then
		self.AdjustAnchors = MISC.AlertFrame_AdjustAnchorsNonAlert
	end
end

local function MoveTalkingHead()
	local TalkingHeadFrame = _G.TalkingHeadFrame

	TalkingHeadFrame.ignoreFramePositionManager = true
	TalkingHeadFrame:ClearAllPoints()
	TalkingHeadFrame:SetPoint('BOTTOM', 0, 120)

	for index, alertFrameSubSystem in ipairs(AlertFrame.alertFrameSubSystems) do
		if alertFrameSubSystem.anchorFrame and alertFrameSubSystem.anchorFrame == TalkingHeadFrame then
			tremove(AlertFrame.alertFrameSubSystems, index)
		end
	end
end

local function NoTalkingHeads()
	if not C.general.hideTalkingHead then return end

	hooksecurefunc(TalkingHeadFrame, 'Show', function(self)
		self:Hide()
	end)
end

local function TalkingHeadOnLoad(_, addon)
	if addon == 'Blizzard_TalkingHeadUI' then
		MoveTalkingHead()
		NoTalkingHeads()
		F:UnregisterEvent(event, TalkingHeadOnLoad)
	end
end

function MISC:AlertFrame()
	parentFrame = CreateFrame('Frame', nil, UIParent)
	parentFrame:SetSize(200, 30)
	F.Mover(parentFrame, L['MOVER_ALERT_FRAMES'], 'AlertFrames', {'CENTER', UIParent, 0, 200})

	GroupLootContainer:EnableMouse(false)
	GroupLootContainer.ignoreFramePositionManager = true

	for _, alertFrameSubSystem in ipairs(AlertFrame.alertFrameSubSystems) do
		MISC.AlertFrame_AdjustPosition(alertFrameSubSystem)
	end

	hooksecurefunc(AlertFrame, 'AddAlertFrameSubSystem', function(_, alertFrameSubSystem)
		MISC.AlertFrame_AdjustPosition(alertFrameSubSystem)
	end)

	hooksecurefunc(AlertFrame, 'UpdateAnchors', MISC.AlertFrame_UpdateAnchor)
	hooksecurefunc('GroupLootContainer_Update', MISC.UpdatGroupLootContainer)

	if IsAddOnLoaded('Blizzard_TalkingHeadUI') then
		MoveTalkingHead()
		NoTalkingHeads()
	else
		F:RegisterEvent('ADDON_LOADED', TalkingHeadOnLoad)
	end
end 
