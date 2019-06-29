local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	F.ReskinClose(ItemRefCloseButton)
	F.ReskinClose(FloatingBattlePetTooltip.CloseButton)
	F.ReskinClose(FloatingPetBattleAbilityTooltip.CloseButton)
	
	function F:ReskinTooltip()
	end
end)