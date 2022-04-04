local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')

local urls = {
    curse = 'https://www.curseforge.com/wow/addons/freeui',
    github = 'https://github.com/Solor/FreeUI',
    discord = 'https://discord.gg/86wbfZXxn7'
}

local icons = {
    curse = C.ASSET_PATH .. 'textures\\curse',
    github = C.ASSET_PATH .. 'textures\\github',
    discord = C.ASSET_PATH .. 'textures\\discord'
}

local function ResetUrlBox(self)
    self:SetText(self.url)
    -- self:HighlightText()
end

local function CreateUrlBox(parent, text, url, texture)
    local box = F.CreateEditBox(parent, 300, 24)
    box:SetPoint('TOP', 0, -70)

    box.lable = F.CreateFS(parent, C.Assets.Font.Condensed, 14, nil, text, 'YELLOW', true, 'TOP', 0, -50)

    box.icon = box:CreateTexture()
    box.icon:SetSize(20, 20)
    box.icon:SetPoint('RIGHT', box, 'LEFT', -4, 0)
    box.icon:SetTexture(texture)

    box.url = url

    ResetUrlBox(box)

    box:SetScript('OnTextChanged', ResetUrlBox)
    box:SetScript('OnCursorChanged', ResetUrlBox)
end

function GUI:CreateAboutFrame(parent)
    local release = CreateFrame('Frame', nil, parent)
    release:SetSize(360, 200)
    release:SetPoint('TOP', 0, -20)

    F.CreateFS(release, C.Assets.Font.Header, 18, nil, L['Stable Release'], nil, true, 'TOP', 0, -10)

    GUI:CreateGradientLine(release, 160, -80, -32, 80, -32)

    CreateUrlBox(release, 'CurseForge', urls.curse, icons.curse)

    local dev = CreateFrame('Frame', nil, parent)
    dev:SetSize(360, 200)
    dev:SetPoint('TOP', 0, -160)

    F.CreateFS(dev, C.Assets.Font.Header, 18, nil, L['Development Repository'], nil, true, 'TOP', 0, -10)

    GUI:CreateGradientLine(dev, 160, -80, -32, 80, -32)

    CreateUrlBox(dev, 'GitHub', urls.github, icons.github)

    local feedback = CreateFrame('Frame', nil, parent)
    feedback:SetSize(360, 200)
    feedback:SetPoint('TOP', 0, -300)

    F.CreateFS(feedback, C.Assets.Font.Header, 18, nil, L['Feedback'], nil, true, 'TOP', 0, -10)

    GUI:CreateGradientLine(feedback, 160, -80, -32, 80, -32)

    CreateUrlBox(feedback, 'Discord', urls.discord, icons.discord)
end
