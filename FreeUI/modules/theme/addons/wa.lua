local F, C = unpack(select(2, ...))
local THEME = F.THEME

local _G = getfenv(0)


local function ReskinWeakAuras(f, fType)
	if fType == 'icon' then
		if not f.styled then
			f.icon:SetTexCoord(unpack(C.TexCoord))
			f.icon.SetTexCoord = F.Dummy
			f.bg = F.SetBD(f)
			f.bg.__icon = f.icon
			f.bg:HookScript('OnUpdate', function(self)
				self:SetAlpha(self.__icon:GetAlpha())
				if self.Shadow then
					self.Shadow:SetAlpha(self.__icon:GetAlpha())
				end
			end)

			f.styled = true
		end
	elseif fType == 'aurabar' then
		if not f.styled then
			f.bg = F.SetBD(f.bar)
			f.bg:SetFrameLevel(0)
			f.icon:SetTexCoord(unpack(C.TexCoord))
			f.icon.SetTexCoord = F.Dummy
			f.iconFrame:SetAllPoints(f.icon)
			F.SetBD(f.iconFrame)

			f.styled = true
		end
	end
end

local function UpdateWeakAuras()
	if not FreeADB.appearance.reskin_weakauras then return end

	local regionTypes = _G.WeakAuras.regionTypes
	local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify

	regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		ReskinWeakAuras(region, 'icon')
		return region
	end

	regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		ReskinWeakAuras(region, 'aurabar')
		return region
	end

	regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		ReskinWeakAuras(region, 'icon')
	end

	regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		ReskinWeakAuras(region, 'aurabar')
	end

	for weakAura in pairs(_G.WeakAuras.regions) do
		local regions = _G.WeakAuras.regions[weakAura]
		if regions.regionType == 'icon' or regions.regionType == 'aurabar' then
			ReskinWeakAuras(regions.region, regions.regionType)
		end
	end
end

THEME:LoadWithAddOn('WeakAuras', UpdateWeakAuras)


--[[ function THEME:WeakAurasOptions()
	if not IsAddOnLoaded('WeakAuras') then return end

	local function ReskinWAOptions()
		local frame = _G.WeakAurasOptions
		if not frame then return end

		F.StripTextures(frame)
		F.SetBD(frame)
		F.ReskinInput(frame.filterInput)
		F.Reskin(_G.WASettingsButton)

		local closeBG = select(1, frame:GetChildren())
		F.StripTextures(closeBG)

		local close = closeBG:GetChildren()
		close:ClearAllPoints()
		close:SetPoint('TOPRIGHT', frame, 'TOPRIGHT')

		local minmizeBG = select(5, frame:GetChildren())
		F.StripTextures(minmizeBG)

		local minmize = minmizeBG:GetChildren()
		minmize:ClearAllPoints()
		minmize:SetPoint('RIGHT', close, 'LEFT')

		for i = 1, frame.texteditor.frame:GetNumChildren() do
			local child = select(i, frame.texteditor.frame:GetChildren())
			if child:GetObjectType() == 'Button' and child:GetText() then
				F.Reskin(child)
			end
		end
	end

	local function loadFunc(event, addon)
		if addon == 'WeakAurasOptions' then
			hooksecurefunc(_G.WeakAuras, 'CreateFrame', ReskinWAOptions)
			F:UnregisterEvent(event, loadFunc)
		end
	end
	F:RegisterEvent('ADDON_LOADED', loadFunc)
end ]]
