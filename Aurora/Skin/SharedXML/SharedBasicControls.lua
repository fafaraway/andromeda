local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

--[[ do FrameXML\SharedBasicControls.lua
end ]]

do --[[ FrameXML\SharedBasicControls.xml ]]
    function Skin.UIPanelDialogTemplate(frame)
        local name = frame:GetName()

        _G[name.."TopLeft"]:Hide()
        _G[name.."TopRight"]:Hide()
        _G[name.."Top"]:Hide()
        _G[name.."BottomLeft"]:Hide()
        _G[name.."BottomRight"]:Hide()
        _G[name.."Bottom"]:Hide()
        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()

        Base.SetBackdrop(frame)

        frame.Title:ClearAllPoints()
        frame.Title:SetPoint("TOPLEFT")
        frame.Title:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        local titleBG = _G[name.."TitleBG"]
        titleBG:SetAllPoints(frame.Title)
        titleBG:Hide()

        _G[name.."DialogBG"]:Hide()

        Skin.UIPanelCloseButton(_G[name.."Close"])
        _G[name.."Close"]:SetPoint("TOPRIGHT", -3, -3)
    end
end

function private.SharedXML.SharedBasicControls()
    local ScriptErrorsFrame = _G.ScriptErrorsFrame

    ScriptErrorsFrame:SetScale(_G.UIParent:GetScale())
    Skin.UIPanelDialogTemplate(ScriptErrorsFrame)
    Skin.UIPanelScrollFrameTemplate(ScriptErrorsFrame.ScrollFrame)
    Skin.UIPanelButtonTemplate(ScriptErrorsFrame.Reload)

    for i, delta in _G.next, {"Previous", "Next"} do
        if i == 1 then
            Skin.NavButtonPrevious(ScriptErrorsFrame[delta.."Error"])
        else
            Skin.NavButtonNext(ScriptErrorsFrame[delta.."Error"])
        end
    end

    Skin.UIPanelButtonTemplate(ScriptErrorsFrame.Close)
end
