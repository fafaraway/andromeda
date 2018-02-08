local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\MovieFrame.lua ]]
    function Hook.MovieFrameCloseDialog_OnShow(self)
        self:SetScale(_G.UIParent:GetScale())
    end
end

function private.FrameXML.MovieFrame()
    _G.MovieFrame.CloseDialog:HookScript("OnShow", Hook.MovieFrameCloseDialog_OnShow)

    Base.SetBackdrop(_G.MovieFrame.CloseDialog)

    Skin.CinematicDialogButtonTemplate(_G.MovieFrame.CloseDialog.ConfirmButton)
    Skin.CinematicDialogButtonTemplate(_G.MovieFrame.CloseDialog.ResumeButton)
end
