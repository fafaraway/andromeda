local F, C, L = unpack(select(2, ...))
local COLORS = F.COLORS


local type, pairs, tonumber, wipe, next, select, unpack = type, pairs, tonumber, table.wipe, next, select, unpack
local strmatch, gmatch, strfind, format, gsub, sub = string.match, string.gmatch, string.find, string.format, string.gsub, string.sub
local min, max, floor, rad, modf = math.min, math.max, math.floor, math.rad, math.modf
local assets = C.Assets
local backdropColor = {.03, .03, .03}
local gradientColor = {.02, .02, .02, .5, .08, .08, .08, .5}


--[[ Math ]]

do
	-- Numberize
	function F.Numb(n)
		if FreeADB['number_format'] == 1 then
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
		elseif FreeADB['number_format'] == 2 then
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
		elseif s > FreeDB.cooldown.decimal_countdown then
			return format('|cffffe700%d|r', s), s - floor(s) -- yellow
		else
			if FreeDB.cooldown.decimal then
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
		local color = FreeADB['colors']['class'][class]
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
			fs:SetFont(C.Assets.Fonts.Normal, 12, 'OUTLINE')
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

	function F.SetFS(object, font, size, flag, text, colour, shadow, anchor, x, y)
		if type(font) == 'table' then
			object:SetFont(font[1], font[2], font[3])
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

		if anchor and x and y then
			object:SetPoint(anchor, x, y)
		else
			object:SetPoint('CENTER', 1, 0)
		end
	end

	-- GameTooltip
	function F:HideTooltip()
		GameTooltip:Hide()
	end

	local function Tooltip_OnEnter(self)
		GameTooltip:SetOwner(self, self.anchor)
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
			end
			GameTooltip:AddLine(self.text, r, g, b, 1)
		end
		GameTooltip:Show()
	end

	function F:AddTooltip(anchor, text, color)
		self.anchor = anchor
		self.text = text
		self.color = color
		self:SetScript('OnEnter', Tooltip_OnEnter)
		self:SetScript('OnLeave', F.HideTooltip)
	end

	-- Gradient Frame
	function F:CreateGF(w, h, o, r, g, b, a1, a2)
		self:SetSize(w, h)
		self:SetFrameStrata('BACKGROUND')
		local gf = self:CreateTexture(nil, 'BACKGROUND')
		gf:SetAllPoints()
		gf:SetTexture(assets.norm_tex)
		gf:SetGradientAlpha(o, r, g, b, a1, r, g, b, a2)
	end

	-- Background texture
	function F:CreateTex()
		if self.Tex then return end

		local frame = self
		if self:GetObjectType() == 'Texture' then frame = self:GetParent() end

		self.Tex = frame:CreateTexture(nil, 'BACKGROUND', nil, 1)
		self.Tex:SetAllPoints(self)
		self.Tex:SetTexture(assets.bg_tex, true, true)
		self.Tex:SetHorizTile(true)
		self.Tex:SetVertTile(true)
		self.Tex:SetBlendMode('ADD')
	end

	function F:CreateSD(a, m, s, override)
		if not override and not FreeADB.appearance.shadow_border then return end
		if self.Shadow then return end

		local frame = self
		if self:GetObjectType() == 'Texture' then frame = self:GetParent() end

		if not m then m, s = 4, 4 end

		self.Shadow = CreateFrame('Frame', nil, frame)
		self.Shadow:SetOutside(self, m, m)
		self.Shadow:SetBackdrop({edgeFile = assets.shadow_tex, edgeSize = F:Scale(s)})
		self.Shadow:SetBackdropBorderColor(0, 0, 0, a or .35)
		self.Shadow:SetFrameLevel(1)

		return self.Shadow
	end
end


--[[ UI skins ]]

do
	-- ls, Azil, and Simpy made this to replace Blizzard's SetBackdrop API while the textures can't snap
	local PIXEL_BORDERS = {'TOP', 'BOTTOM', 'LEFT', 'RIGHT'}

	function F:SetBackdrop(frame, a)
		local borders = frame.pixelBorders
		if not borders then return end

		local size = C.Mult

		borders.CENTER:SetPoint('TOPLEFT', frame)
		borders.CENTER:SetPoint('BOTTOMRIGHT', frame)

		borders.TOP:SetHeight(size)
		borders.BOTTOM:SetHeight(size)
		borders.LEFT:SetWidth(size)
		borders.RIGHT:SetWidth(size)

		F:SetBackdropColor(frame, backdropColor[1], backdropColor[2], backdropColor[3], a)
		F:SetBackdropBorderColor(frame, 0, 0, 0)
	end

	function F:SetBackdropColor(frame, r, g, b, a)
		if frame.pixelBorders then
			frame.pixelBorders.CENTER:SetVertexColor(r, g, b, a)
		end
	end

	function F:SetBackdropBorderColor(frame, r, g, b, a)
		if frame.pixelBorders then
			for _, v in pairs(PIXEL_BORDERS) do
				frame.pixelBorders[v]:SetVertexColor(r or 0, g or 0, b or 0, a)
			end
		end
	end

	function F:SetBackdropColor_Hook(r, g, b, a)
		F:SetBackdropColor(self, r, g, b, a)
	end

	function F:SetBackdropBorderColor_Hook(r, g, b, a)
		F:SetBackdropBorderColor(self, r, g, b, a)
	end

	function F:PixelBorders(frame)
		if frame and not frame.pixelBorders then
			local borders = {}
			for _, v in pairs(PIXEL_BORDERS) do
				borders[v] = frame:CreateTexture(nil, 'BORDER', nil, 1)
				borders[v]:SetTexture(assets.bd_tex)
			end

			borders.CENTER = frame:CreateTexture(nil, 'BACKGROUND', nil, -1)
			borders.CENTER:SetTexture(assets.bd_tex)

			borders.TOP:Point('BOTTOMLEFT', borders.CENTER, 'TOPLEFT', C.Mult, -C.Mult)
			borders.TOP:Point('BOTTOMRIGHT', borders.CENTER, 'TOPRIGHT', -C.Mult, -C.Mult)

			borders.BOTTOM:Point('TOPLEFT', borders.CENTER, 'BOTTOMLEFT', C.Mult, C.Mult)
			borders.BOTTOM:Point('TOPRIGHT', borders.CENTER, 'BOTTOMRIGHT', -C.Mult, C.Mult)

			borders.LEFT:Point('TOPRIGHT', borders.TOP, 'TOPLEFT', 0, 0)
			borders.LEFT:Point('BOTTOMRIGHT', borders.BOTTOM, 'BOTTOMLEFT', 0, 0)

			borders.RIGHT:Point('TOPLEFT', borders.TOP, 'TOPRIGHT', 0, 0)
			borders.RIGHT:Point('BOTTOMLEFT', borders.BOTTOM, 'BOTTOMRIGHT', 0, 0)

			hooksecurefunc(frame, 'SetBackdropColor', F.SetBackdropColor_Hook)
			hooksecurefunc(frame, 'SetBackdropBorderColor', F.SetBackdropBorderColor_Hook)

			frame.pixelBorders = borders
		end
	end

	-- Setup backdrop
	C.Frames = {}
	function F:CreateBD(a)
		self:SetBackdrop(nil)
		F:PixelBorders(self)
		F:SetBackdrop(self, a or FreeADB.appearance.backdrop_alpha)

		if not a then tinsert(C.Frames, self) end
	end

	function F:CreateGradient()
		local tex = self:CreateTexture(nil, 'BORDER')
		tex:SetInside()
		tex:SetTexture(assets.bd_tex)
		tex:SetGradientAlpha('Vertical', unpack(gradientColor))

		return tex
	end

	function F:CreateBDFrame(a, shadow)
		local frame = self
		if self:GetObjectType() == 'Texture' then frame = self:GetParent() end
		local lvl = frame:GetFrameLevel()

		local bg = CreateFrame('Frame', nil, frame)
		bg:SetOutside(self)
		bg:SetFrameLevel(lvl == 0 and 0 or lvl - 1)
		F.CreateBD(bg, a)
		if shadow then F.CreateSD(bg) end

		return bg
	end

	function F:SetBD(x, y, x2, y2)
		local bg = F.CreateBDFrame(self, nil, true)
		if x then
			bg:SetPoint('TOPLEFT', self, x, y)
			bg:SetPoint('BOTTOMRIGHT', self, x2, y2)
		end
		F.CreateTex(bg)

		return bg
	end

	-- Handle icons
	function F:ReskinIcon(shadow)
		self:SetTexCoord(unpack(C.TexCoord))
		return F.CreateBDFrame(self, nil, shadow)
	end

	function F:PixelIcon(texture, highlight)
		F.CreateBD(self)
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
		if r == .65882 then r, g, b = 0, 0, 0 end
		self.__owner.bg:SetBackdropBorderColor(r, g, b)
	end

	local function resetIconBorderColor(self)
		self.__owner.bg:SetBackdropBorderColor(0, 0, 0)
	end

	function F:HookIconBorderColor()
		self:SetAlpha(0)
		self.__owner = self:GetParent()
		if not self.__owner.bg then return end
		if self.__owner.useCircularIconBorder then
			hooksecurefunc(self, 'SetAtlas', updateIconBorderColorByAtlas)
		else
			hooksecurefunc(self, 'SetVertexColor', updateIconBorderColor)
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
		self.Shadow = bg.Shadow

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

		self:SetBackdropBorderColor(C.r, C.g, C.b, 1)
		self.glow:SetAlpha(1)

		CreatePulse(self.glow)
	end

	local function Button_OnLeave(self)
		self:SetBackdropBorderColor(0, 0, 0, 1)
		self.glow:SetScript('OnUpdate', nil)
		self.glow:SetAlpha(0)
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
	}

	function F:Reskin(noGlow)
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

		F.CreateBD(self, 0)

		self.bgTex = F.CreateGradient(self)

		if not noGlow then
			self.glow = CreateFrame('Frame', nil, self)
			self.glow:SetBackdrop({
				edgeFile = assets.shadow_tex,
				edgeSize = 6,
			})
			self.glow:SetPoint('TOPLEFT', -6, 6)
			self.glow:SetPoint('BOTTOMRIGHT', 6, -6)
			self.glow:SetBackdropBorderColor(C.r, C.g, C.b)
			self.glow:SetAlpha(0)

			self:HookScript('OnEnter', Button_OnEnter)
			self:HookScript('OnLeave', Button_OnLeave)
		end
	end

	local function Menu_OnEnter(self)
		self.bg:SetBackdropBorderColor(C.r, C.g, C.b)
	end

	local function Menu_OnLeave(self)
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end

	local function Menu_OnMouseUp(self)
		self.bg:SetBackdropColor(0, 0, 0, FreeADB.appearance.backdrop_alpha)
	end

	local function Menu_OnMouseDown(self)
		self.bg:SetBackdropColor(C.r, C.g, C.b, .25)
	end

	function F:ReskinMenuButton()
		F.StripTextures(self)
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

			local bg = F.CreateBDFrame(self, 0)
			bg:SetPoint('TOPLEFT', thumb, 0, -2)
			bg:SetPoint('BOTTOMRIGHT', thumb, 0, 4)
			F.CreateGradient(bg)
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

		local bg = F.CreateBDFrame(self, 0)
		bg:SetPoint('TOPLEFT', 16, -4)
		bg:SetPoint('BOTTOMRIGHT', -18, 8)
		F.CreateGradient(bg)

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
				self.bgTex:SetVertexColor(C.r, C.g, C.b)
			end
		end
	end

	function F:Texture_OnLeave()
		if self.bg then
			self.bg:SetBackdropColor(0, 0, 0, .25)
		else
			self.bgTex:SetVertexColor(1, 1, 1)
		end
	end

	function F:ReskinClose(a1, p, a2, x, y)
		self:SetSize(16, 16)

		if not a1 then
			self:SetPoint('TOPRIGHT', -6, -6)
		else
			self:ClearAllPoints()
			self:SetPoint(a1, p, a2, x, y)
		end

		F.StripTextures(self)
		F.CreateBD(self, 0)
		F.CreateGradient(self)

		self:SetDisabledTexture(assets.bd_tex)
		local dis = self:GetDisabledTexture()
		dis:SetVertexColor(0, 0, 0, .4)
		dis:SetDrawLayer('OVERLAY')
		dis:SetAllPoints()

		local tex = self:CreateTexture()
		tex:SetTexture(assets.close_tex)
		tex:SetVertexColor(1, 1, 1)
		tex:SetAllPoints()
		self.bgTex = tex

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

		local bg = F.CreateBDFrame(self, 0)
		bg:SetPoint('TOPLEFT', -2, 0)
		bg:SetPoint('BOTTOMRIGHT')
		F.CreateGradient(bg)
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
		self.bgTex = tex

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
		overflowButton.bgTex = tex

		overflowButton:HookScript('OnEnter', F.Texture_OnEnter)
		overflowButton:HookScript('OnLeave', F.Texture_OnLeave)

		self.navBarStyled = true
	end

	-- Handle checkbox and radio
	function F:ReskinCheck(flat, forceSaturation)
		self:SetNormalTexture('')
		self:SetPushedTexture('')
		self:SetHighlightTexture(assets.flat_tex)

		if flat then
			self:SetCheckedTexture(assets.flat_tex)
			self:SetDisabledCheckedTexture(assets.flat_tex)
		else
			self:SetCheckedTexture(assets.tick_tex)
			self:SetDisabledCheckedTexture(assets.tick_tex)
		end

		local hl = self:GetHighlightTexture()
		hl:SetPoint('TOPLEFT', 5, -5)
		hl:SetPoint('BOTTOMRIGHT', -5, 5)
		hl:SetVertexColor(C.r, C.g, C.b, .25)

		local bd = F.CreateBDFrame(self, 0)
		bd:SetPoint('TOPLEFT', 4, -4)
		bd:SetPoint('BOTTOMRIGHT', -4, 4)
		F.CreateGradient(bd)

		if flat then
			local ch = self:GetCheckedTexture()
			ch:SetPoint('TOPLEFT', 5, -5)
			ch:SetPoint('BOTTOMRIGHT', -5, 5)
			ch:SetDesaturated(true)
			ch:SetVertexColor(C.r, C.g, C.b)

			local dis = self:GetDisabledCheckedTexture()
			dis:SetPoint('TOPLEFT', 5, -5)
			dis:SetPoint('BOTTOMRIGHT', -5, 5)
			dis:SetVertexColor(.3, .3, .3)
		else
			local ch = self:GetCheckedTexture()
			ch:SetTexture(assets.tick_tex)
			ch:SetDesaturated(true)
			ch:SetVertexColor(C.r, C.g, C.b)
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

		self:SetNormalTexture(assets.bd_tex)
		local nt = self:GetNormalTexture()
		nt:SetPoint('TOPLEFT', 3, -3)
		nt:SetPoint('BOTTOMRIGHT', -3, 3)

		local bg = _G[frameName..'SwatchBg']
		bg:SetColorTexture(0, 0, 0)
		bg:SetPoint('TOPLEFT', 2, -2)
		bg:SetPoint('BOTTOMRIGHT', -2, 2)
	end

	-- Handle slider
	function F:ReskinSlider(verticle)
		self:SetBackdrop(nil)
		F.StripTextures(self)

		local bd = F.CreateBDFrame(self, .5)
		bd:SetPoint('TOPLEFT', 14, -2)
		bd:SetPoint('BOTTOMRIGHT', -15, 3)
		bd:SetFrameStrata('BACKGROUND')
		F.CreateGradient(bd)

		local thumb = self:GetThumbTexture()
		thumb:SetHeight(self:GetHeight() + 12)
		thumb:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
		thumb:SetVertexColor(1, 1, 1, .5)
		thumb:SetBlendMode('ADD')
		if verticle then thumb:SetRotation(math.rad(90)) end
	end

	-- Handle collapse
	local function UpdateExpandOrCollapse(self, texture)
		if self.settingTexture then return end
		self.settingTexture = true
		self:SetNormalTexture('')

		if texture and texture ~= '' then
			if strfind(texture, 'Plus') then
				self.expTex:SetTexCoord(0, .4375, 0, .4375)
			elseif strfind(texture, 'Minus') then
				self.expTex:SetTexCoord(.5625, 1, 0, .4375)
			end
			self.bg:Show()
		else
			self.bg:Hide()
		end
		self.settingTexture = nil
	end

	function F:ReskinExpandOrCollapse()
		self:SetHighlightTexture('')
		self:SetPushedTexture('')

		local bg = F.CreateBDFrame(self, .25)
		bg:ClearAllPoints()
		bg:SetSize(13, 13)
		bg:SetPoint('TOPLEFT', self:GetNormalTexture())
		F.CreateGradient(bg)
		self.bg = bg

		self.expTex = bg:CreateTexture(nil, 'OVERLAY')
		self.expTex:SetSize(7, 7)
		self.expTex:SetPoint('CENTER')
		self.expTex:SetTexture('Interface\\Buttons\\UI-PlusMinus-Buttons')

		self:HookScript('OnEnter', F.Texture_OnEnter)
		self:HookScript('OnLeave', F.Texture_OnLeave)
		hooksecurefunc(self, 'SetNormalTexture', UpdateExpandOrCollapse)
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
				tex:SetSize(16, 16)
				tex:SetPoint('CENTER')
				button.bgTex = tex

				if name == 'MaximizeButton' then
					F.SetupArrow(tex, 'up')
				else
					F.SetupArrow(tex, 'down')
				end

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
		local portrait = self.portrait or _G[frameName..'Portrait']
		if portrait then portrait:SetAlpha(0) end
		local closeButton = self.CloseButton or _G[frameName..'CloseButton']
		if closeButton then F.ReskinClose(closeButton) end
		return bg
	end

	function F:ReskinGarrisonPortrait()
		self.Portrait:ClearAllPoints()
		self.Portrait:SetPoint('TOPLEFT', 4, -4)
		self.PortraitRing:Hide()
		self.PortraitRingQuality:SetTexture('')
		if self.Highlight then self.Highlight:Hide() end

		self.LevelBorder:SetScale(.0001)
		self.Level:ClearAllPoints()
		self.Level:SetPoint('BOTTOM', self, 0, 12)

		self.squareBG = F.CreateBDFrame(self.Portrait, 1)

		if self.PortraitRingCover then
			self.PortraitRingCover:SetColorTexture(0, 0, 0)
			self.PortraitRingCover:SetAllPoints(self.squareBG)
		end

		if self.Empty then
			self.Empty:SetColorTexture(0, 0, 0)
			self.Empty:SetAllPoints(self.Portrait)
		end
	end

	function F:StyleSearchButton()
		F.StripTextures(self)
		if self.icon then
			F.ReskinIcon(self.icon)
		end
		F.CreateBD(self, .25)

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


--[[ Animation ]]

do
	local FADEFRAMES, FADEMANAGER = {}, CreateFrame('FRAME')
	FADEMANAGER.delay = 0.025

	function F:UIFrameFade_OnUpdate(elapsed)
		FADEMANAGER.timer = (FADEMANAGER.timer or 0) + elapsed

		if FADEMANAGER.timer > FADEMANAGER.delay then
			FADEMANAGER.timer = 0

			for frame, info in next, FADEFRAMES do
				-- Reset the timer if there isn't one, this is just an internal counter
				if frame:IsVisible() then
					info.fadeTimer = (info.fadeTimer or 0) + (elapsed + FADEMANAGER.delay)
				else
					info.fadeTimer = info.timeToFade + 1
				end

				-- If the fadeTimer is less then the desired fade time then set the alpha otherwise hold the fade state, call the finished function, or just finish the fade
				if info.fadeTimer < info.timeToFade then
					if info.mode == 'IN' then
						frame:SetAlpha((info.fadeTimer / info.timeToFade) * info.diffAlpha + info.startAlpha)
					else
						frame:SetAlpha(((info.timeToFade - info.fadeTimer) / info.timeToFade) * info.diffAlpha + info.endAlpha)
					end
				else
					frame:SetAlpha(info.endAlpha)

					-- If there is a fadeHoldTime then wait until its passed to continue on
					if info.fadeHoldTime and info.fadeHoldTime > 0  then
						info.fadeHoldTime = info.fadeHoldTime - elapsed
					else
						-- Complete the fade and call the finished function if there is one
						F:UIFrameFadeRemoveFrame(frame)

						if info.finishedFunc then
							if info.finishedArgs then
								info.finishedFunc(unpack(info.finishedArgs))
							else -- optional method
								info.finishedFunc(info.finishedArg1, info.finishedArg2, info.finishedArg3, info.finishedArg4, info.finishedArg5)
							end

							if not info.finishedFuncKeep then
								info.finishedFunc = nil
							end
						end
					end
				end
			end

			if not next(FADEFRAMES) then
				FADEMANAGER:SetScript('OnUpdate', nil)
			end
		end
	end

	function F:UIFrameFade(frame, info)
		if not frame or frame:IsForbidden() then return end

		frame.fadeInfo = info

		if not info.mode then
			info.mode = 'IN'
		end

		if info.mode == 'IN' then
			if not info.startAlpha then info.startAlpha = 0 end
			if not info.endAlpha then info.endAlpha = 1 end
			if not info.diffAlpha then info.diffAlpha = info.endAlpha - info.startAlpha end
		else
			if not info.startAlpha then info.startAlpha = 1 end
			if not info.endAlpha then info.endAlpha = 0 end
			if not info.diffAlpha then info.diffAlpha = info.startAlpha - info.endAlpha end
		end

		frame:SetAlpha(info.startAlpha)

		if not frame:IsProtected() then
			frame:Show()
		end

		if not FADEFRAMES[frame] then
			FADEFRAMES[frame] = info -- read below comment
			FADEMANAGER:SetScript('OnUpdate', F.UIFrameFade_OnUpdate)
		else
			FADEFRAMES[frame] = info -- keep these both, we need this updated in the event its changed to another ref from a plugin or sth, don't move it up!
		end
	end

	function F:UIFrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
		if not frame or frame:IsForbidden() then return end

		if frame.FadeObject then
			frame.FadeObject.fadeTimer = nil
		else
			frame.FadeObject = {}
		end

		frame.FadeObject.mode = 'IN'
		frame.FadeObject.timeToFade = timeToFade
		frame.FadeObject.startAlpha = startAlpha
		frame.FadeObject.endAlpha = endAlpha
		frame.FadeObject.diffAlpha = endAlpha - startAlpha

		F:UIFrameFade(frame, frame.FadeObject)
	end

	function F:UIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
		if not frame or frame:IsForbidden() then return end

		if frame.FadeObject then
			frame.FadeObject.fadeTimer = nil
		else
			frame.FadeObject = {}
		end

		frame.FadeObject.mode = 'OUT'
		frame.FadeObject.timeToFade = timeToFade
		frame.FadeObject.startAlpha = startAlpha
		frame.FadeObject.endAlpha = endAlpha
		frame.FadeObject.diffAlpha = startAlpha - endAlpha

		F:UIFrameFade(frame, frame.FadeObject)
	end

	function F:UIFrameFadeRemoveFrame(frame)
		if frame and FADEFRAMES[frame] then
			if frame.FadeObject then
				frame.FadeObject.fadeTimer = nil
			end

			FADEFRAMES[frame] = nil
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
		local bu = CreateFrame('Button', nil, self)
		bu:SetSize(width, height)
		if type(text) == 'boolean' then
			F.PixelIcon(bu, fontSize, true)
		else
			F.Reskin(bu)
			bu.text = F.CreateFS(bu, C.Assets.Fonts.Normal, fontSize or 12, nil, text, nil, true)
		end

		return bu
	end

	function F:CreateCheckBox()
		local cb = CreateFrame('CheckButton', nil, self, 'InterfaceOptionsCheckButtonTemplate')
		F.ReskinCheck(cb, true)

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
		eb:SetFont(C.Assets.Fonts.Normal, 11)
		F.CreateBD(eb, .3)
		F.CreateGradient(eb)
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
				opt[i]:SetBackdropColor(1, .8, 0, .3)
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
		self:SetBackdropColor(0, 0, 0)
	end

	local function buttonOnShow(self)
		self.__list:Hide()
	end

	local function buttonOnClick(self)
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		F:TogglePanel(self.__list)
	end

	function F:CreateDropDown(width, height, data)
		local dd = CreateFrame('Frame', nil, self)
		dd:SetSize(width, height)
		F.CreateBD(dd)
		dd:SetBackdropBorderColor(1, 1, 1, .2)
		dd.Text = F.CreateFS(dd, C.Assets.Fonts.Normal, 11, nil, '', nil, true, 'LEFT', 5, 0)
		dd.Text:SetPoint('RIGHT', -5, 0)
		dd.options = {}

		local bu = CreateFrame('Button', nil, dd)
		bu:SetPoint('RIGHT', -5, 0)
		F.ReskinArrow(bu, 'down')
		bu:SetSize(18, 18)

		local list = CreateFrame('Frame', nil, dd)
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
			opt[i] = CreateFrame('Button', nil, list)
			opt[i]:SetPoint('TOPLEFT', 4, -4 - (i-1)*(height+2))
			opt[i]:SetSize(width - 8, height)
			F.CreateBD(opt[i])
			local text = F.CreateFS(opt[i], C.Assets.Fonts.Normal, 11, nil, j, nil, true, 'LEFT', 5, 0)
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

		COLORS.UpdateColors()
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

	function F:CreateColorSwatch(name, color)
		color = color or {r=1, g=1, b=1, colorStr=ffffffff}

		local swatch = CreateFrame('Button', nil, self)
		swatch:SetSize(20, 12)
		F.CreateBD(swatch, 1)
		swatch.text = F.CreateFS(swatch, C.Assets.Fonts.Normal, 11, nil, name, nil, true, 'LEFT', 24, 0)
		local tex = swatch:CreateTexture()
		tex:SetInside()
		tex:SetTexture(C.Assets.bd_tex)
		tex:SetVertexColor(color.r, color.g, color.b)

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

	function F:CreateSlider(name, minValue, maxValue, step, width)
		local slider = CreateFrame('Slider', nil, self, 'OptionsSliderTemplate')
		--slider:SetPoint('TOPLEFT', x, y)
		slider:SetWidth(width or 200)
		slider:SetMinMaxValues(minValue, maxValue)
		slider:SetValueStep(step)
		slider:SetObeyStepOnDrag(true)
		slider:SetHitRectInsets(0, 0, 0, 0)
		F.ReskinSlider(slider)

		slider.Low:SetText(minValue)
		slider.Low:SetPoint('TOPLEFT', slider, 'BOTTOMLEFT', 10, -2)
		slider.Low:SetFont(C.Assets.Fonts.Number, 11)
		slider.High:SetText(maxValue)
		slider.High:SetPoint('TOPRIGHT', slider, 'BOTTOMRIGHT', -10, -2)
		slider.High:SetFont(C.Assets.Fonts.Number, 11)
		slider.Text:ClearAllPoints()
		slider.Text:SetPoint('BOTTOM', slider, 'TOP', 0, 4)
		slider.Text:SetText(name)
		slider.Text:SetTextColor(1, 1, 1)
		slider.Text:SetFont(C.Assets.Fonts.Number, 11)
		slider.value = F.CreateEditBox(slider, 50, 20)
		slider.value:SetPoint('TOP', slider, 'BOTTOM', 0, -6)
		slider.value:SetJustifyH('CENTER')
		slider.value:SetFont(C.Assets.Fonts.Number, 11)
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
		print(C.Title..C.GreyColor..':|r', ...)
	end


	function F.MultiCheck(check, ...)
		for i = 1, select('#', ...) do
			if check == select(i, ...) then
				return true
			end
		end
		return false
	end
end










