local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FreeUIConfigs['theme']['reskin_blizz'] then return end

	-- Cinematic

	CinematicFrameCloseDialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	F.StripTextures(CinematicFrameCloseDialog)
	F.CreateBD(CinematicFrameCloseDialog)
	F.CreateSD(CinematicFrameCloseDialog)
	F.CreateTex(CinematicFrameCloseDialog)
	F.Reskin(CinematicFrameCloseDialogConfirmButton)
	F.Reskin(CinematicFrameCloseDialogResumeButton)

	-- Movie

	local closeDialog = MovieFrame.CloseDialog

	closeDialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	F.StripTextures(closeDialog)
	F.CreateBD(closeDialog)
	F.CreateSD(closeDialog)
	F.CreateTex(closeDialog)
	F.Reskin(closeDialog.ConfirmButton)
	F.Reskin(closeDialog.ResumeButton)
end)
