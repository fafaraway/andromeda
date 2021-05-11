local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

--[[ Totems ]]

local totemsColor = {
    {0.71, 0.29, 0.13}, -- red
    {0.26, 0.71, 0.13}, -- green
    {0.13, 0.55, 0.71}, -- blue
    {0.58, 0.13, 0.71}, -- violet
    {0.71, 0.58, 0.13}, -- yellow
}

function UNITFRAME:CreateTotemsBar(self)
    if C.MyClass ~= 'SHAMAN' then
        return
    end
    if not C.DB.Unitframe.TotemsBar then
        return
    end

    local totems = {}
    local maxTotems = 5
    local spacing = 3
    local width

    width = (self:GetWidth() - (maxTotems + 1) * spacing) / maxTotems
    spacing = width + spacing

    for slot = 1, maxTotems do
        local totem = CreateFrame('StatusBar', nil, self.ClassPowerBarHolder)
        local color = totemsColor[slot]
        local r, g, b = color[1], color[2], color[3]
        totem:SetStatusBarTexture(C.Assets.statusbar_tex)
        totem:SetStatusBarColor(r, g, b)
        totem:SetSize(width, C.DB.Unitframe.TotemsBarHeight)
        F.SetBD(totem)

        totem:SetPoint('TOPLEFT', self.ClassPowerBarHolder, 'TOPLEFT', (slot - 1) * spacing + 1, 0)

        totems[slot] = totem
    end

    self.CustomTotems = totems
end
