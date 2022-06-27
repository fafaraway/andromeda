local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')

local datas = {
    'Haleth, siweia, Gethe, Zorker, |np3lim, silverwind, Rubgrsch, EKE00372, |nfang2hou, lilbit26, Djamy, Hxcktivist, |nrgd87, Witnesscm, Wetxius, Ketho',
    'FreeUI, NDui, NDui_Plus, ShestakUI, |nRealUI, ElvUI, ElvUI_WindTools',
    'oUF, Ace3, cargBags',
}

function GUI:CreateCreditsFrame(parent)
    local credit = CreateFrame('Frame', nil, parent)
    credit:SetSize(360, 200)
    credit:SetPoint('TOP', 0, -20)

    local outline = _G.ANDROMEDA_ADB.FontOutline
    F.CreateFS(
        credit,
        C.Assets.Font.Heavy,
        18,
        outline,
        L['Credits'],
        { 242 / 255, 211 / 255, 104 / 255 },
        outline or 'THICK',
        'TOP',
        0,
        -10
    )

    GUI:CreateGradientLine(credit, 120, -60, -34, 60, -34)

    F.CreateFS(
        credit,
        C.Assets.Font.Bold,
        16,
        outline,
        datas[1],
        { 110 / 255, 199 / 255, 250 / 255 },
        outline or 'THICK',
        'TOP',
        0,
        -50
    )
    F.CreateFS(
        credit,
        C.Assets.Font.Regular,
        16,
        outline,
        datas[2],
        { 101 / 255, 182 / 255, 252 / 255 },
        outline or 'THICK',
        'TOP',
        0,
        -150
    )
    F.CreateFS(
        credit,
        C.Assets.Font.Condensed,
        16,
        outline,
        datas[3],
        { 110 / 255, 163 / 255, 250 / 255 },
        outline or 'THICK',
        'TOP',
        0,
        -220
    )
end
