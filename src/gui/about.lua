local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')

GUI.urlsList = {
    curse = 'https://www.curseforge.com/wow/addons/andromeda',
    wago = 'https://addons.wago.io/addons/andromeda',
    wowi = 'https://www.wowinterface.com/downloads/info23258',
    github = 'https://github.com/fafaraway/andromeda',
    tracker = 'https://github.com/fafaraway/andromeda/issues',
    discord = 'https://discord.gg/86wbfZXxn7',
    qq = '203621176',
}

GUI.lablesList = {
    curse = 'CurseForge',
    wago = 'Wago',
    wowi = 'WoWI',
    github = 'Github',
    discord = 'Discord',
    qq = 'QQ Group',
}

local function ResetUrlBox(self)
    self:SetText(self.url)
end

local function UrlBox_OnEditFocusGained(self)
    self:HighlightText()
end

local function UrlBox_OnEditFocusLost(self)
    self:HighlightText(0, 0)
end

local function CreateUrlBox(parent, text, url, position)
    local box = F.CreateEditBox(parent, 320, 24)
    box:SetPoint(unpack(position))

    box.lable = F.CreateFS(box, C.Assets.Fonts.Condensed, 12, nil, text, 'YELLOW', true)
    box.lable:SetPoint('RIGHT', box, 'LEFT', -4, 0)

    box.url = url

    ResetUrlBox(box)

    box:SetScript('OnTextChanged', ResetUrlBox)
    box:SetScript('OnCursorChanged', ResetUrlBox)
    box:SetScript('OnEditFocusGained', UrlBox_OnEditFocusGained)
    box:SetScript('OnEditFocusLost', UrlBox_OnEditFocusLost)
end

function GUI:CreateAboutFrame(parent)
    local outline = _G.ANDROMEDA_ADB.FontOutline

    local repo = CreateFrame('Frame', nil, parent)
    repo:SetSize(400, 90)
    repo:SetPoint('TOP', 0, -20)

    F.CreateFS(repo, C.Assets.Fonts.Heavy, 18, outline, L['Repository'], 'CLASS', outline or 'THICK', 'TOP', 0, -10)

    GUI:CreateGradientLine(repo, 120, -60, -34, 60, -34)

    CreateUrlBox(repo, GUI.lablesList.github, GUI.urlsList.github, { 'TOP', 0, -50 })

    local tracker = CreateFrame('Frame', nil, parent)
    tracker:SetSize(400, 90)
    tracker:SetPoint('TOP', repo, 'BOTTOM')

    F.CreateFS(tracker, C.Assets.Fonts.Heavy, 18, outline, L['Issue Tracker'], 'CLASS', outline or 'THICK', 'TOP', 0, -10)

    GUI:CreateGradientLine(tracker, 120, -60, -34, 60, -34)

    CreateUrlBox(tracker, GUI.lablesList.github, GUI.urlsList.tracker, { 'TOP', 0, -50 })

    local download = CreateFrame('Frame', nil, parent)
    download:SetSize(400, 150)
    download:SetPoint('TOP', tracker, 'BOTTOM')

    F.CreateFS(download, C.Assets.Fonts.Heavy, 18, outline, L['Download'], 'CLASS', outline or 'THICK', 'TOP', 0, -10)

    GUI:CreateGradientLine(download, 120, -60, -34, 60, -34)

    CreateUrlBox(download, GUI.lablesList.curse, GUI.urlsList.curse, { 'TOP', 0, -50 })
    CreateUrlBox(download, GUI.lablesList.wago, GUI.urlsList.wago, { 'TOP', 0, -80 })
    CreateUrlBox(download, GUI.lablesList.wowi, GUI.urlsList.wowi, { 'TOP', 0, -110 })

    local feedback = CreateFrame('Frame', nil, parent)
    feedback:SetSize(400, 150)
    feedback:SetPoint('TOP', download, 'BOTTOM')

    F.CreateFS(feedback, C.Assets.Fonts.Heavy, 18, outline, L['Discussion'], 'CLASS', outline or 'THICK', 'TOP', 0, -10)

    GUI:CreateGradientLine(feedback, 120, -60, -34, 60, -34)

    CreateUrlBox(feedback, GUI.lablesList.discord, GUI.urlsList.discord, { 'TOP', 0, -50 })
    CreateUrlBox(feedback, GUI.lablesList.qq, GUI.urlsList.qq, { 'TOP', 0, -80 })
end
