local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    -- Cinematic

    _G.CinematicFrameCloseDialog:HookScript('OnShow', function(self)
        self:SetScale(_G.UIParent:GetScale())
    end)

    F.StripTextures(_G.CinematicFrameCloseDialog)
    local bg = F.SetBD(_G.CinematicFrameCloseDialog)
    bg:SetFrameLevel(1)
    F.Reskin(_G.CinematicFrameCloseDialogConfirmButton)
    F.Reskin(_G.CinematicFrameCloseDialogResumeButton)

    -- Movie

    local closeDialog = _G.MovieFrame.CloseDialog

    closeDialog:HookScript('OnShow', function(self)
        self:SetScale(_G.UIParent:GetScale())
    end)

    F.StripTextures(closeDialog)
    local dbg = F.SetBD(closeDialog)
    dbg:SetFrameLevel(1)
    F.Reskin(closeDialog.ConfirmButton)
    F.Reskin(closeDialog.ResumeButton)
end)
