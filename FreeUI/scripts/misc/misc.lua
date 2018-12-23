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
	self:ActionCam()
	self:FasterDelete()
	self:FlightMasterWhistle()
	self:AutoScreenShot()
	self:ReadyCheckEnhancement()
	self:AutoRepair()
	self:AutoSetRole()
	self:BuyStack()
	self:AutoSellJunk()
end



-- ALT + Right Click to buy a stack
function module:BuyStack()
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


-- Auto enables the ActionCam on login
function module:ActionCam()
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
end


-- Instant delete
function module:FasterDelete()
	hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(self)
		self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	end)
end


-- Faster Looting
function module:FasterLoot()
	if not C.misc.fasterLoot then return end
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


-- Auto screenshot when Achievement earned
function module:AutoScreenShot()
	local f = CreateFrame("Frame")
	f:Hide()
	f:SetScript("OnUpdate", function(_, elapsed)
		f.delay = f.delay - elapsed
		if f.delay < 0 then
			Screenshot()
			f:Hide()
		end
	end)

	local function setupMisc(event)
		if not C.misc.autoScreenShot then
			F:UnregisterEvent(event, setupMisc)
		else
			f.delay = 1
			f:Show()
		end
	end
	F:RegisterEvent("ACHIEVEMENT_EARNED", setupMisc)
end


-- Auto repair
function module:AutoRepair()
	if not C.misc.autoRepair then return end

	local isShown, isBankEmpty
	local function autoRepair(override)
		if isShown and not override then return end
		isShown = true
		isBankEmpty = false

		local repairAllCost, canRepair = GetRepairAllCost()
		local myMoney = GetMoney()

		if canRepair and repairAllCost > 0 then
			if (not override) and IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repairAllCost then
				RepairAllItems(true)
			else
				if myMoney > repairAllCost then
					RepairAllItems()
					print(format(C.InfoColor.."%s:|r %s", L["repairCost"], GetMoneyString(repairAllCost)))
					return
				else
					print(C.InfoColor..L["repairError"])
					return
				end
			end

			C_Timer.After(.5, function()
				if isBankEmpty then
					autoRepair(true)
				else
					print(format(C.InfoColor.."%s:|r %s", L["guildRepair"], GetMoneyString(repairAllCost)))
				end
			end)
		end
	end

	local function checkBankFund(_, msgType)
		if msgType == LE_GAME_ERR_GUILD_NOT_ENOUGH_MONEY then
			isBankEmpty = true
		end
	end

	local function merchantClose()
		isShown = false
		F:UnregisterEvent("UI_ERROR_MESSAGE", checkBankFund)
		F:UnregisterEvent("MERCHANT_CLOSED", merchantClose)
	end

	local function merchantShow()
		if IsShiftKeyDown() or not CanMerchantRepair() then return end
		autoRepair()
		F:RegisterEvent("UI_ERROR_MESSAGE", checkBankFund)
		F:RegisterEvent("MERCHANT_CLOSED", merchantClose)
	end
	F:RegisterEvent("MERCHANT_SHOW", merchantShow)
end


-- auto sell junk
function module:AutoSellJunk()
	if not C.misc.autoSellJunk then return end

	local sellCount, stop, cache = 0, true, {}
	local errorText = _G.ERR_VENDOR_DOESNT_BUY

	local function stopSelling(tell)
		stop = true
		if sellCount > 0 and tell then
			print(C.InfoColor..L["SellJunk"]..": ".."|cffffffff"..GetMoneyString(sellCount).."|r")
		end
		sellCount = 0
	end

	local function startSelling()
		if stop then return end
		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				if stop then return end
				local link = GetContainerItemLink(bag, slot)
				if link then
					local price = select(11, GetItemInfo(link))
					local _, count, _, quality = GetContainerItemInfo(bag, slot)
					if quality == 0 and price > 0 and not cache["b"..bag.."s"..slot] then
						sellCount = sellCount + price*count
						cache["b"..bag.."s"..slot] = true
						UseContainerItem(bag, slot)
						C_Timer.After(.2, startSelling)
						return
					end
				end
			end
		end
	end

	local function updateSelling(event, ...)
		local _, arg = ...
		if event == "MERCHANT_SHOW" then
			if IsShiftKeyDown() then return end
			stop = false
			wipe(cache)
			startSelling()
			F:RegisterEvent("UI_ERROR_MESSAGE", updateSelling)
		elseif event == "UI_ERROR_MESSAGE" and arg == errorText then
			stopSelling(false)
		elseif event == "MERCHANT_CLOSED" then
			stopSelling(true)
		end
	end
	F:RegisterEvent("MERCHANT_SHOW", updateSelling)
	F:RegisterEvent("MERCHANT_CLOSED", updateSelling)
end


-- auto set role
function module:AutoSetRole()
	if not C.misc.autoSetRole then return end

	local useSpec = C.misc.autoSetRole_useSpec
	local verbose = C.misc.autoSetRole_verbose

	local _, class = UnitClass("Player")
	local isPureClass
	if class == "HUNTER" or class == "MAGE" or class == "ROGUE" or class == "WARLOCK" then
		isPureClass = true
	end

	local lastMsgTime = 0
	local function Print(msg)
		if time() - lastMsgTime > 10 then
			lastMsgTime = time()
			DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffff"..msg, C.r, C.g, C.b)
		end
	end

	local function setRoleForSpec(self)
		local spec = GetSpecialization()
		if spec then
			UnitSetRole("player", select(6, GetSpecializationInfo(spec)))
			if verbose then
				Print("Role check: Setting role based on current spec.")
			end
		else
			RolePollPopup_Show(self)
			if verbose then
				Print("Role check: You have no spec, cannot set automatically.")
			end
		end
	end

	local function autoSetRole(self, event)
		if event ~= "ROLE_POLL_BEGIN" or InCombatLockdown() then return end

		if isPureClass then
			UnitSetRole("player", "DAMAGER")
			if verbose then
				Print("Role check: Setting role to dps.")
			end
		else
			if UnitGroupRolesAssigned("player") == "NONE" then
				if useSpec then
					setRoleForSpec(self)
				else
					if not self:IsShown() then
						RolePollPopup_Show(self)
					end
				end
			else
				if useSpec then
					setRoleForSpec(self)
				else
					if verbose then
						Print("Role check: Role already set, doing nothing.")
					end
				end
			end
		end
	end

	RolePollPopup:SetScript("OnEvent", autoSetRole)
end

-- flash cursor
function module:FlashCursor()
	if not C.misc.flashCursor then return end

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
