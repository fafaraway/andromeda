local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals floor

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\MainMenuBar.lua ]]
    function Hook.MainMenuTrackingBar_Configure(frame, isOnTop)
        local statusBar = frame.StatusBar
        statusBar:SetHeight(11)
        frame:ClearAllPoints()
        if isOnTop then
            frame:SetPoint("BOTTOM", _G.MainMenuBar, "TOP", 0, 1)
        else
            frame:SetPoint("TOP", _G.MainMenuBar)
        end
    end
end

do --[[ FrameXML\MainMenuBar.xml ]]
    function Skin.MainMenuBarWatchBarTemplate(frame)
        local StatusBar = frame.StatusBar
        Base.SetTexture(StatusBar:GetStatusBarTexture(), "gradientUp")
        Base.SetTexture(StatusBar.Underlay, "gradientUp")

        StatusBar.WatchBarTexture0:SetAlpha(0)
        StatusBar.WatchBarTexture1:SetAlpha(0)
        StatusBar.WatchBarTexture2:SetAlpha(0)
        StatusBar.WatchBarTexture3:SetAlpha(0)

        StatusBar.XPBarTexture0:SetAlpha(0)
        StatusBar.XPBarTexture1:SetAlpha(0)
        StatusBar.XPBarTexture2:SetAlpha(0)
        StatusBar.XPBarTexture3:SetAlpha(0)

        do -- set xp divs
            local divWidth = Scale.Value(1024) / 20
            local xpos = divWidth
            for i = 1, 19 do
                local texture = StatusBar:CreateTexture(nil, "ARTWORK")
                texture:SetColorTexture(0, 0, 0)
                texture:SetSize(1, 11)

                Scale.RawSetPoint(texture, "LEFT", floor(xpos), 0)
                xpos = xpos + divWidth
            end
        end

        --[[ Scale ]]--
        frame:SetSize(1024, 11)
        StatusBar:SetSize(1024, 11)
    end
end

function private.FrameXML.MainMenuBar()
    if private.disabled.mainmenubar then return end

    if private.isPatch then
        _G.MainMenuBarArtFrame.LeftEndCap:Hide()
        _G.MainMenuBarArtFrame.RightEndCap:Hide()
    else
        _G.hooksecurefunc("MainMenuTrackingBar_Configure", Hook.MainMenuTrackingBar_Configure)

        Base.SetTexture(_G.MainMenuExpBar:GetStatusBarTexture(), "gradientUp")
        _G.MainMenuXPBarTextureLeftCap:Hide()
        _G.MainMenuXPBarTextureRightCap:Hide()
        _G.MainMenuXPBarTextureMid:Hide()
        do -- set xp divs
            local divWidth = Scale.Value(1024) / 20
            local xpos = divWidth
            for i = 1, 19 do
                local texture = _G["MainMenuXPBarDiv"..i]
                texture:SetColorTexture(0, 0, 0)
                texture:SetSize(1, 11)

                Scale.RawSetPoint(texture, "LEFT", floor(xpos), 0)
                xpos = xpos + divWidth
            end
        end

        _G.MainMenuBarTexture0:Hide()
        _G.MainMenuBarTexture1:Hide()
        _G.MainMenuBarTexture2:Hide()
        _G.MainMenuBarTexture3:Hide()

        _G.MainMenuBarLeftEndCap:Hide()
        _G.MainMenuBarRightEndCap:Hide()

        Skin.MainMenuBarWatchBarTemplate(_G.ArtifactWatchBar)
        Skin.MainMenuBarWatchBarTemplate(_G.HonorWatchBar)
    end

    --[[ Scale ]]--
    if private.isPatch then
        _G.MainMenuBarArtFrame.PageNumber:SetPoint("LEFT", _G.MainMenuBarArtFrameBackground, "CENTER", 134, -3)
    else
        _G.MainMenuBar:SetSize(1024, 53)

        _G.MainMenuExpBar:SetSize(1024, 11)

        _G.MainMenuBarTexture0:SetSize(256, 43)
        _G.MainMenuBarTexture0:SetPoint("BOTTOM", -384, 0)
        _G.MainMenuBarTexture1:SetSize(256, 43)
        _G.MainMenuBarTexture1:SetPoint("BOTTOM", -128, 0)
        _G.MainMenuBarTexture2:SetSize(256, 43)
        _G.MainMenuBarTexture2:SetPoint("BOTTOM", 128, 0)
        _G.MainMenuBarTexture3:SetSize(256, 43)
        _G.MainMenuBarTexture3:SetPoint("BOTTOM", 384, 0)

        _G.MainMenuBarPageNumber:SetPoint("CENTER", 30, -5)
    end
end
