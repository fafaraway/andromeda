local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base

--local FindUsage = private.FindUsage

do -- lines
    Base.RegisterTexture("lineCross", function(frame, texture)
        local anchor = frame
        if texture then
            anchor = texture
        else
            frame:SetSize(256, 256)
        end

        for i = 1, 2 do
            local line = frame:CreateLine(nil, "BACKGROUND")
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(texture and 1 or 10)
            line:Show()
            if i == 1 then
                line:SetStartPoint("TOPLEFT", anchor)
                line:SetEndPoint("BOTTOMRIGHT", anchor)
            else
                line:SetStartPoint("TOPRIGHT", anchor)
                line:SetEndPoint("BOTTOMLEFT", anchor)
            end
        end
    end)
end

do -- arrows
    local size = 64
    local function setup(frame, texture)
        if not texture then
            frame:SetSize(size, size)
            texture = frame:CreateTexture(nil, "BACKGROUND")
            texture:SetAllPoints()
        end

        texture:SetColorTexture(1, 1, 1)
        texture:Show()
        return texture
    end

    local function GetVertOffset(frame, texture)
        local offset = texture:GetHeight() / 2
        if offset < 1 then
            offset = (frame:GetHeight() - 9) / 2
        end
        return offset
    end
    local function GetHorizOffset(frame, texture)
        local offset = texture:GetWidth() / 2
        if offset < 1 then
            offset = (frame:GetWidth() - 9) / 2
        end
        return offset
    end

    Base.RegisterTexture("arrowLeft", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetVertOffset(frame, texture)
        texture:SetVertexOffset(1, 0, -offset)
        texture:SetVertexOffset(2, 0, offset)
    end)
    Base.RegisterTexture("arrowRight", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetVertOffset(frame, texture)
        texture:SetVertexOffset(3, 0, -offset)
        texture:SetVertexOffset(4, 0, offset)
    end)
    Base.RegisterTexture("arrowUp", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetHorizOffset(frame, texture)
        texture:SetVertexOffset(1, offset, 0)
        texture:SetVertexOffset(3, -offset, 0)
    end)
    Base.RegisterTexture("arrowDown", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetHorizOffset(frame, texture)
        texture:SetVertexOffset(2, offset, 0)
        texture:SetVertexOffset(4, -offset, 0)
    end)
end

do -- gradients
    local min, max = 0.3, 0.7

    local function setup(frame, texture)
        if not texture then
            frame:SetSize(1024, 1024)
            texture = frame:CreateTexture(nil, "BACKGROUND")
            texture:SetAllPoints()
        end

        texture:SetColorTexture(1, 1, 1)
        texture:Show()
        return texture
    end

    local function SetGradientMinMax(frame, texture, direction)
        if frame.SetStatusBarColor then
            local red, green, blue = frame:GetStatusBarColor()
            texture:SetGradient("VERTICAL", red * min, green * min, blue * min, red * max, green * max, blue * max)

            _G.hooksecurefunc(frame, "SetStatusBarColor", function(self, r, g, b)
                texture:SetGradient("VERTICAL", r * min, g * min, b * min, r * max, g * max, b * max)
            end)
        else
            --FindUsage(texture, "SetVertexColor")
            texture:SetGradient("VERTICAL", min, min, min, max, max, max)
        end
    end
    local function SetGradientMaxMin(frame, texture, direction)
        if frame.SetStatusBarColor then
            local red, green, blue = frame:GetStatusBarColor()
            texture:SetGradient("VERTICAL", red * max, green * max, blue * max, red * min, green * min, blue * min)

            _G.hooksecurefunc(frame, "SetStatusBarColor", function(self, r, g, b)
                texture:SetGradient("VERTICAL", r * max, g * max, b * max, r * min, g * min, b * min)
            end)
        else
            texture:SetGradient("VERTICAL", max, max, max, min, min, min)
        end
    end

    Base.RegisterTexture("gradientUp", function(frame, texture)
        local hasTexture = not not texture
        texture = setup(frame, texture)
        if hasTexture then
            SetGradientMinMax(frame, texture, "VERTICAL")
        else
            texture:SetGradient("VERTICAL", min, min, min, max, max, max)
        end
    end)
    Base.RegisterTexture("gradientDown", function(frame, texture)
        local hasTexture = not not texture
        texture = setup(frame, texture)
        if hasTexture then
            SetGradientMaxMin(frame, texture, "VERTICAL")
        else
            texture:SetGradient("VERTICAL", max, max, max, min, min, min)
        end
    end)
    Base.RegisterTexture("gradientLeft", function(frame, texture)
        local hasTexture = not not texture
        texture = setup(frame, texture)
        if hasTexture then
            SetGradientMaxMin(frame, texture, "HORIZONTAL")
        else
            texture:SetGradient("HORIZONTAL", max, max, max, min, min, min)
        end
    end)
    Base.RegisterTexture("gradientRight", function(frame, texture)
        local hasTexture = not not texture
        texture = setup(frame, texture)
        if hasTexture then
            SetGradientMinMax(frame, texture, "HORIZONTAL")
        else
            texture:SetGradient("HORIZONTAL", min, min, min, max, max, max)
        end
    end)
end

do -- LFG Icons
    local map = {
        {name = "GUIDE", 1, 1},
        {name = "HEALER", 2, 1},
        {name = "CHECK", 3, 1},
        {name = "TANK", 1, 2},
        {name = "DAMAGER", 2, 2},
        {name = "PROMPT", 3, 2},
        {name = "COVER", 1, 3},
        {name = "CROSS", 2, 3},
    }
    local size = 76
    for i = 1, #map do
        local info = map[i]
        Base.RegisterTexture("role"..info.name, function(frame, texture)
            frame:SetSize(64, 64)

            local bg = frame:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints()
            bg:SetColorTexture(0, 0, 0)
            bg:Show()

            local icon = frame:CreateTexture(nil, "BORDER")
            icon:SetSize(size, size)
            icon:SetPoint("CENTER", 2, -1)
            icon:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-ROLES]])
            icon:SetTexCoord(_G.GetTexCoordsByGrid(info[1], info[2], 256, 256, 67, 67))
            icon:Show()

            local mask = frame:CreateMaskTexture(nil, "BORDER")
            mask:SetTexture([[Interface\CharacterFrame\TempPortraitAlphaMask]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
            mask:SetSize(size * 0.7, size * 0.7)
            mask:SetPoint("CENTER", icon, 0, 2)
            mask:Show()
            icon:AddMaskTexture(mask)
        end)
    end
end


--[[
Base.RegisterTexture("test", function(frame, texture)
    frame:SetSize(256, 256)

    for i = 1, 2 do
        local line = frame:CreateLine(nil, "BACKGROUND")
        line:SetColorTexture(1, 1, 1)
        line:SetThickness(10)
        line:Show(1)
        if i == 1 then
            line:SetStartPoint("TOPLEFT")
            line:SetEndPoint("BOTTOMRIGHT")
        else
            line:SetStartPoint("TOPRIGHT")
            line:SetEndPoint("BOTTOMLEFT")
        end
    end
end)

local snapshot = _G.UIParent:CreateTexture("$parentSnapshotTest", "BACKGROUND")
snapshot:SetPoint("CENTER")
snapshot:SetSize(16, 16)
Base.SetTexture(snapshot, "test", true)
Base.SetTexture(snapshot, "roleDAMAGER", true)
Base.SetTexture(snapshot, "gradientUp", true)
Base.SetTexture(snapshot, "arrowLeft", true)
Base.SetTexture(snapshot, "gradientLeft", true)
--local color = _G.RAID_CLASS_COLORS[private.charClass.token]
--snapshot:SetVertexColor(color.r, color.g, color.b)
]]
