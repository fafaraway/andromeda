local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

--[[ Stagger ]]

function UNITFRAME:CreateStagger(self)
    if C.MyClass ~= 'MONK' then
        return
    end
    if not C.DB.Unitframe.StaggerBar then
        return
    end

    local stagger = CreateFrame('StatusBar', nil, self.ClassPowerBarHolder)
    stagger:SetAllPoints(self.ClassPowerBarHolder)
    stagger:SetStatusBarTexture(C.Assets.statusbar_tex)

    F.SetBD(stagger)

    local text = F.CreateFS(stagger, C.Assets.Fonts.Regular, 11, nil, '', nil, 'THICK')
    text:SetPoint('TOP', stagger, 'BOTTOM', 0, -4)
    self:Tag(text, '[free:stagger]')

    self.Stagger = stagger
end
