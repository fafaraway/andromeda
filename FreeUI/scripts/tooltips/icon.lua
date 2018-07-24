local F, C, L = unpack(select(2, ...))

if not C.tooltip.enable then return end

IDCard = {}
local registry = {}
local hookfactory = function(hook,orig)
	return function(self,...)
		local reg = registry[self]
		if reg[orig] then reg[orig](self,...) end
		hook(reg.button,self,...)
	end
end

local setItem = hookfactory(function(b,self)
	local _,id = self:GetItem()
	if id and GetItemIcon(id) then
		b:SetNormalTexture(GetItemIcon(id))
		b.link = id
		b.type = "item"
	end
end,"setItem")

local function openToAchievement(link)
	if not (AchievementFrame and AchievementFrame:IsShown()) then
		ToggleAchievementFrame()
	end
	local id = tonumber(link:match("achievement:(%d+)"))
	if not id then return end
	
	AchievementFrame_SelectAchievement(id)
end

local cleared = hookfactory(function(b,self)
	b:SetNormalTexture(nil)
	-- b.achOverlay:Hide()
	b.type = nil
	b.link = nil
end,"cleared")

local setHyperlink = hookfactory(function(b,self,link)
	if not (link and type(link) == "string") then return end
	local linkType,id = link:match("^([^:]+):(%d+)")
	if linkType == "achievement" and id then
		b.link = GetAchievementLink(id)
		b:SetNormalTexture(select(10,GetAchievementInfo(id)))
		-- b.achOverlay:Show()
		b.type = "achievement"
	elseif linkType == "spell" and id then
		b.link = GetSpellLink(id)
		b:SetNormalTexture(select(3,GetSpellInfo(id)))
		b.type = "spell"
	end
end,"setHyperlink")

local function click(self)
	if IsModifiedClick("CHATLINK") and self.link then
		local frame = GetCurrentKeyBoardFocus()
		if frame and frame:IsObjectType("EditBox") then
			frame:Insert(self.link)
		end
	elseif IsModifiedClick("DRESSUP") and self.link then
		if     self.type == "item" then DressUpItemLink(self.link)
		elseif self.type == "achievement" then openToAchievement(self.link) end
	end
end

local function dragstart(self)self:GetParent():StartMoving()end
local function dragstop(self)self:GetParent():StopMovingOrSizing()end

function IDCard:RegisterTooltip(tooltip)
	if registry[tooltip] then return end
	local reg = {}
	registry[tooltip] = reg
		
	local b = CreateFrame("Button",nil,tooltip)
	b:SetWidth(37)
	b:SetHeight(37)
	b:SetPoint("TOPRIGHT",tooltip,"TOPLEFT",-2,-2)
	b:SetScript("OnDragStart",dragstart)
	b:SetScript("OnDragStop",dragstop)
	b:SetScript("OnClick",click)
	b:RegisterForDrag("LeftButton")
	reg.button = b

	F.CreateSD(b)
	
	-- local t = b:CreateTexture(nil,"OVERLAY")
	-- t:SetTexture("Interface\\AchievementFrame\\UI-Achievement-IconFrame")
	-- t:SetTexCoord(0,0.5625,0,0.5625)
	-- t:SetPoint("CENTER",0,0)
	-- t:SetWidth(47)
	-- t:SetHeight(47)	
	-- t:Hide()
	-- b.achOverlay = t
		
	reg.setItem = tooltip:GetScript("OnTooltipSetItem")
	reg.cleared = tooltip:GetScript("OnTooltipCleared")
	reg.setHyperlink = tooltip.SetHyperlink
	tooltip:SetScript("OnTooltipSetItem",setItem)
	tooltip:SetScript("OnTooltipCleared",cleared)
	tooltip.SetHyperlink  = setHyperlink
end

IDCard:RegisterTooltip(ItemRefTooltip)

local newString = "0:0:64:64:5:59:5:59"

-- WorldQuest Tooltip
hooksecurefunc("EmbeddedItemTooltip_SetItemByQuestReward", function(self)
	if self.Icon then
		F.ReskinIcon(self.Icon)
		self.IconBorder:Hide()
	end
end)
_G.BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT = "|T%1$s:16:16:"..newString.."|t |cffffffff%2$d|r %3$s"
_G.BONUS_OBJECTIVE_REWARD_FORMAT = "|T%1$s:16:16:"..newString.."|t %2$s"

-- PVPReward Tooltip
hooksecurefunc("EmbeddedItemTooltip_SetItemByID", function(self)
	if self.Icon then
		F.ReskinIcon(self.Icon)
		self.IconBorder:Hide()
	end
end)