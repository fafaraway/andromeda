local F, C = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

local function UpdateIconBgAlpha(icon, _, _, _, alpha)
    icon.bg:SetAlpha(alpha)
    if icon.bg.__shadow then
        icon.bg.__shadow:SetAlpha(alpha)
    end
end

local x1, x2, y1, y2 = unpack(C.TEX_COORD)
local function UpdateIconTexCoord(icon)
    if icon.isCutting then
        return
    end
    icon.isCutting = true

    local width, height = icon:GetSize()
    if width ~= 0 and height ~= 0 then
        local left, right, top, bottom = x1, x2, y1, y2 -- normal icon
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

local function HandleIcon(icon)
    UpdateIconTexCoord(icon)
    hooksecurefunc(icon, 'SetTexCoord', UpdateIconTexCoord)
    icon.bg = F.SetBD(icon, 0)
    icon.bg:SetBackdropBorderColor(0, 0, 0)
    icon.bg:SetFrameLevel(0)
    hooksecurefunc(icon, 'SetVertexColor', UpdateIconBgAlpha)
end

local function HandleBar(f)
    f.bg = F.SetBD(f.bar, 0)
    f.bg:SetFrameLevel(0)
    f.bg:SetBackdropBorderColor(0, 0, 0)
end

local function ResetBGLevel(frame)
	frame.bg:SetFrameLevel(0)
end

local function RestyleIconAndBar(f, fType)
    if fType == 'icon' then
        if not f.styled then
            HandleIcon(f.icon)

            f.styled = true
        end
    elseif fType == 'aurabar' then
        if not f.styled then
            HandleBar(f)
            HandleIcon(f.icon)
            hooksecurefunc(f, "SetFrameStrata", ResetBGLevel)

            f.styled = true
        end

        f.icon.bg:SetShown(not not f.iconVisible)
    end
end

local function RestyleObjects()
    if not _G.ANDROMEDA_ADB.ReskinWeakAuras then
        return
    end

    if _G.WeakAuras.regionPrototype then
        local function OnPrototypeCreate(region)
            RestyleIconAndBar(region, region.regionType)
        end

        local function OnPrototypeModifyFinish(_, region)
            RestyleIconAndBar(region, region.regionType)
        end
        hooksecurefunc(_G.WeakAuras.regionPrototype, 'create', OnPrototypeCreate)
        hooksecurefunc(_G.WeakAuras.regionPrototype, 'modifyFinish', OnPrototypeModifyFinish)
    elseif _G.WeakAuras.SetTextureOrAtlas then
        hooksecurefunc(_G.WeakAuras, "SetTextureOrAtlas", function(icon)
            local parent = icon:GetParent()
			if parent then
				local region = parent.regionType and parent or parent:GetParent()
				if region.regionType then
					Skin_WeakAuras(region, region.regionType)
				end
			end
        end)
    end
end

THEME:RegisterSkin('WeakAuras', RestyleObjects)
