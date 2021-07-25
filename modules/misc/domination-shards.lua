local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local mod = mod
local floor = floor
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local PickupContainerItem = PickupContainerItem
local ClickSocketButton = ClickSocketButton
local ClearCursor = ClearCursor
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemID = GetContainerItemID
local GetContainerItemLink = GetContainerItemLink
local GetItemIcon = GetItemIcon
local GetItemCount = GetItemCount
local InCombatLockdown = InCombatLockdown
local GetSocketTypes = GetSocketTypes
local GetExistingSocketInfo = GetExistingSocketInfo

local F, C, L = unpack(select(2, ...))
local DS = F:RegisterModule('DominationShards')
local TOOLTIP = F:GetModule('Tooltip')

local EXTRACTOR_ID = 187532
local foundShards = {}

function DS:DomiShard_Equip()
    if not self.itemLink then
        return
    end

    PickupContainerItem(self.bagID, self.slotID)
    ClickSocketButton(1)
    ClearCursor()
end

function DS:DomiShard_ShowTooltip()
    if not self.itemLink then
        return
    end

    _G.GameTooltip:ClearLines()
    _G.GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
    _G.GameTooltip:SetHyperlink(self.itemLink)
    _G.GameTooltip:Show()
end

function DS:DomiShards_Refresh()
    wipe(foundShards)

    for bagID = 0, 4 do
        for slotID = 1, GetContainerNumSlots(bagID) do
            local itemID = GetContainerItemID(bagID, slotID)
            local rank = itemID and TOOLTIP.DomiRankData[itemID]
            if rank then
                local index = TOOLTIP.DomiIndexData[itemID]
                if not index then
                    break
                end

                local button = DS.DomiShardsFrame.icons[index]
                button.bagID = bagID
                button.slotID = slotID
                button.itemLink = GetContainerItemLink(bagID, slotID)
                button.count:SetText(rank)
                button.Icon:SetDesaturated(false)

                foundShards[index] = true
            end
        end
    end

    for index, button in pairs(DS.DomiShardsFrame.icons) do
        if not foundShards[index] then
            button.itemLink = nil
            button.count:SetText('')
            button.Icon:SetDesaturated(true)
        end
    end
end

function DS:DomiShards_ListFrame()
    if DS.DomiShardsFrame then
        return
    end

    local frame = CreateFrame('Frame', 'FreeUIDomiShards', _G.ItemSocketingFrame)
    frame:SetSize(102, 102)
    frame:SetPoint('RIGHT', -35, 30)
    frame.icons = {}
    DS.DomiShardsFrame = frame

    for index, value in pairs(TOOLTIP.DomiDataByGroup) do
        for itemID in pairs(value) do
            local button = CreateFrame('Button', nil, frame)
            button:SetSize(30, 30)
            button:SetPoint('TOPLEFT', 3 + mod(index - 1, 3) * 33, -3 - floor((index - 1) / 3) * 33)
            F.PixelIcon(button, GetItemIcon(itemID), true)
            button:SetScript('OnClick', DS.DomiShard_Equip)
            button:SetScript('OnEnter', DS.DomiShard_ShowTooltip)
            button:SetScript('OnLeave', F.HideTooltip)
            button.count = F.CreateFS(button, C.Assets.Fonts.Bold, 12, nil, '', 'YELLOW', true, 'BOTTOMRIGHT', -3, 3)

            frame.icons[index] = button
            break
        end
    end

    DS:DomiShards_Refresh()
    F:RegisterEvent('BAG_UPDATE', DS.DomiShards_Refresh)
end

function DS:DomiShards_ExtractButton()
    if DS.DomiExtButton then
        return
    end

    if GetItemCount(EXTRACTOR_ID) == 0 then
        return
    end

    _G.ItemSocketingSocketButton:SetWidth(80)

    if InCombatLockdown() then
        return
    end

    local button = CreateFrame('Button', 'FreeUIExtractorButton', _G.ItemSocketingFrame, 'UIPanelButtonTemplate, SecureActionButtonTemplate')
    button:SetSize(80, 22)
    button:SetText(L['Drop'])
    button:SetPoint('RIGHT', _G.ItemSocketingSocketButton, 'LEFT', -3, 0)
    button:SetAttribute('type', 'macro')
    button:SetAttribute('macrotext', '/use item:' .. EXTRACTOR_ID .. '\n/click ItemSocketingSocket1')

    if _G.FREE_ADB.ReskinBlizz then
        F.Reskin(button)
    end

    DS.DomiExtButton = button
end

function DS:DominationShards()
    hooksecurefunc(
        'ItemSocketingFrame_LoadUI',
        function()
            if not _G.ItemSocketingFrame then
                return
            end

            DS:DomiShards_ListFrame()
            DS:DomiShards_ExtractButton()

            if DS.DomiShardsFrame then
                DS.DomiShardsFrame:SetShown(GetSocketTypes(1) == 'Domination' and not GetExistingSocketInfo(1))
            end

            if DS.DomiExtButton then
                DS.DomiExtButton:SetAlpha(GetSocketTypes(1) == 'Domination' and GetExistingSocketInfo(1) and 1 or 0)
            end
        end
    )
end

function DS:OnLogin()
    DS:DominationShards()
end
