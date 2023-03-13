local F, C = unpack(select(2, ...))

local MAX_CONTAINER_ITEMS = 36
local backpackTexture = 'Interface\\Buttons\\Button-Backpack-Up'

local function handleMoneyFrame(frame)
    if frame.MoneyFrame then
        F.StripTextures(frame.MoneyFrame)
        F.CreateBDFrame(frame.MoneyFrame, 0.25)
    end
end

local function createBagIcon(frame, index)
    if not frame.bagIcon then
        frame.bagIcon = frame.PortraitButton:CreateTexture()
        F.ReskinIcon(frame.bagIcon)
        frame.bagIcon:SetPoint('TOPLEFT', 5, -3)
        frame.bagIcon:SetSize(32, 32)
    end
    if index == 1 then
        frame.bagIcon:SetTexture(backpackTexture) -- backpack
    end
    handleMoneyFrame(frame)
end

local function replaceSortTexture(texture)
    texture:SetTexture('Interface\\Icons\\INV_Pet_Broom') -- HD version
    texture:SetTexCoord(unpack(C.TEX_COORD))
end

local function ReskinSortButton(button)
    replaceSortTexture(button:GetNormalTexture())
    replaceSortTexture(button:GetPushedTexture())
    F.CreateBDFrame(button)

    local highlight = button:GetHighlightTexture()
    highlight:SetColorTexture(1, 1, 1, 0.25)
    highlight:SetAllPoints(button)
end

local function ReskinBagSlot(bu)
    bu:SetNormalTexture(0)
    bu:SetPushedTexture(0)
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

    local hl = bu.SlotHighlightTexture
    if hl then
        hl:SetColorTexture(1, 0.8, 0, 0.5)
    end
end

local function updateContainer(frame)
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

    if frame.bagIcon and id ~= 0 then
        local invID = C_Container.ContainerIDToInventoryID(id)
        if invID then
            local icon = GetInventoryItemTexture('player', invID)
            frame.bagIcon:SetTexture(icon or backpackTexture)
        end
    end
end

local function emptySlotBG(button)
    if button.ItemSlotBackground then
        button.ItemSlotBackground:Hide()
    end
end

tinsert(C.BlizzThemes, function()
    if C.DB.Inventory.Enable then
        return
    end

    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    for i = 1, 13 do
        local frameName = 'ContainerFrame' .. i
        local frame = _G[frameName]
        local name = frame.TitleText or _G[frameName .. 'TitleText']
        name:SetDrawLayer('OVERLAY')
        name:ClearAllPoints()
        name:SetPoint('TOP', 0, -10)
        F.ReskinClose(frame.CloseButton)

        F.StripTextures(frame)
        F.SetBD(frame)
        frame.PortraitContainer:Hide()
        if frame.Bg then
            frame.Bg:Hide()
        end
        createBagIcon(frame, i)
        hooksecurefunc(frame, 'Update', updateContainer)

        for k = 1, MAX_CONTAINER_ITEMS do
            local button = _G[frameName .. 'Item' .. k]
            ReskinBagSlot(button)
            hooksecurefunc(button, 'ChangeOwnership', emptySlotBG)
        end
    end

    F.StripTextures(_G.BackpackTokenFrame)
    F.CreateBDFrame(_G.BackpackTokenFrame, 0.25)

    hooksecurefunc(_G.BackpackTokenFrame, 'Update', function(self)
        local tokens = self.Tokens
        if next(tokens) then
            for i = 1, #tokens do
                local token = tokens[i]
                if not token.styled then
                    F.ReskinIcon(token.Icon)
                    token.styled = true
                end
            end
        end
    end)

    F.ReskinEditbox(_G.BagItemSearchBox)
    ReskinSortButton(_G.BagItemAutoSortButton)

    -- Combined bags
    F.ReskinPortraitFrame(_G.ContainerFrameCombinedBags)
    createBagIcon(_G.ContainerFrameCombinedBags, 1)
    _G.ContainerFrameCombinedBags.PortraitButton.Highlight:SetTexture('')

    -- [[ Bank ]]

    _G.BankSlotsFrame:DisableDrawLayer('BORDER')
    _G.BankFrameMoneyFrameInset:Hide()
    _G.BankFrameMoneyFrameBorder:Hide()

    -- "item slots" and "bag slots" text
    select(9, _G.BankSlotsFrame:GetRegions()):SetDrawLayer('OVERLAY')
    select(10, _G.BankSlotsFrame:GetRegions()):SetDrawLayer('OVERLAY')

    F.ReskinPortraitFrame(_G.BankFrame)
    F.ReskinButton(_G.BankFramePurchaseButton)
    F.ReskinTab(_G.BankFrameTab1)
    F.ReskinTab(_G.BankFrameTab2)
    F.ReskinEditbox(_G.BankItemSearchBox)

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

    F.ReskinButton(_G.ReagentBankFrame.DespositButton)
    F.ReskinButton(_G.ReagentBankFrameUnlockInfoPurchaseButton)

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
