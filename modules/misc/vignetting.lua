local F, C = unpack(select(2, ...))
local M = F:GetModule('Vignetting')

function M:UpdateVisibility()
    if not C.DB.General.Vignetting then
        M.Frame:SetAlpha(0)
    else
        M.Frame:SetAlpha(C.DB.General.VignettingAlpha)
    end
end

local function CreateVignetting()
    local f = CreateFrame('Frame')
    f:SetPoint('TOPLEFT')
    f:SetPoint('BOTTOMRIGHT')
    f:SetFrameStrata('BACKGROUND')
    f:SetFrameLevel(0)

    f.tex = f:CreateTexture()
    f.tex:SetTexture(C.Assets.vig_tex)
    f.tex:SetAllPoints(f)

    M.Frame = f

    M:UpdateVisibility()
end

function M:OnLogin()
    if not C.DB.General.Vignetting then
        return
    end

    CreateVignetting()
end
