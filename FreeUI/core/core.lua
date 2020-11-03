local _, engine = ...
local F, C = unpack(engine)


do
	F.oUF = engine.oUF
	F.cargBags = engine.cargBags
end

do
	F:RegisterModule('INSTALL')
	F:RegisterModule('GUI')
	F:RegisterModule('MOVER')
	F:RegisterModule('LOGO')
	F:RegisterModule('THEME')
	F:RegisterModule('BLIZZARD')
	F:RegisterModule('MISC')
	F:RegisterModule('ACTIONBAR')
	F:RegisterModule('COOLDOWN')
	F:RegisterModule('AURA')
	F:RegisterModule('CHAT')
	F:RegisterModule('COMBAT')
	F:RegisterModule('INFOBAR')
	F:RegisterModule('INVENTORY')
	F:RegisterModule('MAP')
	F:RegisterModule('NOTIFICATION')
	F:RegisterModule('ANNOUNCEMENT')
	F:RegisterModule('TOOLTIP')
	F:RegisterModule('UNITFRAME')
	F:RegisterModule('NAMEPLATE')
end

do
	F.INSTALL = F:GetModule('INSTALL')
	F.GUI = F:GetModule('GUI')
	F.MOVER = F:GetModule('MOVER')
	F.LOGO = F:GetModule('LOGO')
	F.THEME = F:GetModule('THEME')
	F.BLIZZARD = F:GetModule('BLIZZARD')
	F.MISC = F:GetModule('MISC')
	F.ACTIONBAR = F:GetModule('ACTIONBAR')
	F.COOLDOWN = F:GetModule('COOLDOWN')
	F.AURA = F:GetModule('AURA')
	F.CHAT = F:GetModule('CHAT')
	F.COMBAT = F:GetModule('COMBAT')
	F.INFOBAR = F:GetModule('INFOBAR')
	F.INVENTORY = F:GetModule('INVENTORY')
	F.MAP = F:GetModule('MAP')
	F.NOTIFICATION = F:GetModule('NOTIFICATION')
	F.ANNOUNCEMENT = F:GetModule('ANNOUNCEMENT')
	F.TOOLTIP = F:GetModule('TOOLTIP')
	F.UNITFRAME = F:GetModule('UNITFRAME')
	F.NAMEPLATE = F:GetModule('NAMEPLATE')
end

do
	F.Libs = {}
	F.LibsMinor = {}

	function F:AddLib(name, major, minor)
		if not name then return end

		-- in this case: `major` is the lib table and `minor` is the minor version
		if type(major) == 'table' and type(minor) == 'number' then
			F.Libs[name], F.LibsMinor[name] = major, minor
		else -- in this case: `major` is the lib name and `minor` is the silent switch
			F.Libs[name], F.LibsMinor[name] = _G.LibStub(major, minor)
		end
	end

	F:AddLib('RangeCheck', 'LibRangeCheck-2.0')
	F:AddLib('Base64', 'LibBase64-1.0')
end
