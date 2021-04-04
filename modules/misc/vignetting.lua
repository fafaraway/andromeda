local _G = _G
local select = select
local unpack = unpack
local CreateFrame = CreateFrame

local F, C = unpack(select(2, ...))
local MISC = F.MISC

function MISC:Vignetting()
    if not C.DB.Misc.Vignetting then
        return
    end
    if C.DB.Misc.VignettingAlpha == 0 then
        return
    end

    local f = CreateFrame('Frame')
    f:SetPoint('TOPLEFT')
    f:SetPoint('BOTTOMRIGHT')
    f:SetFrameLevel(0)
    f:SetFrameStrata('BACKGROUND')
    f.tex = f:CreateTexture()
    f.tex:SetTexture(C.Assets.vig_tex)
    f.tex:SetAllPoints(f)

    f:SetAlpha(C.DB.Misc.VignettingAlpha)
end

MISC:RegisterMisc('Vignetting', MISC.Vignetting)
