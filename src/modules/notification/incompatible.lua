local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')

local IncompatibleAddOns = {
    ['BigFoot'] = true,
    ['!!!163UI!!!'] = true,
    ['Aurora'] = true,
    ['AuroraClassic'] = true,
    ['ElvUI'] = true,
    ['Skinner'] = true,
    ['NDui'] = true,
}

local AddonDependency = {
    ['BigFoot'] = '!!!Libs',
}

local IncompatibleList = {}
local function ConstructFrame()
    local frame = CreateFrame('Frame', nil, _G.UIParent)
    frame:SetPoint('TOP', 0, -200)
    frame:SetFrameStrata('HIGH')
    F.CreateMF(frame)
    F.SetBD(frame)

    local outline = _G.ANDROMEDA_ADB.FontOutline
    F.CreateFS(frame, C.Assets.Fonts.Bold, 18, outline or nil, L['Incompatible AddOns:'], 'RED', outline and 'NONE' or 'THICK', 'TOPLEFT', 10, -10)

    local offset = 0
    for _, addon in pairs(IncompatibleList) do
        F.CreateFS(frame, C.Assets.Fonts.Regular, 14, outline or nil, addon, false, outline and 'NONE' or 'THICK', 'TOPLEFT', 10, -(50 + offset))
        offset = offset + 24
    end
    frame:SetSize(300, 100 + offset)

    local close = F.CreateButton(frame, 16, 16, true, C.Assets.Textures.Close)
    close:SetPoint('TOPRIGHT', -10, -10)
    close:SetScript('OnClick', function()
        frame:Hide()
    end)

    local disable = F.CreateButton(frame, 150, 25, L['Disable Incompatible Addons'])
    disable:SetPoint('BOTTOM', 0, 10)
    disable.text:SetTextColor(1, 0.8, 0)
    disable:SetScript('OnClick', function()
        for _, addon in pairs(IncompatibleList) do
            DisableAddOn(addon, true)
            if AddonDependency[addon] then
                DisableAddOn(AddonDependency[addon], true)
            end
        end
        ReloadUI()
    end)
end

function NOTIFICATION:CheckIncompatible()
    for addon in pairs(IncompatibleAddOns) do
        if IsAddOnLoaded(addon) then
            tinsert(IncompatibleList, addon)
        end
    end

    if #IncompatibleList > 0 then
        ConstructFrame()
    end
end
