local F, C = unpack(select(2, ...))
local M = F:GetModule('Vignetting')

function M:UpdateVisibility()
    if C.DB.General.Vignetting then
        M.Frame:SetAlpha(C.DB.General.VignettingAlpha)
    else
        M.Frame:SetAlpha(0)
    end
end

function M:OnLogin()
    local f = CreateFrame('Frame')
    f:SetPoint('TOPLEFT')
    f:SetPoint('BOTTOMRIGHT')
    f:SetFrameStrata('BACKGROUND')
    f:SetFrameLevel(0)

    f.tex = f:CreateTexture()
    f.tex:SetTexture(C.Assets.Texture.Vignetting)
    f.tex:SetAllPoints(f)

    M.Frame = f

    M:UpdateVisibility()
end
