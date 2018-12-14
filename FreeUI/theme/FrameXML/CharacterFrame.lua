local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	F.ReskinPortraitFrame(CharacterFrame, true)
	F.CleanInset(CharacterFrameInsetRight)

	for i = 1, 3 do
		F.ReskinTab(_G["CharacterFrameTab"..i])
	end
end)