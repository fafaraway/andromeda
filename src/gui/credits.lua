local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')

local datas = {
    people = 'Haleth, siweia, Gethe, Zorker, |np3lim, silverwind, Rubgrsch, EKE00372, |nfang2hou, lilbit26, Djamy, Hxcktivist, |nrgd87, Witnesscm, Wetxius, Ketho',
    addons = 'FreeUI, NDui, NDui_Plus, ShestakUI, |nRealUI, ElvUI, ElvUI_WindTools',
    libraries = 'Ace3, cargBags, oUF',
}

function GUI:CreateCreditsFrame(parent)
    local outline = _G.ANDROMEDA_ADB.FontOutline

    local people = CreateFrame('Frame', nil, parent)
    people:SetSize(400, 120)
    people:SetPoint('TOP', 0, -20)

    F.CreateFS(people, C.Assets.Font.Heavy, 18, outline, L['People'], 'CLASS', outline or 'THICK', { 'TOP', 0, -10 })

    GUI:CreateGradientLine(people, 120, -60, -34, 60, -34)

    F.CreateFS(people, C.Assets.Font.Bold, 16, outline, datas.people, { 250 / 255, 206 / 255, 110 / 255 }, outline or 'THICK', { 'TOP', 0, -50 })

    local addons = CreateFrame('Frame', nil, parent)
    addons:SetSize(400, 90)
    addons:SetPoint('TOP', people, 'BOTTOM')

    F.CreateFS(addons, C.Assets.Font.Heavy, 18, outline, L['AddOns'], 'CLASS', outline or 'THICK', { 'TOP', 0, -10 })

    GUI:CreateGradientLine(addons, 120, -60, -34, 60, -34)

    F.CreateFS(addons, C.Assets.Font.Bold, 16, outline, datas.addons, { 247 / 255, 189 / 255, 94 / 255 }, outline or 'THICK', { 'TOP', 0, -50 })

    local libraries = CreateFrame('Frame', nil, parent)
    libraries:SetSize(400, 150)
    libraries:SetPoint('TOP', addons, 'BOTTOM')

    F.CreateFS(libraries, C.Assets.Font.Heavy, 18, outline, L['Libraries'], 'CLASS', outline or 'THICK', { 'TOP', 0, -10 })

    GUI:CreateGradientLine(libraries, 120, -60, -34, 60, -34)

    F.CreateFS(libraries, C.Assets.Font.Bold, 16, outline, datas.libraries, { 243 / 255, 172 / 255, 80 / 255 }, outline or 'THICK', { 'TOP', 0, -50 })
end
