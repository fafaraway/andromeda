local F, C = unpack(select(2, ...))
local APPEARANCE = F:GetModule('appearance')


if not IsAddOnLoaded('WeakAuras') then return end
if not C.appearance.WeakAuras then return end

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_LOGIN')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', function()
	local function RestyleWeakAuras(f, fType)
		if fType == 'icon' then
			if not f.styled then
				f.icon:SetTexCoord(unpack(C.TexCoord))
				f.icon.SetTexCoord = F.Dummy

				local bg = F.CreateBDFrame(f, 0)
				local shadow = F.CreateSD(bg, .35, 3, 3)

				bg:HookScript('OnUpdate', function(self)
					self:SetAlpha(self:GetParent():GetAlpha())
				end)

				if shadow then
					shadow:HookScript('OnUpdate', function(self)
						self:SetAlpha(self:GetParent():GetAlpha())
					end)
				end

				f.styled = true
			end
		elseif fType == 'aurabar' then
			if not f.styled then
				local barbg = F.CreateBDFrame(f.bar, 0)
				local barglow = F.CreateSD(barbg, .35)

				if f.icon then
					f.icon:SetTexCoord(unpack(C.TexCoord))
					f.icon.SetTexCoord = F.Dummy
					
					local iconbg = F.CreateBDFrame(f.iconFrame, 0)
					F.CreateSD(iconbg)
					f.iconFrame:SetAllPoints(f.icon)
				end
				
				f.styled = true
			end
		end
	end

	local regionTypes = WeakAuras.regionTypes
	local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify

	regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		RestyleWeakAuras(region, 'icon')
		return region
	end

	regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		RestyleWeakAuras(region, 'aurabar')
		return region
	end

	regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		RestyleWeakAuras(region, 'icon')
	end

	regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		RestyleWeakAuras(region, 'aurabar')
	end

	for weakAura in pairs(WeakAuras.regions) do
		local regions = WeakAuras.regions[weakAura]
		if regions.regionType == 'icon' or regions.regionType == 'aurabar' then
			RestyleWeakAuras(regions.region, regions.regionType)
		end
	end
end)