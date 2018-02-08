local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals tinsert max

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local F, C = _G.unpack(private.Aurora)

do --[[ FrameXML\StaticPopup.lua ]]
    function Hook.StaticPopup_Resize(dialog, which)
        local info = _G.StaticPopupDialogs[which]
        if ( not info ) then
            return nil
        end

        local text = _G[dialog:GetName().."Text"]
        local editBox = _G[dialog:GetName().."EditBox"]
        local button1 = _G[dialog:GetName().."Button1"]

        local maxHeightSoFar, maxWidthSoFar = dialog.maxHeightSoFar or 0, dialog.maxWidthSoFar or 0
        local width = 320

        if ( info.verticalButtonLayout ) then
            width = width + 30
        else
            if ( dialog.numButtons == 4 ) then
                width = 574
            elseif ( dialog.numButtons == 3 ) then
                width = 440
            elseif (info.showAlert or info.showAlertGear or info.closeButton or info.wide) then
                -- Widen
                width = 420
            elseif ( info.editBoxWidth and info.editBoxWidth > 260 ) then
                width = width + (info.editBoxWidth - 260)
            elseif ( which == "HELP_TICKET" ) then
                width = 350
            elseif ( which == "GUILD_IMPEACH" ) then
                width = 375
            end
        end
        if ( dialog.insertedFrame ) then
            width = max(Scale.Value(width), dialog.insertedFrame:GetWidth())
        end
        if ( width > maxWidthSoFar )  then
            Scale.RawSetWidth(dialog, width)
            dialog.maxWidthSoFar = width
        end

        local height = Scale.Value(32) + text:GetHeight() + Scale.Value(2)
        if (not info.nobuttons) then
            height = height + Scale.Value(6) + button1:GetHeight()
        end
        if ( info.hasEditBox ) then
            height = height + Scale.Value(8) + editBox:GetHeight()
        elseif ( info.hasMoneyFrame ) then
            height = height + Scale.Value(16)
        elseif ( info.hasMoneyInputFrame ) then
            height = height + Scale.Value(22)
        end
        if ( dialog.insertedFrame ) then
            height = height + dialog.insertedFrame:GetHeight()
        end
        if ( info.hasItemFrame ) then
            height = height + Scale.Value(64)
        end

        if ( info.verticalButtonLayout ) then
            height = height + Scale.Value(16) + (Scale.Value(26) * (dialog.numButtons - 1))
        end

        if ( height > maxHeightSoFar ) then
            Scale.RawSetHeight(dialog, height)
            dialog.maxHeightSoFar = height
        end
    end
end

do --[[ FrameXML\StaticPopup.xml ]]
    function Skin.StaticPopupButtonTemplate(button)
        button:SetNormalTexture("")
        button:SetPushedTexture("")
        button:SetDisabledTexture("")
        button:SetHighlightTexture("")

        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())
        Base.SetHighlight(button, "backdrop")

        --[[ Scale ]]--
        button:SetSize(button:GetSize())
    end

    local function CloseButton_SetNormalTexture(button, texture)
        if button._setNormal then return end
        button._setNormal = true
        button:SetNormalTexture("")
        if texture:find("Hide") then
            button._auroraHighlight[1]:Hide()
            button._auroraHighlight[2]:Show()
        else
            button._auroraHighlight[1]:Show()
            button._auroraHighlight[2]:Hide()
        end
        button._setNormal = nil
    end
    local function CloseButton_SetPushedTexture(button, texture)
        if button._setPushed then return end
        button._setPushed = true
        button:SetPushedTexture("")
        button._setPushed = nil
    end
    function Skin.StaticPopupTemplate(frame)
        local name = frame:GetName()
        Base.SetBackdrop(frame)
        F.CreateSD(frame)

        local close = _G[name .. "CloseButton"]
        Skin.UIPanelCloseButton(close)

        local hideTex = close:CreateTexture(nil, "ARTWORK")
        hideTex:SetColorTexture(1, 1, 1)
        hideTex:SetPoint("TOPLEFT", close, "BOTTOMLEFT", 4, 5)
        hideTex:SetPoint("BOTTOMRIGHT", -4, 4)
        tinsert(close._auroraHighlight, hideTex)

        _G.hooksecurefunc(close, "SetNormalTexture", CloseButton_SetNormalTexture)
        _G.hooksecurefunc(close, "SetPushedTexture", CloseButton_SetPushedTexture)

        -- Skin.StaticPopupButtonTemplate(frame.button1)
        -- Skin.StaticPopupButtonTemplate(frame.button2)
        -- Skin.StaticPopupButtonTemplate(frame.button3)
        -- Skin.StaticPopupButtonTemplate(frame.button4)
        F.Reskin(frame.button1)
        F.Reskin(frame.button2)
        F.Reskin(frame.button3)
        F.Reskin(frame.button4)

        _G[name .. "EditBoxLeft"]:Hide()
        _G[name .. "EditBoxRight"]:Hide()
        _G[name .. "EditBoxMid"]:Hide()

        local editboxBG = _G.CreateFrame("Frame", nil, frame.editBox)
        editboxBG:SetPoint("TOPLEFT", -2, -6)
        editboxBG:SetPoint("BOTTOMRIGHT", 2, 6)
        editboxBG:SetFrameLevel(frame.editBox:GetFrameLevel() - 1)
        Base.SetBackdrop(editboxBG, Aurora.frameColor:GetRGBA())

        Skin.SmallMoneyFrameTemplate(frame.moneyFrame)
        Skin.MoneyInputFrameTemplate(frame.moneyInputFrame)
        Skin.ItemButtonTemplate(frame.ItemFrame)

        local nameFrame = _G[frame.ItemFrame:GetName().."NameFrame"]
        nameFrame:Hide()

        local nameBG = _G.CreateFrame("Frame", nil, frame.ItemFrame)
        nameBG:SetPoint("TOPLEFT", frame.ItemFrame.icon, "TOPRIGHT", 2, 1)
        nameBG:SetPoint("BOTTOMLEFT", frame.ItemFrame.icon, "BOTTOMRIGHT", 2, -1)
        nameBG:SetPoint("RIGHT", 120, 0)
        Base.SetBackdrop(nameBG, Aurora.frameColor:GetRGBA())

        --[[ Scale ]]--
        _G[name .. "Text"]:SetSize(290, 0)
        _G[name .. "Text"]:SetPoint("TOP", 0, -16)
        _G[name .. "AlertIcon"]:SetSize(36, 36)
        _G[name .. "AlertIcon"]:SetPoint("LEFT", 24, 0)
        frame.editBox:SetSize(130, 32)
        frame.editBox:SetPoint("BOTTOM", 0, 45)
        frame.moneyFrame:SetPoint("TOP", frame.text, "BOTTOM", 0, -5)
        frame.moneyInputFrame:SetPoint("TOP", frame.text, "BOTTOM", 0, -5)
        frame.ItemFrame:SetSize(37, 37)
        frame.ItemFrame:SetPoint("BOTTOM", frame.button1, "TOP", 0, 8)
        frame.ItemFrame:SetPoint("LEFT", 82, 0)

        local itemText = _G[frame.ItemFrame:GetName().."Text"]
        itemText:ClearAllPoints()
        itemText:SetPoint("TOPLEFT", nameBG, 4, -4)
        itemText:SetPoint("BOTTOMRIGHT", nameBG, -4, 4)
    end
end

function private.FrameXML.StaticPopup()
    _G.hooksecurefunc("StaticPopup_Resize", Hook.StaticPopup_Resize)

    Skin.StaticPopupTemplate(_G.StaticPopup1)
    Skin.StaticPopupTemplate(_G.StaticPopup2)
    Skin.StaticPopupTemplate(_G.StaticPopup3)
    Skin.StaticPopupTemplate(_G.StaticPopup4)
end
    --[[
function private.FrameXML.StaticPopup()
    local r, g, b = C.r, C.g, C.b

    local function colourMinimize(f)
        if f:IsEnabled() then
            f.minimize:SetVertexColor(r, g, b)
        end
    end

    local function clearMinimize(f)
        f.minimize:SetVertexColor(1, 1, 1)
    end

    for i = 1, 4 do
        local frame = _G["StaticPopup"..i]
        local bu = _G["StaticPopup"..i.."ItemFrame"]
        local close = _G["StaticPopup"..i.."CloseButton"]

        _G["StaticPopup"..i.."ItemFrameNameFrame"]:Hide()
        _G["StaticPopup"..i.."ItemFrameIconTexture"]:SetTexCoord(.08, .92, .08, .92)

        bu:SetNormalTexture("")
        bu:SetHighlightTexture("")
        bu:SetPushedTexture("")
        F.CreateBG(bu)

        F.CreateBD(frame)

        for j = 1, 3 do
            F.Reskin(frame["button"..j])
        end

        F.ReskinClose(close)

        close.minimize = close:CreateTexture(nil, "OVERLAY")
        close.minimize:SetSize(9, 1)
        close.minimize:SetPoint("CENTER")
        close.minimize:SetTexture(C.media.backdrop)
        close.minimize:SetVertexColor(1, 1, 1)
        close:HookScript("OnEnter", colourMinimize)
        close:HookScript("OnLeave", clearMinimize)

        F.ReskinInput(_G["StaticPopup"..i.."EditBox"], 20)
        F.ReskinMoneyInput(_G["StaticPopup"..i.."MoneyInputFrame"])
    end

    _G.hooksecurefunc("StaticPopup_Show", function(which, text_arg1, text_arg2, data)
        local info = _G.StaticPopupDialogs[which]

        if not info then return end

        local dialog = _G.StaticPopup_FindVisible(which, data)
        if not dialog then
            local index = 1
            if info.preferredIndex then
                index = info.preferredIndex
            end
            for i = index, _G.STATICPOPUP_NUMDIALOGS do
                local frame = _G["StaticPopup"..i]
                if not frame:IsShown() then
                    dialog = frame
                    break
                end
            end

            if not dialog and info.preferredIndex then
                for i = 1, info.preferredIndex do
                    local frame = _G["StaticPopup"..i]
                    if not frame:IsShown() then
                        dialog = frame
                        break
                    end
                end
            end
        end

        if not dialog then return end

        if info.closeButton then
            local closeButton = _G[dialog:GetName().."CloseButton"]

            closeButton:SetNormalTexture("")
            closeButton:SetPushedTexture("")

            if info.closeButtonIsHide then
                for _, pixel in pairs(closeButton.pixels) do
                    pixel:Hide()
                end
                closeButton.minimize:Show()
            else
                for _, pixel in pairs(closeButton.pixels) do
                    pixel:Show()
                end
                closeButton.minimize:Hide()
            end
        end
    end)
end
    ]]
