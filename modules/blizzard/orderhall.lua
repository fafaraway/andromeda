local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('BLIZZARD')


local ipairs, format = ipairs, format
local IsShiftKeyDown = IsShiftKeyDown
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_Garrison_GetCurrencyTypes = C_Garrison.GetCurrencyTypes
local C_Garrison_GetClassSpecCategoryInfo = C_Garrison.GetClassSpecCategoryInfo
local C_Garrison_RequestClassSpecCategoryInfo = C_Garrison.RequestClassSpecCategoryInfo
local LE_GARRISON_TYPE_7_0 = Enum.GarrisonType.Type_7_0
local LE_FOLLOWER_TYPE_GARRISON_7_0 = Enum.GarrisonFollowerType.FollowerType_7_0

function BLIZZARD:OrderHall_CreateIcon()
	local hall = CreateFrame('Frame', 'FreeUI_OrderHallIcon', UIParent)
	hall:SetSize(50, 50)
	hall:SetPoint('TOP', 0, -30)
	hall:SetFrameStrata('HIGH')
	hall:Hide()
	F.CreateMF(hall, nil, true)
	F.RestoreMF(hall)
	BLIZZARD.OrderHallIcon = hall

	hall.Icon = hall:CreateTexture(nil, 'ARTWORK')
	hall.Icon:SetAllPoints()
	hall.Icon:SetTexture('Interface\\TargetingFrame\\UI-Classes-Circles')
	hall.Icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[C.MyClass]))
	hall.Category = {}

	hall:SetScript('OnEnter', BLIZZARD.OrderHall_OnEnter)
	hall:SetScript('OnLeave', BLIZZARD.OrderHall_OnLeave)
	hooksecurefunc(OrderHallCommandBar, 'SetShown', function(_, state)
		hall:SetShown(state)
	end)

	-- Default objects
	F.HideOption(OrderHallCommandBar)
	F.HideObject(OrderHallCommandBar.CurrencyHitTest)
end

function BLIZZARD:OrderHall_Refresh()
	C_Garrison_RequestClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
	local currency = C_Garrison_GetCurrencyTypes(LE_GARRISON_TYPE_7_0)
	local info = C_CurrencyInfo_GetCurrencyInfo(currency)
	self.name = info.name
	self.amount = info.quantity
	self.texture = info.iconFileID

	local categoryInfo = C_Garrison_GetClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
	for index, info in ipairs(categoryInfo) do
		local category = self.Category
		if not category[index] then category[index] = {} end
		category[index].name = info.name
		category[index].count = info.count
		category[index].limit = info.limit
		category[index].description = info.description
		category[index].icon = info.icon
	end
	self.numCategory = #categoryInfo
end

function BLIZZARD:OrderHall_OnShiftDown(btn)
	if btn == 'LSHIFT' then
		BLIZZARD.OrderHall_OnEnter(BLIZZARD.OrderHallIcon)
	end
end

local function getIconString(texture)
	return format('|T%s:12:12:0:0:64:64:5:59:5:59|t ', texture)
end

function BLIZZARD:OrderHall_OnEnter()
	BLIZZARD.OrderHall_Refresh(self)

	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT', 5, -5)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(C.MyColor.._G['ORDER_HALL_'..C.MyClass])
	GameTooltip:AddLine(' ')
	GameTooltip:AddDoubleLine(getIconString(self.texture)..self.name, self.amount, 1,1,1, 1,1,1)

	local blank
	for i = 1, self.numCategory do
		if not blank then
			GameTooltip:AddLine(' ')
			blank = true
		end
		local category = self.Category[i]
		if category then
			GameTooltip:AddDoubleLine(getIconString(category.icon)..category.name, category.count..'/'..category.limit, 1,1,1, 1,1,1)
			if IsShiftKeyDown() then
				GameTooltip:AddLine(category.description, .6,.8,1, 1)
			end
		end
	end

	GameTooltip:AddDoubleLine(' ', C.LineString)
	GameTooltip:AddDoubleLine(' ', L['BLIZZARD_ORDERHALL_TIP'], 1,1,1, .6,.8,1)
	GameTooltip:Show()

	F:RegisterEvent('MODIFIER_STATE_CHANGED', BLIZZARD.OrderHall_OnShiftDown)
end

function BLIZZARD:OrderHall_OnLeave()
	GameTooltip:Hide()
	F:UnregisterEvent('MODIFIER_STATE_CHANGED', BLIZZARD.OrderHall_OnShiftDown)
end

function BLIZZARD:OrderHall_OnLoad(addon)
	if addon == 'Blizzard_OrderHallUI' then
		BLIZZARD:OrderHall_CreateIcon()
		F:UnregisterEvent(self, BLIZZARD.OrderHall_OnLoad)
	end
end

function BLIZZARD:OrderHall_OnInit()
	if not C.DB.blizzard.orderhall_icon then return end

	if IsAddOnLoaded('Blizzard_OrderHallUI') then
		BLIZZARD:OrderHall_CreateIcon()
	else
		F:RegisterEvent('ADDON_LOADED', BLIZZARD.OrderHall_OnLoad)
	end
end

BLIZZARD:RegisterBlizz('OrderHallIcon', BLIZZARD.OrderHall_OnInit)
