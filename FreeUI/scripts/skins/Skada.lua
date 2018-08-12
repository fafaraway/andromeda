local F, C, L = unpack(select(2, ...))
local module = F:GetModule("skins")

function module:ReskinSkada()
	--if not C.skins.skada then return end
	if not IsAddOnLoaded("Skada") then return end

	-- Background + Textures
	--[[local skadaBar = _G.Skada.displays["bar"]
	skadaBar._ApplySettings = skadaBar.ApplySettings
	skadaBar.ApplySettings = function(bar, win)
		skadaBar._ApplySettings(bar, win)

		local skada = win.bargroup

		if win.db.enabletitle and not skada.button.skinned then
			skada.button.skinned = true
			F.CreateBDFrame(skada.button)
		end

		skada:SetTexture(C.media.texture)
		skada:SetSpacing(0)
		skada:SetFrameLevel(5)

		skada:SetBackdrop(nil)
		if not skada.backdrop then
			skada.backdrop = F.CreateBDFrame(skada, .2)
		end
	end

	for _, window in _G.ipairs(_G.Skada:GetWindows()) do
		window:UpdateDisplay()
	end]]

	-- Change Skada Default Settings
	Skada.windowdefaults.bartexture = "C.media.texture"
	--Skada.windowdefaults.classicons = false
	--Skada.windowdefaults.title.fontflags = "OUTLINE"
	--Skada.windowdefaults.title.fontsize = 14
	--Skada.windowdefaults.title.color = {r=0,g=0,b=0,a=.3}
	--Skada.windowdefaults.barfontflags = "OUTLINE"
	--Skada.windowdefaults.barfontsize = 15
	--Skada.windowdefaults.barbgcolor = {r=0,g=0,b=0,a=0}

	-- Change Skada NumberFormat
	Skada.options.args.generaloptions.args.numberformat = nil

	function Skada:FormatNumber(number)
		if number then return F.Numb(number) end
	end
end
