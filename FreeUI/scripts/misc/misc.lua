local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("misc")

function module:OnLogin()
	self:ItemLevel()
	self:ProgressBar()
	self:FlashCursor()
	self:QuickJoin()
	self:MissingStats()
	self:FasterLoot()
	self:Vignette()
	self:PVPMessageEnhancement()
	self:UndressButton()
	self:FasterDelete()
	self:FlightMasterWhistle()
	self:ReadyCheckEnhancement()


	hooksecurefunc("ReputationFrame_Update", self.HookParagonRep)
end







-- adding a shadowed border to the UI window
function module:Vignette()
	if not C.appearance.vignette then return end

	self.f = CreateFrame("Frame", "ShadowBackground")
	self.f:SetPoint("TOPLEFT")
	self.f:SetPoint("BOTTOMRIGHT")
	self.f:SetFrameLevel(0)
	self.f:SetFrameStrata("BACKGROUND")
	self.f.tex = self.f:CreateTexture()
	self.f.tex:SetTexture([[Interface\Addons\FreeUI\assets\vignette.tga]])
	self.f.tex:SetAllPoints(f)

	self.f:SetAlpha(C.appearance.vignetteAlpha)
end





-- enhance PVP message
function module:PVPMessageEnhancement(_, msg)
	local _, instanceType = IsInInstance()
	if instanceType == 'pvp' or instanceType == 'arena' then
		RaidNotice_AddMessage(RaidBossEmoteFrame, msg, ChatTypeInfo["RAID_BOSS_EMOTE"]);
	end
end


-- undress button on dress up frame
function module:UndressButton()
	local undress = CreateFrame("Button", "DressUpFrameUndressButton", DressUpFrame, "UIPanelButtonTemplate")
	undress:SetSize(80, 22)
	undress:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT", -1, 0)
	undress:SetText(L['Undress'])
	undress:SetScript("OnClick", function()
		DressUpModel:Undress()
	end)

	local sideUndress = CreateFrame("Button", "SideDressUpModelUndressButton", SideDressUpModel, "UIPanelButtonTemplate")
	sideUndress:SetSize(80, 22)
	sideUndress:SetPoint("TOP", SideDressUpModelResetButton, "BOTTOM", 0, -5)
	sideUndress:SetText(L['Undress'])
	sideUndress:SetScript("OnClick", function()
		SideDressUpModel:Undress()
	end)

	F.Reskin(undress)
	F.Reskin(sideUndress)
end


-- Instant delete
function module:FasterDelete()
	hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(self)
		self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	end)
end


-- Faster Looting
function module:FasterLoot()
	if not C.general.fasterLoot then return end
	local faster = CreateFrame("Frame")
	faster:RegisterEvent("LOOT_READY")
	faster:SetScript("OnEvent",function()
		local tDelay = 0
		if GetTime() - tDelay >= 0.3 then
			tDelay = GetTime()
			if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
				for i = GetNumLootItems(), 1, -1 do
					LootSlot(i)
				end
				tDelay = GetTime()
			end
		end
	end)
end


-- plays a soundbite from Whistle - Flo Rida after Flight Master's Whistle
function module:FlightMasterWhistle()
	local flightMastersWhistle_SpellID1 = 227334
	local flightMastersWhistle_SpellID2 = 253937
	local whistleSound = 'Interface\\Addons\\FreeUI\\assets\\sound\\blowmywhistle.ogg'

	local f = CreateFrame("frame")
	f:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end);

	function f:UNIT_SPELLCAST_SUCCEEDED(unit,lineID,spellID)
		if (unit == "player" and (spellID == flightMastersWhistle_SpellID1 or spellID == flightMastersWhistle_SpellID2)) then
			PlaySoundFile(whistleSound)
		end
	end
	f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end


-- ready check in master sound
function module:ReadyCheckEnhancement()
	F:RegisterEvent("READY_CHECK", function()
		PlaySound(SOUNDKIT.READY_CHECK, "master")
	end)
end





-- flash cursor
function module:FlashCursor()
	if not C.general.flashCursor then return end

	local frame = CreateFrame("Frame", nil, UIParent);
	frame:SetFrameStrata("TOOLTIP");

	local texture = frame:CreateTexture();
	texture:SetTexture([[Interface\Cooldown\star4]]);
	texture:SetBlendMode("ADD");
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
			texture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale);
			texture:Show();
		else
			texture:Hide();
		end
	end
	frame:SetScript("OnUpdate", OnUpdate);
end
