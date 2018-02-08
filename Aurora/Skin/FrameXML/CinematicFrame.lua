local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local F = _G.unpack(private.Aurora)

do --[[ FrameXML\CinematicFrame.lua ]]
    function Hook.CinematicFrameCloseDialog_OnShow(self)
        self:SetScale(_G.UIParent:GetScale())
    end
end

do --[[ FrameXML\CinematicFrame.xml ]]
    function Skin.CinematicDialogButtonTemplate(button)
        button:SetNormalTexture("")
        button:SetPushedTexture("")
        button:SetDisabledTexture("")
        button:SetHighlightTexture("")

        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())
        Base.SetHighlight(button, "backdrop")
    end
end

function private.FrameXML.CinematicFrame()
    _G.CinematicFrame.closeDialog:HookScript("OnShow", Hook.CinematicFrameCloseDialog_OnShow)

    Base.SetBackdrop(_G.CinematicFrame.closeDialog)
    F.CreateBD(_G.CinematicFrame.closeDialog)
    F.CreateSD(_G.CinematicFrame.closeDialog)

    F.Reskin(_G.CinematicFrameCloseDialogConfirmButton)
    F.Reskin(_G.CinematicFrameCloseDialogResumeButton)
end
