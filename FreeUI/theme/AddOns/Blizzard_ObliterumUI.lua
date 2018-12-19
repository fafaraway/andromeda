local F, C = unpack(select(2, ...))

C.themes["Blizzard_ObliterumUI"] = function()
	local obliterum = ObliterumForgeFrame

	F.ReskinPortraitFrame(obliterum, true)
	F.Reskin(obliterum.ObliterateButton)
	obliterum.ItemSlot.Icon:SetTexCoord(unpack(C.TexCoord))
	F.CreateBDFrame(obliterum.ItemSlot.Icon)
end