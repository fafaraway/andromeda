local F, C, L = unpack(select(2, ...))
local MISC = F:GetModule('Misc')


local ipairs, format = ipairs, format
local GetCurrencyInfo, IsShiftKeyDown = GetCurrencyInfo, IsShiftKeyDown
local C_Garrison_GetCurrencyTypes = C_Garrison.GetCurrencyTypes
local C_Garrison_GetClassSpecCategoryInfo = C_Garrison.GetClassSpecCategoryInfo
local C_Garrison_RequestClassSpecCategoryInfo = C_Garrison.RequestClassSpecCategoryInfo
local LE_GARRISON_TYPE_7_0, LE_FOLLOWER_TYPE_GARRISON_7_0 = LE_GARRISON_TYPE_7_0, LE_FOLLOWER_TYPE_GARRISON_7_0

function MISC:OrderHall_CreateIcon()
	local hall = CreateFrame('Frame', 'NDuiOrderHallIcon', UIParent)
	hall:SetSize(50, 50)
	hall:SetPoint('TOP', 0, -30)
	hall:SetFrameStrata('HIGH')
	hall:Hide()
	F.CreateMF(hall, nil, true)
	F.RestoreMF(hall)
	M.OrderHallIcon = hall

	hall.Icon = hall:CreateTexture(nil, 'ARTWORK')
	hall.Icon:SetAllPoints()
	hall.Icon:SetTexture('Interface\\TargetingFrame\\UI-Classes-Circles')
	hall.Icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[C.MyClass]))
	hall.Category = {}

	hall:SetScript('OnEnter', MISC.OrderHall_OnEnter)
	hall:SetScript('OnLeave', MISC.OrderHall_OnLeave)
	hooksecurefunc(OrderHallCommandBar, 'SetShown', function(_, state)
		hall:SetShown(state)
	end)

	-- Default objects
	F.HideOption(OrderHallCommandBar)
	F.HideObject(OrderHallCommandBar.CurrencyHitTest)
	GarrisonLandingPageTutorialBox:SetClampedToScreen(true)
end

function MISC:OrderHall_Refresh()
	C_Garrison_RequestClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
	local currency = C_Garrison_GetCurrencyTypes(LE_GARRISON_TYPE_7_0)
	self.name, self.amount, self.texture = GetCurrencyInfo(currency)

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

function MISC:OrderHall_OnShiftDown(btn)
	if btn == 'LSHIFT' then
		MISC.OrderHall_OnEnter(MISC.OrderHallIcon)
	end
end

local function getIconString(texture)
	return format('|T%s:12:12:0:0:64:64:5:59:5:59|t ', texture)
end

function MISC:OrderHall_OnEnter()
	M.OrderHall_Refresh(self)

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
	GameTooltip:AddDoubleLine(' ', L['MISC_ORDERHALL_TIP'], 1,1,1, .6,.8,1)
	GameTooltip:Show()

	F:RegisterEvent('MODIFIER_STATE_CHANGED', MISC.OrderHall_OnShiftDown)
end

function MISC:OrderHall_OnLeave()
	GameTooltip:Hide()
	F:UnregisterEvent('MODIFIER_STATE_CHANGED', MISC.OrderHall_OnShiftDown)
end

function MISC:OrderHall_OnLoad(addon)
	if addon == 'Blizzard_OrderHallUI' then
		MISC:OrderHall_CreateIcon()
		F:UnregisterEvent(self, MISC.OrderHall_OnLoad)
	end
end

function MISC:OrderHall_OnInit()
	if not FreeUIConfigs['order_hall'] then return end

	if IsAddOnLoaded('Blizzard_OrderHallUI') then
		MISC:OrderHall_CreateIcon()
	else
		F:RegisterEvent('ADDON_LOADED', MISC.OrderHall_OnLoad)
	end
end
MISC:RegisterMisc('OrderHallIcon', MISC.OrderHall_OnInit)
