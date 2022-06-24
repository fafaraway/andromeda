local F, C = unpack(select(2, ...))

local maskTex = C.ASSET_PATH .. 'textures\\opie\\mask'
local borderTex = C.ASSET_PATH .. 'textures\\opie\\border'
local hlTex = C.ASSET_PATH .. 'textures\\opie\\highlight'

local methods = {
    SetOverlayIcon = nop,
    SetOverlayIconVertexColor = nop,
    SetOuterGlow = nop,
    SetBinding = nop,
    SetEquipState = nop,
    SetActive = nop,
    SetCooldownTextShown = nop,
    SetIconTexCoord = nop,
    SetCooldown = nop,
    SetCount = nop,
    SetUsable = nop,
}

function methods:SetIconVertexColor(r, g, b)
    self.icon:SetVertexColor(r, g, b)
end

function methods:SetDominantColor(r, g, b)
    self.NormalTexture:SetVertexColor(r, g, b)
end

function methods:SetIcon(texture)
    self.icon:SetTexture(texture)
end

function methods:SetHighlighted(highlight)
    self.highlight:SetShown(highlight)
end

local function constructor(name, parent, size)
    local button = CreateFrame('CheckButton', name, parent, 'ActionButtonTemplate')
    button:SetSize(size, size)
    button:EnableMouse(false)

    local icon = button.icon
    icon:SetMask(maskTex)

    local texture = button.NormalTexture
    texture:ClearAllPoints()
    texture:SetPoint('TOPLEFT', icon, -6, 6)
    texture:SetPoint('BOTTOMRIGHT', icon, 6, -6)
    texture:SetTexture(borderTex)

    local highlight = button:CreateTexture(nil, 'OVERLAY')
    highlight:SetAllPoints()
    highlight:SetTexture(hlTex)
    highlight:SetVertexColor(1, 1, 1, 0.3)
    button.highlight = highlight

    return Mixin(button, methods)
end

F:HookAddOn('OPie', function()
    _G.OPie.UI:RegisterIndicatorConstructor(
        C.ADDON_TITLE,
        { name = C.ADDON_TITLE, apiLevel = 1, CreateIndicator = constructor }
    )
end)
