local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("misc")

function module:OnLogin()
	self:AddAlerts()
	self:rareAlert()
	self:ShowItemLevel()
	self:progressBar()
	self:flashCursor()
	self:QuickJoin()
	self:MissingStats()
	self:fasterLooting()
	self:vignette()
	self:PVPMessageEnhancement()
end


-- ALT + Right Click to buy a stack
local old_MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
local cache = {}
function MerchantItemButton_OnModifiedClick(self, ...)
	if IsAltKeyDown() then
		local id = self:GetID()
		local itemLink = GetMerchantItemLink(id)
		if not itemLink then return end
		local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
		if ( maxStack and maxStack > 1 ) then
			if not cache[itemLink] then
				StaticPopupDialogs["BUY_STACK"] = {
					text = "Stack Buying Check",
					button1 = YES,
					button2 = NO,
					OnAccept = function()
						BuyMerchantItem(id, GetMerchantItemMaxStack(id))
						cache[itemLink] = true
					end,
					hideOnEscape = 1,
					hasItemFrame = 1,
				}
				local r, g, b = GetItemQualityColor(quality or 1)
				StaticPopup_Show("BUY_STACK", " ", " ", {["texture"] = texture, ["name"] = name, ["color"] = {r, g, b, 1}, ["link"] = itemLink, ["index"] = id, ["count"] = maxStack})
			else
				BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			end
		end
	end
	old_MerchantItemButton_OnModifiedClick(self, ...)
end


-- adding a shadowed border to the UI window
function module:vignette()
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


-- Auto enables the ActionCam on login
if C.misc.autoActionCam then
	local aac = CreateFrame("Frame", "AutoActionCam")

	aac:RegisterEvent("PLAYER_LOGIN")
	UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")

	function SetCam(cmd)
		ConsoleExec("ActionCam " .. cmd)
	end

	function aac:OnEvent(event, ...)
		if event == "PLAYER_LOGIN" then
			SetCam("basic")
		end
	end
	aac:SetScript("OnEvent", aac.OnEvent)
end


-- enhance PVP message
function module:PVPMessageEnhancement(_, msg)
	local _, instanceType = IsInInstance()
	if instanceType == 'pvp' or instanceType == 'arena' then
		RaidNotice_AddMessage(RaidBossEmoteFrame, msg, ChatTypeInfo["RAID_BOSS_EMOTE"]);
	end
end


-- undress button on dress up frame
if C.misc.undressButton then
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
do
	hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(self)
		self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	end)
end


-- Faster Looting
function module:fasterLooting()
	if not C.misc.fasterLooting then return end
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
do
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
do
	F:RegisterEvent("READY_CHECK", function()
		PlaySound(SOUNDKIT.READY_CHECK, "master")
	end)
end










