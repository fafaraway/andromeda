local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	-- Ready check
	F.SetBD(ReadyCheckFrame)
	ReadyCheckPortrait:SetAlpha(0)
	select(2, ReadyCheckListenerFrame:GetRegions()):Hide()

	ReadyCheckFrame:HookScript("OnShow", function(self)
		if self.initiator and UnitIsUnit("player", self.initiator) then
			self:Hide()
		end
	end)

	F.Reskin(ReadyCheckFrameYesButton)
	F.Reskin(ReadyCheckFrameNoButton)

	-- Role poll
	F.StripTextures(RolePollPopup)
	F.SetBD(RolePollPopup)
	F.Reskin(RolePollPopupAcceptButton)
	F.ReskinClose(RolePollPopupCloseButton)

	F.ReskinRole(RolePollPopupRoleButtonTank, "TANK")
	F.ReskinRole(RolePollPopupRoleButtonHealer, "HEALER")
	F.ReskinRole(RolePollPopupRoleButtonDPS, "DPS")
end)
