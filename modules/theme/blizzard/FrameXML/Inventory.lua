local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local hooksecurefunc = hooksecurefunc
local GetInventoryItemTexture = GetInventoryItemTexture
local BankFrameItemButton_Update = BankFrameItemButton_Update

local F, C = unpack(select(2, ...))

local MAX_CONTAINER_ITEMS = 36

local backpackTexture = 'Interface\\Buttons\\Button-Backpack-Up'
local bagIDToInvID = {
    [1] = 20,
    [2] = 21,
    [3] = 22,
    [4] = 23,
    [5] = 80,
    [6] = 81,
    [7] = 82,
    [8] = 83,
    [9] = 84,
    [10] = 85,
    [11] = 86,
}

local function CreateBagIcon(frame, index)
    if not frame.bagIcon then
        frame.bagIcon = frame.PortraitButton:CreateTexture()
        F.ReskinIcon(frame.bagIcon)
        frame.bagIcon:SetPoint('TOPLEFT', 5, -3)
        frame.bagIcon:SetSize(32, 32)
    end
    if index == 1 then
        frame.bagIcon:SetTexture(backpackTexture) -- backpack
    end
end

local function ReplaceSortTexture(texture)
    texture:SetTexture('Interface\\Icons\\INV_Pet_Broom') -- HD version
    texture:SetTexCoord(unpack(C.TEX_COORD))
end

local function ReskinSortButton(button)
    ReplaceSortTexture(button:GetNormalTexture())
    ReplaceSortTexture(button:GetPushedTexture())
    F.CreateBDFrame(button)

    local highlight = button:GetHighlightTexture()
    highlight:SetColorTexture(1, 1, 1, 0.25)
    highlight:SetAllPoints(button)
end

local function ReskinBagSlot(bu)
    bu:SetNormalTexture('')
    bu:SetPushedTexture('')
    bu:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
    bu.searchOverlay:SetOutside()

    bu.icon:SetTexCoord(unpack(C.TEX_COORD))
    bu.bg = F.CreateBDFrame(bu.icon, 0.25)
    F.ReskinIconBorder(bu.IconBorder)

    local questTexture = bu.IconQuestTexture
    if questTexture then
        questTexture:SetDrawLayer('BACKGROUND')
        questTexture:SetSize(1, 1)
    end
end

tinsert(C.BlizzThemes, function()
    if C.DB.Inventory.Enable then
        return
    end

    -- [[ Bags ]]

    _G.BackpackTokenFrame:GetRegions():Hide()

    for i = 1, 12 do
        local con = _G['ContainerFrame' .. i]
        local name = _G['ContainerFrame' .. i .. 'Name']

        F.StripTextures(con, true)
        con.PortraitButton.Highlight:SetTexture('')
        CreateBagIcon(con, i)

        name:ClearAllPoints()
        name:SetPoint('TOP', 0, -10)

        for k = 1, MAX_CONTAINER_ITEMS do
            local item = 'ContainerFrame' .. i .. 'Item' .. k
            local button = _G[item]
            if not button.IconQuestTexture then
                button.IconQuestTexture = _G[item .. 'IconQuestTexture']
            end
            ReskinBagSlot(button)
        end

        local f = F.SetBD(con)
        f:SetPoint('TOPLEFT', 8, -4)
        f:SetPoint('BOTTOMRIGHT', -4, 3)

        F.ReskinClose(_G['ContainerFrame' .. i .. 'CloseButton'])
    end

    for i = 1, 3 do
        local ic = _G['BackpackTokenFrameToken' .. i .. 'Icon']
        F.ReskinIcon(ic)
    end

    F.ReskinInput(_G.BagItemSearchBox)

    hooksecurefunc('ContainerFrame_Update', function(frame)
        local id = frame:GetID()
        local name = frame:GetName()

        if id == 0 then
            _G.BagItemSearchBox:ClearAllPoints()
            _G.BagItemSearchBox:SetPoint('TOPLEFT', frame, 'TOPLEFT', 50, -35)
            _G.BagItemAutoSortButton:ClearAllPoints()
            _G.BagItemAutoSortButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', -9, -31)
        end

        for i = 1, frame.size do
            local itemButton = _G[name .. 'Item' .. i]
            if _G[name .. 'Item' .. i .. 'IconQuestTexture']:IsShown() then
                itemButton.IconBorder:SetVertexColor(1, 1, 0)
            end
        end

        if frame.bagIcon then
            local invID = bagIDToInvID[id]
            if invID then
                local icon = GetInventoryItemTexture('player', invID)
                frame.bagIcon:SetTexture(icon or backpackTexture)
            end
        end
    end)

    ReskinSortButton(_G.BagItemAutoSortButton)

    -- [[ Bank ]]

    _G.BankSlotsFrame:DisableDrawLayer('BORDER')
    _G.BankPortraitTexture:Hide()
    _G.BankFrameMoneyFrameInset:Hide()
    _G.BankFrameMoneyFrameBorder:Hide()

    -- "item slots" and "bag slots" text
    select(9, _G.BankSlotsFrame:GetRegions()):SetDrawLayer('OVERLAY')
    select(10, _G.BankSlotsFrame:GetRegions()):SetDrawLayer('OVERLAY')

    F.ReskinPortraitFrame(_G.BankFrame)
    F.Reskin(_G.BankFramePurchaseButton)
    F.ReskinTab(_G.BankFrameTab1)
    F.ReskinTab(_G.BankFrameTab2)
    F.ReskinInput(_G.BankItemSearchBox)

    for i = 1, 28 do
        ReskinBagSlot(_G['BankFrameItem' .. i])
    end

    for i = 1, 7 do
        ReskinBagSlot(_G.BankSlotsFrame['Bag' .. i])
    end

    ReskinSortButton(_G.BankItemAutoSortButton)

    hooksecurefunc('BankFrameItemButton_Update', function(button)
        if not button.isBag and button.IconQuestTexture:IsShown() then
            button.IconBorder:SetVertexColor(1, 1, 0)
        end
    end)

    -- [[ Reagent bank ]]

    _G.ReagentBankFrame:DisableDrawLayer('BACKGROUND')
    _G.ReagentBankFrame:DisableDrawLayer('BORDER')
    _G.ReagentBankFrame:DisableDrawLayer('ARTWORK')

    F.Reskin(_G.ReagentBankFrame.DespositButton)
    F.Reskin(_G.ReagentBankFrameUnlockInfoPurchaseButton)

    -- make button more visible
    F.StripTextures(_G.ReagentBankFrameUnlockInfo)
    _G.ReagentBankFrameUnlockInfoBlackBG:SetColorTexture(0.1, 0.1, 0.1)

    local reagentButtonsStyled = false
    _G.ReagentBankFrame:HookScript('OnShow', function()
        if not reagentButtonsStyled then
            for i = 1, 98 do
                local button = _G['ReagentBankFrameItem' .. i]
                ReskinBagSlot(button)
                BankFrameItemButton_Update(button)
            end
            reagentButtonsStyled = true
        end
    end)
end)
