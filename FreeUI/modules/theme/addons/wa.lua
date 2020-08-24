local F, C = unpack(select(2, ...))
local THEME = F:GetModule('THEME')


local function updateWeakAuras(f, fType)
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

local function ReskinWeakAuras()
	if not FreeDB['theme']['reskin_weakauras'] then return end

	local regionTypes = WeakAuras.regionTypes
	local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify


	regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		updateWeakAuras(region, 'icon')
		return region
	end

	regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		updateWeakAuras(region, 'aurabar')
		return region
	end

	regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		updateWeakAuras(region, 'icon')
	end

	regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		updateWeakAuras(region, 'aurabar')
	end

	for weakAura in pairs(WeakAuras.regions) do
		local regions = WeakAuras.regions[weakAura]
		if regions.regionType == 'icon' or regions.regionType == 'aurabar' then
			updateWeakAuras(regions.region, regions.regionType)
		end
	end
end

THEME:LoadWithAddOn('WeakAuras', ReskinWeakAuras)


