local F, C, L = unpack(select(2, ...))


local type, pairs, tonumber, wipe, next, select, unpack = type, pairs, tonumber, table.wipe, next, select, unpack
local strmatch, gmatch, strfind, format, gsub, sub = string.match, string.gmatch, string.find, string.format, string.gsub, string.sub
local min, max, floor, rad, modf = math.min, math.max, math.floor, math.rad, math.modf
local assets = C.Assets
--local gradientColor = {.06, .06, .06, .4, .1, .1, .1, .4}


--[[ Math ]]

do
	-- Numberize
	function F.Numb(n)
		if FREE_ADB.number_format == 1 then
			if n >= 1e12 then
				return ('%.2ft'):format(n / 1e12)
			elseif n >= 1e9 then
				return ('%.2fb'):format(n / 1e9)
			elseif n >= 1e6 then
				return ('%.2fm'):format(n / 1e6)
			elseif n >= 1e3 then
				return ('%.2fk'):format(n / 1e3)
			else
				return ('%.0f'):format(n)
			end
		elseif FREE_ADB.number_format == 2 then
			if n >= 1e12 then
				return format('%.2f'..L['MISC_NUMBER_CAP'][3], n / 1e12)
			elseif n >= 1e8 then
				return format('%.2f'..L['MISC_NUMBER_CAP'][2], n / 1e8)
			elseif n >= 1e4 then
				return format('%.2f'..L['MISC_NUMBER_CAP'][1], n / 1e4)
			else
				return format('%.0f', n)
			end
		else
			return format('%.0f', n)
		end
	end

	function F:Round(number, idp)
		idp = idp or 0
		local mult = 10 ^ idp
		return floor(number * mult + .5) / mult
	end

	function F:Scale(x)
		local mult = C.Mult
		return mult * floor(x / mult + .5)
	end

	-- Cooldown calculation
	local day, hour, minute = 86400, 3600, 60
	function F.FormatTime(s)
		if s >= day then
			return format('|cffbebfb3%d|r', s/day), s % day -- grey
		elseif s >= hour then
			return format('|cffffffff%d|r', s/hour), s % hour -- white
		elseif s >= minute then
			return format('|cff1e84d0%d|r', s/minute), s % minute -- blue
		elseif s > C.DB.cooldown.decimal_countdown then
			return format('|cffffe700%d|r', s), s - floor(s) -- yellow
		else
			if C.DB.cooldown.decimal then
				return format('|cfffd3612%.1f|r', s), s - format('%.1f', s) -- red
			else
				return format('|cfffd3612%d|r', s + .5), s - floor(s)
			end
		end
	end

	function F.FormatTimeRaw(s)
		if s >= day then
			return format('%dd', s/day)
		elseif s >= hour then
			return format('%dh', s/hour)
		elseif s >= minute then
			return format('%dm', s/minute)
		elseif s >= C.Actionbar.decimal_countdown then
			return floor(s)
		else
			return format('%d', s)
		end
	end

	function F:CooldownOnUpdate(elapsed, raw)
		local formatTime = raw and F.FormatTimeRaw or F.FormatTime
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			local timeLeft = self.expiration - GetTime()
			if timeLeft > 0 then
				local text = formatTime(timeLeft)
				self.timer:SetText(text)
			else
				self:SetScript('OnUpdate', nil)
				self.timer:SetText(nil)
			end
			self.elapsed = 0
		end
	end

	-- Table
	function F.CopyTable(source, target)
		for key, value in pairs(source) do
			if type(value) == 'table' then
				if not target[key] then target[key] = {} end
				for k in pairs(value) do
					target[key][k] = value[k]
				end
			else
				target[key] = value
			end
		end
	end

	function F.SplitList(list, variable, cleanup)
		if cleanup then wipe(list) end

		for word in variable:gmatch('%S+') do
			list[word] = true
		end
	end

	-- GUID to npcID
	function F.GetNPCID(guid)
		local id = tonumber(strmatch((guid or ''), '%-(%d-)%-%x-$'))
		return id
	end


	function F:WaitFunc(elapse)
		local i = 1
		while i <= #F.WaitTable do
			local data = F.WaitTable[i]
			if data[1] > elapse then
				data[1], i = data[1] - elapse, i + 1
			else
				tremove(F.WaitTable, i)
				data[2](unpack(data[3]))

				if #F.WaitTable == 0 then
					F.WaitFrame:Hide()
				end
			end
		end
	end

	F.WaitTable = {}
	F.WaitFrame = CreateFrame('Frame', 'FreeUI_WaitFrame', _G.UIParent)
	F.WaitFrame:SetScript('OnUpdate', F.WaitFunc)

	--Add time before calling a function
	function F:Delay(delay, func, ...)
		if type(delay) ~= 'number' or type(func) ~= 'function' then
			return false
		end

		-- Restrict to the lowest time that the C_Timer API allows us
		if delay < 0.01 then delay = 0.01 end

		if select('#', ...) <= 0 then
			C_Timer.After(delay, func)
		else
			tinsert(F.WaitTable,{delay,func,{...}})
			F.WaitFrame:Show()
		end

		return true
	end
end


--[[ Color ]]

do
	function F.RGBToHex(r, g, b)
		if r then
			if type(r) == 'table' then
				if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
			end
			return format('|cff%02x%02x%02x', r*255, g*255, b*255)
		end
	end

	function F.HexToRGB(hex)
		return tonumber('0x'..sub(hex, 1, 2)) / 255, tonumber('0x'..sub(hex, 3, 4)) / 255, tonumber('0x'..sub(hex, 5, 6)) / 255
	end

	function F.ClassColor(class)
		local color = C.ClassColors[class]
		if not color then return 1, 1, 1 end
		return color.r, color.g, color.b
	end

	function F.UnitColor(unit)
		local r, g, b = 1, 1, 1
		if UnitIsPlayer(unit) then
			local class = select(2, UnitClass(unit))
			if class then
				r, g, b = F.ClassColor(class)
			end
		elseif UnitIsTapDenied(unit) then
			r, g, b = .6, .6, .6
		else
			local reaction = UnitReaction(unit, 'player')
			if reaction then
				local color = FACTION_BAR_COLORS[reaction]
				r, g, b = color.r, color.g, color.b
			end
		end
		return r, g, b
	end

	function F.ColorGradient(perc, ...)
		if perc >= 1 then
			return select(select('#', ...) - 2, ...)
		elseif perc <= 0 then
			return ...
		end

		local num = select('#', ...) / 3
		local segment, relperc = modf(perc*(num-1))
		local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

		return r1+(r2-r1)*relperc, g1+(g2-g1)*relperc, b1+(b2-b1)*relperc
	end
end


--[[ Itemlevel ]]

do
	local iLvlDB = {}
	local itemLevelString = gsub(ITEM_LEVEL, '%%d', '')
	local enchantString = gsub(ENCHANTED_TOOLTIP_LINE, '%%s', '(.+)')
	local essenceTextureID = 2975691
	local essenceDescription = GetSpellDescription(277253)
	local ITEM_SPELL_TRIGGER_ONEQUIP = ITEM_SPELL_TRIGGER_ONEQUIP
	local tip = CreateFrame('GameTooltip', 'FreeUI_ScanTooltip', nil, 'GameTooltipTemplate')
	F.ScanTip = tip

	function F:InspectItemTextures()
		if not tip.gems then
			tip.gems = {}
		else
			wipe(tip.gems)
		end

		if not tip.essences then
			tip.essences = {}
		else
			for _, essences in pairs(tip.essences) do
				wipe(essences)
			end
		end

		local step = 1
		for i = 1, 10 do
			local tex = _G[tip:GetName()..'Texture'..i]
			local texture = tex and tex:IsShown() and tex:GetTexture()
			if texture then
				if texture == essenceTextureID then
					local selected = (tip.gems[i-1] ~= essenceTextureID and tip.gems[i-1]) or nil
					if not tip.essences[step] then tip.essences[step] = {} end
					tip.essences[step][1] = selected		--essence texture if selected or nil
					tip.essences[step][2] = tex:GetAtlas()	--atlas place 'tooltip-heartofazerothessence-major' or 'tooltip-heartofazerothessence-minor'
					tip.essences[step][3] = texture			--border texture placed by the atlas

					step = step + 1
					if selected then tip.gems[i-1] = nil end
				else
					tip.gems[i] = texture
				end
			end
		end

		return tip.gems, tip.essences
	end

	function F:InspectItemInfo(text, slotInfo)
		local itemLevel = strfind(text, itemLevelString) and strmatch(text, '(%d+)%)?$')
		if itemLevel then
			slotInfo.iLvl = tonumber(itemLevel)
		end

		local enchant = strmatch(text, enchantString)
		if enchant then
			slotInfo.enchantText = enchant
		end
	end

	function F:CollectEssenceInfo(index, lineText, slotInfo)
		local step = 1
		local essence = slotInfo.essences[step]
		if essence and next(essence) and (strfind(lineText, ITEM_SPELL_TRIGGER_ONEQUIP, nil, true) and strfind(lineText, essenceDescription, nil, true)) then
			for i = 4, 2, -1 do
				local line = _G[tip:GetName()..'TextLeft'..index-i]
				local text = line and line:GetText()

				if text and (not strmatch(text, '^[ +]')) and essence and next(essence) then
					local r, g, b = line:GetTextColor()
					essence[4] = r
					essence[5] = g
					essence[6] = b

					step = step + 1
					essence = slotInfo.essences[step]
				end
			end
		end
	end

	function F.GetItemLevel(link, arg1, arg2, fullScan)
		if fullScan then
			tip:SetOwner(UIParent, 'ANCHOR_NONE')
			tip:SetInventoryItem(arg1, arg2)

			if not tip.slotInfo then tip.slotInfo = {} else wipe(tip.slotInfo) end

			local slotInfo = tip.slotInfo
			slotInfo.gems, slotInfo.essences = F:InspectItemTextures()

			for i = 1, tip:NumLines() do
				local line = _G[tip:GetName()..'TextLeft'..i]
				if line then
					local text = line:GetText() or ''
					F:InspectItemInfo(text, slotInfo)
					F:CollectEssenceInfo(i, text, slotInfo)
				end
			end

			return slotInfo
		else
			if iLvlDB[link] then return iLvlDB[link] end

			tip:SetOwner(UIParent, 'ANCHOR_NONE')
			if arg1 and type(arg1) == 'string' then
				tip:SetInventoryItem(arg1, arg2)
			elseif arg1 and type(arg1) == 'number' then
				tip:SetBagItem(arg1, arg2)
			else
				tip:SetHyperlink(link)
			end

			local firstLine = _G.FreeUI_ScanTooltipTextLeft1:GetText()
			if firstLine == RETRIEVING_ITEM_INFO then
				return 'tooSoon'
			end

			for i = 2, 5 do
				local line = _G[tip:GetName()..'TextLeft'..i]
				if line then
					local text = line:GetText() or ''
					local found = strfind(text, itemLevelString)
					if found then
						local level = strmatch(text, '(%d+)%)?$')
						iLvlDB[link] = tonumber(level)
						break
					end
				end
			end

			return iLvlDB[link]
		end
	end
end


--[[ Kill regions ]]

do
	function F:Dummy()
		return
	end

	F.HiddenFrame = CreateFrame('Frame')
	F.HiddenFrame:Hide()

	function F:HideObject()
		if self.UnregisterAllEvents then
			self:UnregisterAllEvents()
			self:SetParent(F.HiddenFrame)
		else
			self.Show = self.Hide
		end
		self:Hide()
	end

	function F:HideOption()
		self:SetAlpha(0)
		self:SetScale(.0001)
	end

	local BlizzTextures = {
		'Inset',
		'inset',
		'InsetFrame',
		'LeftInset',
		'RightInset',
		'NineSlice',
		'BG',
		'border',
		'Border',
		'Background',
		'BorderFrame',
		'bottomInset',
		'BottomInset',
		'bgLeft',
		'bgRight',
		'FilligreeOverlay',
		'PortraitOverlay',
		'ArtOverlayFrame',
		'Portrait',
		'portrait',
		'ScrollFrameBorder',
		'ScrollUpBorder',
		'ScrollDownBorder',
	}

	function F:StripTextures(kill)
		local frameName = self.GetName and self:GetName()
		for _, texture in pairs(BlizzTextures) do
			local blizzFrame = self[texture] or (frameName and _G[frameName..texture])
			if blizzFrame then
				F.StripTextures(blizzFrame, kill)
			end
		end

		if self.GetNumRegions then
			for i = 1, self:GetNumRegions() do
				local region = select(i, self:GetRegions())
				if region and region.IsObjectType and region:IsObjectType('Texture') then
					if kill and type(kill) == 'boolean' then
						F.HideObject(region)
					elseif tonumber(kill) then
						if kill == 0 then
							region:SetAlpha(0)
						elseif i ~= kill then
							region:SetTexture('')
						end
					else
						region:SetTexture('')
					end
				end
			end
		end
	end
end


--[[ UI widgets ]]

do
	-- Dropdown menu
	F.EasyMenu = CreateFrame('Frame', 'FreeUI_EasyMenu', UIParent, 'UIDropDownMenuTemplate')

	-- Fontstring
	function F:CreateFS(font, size, flag, text, colour, shadow, anchor, x, y)
		local fs = self:CreateFontString(nil, 'OVERLAY')

		if font then
			if type(font) == 'table' then
				fs:SetFont(font[1], font[2], font[3])
			else
				fs:SetFont(font, size, flag and 'OUTLINE')
			end
		else
			fs:SetFont(C.Assets.Fonts.Regular, 12, 'OUTLINE')
		end

		if text then
			fs:SetText(text)
		end

		if type(colour) == 'table' then
			fs:SetTextColor(colour[1], colour[2], colour[3])
		elseif colour == 'CLASS' then
			fs:SetTextColor(C.r, C.g, C.b)
		elseif colour == 'YELLOW' then
			fs:SetTextColor(.9, .82, .62)
		elseif colour == 'RED' then
			fs:SetTextColor(1, .15, .21)
		elseif colour == 'GREEN' then
			fs:SetTextColor(.23, .62, .21)
		elseif colour == 'BLUE' then
			fs:SetTextColor(.6, .8, 1)
		elseif colour == 'GREY' then
			fs:SetTextColor(.5, .5, .5)
		else
			fs:SetTextColor(1, 1, 1)
		end

		if type(shadow) == 'boolean' then
			fs:SetShadowColor(0, 0, 0, 1)
			fs:SetShadowOffset(1, -1)
		elseif shadow == 'THICK' then
			fs:SetShadowColor(0, 0, 0, 1)
			fs:SetShadowOffset(2, -2)
		else
			fs:SetShadowColor(0, 0, 0, 0)
		end

		if anchor and x and y then
			fs:SetPoint(anchor, x, y)
		else
			fs:SetPoint('CENTER', 1, 0)
		end

		return fs
	end

	function F.SetFS(object, font, size, flag, text, colour, shadow)
		if type(font) == 'table' then
			object:SetFont(font[1], font[2], font[3] or nil)
		else
			object:SetFont(font, size, flag and 'OUTLINE')
		end

		if text then
			object:SetText(text)
		end

		if type(colour) == 'table' then
			object:SetTextColor(colour[1], colour[2], colour[3])
		elseif type(colour) == 'string' then
			if colour == 'CLASS' then
				object:SetTextColor(C.r, C.g, C.b)
			elseif colour == 'YELLOW' then
				object:SetTextColor(.9, .8, .6)
			elseif colour == 'RED' then
				object:SetTextColor(1, .2, .2)
			elseif colour == 'GREEN' then
				object:SetTextColor(.2, .6, .2)
			elseif colour == 'BLUE' then
				object:SetTextColor(.6, .8, 1)
			elseif colour == 'GREY' then
				object:SetTextColor(.5, .5, .5)
			end
		end

		if type(shadow) == 'boolean' then
			object:SetShadowColor(0, 0, 0, 1)
			object:SetShadowOffset(1, -1)
		elseif shadow == 'THICK' then
			object:SetShadowColor(0, 0, 0, 1)
			object:SetShadowOffset(2, -2)
		else
			object:SetShadowColor(0, 0, 0, 0)
		end


	end

	function F.StyleAddonName(msg)
		msg = gsub(msg, '%%AddonName%%', C.AddonName)
		return msg
	end

	function F.CreateColorString(text, color)
		if not text or not type(text) == 'string' then
			return
		end

		if not color or type(color) ~= 'table' then
			return
		end

		local hex = color.r and color.g and color.b and F.RGBToHex(color.r, color.g, color.b) or '|cffffffff'

		return hex .. text .. '|r'
	end

	function F.CreateClassColorString(text, class)
		if not text or not type(text) == 'string' then
			return
		end

		if not class or type(class) ~= 'string' then
			return
		end

		local r, g, b = F.ClassColor(class)
		local hex = r and g and b and F.RGBToHex(r, g, b) or '|cffffffff'

		return hex .. text .. '|r'
	end

	-- GameTooltip
	function F:HideTooltip()
		GameTooltip:Hide()
	end

	local function Tooltip_OnEnter(self)
		GameTooltip:SetOwner(self, self.anchor, 0, 4)
		GameTooltip:ClearLines()
		if self.title then
			GameTooltip:AddLine(self.title)
		end
		if tonumber(self.text) then
			GameTooltip:SetSpellByID(self.text)
		elseif self.text then
			local r, g, b = 1, 1, 1
			if self.color == 'CLASS' then
				r, g, b = C.r, C.g, C.b
			elseif self.color == 'SYSTEM' then
				r, g, b = 1, .8, 0
			elseif self.color == 'BLUE' then
				r, g, b = .6, .8, 1
			elseif self.color == 'RED' then
				r, g, b = .9, .3, .3
			end
			GameTooltip:AddLine(self.text, r, g, b, 1)
		end
		GameTooltip:Show()
	end

	function F:AddTooltip(anchor, text, color)
		self.anchor = anchor
		self.text = text
		self.color = color
		self:HookScript('OnEnter', Tooltip_OnEnter)
		self:HookScript('OnLeave', F.HideTooltip)
	end

	-- Gradient Frame
	local orientationAbbr = {
		['V'] = 'Vertical',
		['H'] = 'Horizontal',
	}

	function F:SetGradient(orientation, r, g, b, a1, a2, width, height)
		orientation = orientationAbbr[orientation]
		if not orientation then return end

		local tex = self:CreateTexture(nil, 'BACKGROUND')
		tex:SetTexture(C.Assets.bd_tex)
		tex:SetGradientAlpha(orientation, r, g, b, a1, r, g, b, a2)
		if width then tex:SetWidth(width) end
		if height then tex:SetHeight(height) end

		return tex
	end

	-- Background texture
	function F:CreateTex()
		if self.__bgTex then return end

		local frame = self
		if self:IsObjectType('Texture') then frame = self:GetParent() end

		local tex = frame:CreateTexture(nil, 'BACKGROUND', nil, 1)
		tex:SetAllPoints(self)
		tex:SetTexture(assets.bg_tex, true, true)
		tex:SetHorizTile(true)
		tex:SetVertTile(true)
		tex:SetBlendMode('ADD')

		self.__bgTex = tex
	end

	local shadowBackdrop = {edgeFile = assets.shadow_tex}
	function F:CreateSD(a, m, s, override)
		if not override and not FREE_ADB.shadow_border then return end
		if self.__shadow then return end

		local frame = self
		if self:IsObjectType('Texture') then frame = self:GetParent() end

		if not m then m, s = 4, 4 end
		shadowBackdrop.edgeSize = s or 4
		self.__shadow = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
		self.__shadow:SetOutside(self, m, m)
		self.__shadow:SetBackdrop(shadowBackdrop)
		self.__shadow:SetBackdropBorderColor(.04, .04, .04, a or .25)
		self.__shadow:SetFrameLevel(1)

		return self.__shadow
	end
end


--[[ UI skins ]]

do
	-- Setup backdrop
	C.Frames = {}

	local defaultBackdrop = {bgFile = assets.bd_tex, edgeFile = assets.bd_tex}
	function F:CreateBD(a, r, g, b)
		defaultBackdrop.edgeSize = C.Mult
		self:SetBackdrop(defaultBackdrop)
		if r then
			self:SetBackdropColor(r, g, b, a or FREE_ADB.backdrop_alpha)
		else
			self:SetBackdropColor(C.BackdropColor[1], C.BackdropColor[2], C.BackdropColor[3], a or FREE_ADB.backdrop_alpha)
		end
		self:SetBackdropBorderColor(C.BorderColor[1], C.BorderColor[2], C.BorderColor[3])

		if not a then tinsert(C.Frames, self) end
	end

	function F:CreateGradient()
		local tex = self:CreateTexture(nil, 'BORDER')
		tex:SetInside()
		tex:SetTexture(assets.bd_tex)
		tex:SetGradientAlpha('Vertical', unpack(C.GradientColor))

		return tex
	end

	function F:CreateBDFrame(a, gradient, r, g, b)
		local frame = self
		if self:IsObjectType('Texture') then frame = self:GetParent() end
		local lvl = frame:GetFrameLevel()

		local bg = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
		bg:SetOutside(self)
		bg:SetFrameLevel(lvl == 0 and 0 or lvl - 1)
		if r then
			F.CreateBD(bg, a, r, g, b)
		else
			F.CreateBD(bg, a)
		end
		if gradient then
			self.__gradient = F.CreateGradient(bg)
		end

		return bg
	end

	function F:SetBD(a, x, y, x2, y2)
		local bg = F.CreateBDFrame(self, a)
		if x then
			bg:SetPoint('TOPLEFT', self, x, y)
			bg:SetPoint('BOTTOMRIGHT', self, x2, y2)
		end
		F.CreateSD(bg)
		F.CreateTex(bg)

		return bg
	end

	-- Handle icons
	function F:ReskinIcon(shadow)
		self:SetTexCoord(unpack(C.TexCoord))
		local bg = F.CreateBDFrame(self)
		if shadow then F.CreateSD(bg) end
		return bg
	end

	function F:PixelIcon(texture, highlight)
		self.bg = F.CreateBDFrame(self)
		self.bg:SetAllPoints()
		self.Icon = self:CreateTexture(nil, 'ARTWORK')
		self.Icon:SetInside()
		self.Icon:SetTexCoord(unpack(C.TexCoord))
		if texture then
			local atlas = strmatch(texture, 'Atlas:(.+)$')
			if atlas then
				self.Icon:SetAtlas(atlas)
			else
				self.Icon:SetTexture(texture)
			end
		end
		if highlight and type(highlight) == 'boolean' then
			self:EnableMouse(true)
			self.HL = self:CreateTexture(nil, 'HIGHLIGHT')
			self.HL:SetColorTexture(1, 1, 1, .25)
			self.HL:SetInside()
		end
	end

	function F:AuraIcon(highlight)
		self.CD = CreateFrame('Cooldown', nil, self, 'CooldownFrameTemplate')
		self.CD:SetInside()
		self.CD:SetReverse(true)
		F.PixelIcon(self, nil, highlight)
		F.CreateSD(self)
	end

	function F:CreateHelpInfo(tooltip)
		local bu = CreateFrame('Button', nil, self)
		bu:SetSize(40, 40)
		bu.Icon = bu:CreateTexture(nil, 'ARTWORK')
		bu.Icon:SetAllPoints()
		bu.Icon:SetTexture(616343)
		bu:SetHighlightTexture(616343)
		if tooltip then
			bu.title = L.GUI.HINT
			F.AddTooltip(bu, 'ANCHOR_BOTTOMLEFT', tooltip, 'BLUE')
		end

		return bu
	end

	function F:CreateWatermark()
		local logo = self:CreateTexture(nil, 'BACKGROUND')
		logo:SetPoint('BOTTOMRIGHT', 10, 0)
		logo:SetTexture(C.Assets.logo)
		logo:SetTexCoord(0, 1, 0, .75)
		logo:SetSize(200, 75)
		logo:SetAlpha(.3)
	end

	local AtlasToQuality = {
		['auctionhouse-itemicon-border-gray'] = LE_ITEM_QUALITY_POOR,
		['auctionhouse-itemicon-border-white'] = LE_ITEM_QUALITY_COMMON,
		['auctionhouse-itemicon-border-green'] = LE_ITEM_QUALITY_UNCOMMON,
		['auctionhouse-itemicon-border-blue'] = LE_ITEM_QUALITY_RARE,
		['auctionhouse-itemicon-border-purple'] = LE_ITEM_QUALITY_EPIC,
		['auctionhouse-itemicon-border-orange'] = LE_ITEM_QUALITY_LEGENDARY,
		['auctionhouse-itemicon-border-artifact'] = LE_ITEM_QUALITY_ARTIFACT,
		['auctionhouse-itemicon-border-account'] = LE_ITEM_QUALITY_HEIRLOOM,
	}

	local function updateIconBorderColorByAtlas(self, atlas)
		local quality = AtlasToQuality[atlas]
		local color = C.QualityColors[quality or 1]
		self.__owner.bg:SetBackdropBorderColor(color.r, color.g, color.b)
	end

	local function updateIconBorderColor(self, r, g, b)
		if not r or (r==.65882 and g==.65882 and b==.65882) or (r>.99 and g>.99 and b>.99) then
			r, g, b = 0, 0, 0
		end
		self.__owner.bg:SetBackdropBorderColor(r, g, b)
	end

	local function resetIconBorderColor(self)
		self.__owner.bg:SetBackdropBorderColor(0, 0, 0)
	end

	function F:ReskinIconBorder(needInit)
		self:SetAlpha(0)
		self.__owner = self:GetParent()
		if not self.__owner.bg then return end
		if self.__owner.useCircularIconBorder then -- for auction item display
			hooksecurefunc(self, 'SetAtlas', updateIconBorderColorByAtlas)
		else
			hooksecurefunc(self, 'SetVertexColor', updateIconBorderColor)
			if needInit then
				self:SetVertexColor(self:GetVertexColor()) -- for border with color before hook
			end
		end
		hooksecurefunc(self, 'Hide', resetIconBorderColor)
	end

	-- Handle statusbar
	function F:CreateSB(spark, r, g, b)
		self:SetStatusBarTexture(assets.norm_tex)
		if r and g and b then
			self:SetStatusBarColor(r, g, b)
		else
			self:SetStatusBarColor(C.r, C.g, C.b)
		end

		local bg = F.SetBD(self)
		self.__shadow = bg.__shadow

		if spark then
			self.Spark = self:CreateTexture(nil, 'OVERLAY')
			self.Spark:SetTexture(assets.spark_tex)
			self.Spark:SetBlendMode('ADD')
			self.Spark:SetAlpha(.8)
			self.Spark:SetPoint('TOPLEFT', self:GetStatusBarTexture(), 'TOPRIGHT', -10, 10)
			self.Spark:SetPoint('BOTTOMRIGHT', self:GetStatusBarTexture(), 'BOTTOMRIGHT', 10, -10)
		end
	end

	-- Handle button
	local function CreatePulse(frame)
		local speed = .05
		local mult = 1
		local alpha = 1
		local last = 0
		frame:SetScript('OnUpdate', function(self, elapsed)
			last = last + elapsed
			if last > speed then
				last = 0
				self:SetAlpha(alpha)
			end
			alpha = alpha - elapsed*mult
			if alpha < 0 and mult > 0 then
				mult = mult*-1
				alpha = 0
			elseif alpha > 1 and mult < 0 then
				mult = mult*-1
			end
		end)
	end

	local function Button_OnEnter(self)
		if not self:IsEnabled() then return end

		self.__bg:SetBackdropBorderColor(C.r, C.g, C.b, 1)
		self.__shadow:SetBackdropBorderColor(C.r, C.g, C.b)
		self.__shadow:SetAlpha(1)

		CreatePulse(self.__shadow)
	end

	local function Button_OnLeave(self)
		self.__bg:SetBackdropBorderColor(.4, .4, .4, .2)
		self.__shadow:SetBackdropBorderColor(0, 0, 0)
		self.__shadow:SetScript('OnUpdate', nil)
		self.__shadow:SetAlpha(.25)
	end

	local blizzRegions = {
		'Left',
		'Middle',
		'Right',
		'Mid',
		'LeftDisabled',
		'MiddleDisabled',
		'RightDisabled',
		'TopLeft',
		'TopRight',
		'BottomLeft',
		'BottomRight',
		'TopMiddle',
		'MiddleLeft',
		'MiddleRight',
		'BottomMiddle',
		'MiddleMiddle',
		'TabSpacer',
		'TabSpacer1',
		'TabSpacer2',
		'_RightSeparator',
		'_LeftSeparator',
		'Cover',
		'Border',
		'Background',
		'TopTex',
		'TopLeftTex',
		'TopRightTex',
		'LeftTex',
		'BottomTex',
		'BottomLeftTex',
		'BottomRightTex',
		'RightTex',
		'MiddleTex',
		'Center',
	}

	function F:Reskin(shadow, noGlow)
		if self.SetNormalTexture then self:SetNormalTexture('') end
		if self.SetHighlightTexture then self:SetHighlightTexture('') end
		if self.SetPushedTexture then self:SetPushedTexture('') end
		if self.SetDisabledTexture then self:SetDisabledTexture('') end

		local buttonName = self.GetName and self:GetName()
		for _, region in pairs(blizzRegions) do
			region = buttonName and _G[buttonName..region] or self[region]
			if region then
				region:SetAlpha(0)
			end
		end

		self.__bg = F.CreateBDFrame(self, 0, true)
		self.__bg:SetBackdropBorderColor(.4, .4, .4, .2)
		self.__bg:SetFrameLevel(self:GetFrameLevel())
		self.__bg:SetAllPoints()

		self.__shadow = F.CreateSD(self, .25, 6, 6)
		--self.__shadow:SetAlpha(shadow and .25 or 0)

		self:HookScript('OnEnter', Button_OnEnter)
		self:HookScript('OnLeave', Button_OnLeave)

		--if not noGlow then
			-- self.glow = CreateFrame('Frame', nil, self, 'BackdropTemplate')
			-- self.glow:SetBackdrop({
			-- 	edgeFile = assets.shadow_tex,
			-- 	edgeSize = 6,
			-- })
			-- self.glow:SetPoint('TOPLEFT', -6, 6)
			-- self.glow:SetPoint('BOTTOMRIGHT', 6, -6)
			-- self.glow:SetBackdropBorderColor(0, 0, 0)
			-- self.glow:SetAlpha(shadow and .25 or 0)

			-- self:HookScript('OnEnter', Button_OnEnter)
			-- self:HookScript('OnLeave', Button_OnLeave)
		--end
	end

	local function Menu_OnEnter(self)
		self.bg:SetBackdropBorderColor(C.r, C.g, C.b)
	end

	local function Menu_OnLeave(self)
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end

	local function Menu_OnMouseUp(self)
		self.bg:SetBackdropColor(0, 0, 0, .6)
	end

	local function Menu_OnMouseDown(self)
		self.bg:SetBackdropColor(C.r, C.g, C.b, .2)
	end

	function F:ReskinMenuButton()
		--F.StripTextures(self)
		self.bg = F.SetBD(self)
		self:SetScript('OnEnter', Menu_OnEnter)
		self:SetScript('OnLeave', Menu_OnLeave)
		self:HookScript('OnMouseUp', Menu_OnMouseUp)
		self:HookScript('OnMouseDown', Menu_OnMouseDown)
	end

	-- Handle tabs
	function F:ReskinTab()
		self:DisableDrawLayer('BACKGROUND')

		local bg = F.CreateBDFrame(self)
		bg:SetPoint('TOPLEFT', 8, -3)
		bg:SetPoint('BOTTOMRIGHT', -8, 0)
		F.CreateSD(bg)
		self.bg = bg

		self:SetHighlightTexture(assets.bd_tex)
		local hl = self:GetHighlightTexture()
		hl:ClearAllPoints()
		hl:SetInside(bg)
		hl:SetVertexColor(C.r, C.g, C.b, .25)
	end

	local function resetTabAnchor(tab)
		local text = tab.Text or _G[tab:GetName()..'Text']
		if text then
			text:SetPoint('CENTER', tab)
		end
	end
	hooksecurefunc('PanelTemplates_DeselectTab', resetTabAnchor)
	hooksecurefunc('PanelTemplates_SelectTab', resetTabAnchor)

	-- Handle scrollframe
	local function Scroll_OnEnter(self)
		local thumb = self.thumb
		if not thumb then return end
		thumb.bg:SetBackdropColor(C.r, C.g, C.b, .25)
		thumb.bg:SetBackdropBorderColor(0, 0, 0)
	end

	local function Scroll_OnLeave(self)
		local thumb = self.thumb
		if not thumb then return end
		thumb.bg:SetBackdropColor(0, 0, 0, 0)
		thumb.bg:SetBackdropBorderColor(0, 0, 0)
	end

	local function GrabScrollBarElement(frame, element)
		local frameName = frame:GetDebugName()
		return frame[element] or frameName and (_G[frameName..element] or strfind(frameName, element)) or nil
	end

	function F:ReskinScroll()
		F.StripTextures(self:GetParent())
		F.StripTextures(self)

		local thumb = GrabScrollBarElement(self, 'ThumbTexture') or GrabScrollBarElement(self, 'thumbTexture') or self.GetThumbTexture and self:GetThumbTexture()
		if thumb then
			thumb:SetAlpha(0)
			thumb:SetWidth(16)
			self.thumb = thumb

			local bg = F.CreateBDFrame(self, 0, true)
			bg:SetPoint('TOPLEFT', thumb, 0, -2)
			bg:SetPoint('BOTTOMRIGHT', thumb, 0, 4)
			thumb.bg = bg
		end

		local up, down = self:GetChildren()
		F.ReskinArrow(up, 'up')
		F.ReskinArrow(down, 'down')

		self:HookScript('OnEnter', Scroll_OnEnter)
		self:HookScript('OnLeave', Scroll_OnLeave)
	end

	-- Handle dropdown
	function F:ReskinDropDown()
		F.StripTextures(self)

		local frameName = self.GetName and self:GetName()
		local down = self.Button or frameName and (_G[frameName..'Button'] or _G[frameName..'_Button'])

		local bg = F.CreateBDFrame(self, 0, true)
		bg:SetPoint('TOPLEFT', 16, -4)
		bg:SetPoint('BOTTOMRIGHT', -18, 8)

		down:ClearAllPoints()
		down:SetPoint('RIGHT', bg, -2, 0)
		F.ReskinArrow(down, 'down')
	end

	-- Handle close button
	function F:Texture_OnEnter()
		if self:IsEnabled() then
			if self.bg then
				self.bg:SetBackdropColor(C.r, C.g, C.b, .25)
			else
				self.__texture:SetVertexColor(C.r, C.g, C.b)
			end
		end
	end

	function F:Texture_OnLeave()
		if self.bg then
			self.bg:SetBackdropColor(0, 0, 0, .25)
		else
			self.__texture:SetVertexColor(1, 1, 1)
		end
	end

	function F:ReskinClose(parent, xOffset, yOffset)
		parent = parent or self:GetParent()
		xOffset = xOffset or -6
		yOffset = yOffset or -6

		self:SetSize(16, 16)
		self:ClearAllPoints()
		self:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', xOffset, yOffset)

		F.StripTextures(self)
		local bg = F.CreateBDFrame(self, 0, true)
		bg:SetAllPoints()

		self:SetDisabledTexture(assets.bd_tex)
		local dis = self:GetDisabledTexture()
		dis:SetVertexColor(0, 0, 0, .4)
		dis:SetDrawLayer('OVERLAY')
		dis:SetAllPoints()

		local tex = self:CreateTexture()
		tex:SetTexture(assets.close_tex)
		tex:SetVertexColor(1, 1, 1)
		tex:SetAllPoints()

		self.__texture = tex

		self:HookScript('OnEnter', F.Texture_OnEnter)
		self:HookScript('OnLeave', F.Texture_OnLeave)
	end

	-- Handle editbox
	function F:ReskinEditBox(height, width)
		local frameName = self.GetName and self:GetName()
		for _, region in pairs(blizzRegions) do
			region = frameName and _G[frameName..region] or self[region]
			if region then
				region:SetAlpha(0)
			end
		end

		local bg = F.CreateBDFrame(self, .45, false, .04, .04, .04)
		bg:SetPoint('TOPLEFT', -2, 0)
		bg:SetPoint('BOTTOMRIGHT')
		bg:SetBackdropBorderColor(1, 1, 1, .2)
		self.bg = bg

		if height then self:SetHeight(height) end
		if width then self:SetWidth(width) end
	end
	F.ReskinInput = F.ReskinEditBox -- Deprecated

	-- Handle arrows
	local arrowDegree = {
		['up'] = 0,
		['down'] = 180,
		['left'] = 90,
		['right'] = -90,
	}

	function F:SetupArrow(direction)
		self:SetTexture(assets.arrow_tex)
		self:SetRotation(rad(arrowDegree[direction]))
	end

	function F:ReskinArrow(direction)
		self:SetSize(16, 16)
		F.Reskin(self, true)

		self:SetDisabledTexture(assets.bd_tex)
		local dis = self:GetDisabledTexture()
		dis:SetVertexColor(0, 0, 0, .3)
		dis:SetDrawLayer('OVERLAY')
		dis:SetAllPoints()

		local tex = self:CreateTexture(nil, 'ARTWORK')
		tex:SetVertexColor(1, 1, 1)
		tex:SetAllPoints()
		F.SetupArrow(tex, direction)
		self.__texture = tex

		self:HookScript('OnEnter', F.Texture_OnEnter)
		self:HookScript('OnLeave', F.Texture_OnLeave)
	end

	function F:ReskinFilterButton()
		F.StripTextures(self)
		F.Reskin(self)
		self.Text:SetPoint('CENTER')
		F.SetupArrow(self.Icon, 'right')
		self.Icon:SetPoint('RIGHT')
		self.Icon:SetSize(14, 14)
	end

	function F:ReskinNavBar()
		if self.navBarStyled then return end

		local homeButton = self.homeButton
		local overflowButton = self.overflowButton

		self:GetRegions():Hide()
		self:DisableDrawLayer('BORDER')
		self.overlay:Hide()
		homeButton:GetRegions():Hide()
		F.Reskin(homeButton)
		F.Reskin(overflowButton, true)

		local tex = overflowButton:CreateTexture(nil, 'ARTWORK')
		tex:SetTexture(assets.arrow_reft)
		tex:SetSize(8, 8)
		tex:SetPoint('CENTER')
		overflowButton.__texture = tex

		overflowButton:HookScript('OnEnter', F.Texture_OnEnter)
		overflowButton:HookScript('OnLeave', F.Texture_OnLeave)

		self.navBarStyled = true
	end

	-- Handle checkbox and radio
	function F:ReskinCheck(flat, forceSaturation)
		self:SetNormalTexture('')
		self:SetPushedTexture('')

		local bg = F.CreateBDFrame(self, .45, false, .04, .04, .04)
		bg:SetInside(self, 4, 4)
		bg:SetBackdropBorderColor(1, 1, 1, .2)
		F.CreateSD(bg, .25)
		self.bg = bg

		if self.SetHighlightTexture then
			local highligh = self:CreateTexture()
			highligh:SetColorTexture(1, 1, 1, 0.3)
			highligh:SetPoint('TOPLEFT', self, 6, -6)
			highligh:SetPoint('BOTTOMRIGHT', self, -6, 6)
			self:SetHighlightTexture(highligh)
		end

		if flat then
			if self.SetCheckedTexture then
				local checked = self:CreateTexture()
				checked:SetColorTexture(C.r, C.g, C.b)
				checked:SetPoint('TOPLEFT', self, 6, -6)
				checked:SetPoint('BOTTOMRIGHT', self, -6, 6)
				self:SetCheckedTexture(checked)
			end

			if self.SetDisabledCheckedTexture then
				local disabled = self:CreateTexture()
				disabled:SetColorTexture(.3, .3, .3)
				disabled:SetPoint('TOPLEFT', self, 6, -6)
				disabled:SetPoint('BOTTOMRIGHT', self, -6, 6)
				self:SetDisabledCheckedTexture(disabled)
			end
		else
			self:SetCheckedTexture(assets.tick_tex)
			self:SetDisabledCheckedTexture(assets.tick_tex)

			if self.SetCheckedTexture then
				local checked = self:GetCheckedTexture()
				checked:SetVertexColor(C.r, C.g, C.b)
				checked:SetPoint('TOPLEFT', self, 5, -5)
				checked:SetPoint('BOTTOMRIGHT', self, -5, 5)
				checked:SetDesaturated(true)
			end

			if self.SetDisabledCheckedTexture then
				local disabled = self:GetDisabledCheckedTexture()
				disabled:SetVertexColor(.3, .3, .3)
				disabled:SetPoint('TOPLEFT', self, 5, -5)
				disabled:SetPoint('BOTTOMRIGHT', self, -5, 5)
			end
		end

		self.forceSaturation = forceSaturation
	end

	function F:ReskinRadio()
		self:SetNormalTexture('')
		self:SetHighlightTexture('')
		self:SetCheckedTexture(assets.bd_tex)

		local ch = self:GetCheckedTexture()
		ch:SetPoint('TOPLEFT', 4, -4)
		ch:SetPoint('BOTTOMRIGHT', -4, 4)
		ch:SetVertexColor(C.r, C.g, C.b, .6)

		local bd = F.CreateBDFrame(self, 0)
		bd:SetPoint('TOPLEFT', 3, -3)
		bd:SetPoint('BOTTOMRIGHT', -3, 3)
		F.CreateGradient(bd)
		self.bd = bd

		self:HookScript('OnEnter', F.Texture_OnEnter)
		self:HookScript('OnLeave', F.Texture_OnLeave)
	end

	-- Color swatch
	function F:ReskinColorSwatch()
		local frameName = self.GetName and self:GetName()
		local swatchBg = frameName and _G[frameName..'SwatchBg']
		if swatchBg then
			swatchBg:SetColorTexture(0, 0, 0)
			swatchBg:SetInside(nil, 2, 2)
		end

		self:SetNormalTexture(assets.bd_tex)
		self:GetNormalTexture():SetInside(self, 3, 3)
	end

	-- Handle slider
	function F:ReskinSlider(vertical)
		self:SetBackdrop(nil)
		F.StripTextures(self)

		local bd = F.CreateBDFrame(self, .45, false, .04, .04, .04)
		bd:SetPoint('TOPLEFT', 14, -2)
		bd:SetPoint('BOTTOMRIGHT', -15, 3)
		bd:SetBackdropBorderColor(1, 1, 1, .2)
		bd:SetFrameStrata('BACKGROUND')
		F.CreateSD(bd)

		local thumb = self:GetThumbTexture()
		thumb:SetHeight(self:GetHeight() + 12)
		thumb:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
		thumb:SetVertexColor(1, 1, 1, .5)
		thumb:SetBlendMode('ADD')
		if vertical then thumb:SetRotation(rad(90)) end
	end

	-- Handle collapse
	local function updateCollapseTexture(texture, collapsed)
		local atlas = collapsed and 'Soulbinds_Collection_CategoryHeader_Expand' or 'Soulbinds_Collection_CategoryHeader_Collapse'
		texture:SetAtlas(atlas, true)
	end

	local function resetCollapseTexture(self, texture)
		if self.settingTexture then return end
		self.settingTexture = true
		self:SetNormalTexture('')

		if texture and texture ~= '' then
			if strfind(texture, 'Plus') or strfind(texture, 'Closed') then
				self.__texture:DoCollapse(true)
			elseif strfind(texture, 'Minus') or strfind(texture, 'Open') then
				self.__texture:DoCollapse(false)
			end
			self.bg:Show()
		else
			self.bg:Hide()
		end
		self.settingTexture = nil
	end

	function F:ReskinCollapse(isAtlas)
		self:SetHighlightTexture('')
		self:SetPushedTexture('')

		local bg = F.CreateBDFrame(self, .25, true)
		bg:ClearAllPoints()
		bg:SetSize(13, 13)
		bg:SetPoint('TOPLEFT', self:GetNormalTexture())
		self.bg = bg

		self.__texture = bg:CreateTexture(nil, 'OVERLAY')
		self.__texture:SetPoint('CENTER')
		self.__texture.DoCollapse = updateCollapseTexture

		self:HookScript('OnEnter', F.Texture_OnEnter)
		self:HookScript('OnLeave', F.Texture_OnLeave)
		if isAtlas then
			hooksecurefunc(self, 'SetNormalAtlas', resetCollapseTexture)
		else
			hooksecurefunc(self, 'SetNormalTexture', resetCollapseTexture)
		end
	end

	local buttonNames = {'MaximizeButton', 'MinimizeButton'}
	function F:ReskinMinMax()
		for _, name in next, buttonNames do
			local button = self[name]
			if button then
				button:SetSize(16, 16)
				button:ClearAllPoints()
				button:SetPoint('CENTER', -3, 0)
				F.Reskin(button)

				local tex = button:CreateTexture()
				tex:SetAllPoints()
				if name == 'MaximizeButton' then
					F.SetupArrow(tex, 'up')
				else
					F.SetupArrow(tex, 'down')
				end
				button.__texture = tex

				button:SetScript('OnEnter', F.Texture_OnEnter)
				button:SetScript('OnLeave', F.Texture_OnLeave)
			end
		end
	end

	-- UI templates
	function F:ReskinPortraitFrame()
		F.StripTextures(self)
		local bg = F.SetBD(self)
		local frameName = self.GetName and self:GetName()
		local portrait = self.PortraitTexture or self.portrait or (frameName and _G[frameName..'Portrait'])
		if portrait then
			portrait:SetAlpha(0)
		end
		local closeButton = self.CloseButton or (frameName and _G[frameName..'CloseButton'])
		if closeButton then
			F.ReskinClose(closeButton)
		end
		return bg
	end

	local ReplacedRoleTex = {
		['Adventures-Tank'] = 'Soulbinds_Tree_Conduit_Icon_Protect',
		['Adventures-Healer'] = 'ui_adv_health',
		['Adventures-DPS'] = 'ui_adv_atk',
		['Adventures-DPS-Ranged'] = 'Soulbinds_Tree_Conduit_Icon_Utility',
	}

	local function replaceFollowerRole(roleIcon, atlas)
		local newAtlas = ReplacedRoleTex[atlas]
		if newAtlas then
			roleIcon:SetAtlas(newAtlas)
		end
	end

	function F:ReskinGarrisonPortrait()
		local level = self.Level or self.LevelText
		if level then
			level:ClearAllPoints()
			level:SetPoint('BOTTOM', self, 0, 12)
			if self.LevelCircle then self.LevelCircle:Hide() end
			if self.LevelBorder then self.LevelBorder:SetScale(.0001) end
		end

		self.squareBG = F.CreateBDFrame(self.Portrait, 1)

		if self.PortraitRing then
			self.PortraitRing:Hide()
			self.PortraitRingQuality:SetTexture('')
			self.PortraitRingCover:SetColorTexture(0, 0, 0)
			self.PortraitRingCover:SetAllPoints(self.squareBG)
		end

		if self.Empty then
			self.Empty:SetColorTexture(0, 0, 0)
			self.Empty:SetAllPoints(self.Portrait)
		end
		if self.Highlight then self.Highlight:Hide() end
		if self.PuckBorder then self.PuckBorder:SetAlpha(0) end

		if self.HealthBar then
			self.HealthBar.Border:Hide()

			local roleIcon = self.HealthBar.RoleIcon
			roleIcon:ClearAllPoints()
			roleIcon:SetPoint('CENTER', self.squareBG, 'TOPRIGHT')
			replaceFollowerRole(roleIcon, roleIcon:GetAtlas())
			hooksecurefunc(roleIcon, 'SetAtlas', replaceFollowerRole)

			local background = self.HealthBar.Background
			background:SetAlpha(0)
			background:ClearAllPoints()
			background:SetPoint('TOPLEFT', self.squareBG, 'BOTTOMLEFT', C.Mult, 6)
			background:SetPoint('BOTTOMRIGHT', self.squareBG, 'BOTTOMRIGHT', -C.Mult, C.Mult)
			self.HealthBar.Health:SetTexture(C.Assets.norm_tex)
		end
	end

	function F:StyleSearchButton()
		F.StripTextures(self)
		if self.icon then
			F.ReskinIcon(self.icon)
		end
		F.CreateBDFrame(self, .25)

		self:SetHighlightTexture(assets.bd_tex)
		local hl = self:GetHighlightTexture()
		hl:SetVertexColor(C.r, C.g, C.b, .25)
		hl:SetInside()
	end

	function F:AffixesSetup()
		for _, frame in ipairs(self.Affixes) do
			frame.Border:SetTexture(nil)
			frame.Portrait:SetTexture(nil)
			if not frame.bg then
				frame.bg = F.ReskinIcon(frame.Portrait)
			end

			if frame.info then
				frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
			elseif frame.affixID then
				local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
				frame.Portrait:SetTexture(filedataid)
			end
		end
	end

	-- Role Icons
	function F:GetRoleTexCoord()
		if self == 'TANK' then
			return .34/9.03, 2.86/9.03, 3.16/9.03, 5.68/9.03
		elseif self == 'DPS' or self == 'DAMAGER' then
			return 3.26/9.03, 5.78/9.03, 3.16/9.03, 5.68/9.03
		elseif self == 'HEALER' then
			return 3.26/9.03, 5.78/9.03, .28/9.03, 2.78/9.03
		elseif self == 'LEADER' then
			return .34/9.03, 2.86/9.03, .28/9.03, 2.78/9.03
		elseif self == 'READY' then
			return 6.17/9.03, 8.75/9.03, .28/9.03, 2.78/9.03
		elseif self == 'PENDING' then
			return 6.17/9.03, 8.75/9.03, 3.16/9.03, 5.68/9.03
		elseif self == 'REFUSE' then
			return 3.26/9.03, 5.78/9.03, 6.03/9.03, 8.61/9.03
		end
	end

	function F:ReskinRole(role)
		if self.background then self.background:SetTexture('') end
		local cover = self.cover or self.Cover
		if cover then cover:SetTexture('') end
		local texture = self.GetNormalTexture and self:GetNormalTexture() or self.texture or self.Texture or (self.SetTexture and self) or self.Icon
		if texture then
			texture:SetTexture(assets.roles_icon)
			texture:SetTexCoord(F.GetRoleTexCoord(role))
		end
		self.bg = F.CreateBDFrame(self)

		local checkButton = self.checkButton or self.CheckButton or self.CheckBox
		if checkButton then
			checkButton:SetFrameLevel(self:GetFrameLevel() + 2)
			checkButton:SetPoint('BOTTOMLEFT', -2, -2)
			F.ReskinCheck(checkButton)
		end

		local shortageBorder = self.shortageBorder
		if shortageBorder then
			shortageBorder:SetTexture('')
			local icon = self.incentiveIcon
			icon:SetPoint('BOTTOMRIGHT')
			icon:SetSize(14, 14)
			icon.texture:SetSize(14, 14)
			F.ReskinIcon(icon.texture)
			icon.border:SetTexture('')
		end
	end
end


--[[ Smooth ]]

do
	local next, Lerp, abs = next, Lerp, math.abs
	local abs = math.abs

	local activeObjects, handledObjects = {}, {}
	local TARGET_FPS, AMOUNT = 60, .33

	local function clamp(v, min, max)
		min = min or 0
		max = max or 1
		v = tonumber(v)

		if v > max then
			return max
		elseif v < min then
			return min
		end

		return v
	end

	local function isCloseEnough(new, target, range)
		if range > 0 then
			return abs((new - target) / range) <= .001
		end

		return true
	end

	local smoothframe = CreateFrame('Frame')

	local function onUpdate(_, elapsed)
		for object, target in next, activeObjects do
			local new = Lerp(object._value, target, clamp(AMOUNT * elapsed * TARGET_FPS))
			if isCloseEnough(new, target, object._max - object._min) then
				new = target
				activeObjects[object] = nil
			end

			object:SetValue_(new)
			object._value = new
		end
	end

	local function bar_SetSmoothedValue(self, value)
		self._value = self:GetValue()
		activeObjects[self] = clamp(value, self._min, self._max)
	end

	local function bar_SetSmoothedMinMaxValues(self, min, max)
		self:SetMinMaxValues_(min, max)

		if self._max and self._max ~= max then
			local ratio = 1
			if max ~= 0 and self._max and self._max ~= 0 then
				ratio = max / (self._max or max)
			end

			local target = activeObjects[self]
			if target then
				activeObjects[self] = target * ratio
			end

			local cur = self._value
			if cur then
				self:SetValue_(cur * ratio)
				self._value = cur * ratio
			end
		end

		self._min = min
		self._max = max
	end

	function F:SmoothBar(bar)
		bar._min, bar._max = bar:GetMinMaxValues()
		bar._value = bar:GetValue()

		bar.SetValue_ = bar.SetValue
		bar.SetMinMaxValues_ = bar.SetMinMaxValues
		bar.SetValue = bar_SetSmoothedValue
		bar.SetMinMaxValues = bar_SetSmoothedMinMaxValues

		handledObjects[bar] = true

		if not smoothframe:GetScript('OnUpdate') then
			smoothframe:SetScript('OnUpdate', onUpdate)
		end
	end

	function F:DesmoothBar(bar)
		if activeObjects[bar] then
			bar:SetValue_(activeObjects[bar])
			activeObjects[bar] = nil
		end

		if bar.SetValue_ then
			bar.SetValue = bar.SetValue_
			bar.SetValue_ = nil
		end

		if bar.SetMinMaxValues_ then
			bar.SetMinMaxValues = bar.SetMinMaxValues_
			bar.SetMinMaxValues_ = nil
		end

		handledObjects[bar] = nil

		if not next(handledObjects) then
			smoothframe:SetScript('OnUpdate', nil)
		end
	end

	function F:SetSmoothingAmount(amount)
		AMOUNT = clamp(amount, .15, .6)
	end
end


--[[ GUI elements ]]

do
	function F:CreateButton(width, height, text, fontSize)
		local bu = CreateFrame('Button', nil, self, 'BackdropTemplate')
		bu:SetSize(width, height)
		if type(text) == 'boolean' then
			F.PixelIcon(bu, fontSize, true)
		else
			F.Reskin(bu)
			bu.text = F.CreateFS(bu, C.Assets.Fonts.Regular, fontSize or 12, nil, text, nil, true)
		end

		return bu
	end

	function F:CreateCheckBox(flat)
		local cb = CreateFrame('CheckButton', nil, self, 'InterfaceOptionsCheckButtonTemplate')
		F.ReskinCheck(cb, flat, true, true)

		cb.Type = 'CheckBox'
		return cb
	end

	local function editBoxClearFocus(self)
		self:ClearFocus()
	end

	function F:CreateEditBox(width, height)
		local eb = CreateFrame('EditBox', nil, self)
		eb:SetSize(width, height)
		eb:SetAutoFocus(false)
		eb:SetTextInsets(5, 5, 5, 5)
		eb:SetFont(C.Assets.Fonts.Regular, 11)
		eb.bg = F.CreateBDFrame(eb, .45, false, .04, .04, .04)
		eb.bg:SetBackdropBorderColor(1, 1, 1, .2)
		eb.bg:SetAllPoints()
		F.CreateSD(eb.bg)

		eb:SetScript('OnEscapePressed', editBoxClearFocus)
		eb:SetScript('OnEnterPressed', editBoxClearFocus)

		eb.Type = 'EditBox'
		return eb
	end

	local function optOnClick(self)
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		local opt = self.__owner.options
		for i = 1, #opt do
			if self == opt[i] then
				opt[i]:SetBackdropColor(C.r, C.g, C.b, .3)
				opt[i].selected = true
			else
				opt[i]:SetBackdropColor(0, 0, 0, .3)
				opt[i].selected = false
			end
		end
		self.__owner.Text:SetText(self.text)
		self:GetParent():Hide()
	end

	local function optOnEnter(self)
		if self.selected then return end
		self:SetBackdropColor(1, 1, 1, .25)
	end

	local function optOnLeave(self)
		if self.selected then return end
		self:SetBackdropColor(.1, .1, .1, .25)
	end

	local function buttonOnShow(self)
		self.__list:Hide()
	end

	local function buttonOnClick(self)
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		F:TogglePanel(self.__list)
	end

	function F:CreateDropDown(width, height, data)
		local dd = CreateFrame('Frame', nil, self, 'BackdropTemplate')
		dd:SetSize(width, height)
		F.CreateBD(dd)
		dd:SetBackdropBorderColor(1, 1, 1, .2)
		dd.Text = F.CreateFS(dd, C.Assets.Fonts.Regular, 11, nil, '', nil, true, 'LEFT', 5, 0)
		dd.Text:SetPoint('RIGHT', -5, 0)
		dd.options = {}

		local bu = CreateFrame('Button', nil, dd)
		bu:SetPoint('RIGHT', -5, 0)
		F.ReskinArrow(bu, 'down')
		bu:SetSize(18, 18)

		local list = CreateFrame('Frame', nil, dd, 'BackdropTemplate')
		list:SetPoint('TOP', dd, 'BOTTOM', 0, -2)
		F.CreateBD(list, 1)
		list:SetBackdropBorderColor(1, 1, 1, .2)
		list:Hide()
		bu.__list = list
		bu:SetScript('OnShow', buttonOnShow)
		bu:SetScript('OnClick', buttonOnClick)
		dd.button = bu

		local opt, index = {}, 0
		for i, j in pairs(data) do
			opt[i] = CreateFrame('Button', nil, list, 'BackdropTemplate')
			opt[i]:SetPoint('TOPLEFT', 4, -4 - (i-1)*(height+2))
			opt[i]:SetSize(width - 8, height)
			F.CreateBD(opt[i])
			local text = F.CreateFS(opt[i], C.Assets.Fonts.Regular, 11, nil, j, nil, true, 'LEFT', 5, 0)
			text:SetPoint('RIGHT', -5, 0)
			opt[i].text = j
			opt[i].__owner = dd
			opt[i]:SetScript('OnClick', optOnClick)
			opt[i]:SetScript('OnEnter', optOnEnter)
			opt[i]:SetScript('OnLeave', optOnLeave)

			dd.options[i] = opt[i]
			index = index + 1
		end
		list:SetSize(width, index*(height+2) + 6)

		dd.Type = 'DropDown'
		return dd
	end

	local function updatePicker()
		local swatch = ColorPickerFrame.__swatch
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local colorStr = format('ff%02x%02x%02x', r * 255, g * 255, b * 255)
		swatch.tex:SetVertexColor(r, g, b)
		swatch.color.r, swatch.color.g, swatch.color.b, swatch.color.colorStr = r, g, b, colorStr
		F.UpdateCustomClassColors()
		F.UNITFRAME:UpdateColors()
	end

	local function cancelPicker()
		local swatch = ColorPickerFrame.__swatch
		local r, g, b = ColorPicker_GetPreviousValues()
		local colorStr = format('ff%02x%02x%02x', r * 255, g * 255, b * 255)
		swatch.tex:SetVertexColor(r, g, b)
		swatch.color.r, swatch.color.g, swatch.color.b, swatch.color.colorStr = r, g, b, colorStr
	end

	local function openColorPicker(self)
		local r, g, b, colorStr = self.color.r, self.color.g, self.color.b, self.color.colorStr
		ColorPickerFrame.__swatch = self
		ColorPickerFrame.func = updatePicker
		ColorPickerFrame.previousValues = {r = r, g = g, b = b, colorStr = colorStr}
		ColorPickerFrame.cancelFunc = cancelPicker
		ColorPickerFrame:SetColorRGB(r, g, b)
		ColorPickerFrame:Show()
	end

	local function GetSwatchTexColor(tex)
		local r, g, b = tex:GetVertexColor()
		r = F:Round(r, 2)
		g = F:Round(g, 2)
		b = F:Round(b, 2)
		return r, g, b
	end

	function F:CreateColorSwatch(name, color)
		color = color or {r=1, g=1, b=1, colorStr=ffffffff}

		local swatch = CreateFrame('Button', nil, self, 'BackdropTemplate')
		swatch:SetSize(20, 12)
		swatch.bg = F.CreateBDFrame(swatch, 1)
		swatch.bg:SetBackdropBorderColor(1, 1, 1, .2)
		swatch.text = F.CreateFS(swatch, C.Assets.Fonts.Regular, 12, nil, name, nil, true, 'LEFT', 24, 0)
		local tex = swatch:CreateTexture()
		tex:SetInside(swatch, 2, 2)
		tex:SetTexture(C.Assets.bd_tex)
		tex:SetVertexColor(color.r, color.g, color.b)
		tex.GetColor = GetSwatchTexColor

		swatch.tex = tex
		swatch.color = color
		swatch:SetScript('OnClick', openColorPicker)

		return swatch
	end

	local function updateSliderEditBox(self)
		local slider = self.__owner
		local minValue, maxValue = slider:GetMinMaxValues()
		local text = tonumber(self:GetText())
		if not text then return end
		text = min(maxValue, text)
		text = max(minValue, text)
		slider:SetValue(text)
		self:SetText(text)
		self:ClearFocus()
	end

	local function resetSliderValue(self)
		local slider = self.__owner
		if slider.__default then
			slider:SetValue(slider.__default)
		end
	end

	function F:CreateSlider(name, minValue, maxValue, step, x, y, width)
		local slider = CreateFrame('Slider', nil, self, 'OptionsSliderTemplate')
		slider:SetPoint('TOPLEFT', x, y)
		slider:SetWidth(width or 140)
		slider:SetMinMaxValues(minValue, maxValue)
		slider:SetValueStep(step)
		slider:SetObeyStepOnDrag(true)
		slider:SetHitRectInsets(0, 0, 0, 0)
		F.ReskinSlider(slider)

		slider.Low:SetText(minValue)
		slider.Low:SetPoint('TOPLEFT', slider, 'BOTTOMLEFT', 10, -2)
		slider.Low:SetFont(C.Assets.Fonts.Regular, 11)
		slider.High:SetText(maxValue)
		slider.High:SetPoint('TOPRIGHT', slider, 'BOTTOMRIGHT', -10, -2)
		slider.High:SetFont(C.Assets.Fonts.Regular, 11)
		slider.Text:ClearAllPoints()
		slider.Text:SetPoint('CENTER', 0, 20)
		slider.Text:SetText(name)
		slider.Text:SetTextColor(1, 1, 1)
		slider.Text:SetFont(C.Assets.Fonts.Regular, 11)
		slider.value = F.CreateEditBox(slider, 50, 20)
		slider.value:SetPoint('TOP', slider, 'BOTTOM', 0, -6)
		slider.value:SetJustifyH('CENTER')
		slider.value:SetFont(C.Assets.Fonts.Regular, 11)
		slider.value.__owner = slider
		slider.value:SetScript('OnEnterPressed', updateSliderEditBox)

		slider.clicker = CreateFrame('Button', nil, slider)
		slider.clicker:SetAllPoints(slider.Text)
		slider.clicker.__owner = slider
		slider.clicker:SetScript('OnDoubleClick', resetSliderValue)

		return slider
	end

	function F:TogglePanel(frame)
		if frame:IsShown() then
			frame:Hide()
		else
			frame:Show()
		end
	end
end


--[[ Add APIs ]]

do
	local function WatchPixelSnap(frame, snap)
		if (frame and not frame:IsForbidden()) and frame.PixelSnapDisabled and snap then
			frame.PixelSnapDisabled = nil
		end
	end

	local function DisablePixelSnap(frame)
		if (frame and not frame:IsForbidden()) and not frame.PixelSnapDisabled then
			if frame.SetSnapToPixelGrid then
				frame:SetSnapToPixelGrid(false)
				frame:SetTexelSnappingBias(0)
			elseif frame.GetStatusBarTexture then
				local texture = frame:GetStatusBarTexture()
				if texture and texture.SetSnapToPixelGrid then
					texture:SetSnapToPixelGrid(false)
					texture:SetTexelSnappingBias(0)
				end
			end

			frame.PixelSnapDisabled = true
		end
	end

	local function Kill(object)
		if object.UnregisterAllEvents then
			object:UnregisterAllEvents()
			object:SetParent(F.HiddenFrame)
		else
			object.Show = object.Hide
		end

		object:Hide()
	end

	local function Size(frame, width, height, ...)
		assert(width)
		frame:SetSize(F:Scale(width), F:Scale(height or width), ...)
	end

	local function Width(frame, width, ...)
		assert(width)
		frame:SetWidth(F:Scale(width), ...)
	end

	local function Height(frame, height, ...)
		assert(height)
		frame:SetHeight(F:Scale(height), ...)
	end

	local function Point(frame, arg1, arg2, arg3, arg4, arg5, ...)
		if arg2 == nil then arg2 = frame:GetParent() end

		if type(arg2) == 'number' then arg2 = F:Scale(arg2) end
		if type(arg3) == 'number' then arg3 = F:Scale(arg3) end
		if type(arg4) == 'number' then arg4 = F:Scale(arg4) end
		if type(arg5) == 'number' then arg5 = F:Scale(arg5) end

		frame:SetPoint(arg1, arg2, arg3, arg4, arg5, ...)
	end

	local function SetInside(frame, anchor, xOffset, yOffset, anchor2)
		xOffset = xOffset or C.Mult
		yOffset = yOffset or C.Mult
		anchor = anchor or frame:GetParent()

		DisablePixelSnap(frame)
		frame:ClearAllPoints()
		frame:Point('TOPLEFT', anchor, 'TOPLEFT', xOffset, -yOffset)
		frame:Point('BOTTOMRIGHT', anchor2 or anchor, 'BOTTOMRIGHT', -xOffset, yOffset)
	end

	local function SetOutside(frame, anchor, xOffset, yOffset, anchor2)
		xOffset = xOffset or C.Mult
		yOffset = yOffset or C.Mult
		anchor = anchor or frame:GetParent()

		DisablePixelSnap(frame)
		frame:ClearAllPoints()
		frame:Point('TOPLEFT', anchor, 'TOPLEFT', -xOffset, yOffset)
		frame:Point('BOTTOMRIGHT', anchor2 or anchor, 'BOTTOMRIGHT', xOffset, -yOffset)
	end

	local function addapi(object)
		local mt = getmetatable(object).__index
		if not object.Kill then mt.Kill = Kill end
		if not object.Size then mt.Size = Size end
		if not object.Width then mt.Width = Width end
		if not object.Height then mt.Height = Height end
		if not object.Point then mt.Point = Point end
		if not object.SetInside then mt.SetInside = SetInside end
		if not object.SetOutside then mt.SetOutside = SetOutside end
		if not object.DisabledPixelSnap then
			if mt.SetTexture then hooksecurefunc(mt, 'SetTexture', DisablePixelSnap) end
			if mt.SetTexCoord then hooksecurefunc(mt, 'SetTexCoord', DisablePixelSnap) end
			if mt.CreateTexture then hooksecurefunc(mt, 'CreateTexture', DisablePixelSnap) end
			if mt.SetVertexColor then hooksecurefunc(mt, 'SetVertexColor', DisablePixelSnap) end
			if mt.SetColorTexture then hooksecurefunc(mt, 'SetColorTexture', DisablePixelSnap) end
			if mt.SetSnapToPixelGrid then hooksecurefunc(mt, 'SetSnapToPixelGrid', WatchPixelSnap) end
			if mt.SetStatusBarTexture then hooksecurefunc(mt, 'SetStatusBarTexture', DisablePixelSnap) end
			mt.DisabledPixelSnap = true
		end
	end

	local handled = {['Frame'] = true}
	local object = CreateFrame('Frame')
	addapi(object)
	addapi(object:CreateTexture())
	addapi(object:CreateMaskTexture())

	object = EnumerateFrames()
	while object do
		if not object:IsForbidden() and not handled[object:GetObjectType()] then
			addapi(object)
			handled[object:GetObjectType()] = true
		end

		object = EnumerateFrames(object)
	end
end


do
	function F.Print(...)
		print(C.AddonName..C.GreyColor..':|r', ...)
	end

	function F.MultiCheck(check, ...)
		for i = 1, select('#', ...) do
			if check == select(i, ...) then
				return true
			end
		end
		return false
	end

	--[[
		分割 CJK 字符串
		@param {string} delimiter 分割符
		@param {string} subject 待分割字符串
		@return {table/string} 分割结果
	]]
	function F.SplitCJKString(delimiter, subject)
		if not subject or subject == '' then
			return {}
		end

		local length = strlen(delimiter)
		local results = {}

		local i = 0
		local j = 0

		while true do
			j = strfind(subject, delimiter, i + length)
			if strlen(subject) == i then
				break
			end

			if j == nil then
				tinsert(results, strsub(subject, i))
				break
			end

			tinsert(results, strsub(subject, i, j - 1))
			i = j + length
		end

		return unpack(results)
	end

	function F.TablePrint(object)
		if type(object) == 'table' then
			local cache = {}
			local function printLoop(subject, indent)
				if (cache[tostring(subject)]) then
					print(indent .. '*' .. tostring(subject))
				else
					cache[tostring(subject)] = true
					if (type(subject) == 'table') then
						for pos, val in pairs(subject) do
							if (type(val) == 'table') then
								print(indent .. '[' .. pos .. '] => ' .. tostring(subject) .. ' {')
								printLoop(val, indent .. strrep(' ', strlen(pos) + 8))
								print(indent .. strrep(' ', strlen(pos) + 6) .. '}')
							elseif (type(val) == 'string') then
								print(indent .. "[' .. pos .. '] => '' .. val .. ''")
							else
								print(indent .. '[' .. pos .. '] => ' .. tostring(val))
							end
						end
					else
						print(indent .. tostring(subject))
					end
				end
			end
			if (type(object) == 'table') then
				print(tostring(object) .. ' {')
				printLoop(object, '  ')
				print('}')
			else
				printLoop(object, '  ')
			end
			print()
		elseif type(object) == 'string' then
			print("(string) '' .. object .. ''")
		else
			print('(' .. type(object) .. ') ' .. tostring(object))
		end
	end

	function F.Debug(...)
		if not C.isDeveloper then return end

		print('Debug: ', ...)
	end
end










