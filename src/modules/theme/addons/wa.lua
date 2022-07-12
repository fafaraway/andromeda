local F, C = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

local function UpdateIconBgAlpha(icon, _, _, _, alpha)
    icon.bg:SetAlpha(alpha)
    if icon.bg.__shadow then
        icon.bg.__shadow:SetAlpha(alpha)
    end
end

local function UpdateIconTexCoord(icon)
    if icon.isCutting then
        return
    end
    icon.isCutting = true

    local width, height = icon:GetSize()
    if width ~= 0 and height ~= 0 then
        local left, right, top, bottom = unpack(C.TEX_COORD) -- normal icon
        local ratio = width / height
        if ratio > 1 then -- fat icon
            local offset = (1 - 1 / ratio) / 2
            top = top + offset
            bottom = bottom - offset
        elseif ratio < 1 then -- thin icon
            local offset = (1 - ratio) / 2
            left = left + offset
            bottom = bottom - offset
        end
        icon:SetTexCoord(left, right, top, bottom)
    end

    icon.isCutting = nil
end

local function RestyleIcon(icon)
    UpdateIconTexCoord(icon)
    hooksecurefunc(icon, 'SetTexCoord', UpdateIconTexCoord)
    icon.bg = F.SetBD(icon, 0)
    icon.bg:SetBackdropBorderColor(0, 0, 0)
    icon.bg:SetFrameLevel(0)
    hooksecurefunc(icon, 'SetVertexColor', UpdateIconBgAlpha)
end

local function RestyleBar(f)
    f.bg = F.SetBD(f.bar, 0)
    f.bg:SetFrameLevel(0)
    f.bg:SetBackdropBorderColor(0, 0, 0)
end

local function RestyleObject(f, fType)
    if fType == 'icon' then
        if not f.styled then
            RestyleIcon(f.icon)

            f.styled = true
        end
    elseif fType == 'aurabar' then
        if not f.styled then
            RestyleBar(f)
            RestyleIcon(f.icon)

            f.styled = true
        end

        f.icon.bg:SetShown(not not f.iconVisible)
    end
end

local function RestyleWeakAuras()
    if not _G.ANDROMEDA_ADB.ReskinWeakAuras then
        return
    end

    local regionTypes = _G.WeakAuras.regionTypes
    local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
    local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify

    regionTypes.icon.create = function(parent, data)
        local region = Create_Icon(parent, data)
        RestyleObject(region, 'icon')
        return region
    end

    regionTypes.aurabar.create = function(parent)
        local region = Create_AuraBar(parent)
        RestyleObject(region, 'aurabar')
        return region
    end

    regionTypes.icon.modify = function(parent, region, data)
        Modify_Icon(parent, region, data)
        RestyleObject(region, 'icon')
    end

    regionTypes.aurabar.modify = function(parent, region, data)
        Modify_AuraBar(parent, region, data)
        RestyleObject(region, 'aurabar')
    end

    for _, regions in pairs(_G.WeakAuras.regions) do
        if regions.regionType == 'icon' or regions.regionType == 'aurabar' then
            RestyleObject(regions.region, regions.regionType)
        end
    end
end

THEME:RegisterSkin('WeakAuras', RestyleWeakAuras)
