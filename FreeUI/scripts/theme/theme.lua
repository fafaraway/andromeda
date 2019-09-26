local F, C = unpack(select(2, ...))
local APPEARANCE = F:RegisterModule('appearance')


C.themes = {}
C.themes['FreeUI'] = {}

local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(self, _, addon)
	if not C.appearance.themes then
		self:UnregisterEvent('ADDON_LOADED')
		return
	end

	if IsAddOnLoaded('Aurora') or IsAddOnLoaded('AuroraClassic') or IsAddOnLoaded('Skinner') then
		print('FreeUI includes an efficient built-in module of theme.')
		print("It's highly recommended that you disable Aurora or Skinner.")
		return
	end

	for _addon, theme in pairs(C.themes) do
		if type(theme) == 'function' then
			if _addon == addon then
				if theme then
					theme()
				end
			end
		elseif type(theme) == 'table' then
			if _addon == addon then
				for _, theme in pairs(C.themes[_addon]) do
					if theme then
						theme()
					end
				end
			end
		end
	end
end)


function APPEARANCE:FlashCursor()
	if not C.appearance.flashCursor then return end

	local f = CreateFrame('Frame', nil, UIParent);
	f:SetFrameStrata('TOOLTIP');

	local texture = f:CreateTexture();
	texture:SetTexture([[Interface\Cooldown\star4]]);
	texture:SetBlendMode('ADD');
	texture:SetAlpha(0.5);

	local x = 0;
	local y = 0;
	local speed = 0;
	local function OnUpdate(_, elapsed)
		local dX = x;
		local dY = y;
		x, y = GetCursorPosition();
		dX = x - dX;
		dY = y - dY;
		local weight = 2048 ^ -elapsed;
		speed = math.min(weight * speed + (1 - weight) * math.sqrt(dX * dX + dY * dY) / elapsed, 1024);
		local size = speed / 6 - 16;
		if (size > 0) then
			local scale = UIParent:GetEffectiveScale();
			texture:SetHeight(size);
			texture:SetWidth(size);
			texture:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale);
			texture:Show();
		else
			texture:Hide();
		end
	end
	f:SetScript('OnUpdate', OnUpdate);
end

function APPEARANCE:Vignette()
	if not C.appearance.vignette then return end

	local f = CreateFrame('Frame')
	f:SetPoint('TOPLEFT')
	f:SetPoint('BOTTOMRIGHT')
	f:SetFrameLevel(0)
	f:SetFrameStrata('BACKGROUND')
	f.tex = f:CreateTexture()
	f.tex:SetTexture(C.AssetsPath..'vignette.tga')
	f.tex:SetAllPoints(f)

	f:SetAlpha(C.appearance.vignetteAlpha)
end


function APPEARANCE:OnLogin()
	self:FlashCursor()
	self:Vignette()
	self:QuestTracker()
	self:PetBattle()
end
