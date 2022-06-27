local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')

local urls = {
    curse = 'https://www.curseforge.com/wow/addons/andromeda',
    wago = 'https://addons.wago.io/addons/freeui',
    wowi = 'https://www.wowinterface.com/downloads/info23258',
    github = 'https://github.com/neotpravlennoye/andromeda',
    discord = 'https://discord.gg/86wbfZXxn7',
    qq = '203621176',
}

local icons = {
    curse = C.ASSET_PATH .. 'textures\\site\\curse',
    wago = C.ASSET_PATH .. 'textures\\site\\wago',
    wowi = C.ASSET_PATH .. 'textures\\site\\wowi',
    github = C.ASSET_PATH .. 'textures\\site\\github',
    discord = C.ASSET_PATH .. 'textures\\site\\discord',
    qq = C.ASSET_PATH .. 'textures\\site\\qq',
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

local function CreateUrlBox(parent, text, url, texture, position)
    local box = F.CreateEditBox(parent, 340, 24)

    if position then
        box:SetPoint(unpack(position))
    else
        box:SetPoint('TOP', 0, -70)
    end

    box.lable = F.CreateFS(parent, C.Assets.Font.Condensed, 13, nil, text, 'YELLOW', true)
    box.lable:SetPoint('BOTTOM', box, 'TOP', 0, 4)

    box.icon = box:CreateTexture()
    box.icon:SetSize(20, 20)
    box.icon:SetPoint('RIGHT', box, 'LEFT', -4, 0)
    box.icon:SetTexture(texture)

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
    repo:SetSize(400, 120)
    repo:SetPoint('TOP', 0, -20)

    F.CreateFS(repo, C.Assets.Font.Heavy, 18, outline, L['Development Repository'], { 242 / 255, 211 / 255, 104 / 255 }, outline or 'THICK', 'TOP', 0, -10)

    GUI:CreateGradientLine(repo, 120, -60, -34, 60, -34)

    CreateUrlBox(repo, 'Github', urls.github, icons.github)

    local download = CreateFrame('Frame', nil, parent)
    download:SetSize(400, 220)
    download:SetPoint('TOP', repo, 'BOTTOM')

    F.CreateFS(download, C.Assets.Font.Heavy, 18, outline, L['Stable Version Download'], { 242 / 255, 211 / 255, 104 / 255 }, outline or 'THICK', 'TOP', 0, -10)

    GUI:CreateGradientLine(download, 120, -60, -34, 60, -34)

    CreateUrlBox(download, 'CurseForge.com', urls.curse, icons.curse)
    CreateUrlBox(download, 'Wago.io', urls.wago, icons.wago, { 'TOP', 0, -120 })
    CreateUrlBox(download, 'WoWInterface.com', urls.wowi, icons.wowi, { 'TOP', 0, -170 })

    local feedback = CreateFrame('Frame', nil, parent)
    feedback:SetSize(400, 220)
    feedback:SetPoint('TOP', download, 'BOTTOM')

    F.CreateFS(feedback, C.Assets.Font.Heavy, 18, outline, L['Feedback'], { 242 / 255, 211 / 255, 104 / 255 }, outline or 'THICK', 'TOP', 0, -10)

    GUI:CreateGradientLine(feedback, 120, -60, -34, 60, -34)

    CreateUrlBox(feedback, 'Discord Channel', urls.discord, icons.discord)
    CreateUrlBox(feedback, 'QQ Group', urls.qq, icons.qq, { 'TOP', 0, -120 })
end
