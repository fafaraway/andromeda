local _G = _G
local unpack = unpack
local select = select
local format = format
local CreateFrame = CreateFrame

local F, C, L = unpack(select(2, ...))
local BLIZZARD = F.BLIZZARD

function BLIZZARD:CreatButton(parent, width, height, text, anchor)
    local button = CreateFrame('Button', nil, parent, 'UIPanelButtonTemplate')
    button:SetSize(width, height)
    button:SetPoint(unpack(anchor))
    button:SetText(text)

    if _G.FREE_ADB.reskin_blizz then
        F.Reskin(button)
    end

    return button
end

function BLIZZARD:EnhanceDressup()
    if not C.DB.blizzard.EnhanceDressup then
        return
    end

    local parent = _G.DressUpFrameResetButton
    local button = BLIZZARD:CreatButton(parent, 80, 22, L.BLIZZARD.UNDRESS, {'RIGHT', parent, 'LEFT', -1, 0})
    button:RegisterForClicks('AnyUp')
    button:SetScript('OnClick', function(_, btn)
        local actor = _G.DressUpFrame.ModelScene:GetPlayerActor()
        if not actor then
            return
        end

        if btn == 'LeftButton' then
            actor:Undress()
        else
            actor:UndressSlot(19)
        end
    end)

    F.AddTooltip(button, 'ANCHOR_TOP', format(L.BLIZZARD.UNDRESS_TIP, C.Assets.mouse_left, C.Assets.mouse_right))
end
BLIZZARD:RegisterBlizz('EnhanceDressup', BLIZZARD.EnhanceDressup)
