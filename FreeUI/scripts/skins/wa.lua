local F, C, L = unpack(select(2, ...))
local module = F:GetModule("skins")

local function ReskinWA()
	local function applyBackground(f)
		--if f:GetFrameLevel() < 7 then f:SetFrameLevel(7) end

		f.bg = F.CreateBDFrame(f)
		f.sd = F.CreateSD(f.bg)

		f.bg = true
		f.sd = true
	end

	local function Skin_WeakAuras(f, fType)
		if not f or (f and f.styled) then return end
		if fType == "icon" then
			if not f.styled then
				f.icon:SetTexCoord(unpack(C.texCoord))
				f.icon.SetTexCoord = F.dummy
				if not f.bg then applyBackground(f) end
				f.styled = true
			end
		elseif fType == "aurabar" then
			if not f.styled then
				f.icon:SetTexCoord(unpack(C.texCoord))
				f.icon.SetTexCoord = F.dummy
				F.CreateSD(f.bar)
				f.iconFrame:SetAllPoints(f.icon)
				F.CreateSD(f.iconFrame)
				f.styled = true
			end
		end
	end

	local regionTypes = WeakAuras.regionTypes
	local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify

	regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		Skin_WeakAuras(region, "icon")
		return region
	end

	regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		Skin_WeakAuras(region, "aurabar")
		return region
	end

	regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		Skin_WeakAuras(region, "icon")
	end

	regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		Skin_WeakAuras(region, "aurabar")
	end

	for weakAura, _ in pairs(WeakAuras.regions) do
		local regions = WeakAuras.regions[weakAura]
		if regions.regionType == "icon" then
			Skin_WeakAuras(regions.region, regions.regionType)
		end
	end
end
module:LoadWithAddOn("WeakAuras", "WeakAuras", ReskinWA)