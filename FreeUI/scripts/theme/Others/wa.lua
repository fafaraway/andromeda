local F, C, L = unpack(select(2, ...))
local module = F:GetModule("Theme")
if not C.appearance.reskinWA then return end

local pairs = pairs

local function ReskinWA()
	local function Skin_WeakAuras(f, fType)
		if fType == "icon" then
			if not f.styled then
				f.icon:SetTexCoord(unpack(C.TexCoord))
				f.icon.SetTexCoord = F.Dummy

				local bg = F.CreateBDFrame(f, 0)
				local sd = F.CreateSD(bg)

				bg:HookScript("OnUpdate", function(self)
					self:SetAlpha(self:GetParent():GetAlpha())
				end)

				sd:HookScript("OnUpdate", function(self)
					self:SetAlpha(self:GetParent():GetAlpha())
				end)

				f.styled = true
			end
		elseif fType == "aurabar" then
			if not f.styled then
				local barbg = F.CreateBDFrame(f.bar, 0)
				F.CreateSD(barbg)

				f.icon:SetTexCoord(unpack(C.TexCoord))
				f.icon.SetTexCoord = F.Dummy
				
				local iconbg = F.CreateBDFrame(f.iconFrame, 0)
				F.CreateSD(iconbg)
				f.iconFrame:SetAllPoints(f.icon)
				
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

	for weakAura in pairs(WeakAuras.regions) do
		local regions = WeakAuras.regions[weakAura]
		if regions.regionType == "icon" or regions.regionType == "aurabar" then
			Skin_WeakAuras(regions.region, regions.regionType)
		end
	end
end
module:LoadWithAddOn("WeakAuras", "WeakAuras", ReskinWA)