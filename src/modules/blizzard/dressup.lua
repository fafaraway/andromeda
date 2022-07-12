local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

function BLIZZARD:CreatButton(parent, width, height, text, anchor)
    local button = CreateFrame('Button', nil, parent, 'UIPanelButtonTemplate')
    button:SetSize(width, height)
    button:SetPoint(unpack(anchor))
    button:SetText(text)

    if _G.ANDROMEDA_ADB.ReskinBlizz then
        F.Reskin(button)
    end

    return button
end

function BLIZZARD:EnhancedDressup()
    if not C.DB.General.EnhancedDressup then
        return
    end

    local parent = _G.DressUpFrameResetButton
    local button = BLIZZARD:CreatButton(parent, 80, 22, L['Undress'], { 'RIGHT', parent, 'LEFT', -1, 0 })
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

    F.AddTooltip(
        button,
        'ANCHOR_TOP',
        string.format(L['%s Undress all|n%s Undress tabard'], C.MOUSE_LEFT_BUTTON, C.MOUSE_RIGHT_BUTTON)
    )

    _G.DressUpFrame.LinkButton:SetWidth(80)
    _G.DressUpFrame.LinkButton:SetText(_G.SOCIAL_SHARE_TEXT)
end
