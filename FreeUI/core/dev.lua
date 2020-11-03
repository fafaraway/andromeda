local F, C, L = unpack(select(2, ...))




SlashCmdList.FREE_ONLY = function()
	for i = 1, GetNumAddOns() do
		local name = GetAddOnInfo(i)
		if name ~= 'FreeUI' and name ~= '!BaudErrorFrame' and GetAddOnEnableState(C.MyName, name) == 2 then
			DisableAddOn(name, C.MyName)
		end
	end
	ReloadUI()
end
SLASH_FREE_ONLY1 = '/freeonly'










