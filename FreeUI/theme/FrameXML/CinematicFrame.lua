local F, C, L = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	CinematicFrameCloseDialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	F.CreateBD(CinematicFrameCloseDialog)
	F.CreateSD(CinematicFrameCloseDialog)
	F.Reskin(CinematicFrameCloseDialogConfirmButton)
	F.Reskin(CinematicFrameCloseDialogResumeButton)
end)