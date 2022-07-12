local F, C, L = unpack(select(2, ...))
local INVENTORY = F:GetModule('Inventory')

local isShown, isBankEmpty, autoRepair, repairAllCost, canRepair

local function delayFunc()
    if isBankEmpty then
        autoRepair(true)
    else
        F:Print(
            string.format(
                C.GREEN_COLOR .. '%s|r %s',
                L['Repair cost covered by Guild Bank'],
                GetMoneyString(repairAllCost, true)
            )
        )
    end
end

function autoRepair(override)
    if isShown and not override then
        return
    end

    isShown = true
    isBankEmpty = false

    local myMoney = GetMoney()
    repairAllCost, canRepair = GetRepairAllCost()

    if canRepair and repairAllCost > 0 then
        if
            not override
            and _G.ANDROMEDA_ADB['RepairType'] == 1
            and IsInGuild()
            and CanGuildBankRepair()
            and GetGuildBankWithdrawMoney() >= repairAllCost
        then
            RepairAllItems(true)
        else
            if myMoney > repairAllCost then
                RepairAllItems()
                F:Print(
                    string.format(C.GREEN_COLOR .. '%s|r %s', L['Repair cost'], GetMoneyString(repairAllCost, true))
                )
                return
            else
                F:Print(C.RED_COLOR .. L['You have insufficient funds to repair your equipment!'])
                return
            end
        end

        F:Delay(0.5, delayFunc)
    end

    PlaySound(SOUNDKIT.ITEM_REPAIR)
end

local function checkBankFund(_, msgType)
    if msgType == _G.LE_GAME_ERR_GUILD_NOT_ENOUGH_MONEY then
        isBankEmpty = true
    end
end

local function merchantClose()
    isShown = false

    F:UnregisterEvent('UI_ERROR_MESSAGE', checkBankFund)
    F:UnregisterEvent('MERCHANT_CLOSED', merchantClose)
end

local function merchantShow()
    if IsAltKeyDown() or _G.ANDROMEDA_ADB['RepairType'] == 0 or not CanMerchantRepair() then
        return
    end

    autoRepair()

    F:RegisterEvent('UI_ERROR_MESSAGE', checkBankFund)
    F:RegisterEvent('MERCHANT_CLOSED', merchantClose)
end

function INVENTORY:AutoRepair()
    F:RegisterEvent('MERCHANT_SHOW', merchantShow)
end
