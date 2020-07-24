local F, C, L = unpack(select(2, ...))
local THEME, cfg = F:GetModule("Theme"), C.Theme


function THEME:DetectConfliction()
	if IsAddOnLoaded("AuroraClassic") or IsAddOnLoaded("Aurora") or IsAddOnLoaded("Skinner") then
		StaticPopup_Show("THEME_CONFLICTION_WARNING")
	end
end

function THEME:LoadDefaultSkins()
	if IsAddOnLoaded("AuroraClassic") or IsAddOnLoaded("Aurora") or IsAddOnLoaded("Skinner") then return end

	for _, func in pairs(C.BlizzThemes) do
		func()
	end
	wipe(C.BlizzThemes)

	if not cfg.reskin_blizz then return end

	for addonName, func in pairs(C.Themes) do
		local isLoaded, isFinished = IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			func()
			C.Themes[addonName] = nil
		end
	end

	F:RegisterEvent("ADDON_LOADED", function(_, addonName)
		local func = C.Themes[addonName]
		if func then
			func()
			C.Themes[addonName] = nil
		end
	end)
end


function THEME:CursorTrail()
	if not cfg.cursor_trail then return end

	local f = CreateFrame('Frame', nil, UIParent);
	f:SetFrameStrata('TOOLTIP');

	local tex = f:CreateTexture();
	tex:SetTexture([[Interface\Cooldown\star4]]);
	tex:SetBlendMode('ADD');
	tex:SetAlpha(0.5);

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
			tex:SetHeight(size);
			tex:SetWidth(size);
			tex:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale);
			tex:Show();
		else
			tex:Hide();
		end
	end
	f:SetScript('OnUpdate', OnUpdate);
end

function THEME:Vignetting()
	if not cfg.vignetting then return end

	local f = CreateFrame('Frame')
	f:SetPoint('TOPLEFT')
	f:SetPoint('BOTTOMRIGHT')
	f:SetFrameLevel(0)
	f:SetFrameStrata('BACKGROUND')
	f.tex = f:CreateTexture()
	f.tex:SetTexture(C.Assets.vig_tex)
	f.tex:SetAllPoints(f)

	f:SetAlpha(cfg.vignetting_alpha)
end


function THEME:OnLogin()
	self:DetectConfliction()
	self:LoadDefaultSkins()

	self:CursorTrail()
	self:Vignetting()

	self:ReskinDBMBar()
	self:ReskinDBMGUI()
	self:ReskinPGF()
	self:ReskinSkada()

	
end


function THEME:LoadWithAddOn(addonName, func)
	local function loadFunc(event, addon)

		if event == "PLAYER_ENTERING_WORLD" then
			F:UnregisterEvent(event, loadFunc)
			if IsAddOnLoaded(addonName) then
				func()
				F:UnregisterEvent("ADDON_LOADED", loadFunc)
			end
		elseif event == "ADDON_LOADED" and addon == addonName then
			func()
			F:UnregisterEvent(event, loadFunc)
		end
	end

	F:RegisterEvent("PLAYER_ENTERING_WORLD", loadFunc)
	F:RegisterEvent("ADDON_LOADED", loadFunc)
end