local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	local r, g, b = C.r, C.g, C.b

	for i = 1, 6 do
		select(i, GhostFrame:GetRegions()):Hide()
	end
	F.ReskinIcon(GhostFrameContentsFrameIcon)

	local bg = F.SetBD(GhostFrame, 0)
	F.CreateGradient(bg)
	GhostFrame:SetHighlightTexture(C.Assets.bd_tex)
	GhostFrame:GetHighlightTexture():SetVertexColor(r, g, b, .25)
end)
