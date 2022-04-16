local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')

local datas = {
    'Haleth, Siweia',
    'Alza, Tukz, Gethe, Elv|nHaste, Lightspark, Zork, Allez|nAlleyKat, Caellian, p3lim, Shantalya|ntekkub, Tuller, Wildbreath, aduth|nsilverwind, Nibelheim, humfras, aliluya555|nPaojy, Rubgrsch, EKE, fang2hou|nlilbitz95, Djamy, Hacktivist',
    'NDui, NDui_Plus, ShestakUI, RealUI, ElvUI, ElvUI_WindTools',
}

function GUI:CreateCreditsFrame(parent)
    local credit = CreateFrame('Frame', nil, parent)
    credit:SetSize(360, 200)
    credit:SetPoint('TOP', 0, -20)

    F.CreateFS(credit, C.Assets.Font.Header, 18, nil, L['Credits'], nil, true, 'TOP', 0, -10)
    local cll = F.SetGradient(credit, 'H', 0.7, 0.7, 0.7, 0, 0.5, 160, C.MULT)
    cll:SetPoint('TOP', -80, -32)
    local clr = F.SetGradient(credit, 'H', 0.7, 0.7, 0.7, 0.5, 0, 160, C.MULT)
    clr:SetPoint('TOP', 80, -32)

    F.CreateFS(credit, C.Assets.Font.Bold, 16, nil, datas[1], { 1, 0.5, 0 }, true, 'TOP', 0, -50)
    F.CreateFS(credit, C.Assets.Font.Regular, 14, nil, datas[2], { 0.6, 0.2, 0.9 }, true, 'TOP', 0, -90)
    F.CreateFS(credit, C.Assets.Font.Condensed, 12, nil, datas[3], { 0, 0.4, 0.9 }, true, 'TOP', 0, -220)
end
