local F, C, L = unpack(select(2, ...))

C.ThemeWidgets = {
    frame = {},
    button = {},
    checkbox = {},
    editbox = {},
    slider = {},
    dropdown = {},
    colorswatch = {},
}

-- Utils

do
    --

    function F:MultiCheck(check, ...)
        for i = 1, select('#', ...) do
            if check == select(i, ...) then
                return true
            end
        end

        return false
    end

    --

    do
        local tmp = {}
        local function myPrint(...)
            local prefix = format('[%s]', C.COLORFUL_ADDON_TITLE)
            local n = 0

            n = n + 1
            tmp[n] = prefix

            for i = 1, select('#', ...) do
                n = n + 1
                tmp[n] = tostring(select(i, ...))
            end

            local frame = (_G.SELECTED_CHAT_FRAME or _G.DEFAULT_CHAT_FRAME)
            frame:AddMessage(table.concat(tmp, ' ', 1, n))
        end

        function F:Print(...)
            return myPrint(...)
        end

        function F:Printf(...)
            return myPrint(format(...))
        end
    end

    --

    function F:HookAddOn(addonName, callback)
        self:RegisterEvent('ADDON_LOADED', function(_, name)
            if name == addonName then
                callback()
                return true
            elseif name == C.ADDON_NAME and IsAddOnLoaded(addonName) then
                callback()
                return true
            end
        end)
    end

    --

    function F:RegisterSlashCommand(...)
        local name = C.ADDON_TITLE .. 'Slash' .. random()

        local numArgs = select('#', ...)
        local callback = select(numArgs, ...)
        if type(callback) ~= 'function' or numArgs < 2 then
            error('Syntax: RegisterSlashCommand("/slash1"[, "/slash2"], slashFunction)')
        end

        for index = 1, numArgs - 1 do
            local str = select(index, ...)
            if type(str) ~= 'string' then
                error('Syntax: RegisterSlashCommand("/slash1"[, "/slash2"], slashFunction)')
            end

            _G['SLASH_' .. name .. index] = str
        end

        _G.SlashCmdList[name] = callback
    end

    -- Class Color

    function F:ClassColor(class)
        local color = C.ClassColors[class]
        if not color then
            return 1, 1, 1
        end
        return color.r, color.g, color.b
    end

    function F:UnitColor(unit)
        local r, g, b = 1, 1, 1
        if UnitIsPlayer(unit) then
            local class = select(2, UnitClass(unit))
            if class then
                r, g, b = F:ClassColor(class)
            end
        elseif UnitIsTapDenied(unit) then
            r, g, b = 0.6, 0.6, 0.6
        else
            local reaction = UnitReaction(unit, 'player')
            if reaction then
                local color = _G.FACTION_BAR_COLORS[reaction]
                r, g, b = color.r, color.g, color.b
            end
        end
        return r, g, b
    end

    -- Table

    function F:CopyTable(source, target)
        for key, value in pairs(source) do
            if type(value) == 'table' then
                if not target[key] then
                    target[key] = {}
                end
                for k in pairs(value) do
                    target[key][k] = value[k]
                end
            else
                target[key] = value
            end
        end
    end

    function F:SplitList(list, variable, cleanup)
        if cleanup then
            wipe(list)
        end

        for word in variable:gmatch('%S+') do
            word = tonumber(word) or word -- use number if exists, needs review
            list[word] = true
        end
    end

    -- Atlas info

    function F:GetTextureStrByAtlas(info, sizeX, sizeY)
        local file = info and info.file
        if not file then
            return
        end

        local width, height, txLeft, txRight, txTop, txBottom = info.width, info.height, info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord
        local atlasWidth = width / (txRight - txLeft)
        local atlasHeight = height / (txBottom - txTop)
        local str = '|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t'

        return format(str, file, (sizeX or 0), (sizeY or 0), atlasWidth, atlasHeight, atlasWidth * txLeft, atlasWidth * txRight, atlasHeight * txTop, atlasHeight * txBottom)
    end

    -- GUID to npcID

    function F:GetNpcId(guid)
        local id = tonumber(strmatch((guid or ''), '%-(%d-)%-%x-$'))
        return id
    end

    -- Disable blizz EditMode

    function F:DisableEditMode(object)
        object.HighlightSystem = nop
        object.ClearHighlight = nop
    end

    --

    do
        local t, d = '|T%s%s|t', ''
        function F:TextureString(texture, data)
            return format(t, texture, data or d)
        end
    end

    -- Lock CVar

    do
        local lockedCVars = {}
        function F:LockCVar(name, value)
            SetCVar(name, value)
            lockedCVars[name] = value
        end

        function F:UpdateCVars(var, state)
            local lockedVar = lockedCVars[var]
            if lockedVar ~= nil and state ~= lockedVar then
                SetCVar(var, lockedVar)
                if C.IS_DEVELOPER then
                    F:Print('CVar reset', var, lockedVar)
                end
            end
        end

        F:RegisterEvent('CVAR_UPDATE', F.UpdateCVars)
    end

    -- #FIXME 10.0以后如果SetAlpha的值大于1或者小于0会报错，10.0以前则不会
    -- 等以后有空了再仔细看看为什么有些地方的值会超出限制

    function F.TempFixSetAlpha(n)
        if n > 1 then
            n = 1
        elseif n < 0 then
            n = 0
        end

        return n
    end
end

-- Scan Tooltip

do
    local iLvlDB = {}
    local slotData = { gems = {}, gemsColor = {} }
    local ilvlStr = '^' .. gsub(_G.ITEM_LEVEL, '%%d', '')
    local enchantStr = gsub(_G.ENCHANTED_TOOLTIP_LINE, '%%s', '(.+)')
    function F.GetItemLevel(link, arg1, arg2, fullScan)
        if fullScan then
            local data = C_TooltipInfo.GetInventoryItem(arg1, arg2)
            if not data then
                return
            end

            wipe(slotData.gems)
            wipe(slotData.gemsColor)
            slotData.iLvl = nil
            slotData.enchantText = nil

            local isHoA = C.IS_NEW_PATCH_10_1 and data.id == 158075 or data.args and data.args[2] and data.args[2].intVal == 158075
            local num = 0
            for i = 2, #data.lines do
                local lineData = data.lines[i]
                if C.IS_NEW_PATCH_10_1 then
                    if not slotData.iLvl then
                        local text = lineData.leftText
                        local found = text and strfind(text, ilvlStr)
                        if found then
                            local level = strmatch(text, '(%d+)%)?$')
                            slotData.iLvl = tonumber(level) or 0
                        end
                    elseif isHoA then
                        if lineData.essenceIcon then
                            num = num + 1
                            slotData.gems[num] = lineData.essenceIcon
                            slotData.gemsColor[num] = lineData.leftColor
                        end
                    else
                        if lineData.enchantID then
                            slotData.enchantText = strmatch(lineData.leftText, enchantStr)
                        elseif lineData.gemIcon then
                            num = num + 1
                            slotData.gems[num] = lineData.gemIcon
                        elseif lineData.socketType then
                            num = num + 1
                            slotData.gems[num] = format('Interface\\ItemSocketingFrame\\UI-EmptySocket-%s', lineData.socketType)
                        end
                    end
                else
                    local argVal = lineData and lineData.args
                    if argVal then
                        if not slotData.iLvl then
                            local text = argVal[2] and argVal[2].stringVal
                            local found = text and strfind(text, ilvlStr)
                            if found then
                                local level = strmatch(text, '(%d+)%)?$')
                                slotData.iLvl = tonumber(level) or 0
                            end
                        elseif isHoA then
                            if argVal[6] and argVal[6].field == 'essenceIcon' then
                                num = num + 1
                                slotData.gems[num] = argVal[6].intVal
                                slotData.gemsColor[num] = argVal[3] and argVal[3].colorVal
                            end
                        else
                            local lineInfo = argVal[4] and argVal[4].field
                            if lineInfo == 'enchantID' then
                                local enchant = argVal[2] and argVal[2].stringVal
                                slotData.enchantText = strmatch(enchant, enchantStr)
                            elseif lineInfo == 'gemIcon' then
                                num = num + 1
                                slotData.gems[num] = argVal[4].intVal
                            elseif lineInfo == 'socketType' then
                                num = num + 1
                                slotData.gems[num] = format('Interface\\ItemSocketingFrame\\UI-EmptySocket-%s', argVal[4].stringVal)
                            end
                        end
                    end
                end
            end

            return slotData
        else
            if iLvlDB[link] then
                return iLvlDB[link]
            end

            local data
            if arg1 and type(arg1) == 'string' then
                data = C_TooltipInfo.GetInventoryItem(arg1, arg2)
            elseif arg1 and type(arg1) == 'number' then
                data = C_TooltipInfo.GetBagItem(arg1, arg2)
            else
                data = C_TooltipInfo.GetHyperlink(link, nil, nil, true)
            end

            if not data then
                return
            end

            for i = 2, 5 do
                local lineData = data.lines[i]
                if not lineData then
                    break
                end

                if C.IS_NEW_PATCH_10_1 then
                    local text = lineData.leftText
                    local found = text and strfind(text, ilvlStr)
                    if found then
                        local level = strmatch(text, '(%d+)%)?$')
                        iLvlDB[link] = tonumber(level)
                        break
                    end
                else
                    local argVal = lineData.args
                    if argVal then
                        local text = argVal[2] and argVal[2].stringVal
                        local found = text and strfind(text, ilvlStr)
                        if found then
                            local level = strmatch(text, '(%d+)%)?$')
                            iLvlDB[link] = tonumber(level)
                            break
                        end
                    end
                end
            end

            return iLvlDB[link]
        end
    end

    local pendingNPCs, nameCache, callbacks = {}, {}, {}
    local loadingStr = '...'
    local pendingFrame = CreateFrame('Frame')
    pendingFrame:Hide()
    pendingFrame:SetScript('OnUpdate', function(self, elapsed)
        self.elapsed = (self.elapsed or 0) + elapsed
        if self.elapsed > 1 then
            if next(pendingNPCs) then
                for npcID, count in pairs(pendingNPCs) do
                    if count > 2 then
                        nameCache[npcID] = _G.UNKNOWN
                        if callbacks[npcID] then
                            callbacks[npcID](_G.UNKNOWN)
                        end
                        pendingNPCs[npcID] = nil
                    else
                        local name = F.GetNpcName(npcID, callbacks[npcID])
                        if name and name ~= loadingStr then
                            pendingNPCs[npcID] = nil
                        else
                            pendingNPCs[npcID] = pendingNPCs[npcID] + 1
                        end
                    end
                end
            else
                self:Hide()
            end

            self.elapsed = 0
        end
    end)

    --

    function F.GetNpcName(npcID, callback)
        local name = nameCache[npcID]
        if not name then
            name = loadingStr
            local data = C_TooltipInfo.GetHyperlink(format('unit:Creature-0-0-0-0-%d', npcID))
            local lineData = data and data.lines
            if lineData then
                local argVal = lineData[1] and lineData[1].args
                if argVal then
                    name = argVal[2] and argVal[2].stringVal
                end
            end
            if name == loadingStr then
                if not pendingNPCs[npcID] then
                    pendingNPCs[npcID] = 1
                    pendingFrame:Show()
                end
            else
                nameCache[npcID] = name
            end
        end

        if callback then
            callback(name)
            callbacks[npcID] = callback
        end

        return name
    end

    --

    do
        local unknownStr = {
            [_G.TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN] = true,
            [_G.TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN] = true,
        }
        function F.IsUnknownTransmog(bagID, slotID)
            local data = C_TooltipInfo.GetBagItem(bagID, slotID)
            local lineData = data and data.lines
            if not lineData then
                return
            end

            for i = #lineData, 1, -1 do
                if C.IS_NEW_PATCH_10_1 then
                    local line = lineData[i]

                    if line.price then
                        return false
                    end

                    return line.leftText and unknownStr[line.leftText]
                else
                    local argVal = lineData[i] and lineData[i].args
                    if argVal then
                        if argVal[4] and argVal[4].field == 'price' then
                            return false
                        end

                        local stringVal = argVal[2] and argVal[2].stringVal
                        if unknownStr[stringVal] then
                            return true
                        end
                    end
                end
            end
        end

        function F.IsSoulBound(bagID, slotID)
            local data = C_TooltipInfo.GetBagItem(bagID, slotID)
            if data then
                for i = 1, #data.lines do
                    local lineData = data.lines[i]
                    local argVal = lineData and lineData.args
                    if argVal then
                        local text = argVal[2] and argVal[2].stringVal
                        if text then
                            if text == _G.ITEM_SOULBOUND then
                                return true
                            end
                        end
                    end
                end
            end
        end

        local boaStr = {
            [_G.ITEM_BNETACCOUNTBOUND] = true,
            [_G.ITEM_BIND_TO_BNETACCOUNT] = true,
            [_G.ITEM_ACCOUNTBOUND] = true,
        }
        function F.IsBoA(bagID, slotID)
            local data = C_TooltipInfo.GetBagItem(bagID, slotID)
            if data then
                for i = 1, #data.lines do
                    local lineData = data.lines[i]
                    local argVal = lineData and lineData.args
                    if argVal then
                        local text = argVal[2] and argVal[2].stringVal
                        if text then
                            if boaStr[text] then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Widgets

do
    -- Dropdown menu

    F.EasyMenu = CreateFrame('Frame', C.ADDON_TITLE .. 'EasyMenu', _G.UIParent, 'UIDropDownMenuTemplate')

    -- Toggle panel

    function F:TogglePanel(frame)
        if frame:IsShown() then
            frame:Hide()
        else
            frame:Show()
        end
    end

    -- Font string

    do
        function F:CreateFS(font, size, flag, text, colour, shadow, anchor, x, y)
            local outline = _G.ANDROMEDA_ADB.FontOutline
            local fs = self:CreateFontString(nil, 'OVERLAY')

            if font then
                fs:SetFont(font, size, flag and 'OUTLINE' or '')
            else
                fs:SetFont(C.Assets.Fonts.Regular, 12, outline and 'OUTLINE' or '')
            end

            if text then
                fs:SetText(text)
            end

            local r, g, b
            if colour == 'CLASS' then
                r, g, b = F:HexToRgb(C.MY_CLASS_COLOR)
            elseif colour == 'INFO' then
                r, g, b = F:HexToRgb(C.INFO_COLOR)
            elseif colour == 'YELLOW' then
                r, g, b = F:HexToRgb(C.YELLOW_COLOR)
            elseif colour == 'RED' then
                r, g, b = F:HexToRgb(C.RED_COLOR)
            elseif colour == 'GREEN' then
                r, g, b = F:HexToRgb(C.GREEN_COLOR)
            elseif colour == 'BLUE' then
                r, g, b = F:HexToRgb(C.BLUE_COLOR)
            elseif colour == 'GREY' then
                r, g, b = F:HexToRgb(C.GREY_COLOR)
            else
                r, g, b = 255, 255, 255
            end

            if type(colour) == 'table' then
                fs:SetTextColor(colour[1], colour[2], colour[3])
            else
                fs:SetTextColor(r / 255, g / 255, b / 255)
            end

            if shadow == 'NORMAL' then
                fs:SetShadowColor(0, 0, 0, 1)
                fs:SetShadowOffset(1, -1)
            elseif shadow == 'THICK' then
                fs:SetShadowColor(0, 0, 0, 1)
                fs:SetShadowOffset(2, -2)
            elseif shadow == 'NONE' then
                fs:SetShadowColor(0, 0, 0, 0)
                fs:SetShadowOffset(0, 0)
            end

            if type(anchor) == 'table' then
                fs:SetPoint(unpack(anchor))
            elseif anchor and x and y then
                fs:SetPoint(anchor, x, y)
            else
                fs:SetPoint('CENTER', 1, 0)
            end

            return fs
        end

        function F:SetFS(font, size, flag, text, colour, shadow)
            if not font then
                return
            end

            self:SetFont(font, size, flag and 'OUTLINE' or '')

            if text then
                self:SetText(text)
            end

            local r, g, b
            if colour == 'CLASS' then
                r, g, b = F:HexToRgb(C.MY_CLASS_COLOR)
            elseif colour == 'INFO' then
                r, g, b = F:HexToRgb(C.INFO_COLOR)
            elseif colour == 'YELLOW' then
                r, g, b = F:HexToRgb(C.YELLOW_COLOR)
            elseif colour == 'RED' then
                r, g, b = F:HexToRgb(C.RED_COLOR)
            elseif colour == 'GREEN' then
                r, g, b = F:HexToRgb(C.GREEN_COLOR)
            elseif colour == 'BLUE' then
                r, g, b = F:HexToRgb(C.BLUE_COLOR)
            elseif colour == 'GREY' then
                r, g, b = F:HexToRgb(C.GREY_COLOR)
            else
                r, g, b = 255, 255, 255
            end

            if type(colour) == 'table' then
                self:SetTextColor(colour[1], colour[2], colour[3])
            else
                self:SetTextColor(r / 255, g / 255, b / 255)
            end

            if shadow == 'NORMAL' then
                self:SetShadowColor(0, 0, 0, 1)
                self:SetShadowOffset(1, -1)
            elseif shadow == 'THICK' then
                self:SetShadowColor(0, 0, 0, 1)
                self:SetShadowOffset(2, -2)
            elseif shadow == 'NONE' then
                self:SetShadowColor(0, 0, 0, 0)
                self:SetShadowOffset(0, 0)
            end
        end

        function F:SetFontSize(size)
            local name, _, flag = self:GetFont()
            self:SetFont(name, size, flag)
        end

        function F:SetFontShadow(type)
            if not type then
                return
            end

            if type == 'NONE' then
                self:SetShadowColor(0, 0, 0, 0)
                self:SetShadowOffset(0, 0)
            elseif type == 'NORMAL' then
                self:SetShadowColor(0, 0, 0, 1)
                self:SetShadowOffset(1, -1)
            elseif type == 'THICK' then
                self:SetShadowColor(0, 0, 0, 1)
                self:SetShadowOffset(2, -2)
            end
        end

        function F:CreateColorString(text, color)
            if not text or not type(text) == 'string' then
                return
            end

            if not color or type(color) ~= 'table' then
                return
            end

            local hex = color.r and color.g and color.b and F:RgbToHex(color.r, color.g, color.b) or '|cffffffff'

            return hex .. text .. '|r'
        end

        function F:CreateClassColorString(text, class)
            if not text or not type(text) == 'string' then
                return
            end

            if not class or type(class) ~= 'string' then
                return
            end

            local r, g, b = F:ClassColor(class)
            local hex = r and g and b and F:RgbToHex(r, g, b) or '|cffffffff'

            return hex .. text .. '|r'
        end

        function F.ShortenString(string, i, dots)
            if not string then
                return
            end
            local bytes = string:len()
            if bytes <= i then
                return string
            else
                local len, pos = 0, 1
                while pos <= bytes do
                    len = len + 1
                    local c = string:byte(pos)
                    if c > 0 and c <= 127 then
                        pos = pos + 1
                    elseif c >= 192 and c <= 223 then
                        pos = pos + 2
                    elseif c >= 224 and c <= 239 then
                        pos = pos + 3
                    elseif c >= 240 and c <= 247 then
                        pos = pos + 4
                    end
                    if len == i then
                        break
                    end
                end
                if len == i and pos <= bytes then
                    return string:sub(1, pos - 1) .. (dots and '...' or '')
                else
                    return string
                end
            end
        end

        -- 'Lady Sylvanas Windrunner' to 'L. S. Windrunner'
        function F.AbbrNameString(string)
            if string then
                return gsub(string, '%s?(.[\128-\191]*)%S+%s', '%1. ')
            else
                return string
            end
        end

        function F:StyleAddonName(msg)
            msg = gsub(msg, '%%ADDONNAME%%', C.COLORFUL_ADDON_TITLE)

            return msg
        end
    end

    -- GameTooltip

    do
        function F:HideTooltip()
            _G.GameTooltip:Hide()
        end

        local function tooltipOnEnter(self)
            _G.GameTooltip:SetOwner(self, self.anchor, 0, 4)
            _G.GameTooltip:ClearLines()

            if self.tipHeader then
                _G.GameTooltip:AddLine(self.tipHeader)
            end

            local r, g, b

            if tonumber(self.text) then
                _G.GameTooltip:SetSpellByID(self.text)
            elseif self.text then
                if self.color == 'CLASS' then
                    r, g, b = F:HexToRgb(C.MY_CLASS_COLOR)
                elseif self.color == 'INFO' then
                    r, g, b = F:HexToRgb(C.INFO_COLOR)
                elseif self.color == 'YELLOW' then
                    r, g, b = F:HexToRgb(C.YELLOW_COLOR)
                elseif self.color == 'RED' then
                    r, g, b = F:HexToRgb(C.RED_COLOR)
                elseif self.color == 'GREEN' then
                    r, g, b = F:HexToRgb(C.GREEN_COLOR)
                elseif self.color == 'BLUE' then
                    r, g, b = F:HexToRgb(C.BLUE_COLOR)
                elseif self.color == 'GREY' then
                    r, g, b = F:HexToRgb(C.GREY_COLOR)
                else
                    r, g, b = 255, 255, 255
                end

                if self.blankLine then
                    _G.GameTooltip:AddLine(' ')
                end

                _G.GameTooltip:AddLine(self.text, r / 255, g / 255, b / 255, 1)
            end

            _G.GameTooltip:Show()
        end

        function F:AddTooltip(anchor, text, color, blankLine)
            self.anchor = anchor
            self.text = text
            self.color = color
            self.blankLine = blankLine
            self:HookScript('OnEnter', tooltipOnEnter)
            self:HookScript('OnLeave', F.HideTooltip)
        end
    end

    -- Gradient Frame

    do
        local orientationAbbr = {
            ['V'] = 'Vertical',
            ['H'] = 'Horizontal',
        }

        function F:SetGradient(orientation, r, g, b, a1, a2, width, height)
            orientation = orientationAbbr[orientation]

            if not orientation then
                return
            end

            local tex = self:CreateTexture(nil, 'BACKGROUND')
            tex:SetTexture(C.Assets.Textures.Backdrop)
            tex:SetGradient(orientation, CreateColor(r, g, b, a1), CreateColor(r, g, b, a2))

            if width then
                tex:SetWidth(width)
            end

            if height then
                tex:SetHeight(height)
            end

            return tex
        end
    end

    -- Backdrop

    do
        function F:CreateTex()
            if self.__bgTex then
                return
            end

            local frame = self
            if self:IsObjectType('Texture') then
                frame = self:GetParent()
            end

            local tex = frame:CreateTexture(nil, 'BACKGROUND', nil, 1)
            tex:SetAllPoints(self)
            tex:SetTexture(C.Assets.Textures.BackdropStripes, true, true)
            tex:SetHorizTile(true)
            tex:SetVertTile(true)
            tex:SetBlendMode('ADD')

            self.__bgTex = tex
        end

        function F:CreateSD(a, m, s, override)
            if not override and not _G.ANDROMEDA_ADB.ShadowOutline then
                return
            end

            if self.__shadow then
                return
            end

            local frame = self
            if self:IsObjectType('Texture') then
                frame = self:GetParent()
            end

            local color = _G.ANDROMEDA_ADB.ShadowColor
            local shadowAlpha = _G.ANDROMEDA_ADB.ShadowAlpha

            local shadow = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
            shadow:SetOutside(self, m or 5, m or 5)
            shadow:SetBackdrop({
                edgeFile = C.Assets.Textures.Shadow,
                edgeSize = s or 5,
            })
            shadow:SetBackdropBorderColor(color.r, color.g, color.b, a or shadowAlpha)
            shadow:SetFrameStrata(frame:GetFrameStrata())
            self.__shadow = shadow

            return self.__shadow
        end

        function F:CreateGradient()
            local gradStyle = _G.ANDROMEDA_ADB.GradientStyle
            local normTex = C.Assets.Textures.Backdrop

            local tex = self:CreateTexture(nil, 'BORDER')
            tex:SetAllPoints(self)
            tex:SetTexture(normTex)

            local color = _G.ANDROMEDA_ADB.ButtonBackdropColor
            if gradStyle then
                tex:SetGradient('Vertical', CreateColor(color.r, color.g, color.b, 0.65), CreateColor(0, 0, 0, 0.25))
            else
                tex:SetVertexColor(color.r, color.g, color.b, 0)
            end

            return tex
        end

        function F:UpdateBackdropColor()
            local r, g, b = unpack(_G.ANDROMEDA_ADB.BackdropColor)
            local backdropAlpha = _G.ANDROMEDA_ADB.BackdropAlpha

            for _, frame in pairs(C.Frames) do
                frame:SetBackdropColor(r, g, b, backdropAlpha)
            end
        end

        C.Frames = {}
        function F:CreateBD(alpha)
            local color = _G.ANDROMEDA_ADB.BackdropColor
            local backdropAlpha = _G.ANDROMEDA_ADB.BackdropAlpha

            self:SetBackdrop({
                bgFile = C.Assets.Textures.Backdrop,
                edgeFile = C.Assets.Textures.Backdrop,
                edgeSize = C.MULT,
            })
            self:SetBackdropColor(color.r, color.g, color.b, alpha or backdropAlpha)

            F.SetBorderColor(self)

            if not alpha then
                tinsert(C.Frames, self)
            end
        end

        function F:CreateBDFrame(a, gradient)
            local frame = self
            if self:IsObjectType('Texture') then
                frame = self:GetParent()
            end
            local lvl = frame:GetFrameLevel()

            self.__bg = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
            self.__bg:SetOutside(self)
            self.__bg:SetFrameLevel(lvl == 0 and 0 or lvl - 1)

            F.CreateBD(self.__bg, a)

            if gradient then
                self.__gradient = F.CreateGradient(self.__bg)
            end

            return self.__bg
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

        function F:UpdateBorderColor()
            local color = _G.ANDROMEDA_ADB.BorderColor
            local borderAlpha = _G.ANDROMEDA_ADB.BorderAlpha

            for _, frame in pairs(C.Frames) do
                frame:SetBackdropBorderColor(color.r, color.g, color.b, borderAlpha)
            end
        end

        function F:SetBorderColor(alpha)
            local color = _G.ANDROMEDA_ADB.BorderColor
            local borderAlpha = _G.ANDROMEDA_ADB.BorderAlpha
            self:SetBackdropBorderColor(color.r, color.g, color.b, alpha or borderAlpha)
        end

        function F:UpdateShadowColor()
            local color = _G.ANDROMEDA_ADB.ShadowColor
            local shadowAlpha = _G.ANDROMEDA_ADB.ShadowAlpha

            for _, frame in pairs(C.Frames) do
                if not frame.__shadow then
                    return
                end
                frame.__shadow:SetBackdropBorderColor(color.r, color.g, color.b, shadowAlpha)
            end
        end

        function F:SetShadowColor(alpha)
            if not self.__shadow then
                return
            end

            local color = _G.ANDROMEDA_ADB.ShadowColor
            local shadowAlpha = _G.ANDROMEDA_ADB.ShadowAlpha
            self.__shadow:SetBackdropBorderColor(color.r, color.g, color.b, alpha or shadowAlpha)
        end
    end

    -- Help Tip

    do
        function F.HelpInfoAcknowledge(callbackArg)
            _G.ANDROMEDA_ADB['HelpTips'][callbackArg] = true
        end

        function F:CreateHelpInfo(tooltip)
            local bu = CreateFrame('Button', nil, self)
            bu:SetSize(40, 40)
            bu:SetHighlightTexture(616343)

            bu.Icon = bu:CreateTexture(nil, 'ARTWORK')
            bu.Icon:SetAllPoints()
            bu.Icon:SetTexture(616343)

            if tooltip then
                bu.tipHeader = L['Hint']
                F.AddTooltip(bu, 'ANCHOR_BOTTOMLEFT', tooltip, 'BLUE')
            end

            return bu
        end
    end

    -- Statusbar

    do
        function F:CreateStatusbar(spark, r, g, b)
            self:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
            if r and g and b then
                self:SetStatusBarColor(r, g, b)
            else
                self:SetStatusBarColor(C.r, C.g, C.b)
            end

            local bg = F.SetBD(self)
            self.__shadow = bg.__shadow

            if spark then
                self.Spark = self:CreateTexture(nil, 'OVERLAY')
                self.Spark:SetTexture(C.Assets.Textures.Spark)
                self.Spark:SetBlendMode('ADD')
                self.Spark:SetAlpha(0.8)
                self.Spark:SetPoint('TOPLEFT', self:GetStatusBarTexture(), 'TOPRIGHT', -10, 10)
                self.Spark:SetPoint('BOTTOMRIGHT', self:GetStatusBarTexture(), 'BOTTOMRIGHT', 10, -10)
            end
        end

        function F:CreateAndUpdateBarTicks(bar, ticks, numTicks)
            for i = 1, #ticks do
                ticks[i]:Hide()
            end

            if numTicks and numTicks > 0 then
                local width, height = bar:GetSize()
                local delta = width / numTicks
                for i = 1, numTicks - 1 do
                    if not ticks[i] then
                        ticks[i] = bar:CreateTexture(nil, 'OVERLAY')
                        ticks[i]:SetTexture(C.Assets.Textures.StatusbarFlat)
                        ticks[i]:SetVertexColor(0, 0, 0)
                        ticks[i]:SetWidth(C.MULT)
                        ticks[i]:SetHeight(height)
                    end

                    ticks[i]:ClearAllPoints()
                    ticks[i]:SetPoint('RIGHT', bar, 'LEFT', delta * i, 0)
                    ticks[i]:Show()
                end
            end
        end
    end

    -- Editbox

    do
        local function clearFocus(editbox)
            editbox:ClearFocus()
        end

        function F:CreateEditbox(width, height)
            local outline = _G.ANDROMEDA_ADB.FontOutline
            local font = C.Assets.Fonts.Condensed

            local eb = CreateFrame('EditBox', nil, self)
            eb:SetSize(width, height)
            eb:SetAutoFocus(false)
            eb:SetTextInsets(5, 5, 5, 5)
            eb:SetFont(font, 11, outline and 'OUTLINE' or '')

            eb.bg = F.CreateBDFrame(eb, 0.25, true)
            eb.bg:SetAllPoints()

            F.SetBorderColor(eb.bg)
            F.CreateSD(eb.bg, 0.25)
            F.CreateTex(eb)

            eb:SetScript('OnEscapePressed', clearFocus)
            eb:SetScript('OnEnterPressed', clearFocus)

            eb.Type = 'editbox'

            return eb
        end
    end

    -- Dropdown

    do
        local function optOnClick(option)
            local classColor = _G.ANDROMEDA_ADB.WidgetHighlightClassColor
            local newColor = _G.ANDROMEDA_ADB.WidgetHighlightColor

            PlaySound(_G.SOUNDKIT.GS_TITLE_OPTION_OK)

            local list = option.__owner.options
            for i = 1, #list do
                if option == list[i] then
                    if classColor then
                        list[i]:SetBackdropColor(C.r, C.g, C.b, 0.25)
                    else
                        list[i]:SetBackdropColor(newColor.r, newColor.g, newColor.b, 0.25)
                    end
                    list[i].selected = true
                else
                    list[i]:SetBackdropColor(0.1, 0.1, 0.1, 0.25)
                    list[i].selected = false
                end
            end

            option.__owner.Text:SetText(option.text)
            option:GetParent():Hide()
        end

        local function optOnEnter(option)
            if option.selected then
                return
            end

            option:SetBackdropColor(1, 1, 1, 0.25)
        end

        local function optOnLeave(option)
            if option.selected then
                return
            end

            option:SetBackdropColor(0.1, 0.1, 0.1, 0.25)
        end

        local function ddOnShow(dd)
            dd.__list:Hide()
        end

        local function ddOnClick(dd)
            PlaySound(_G.SOUNDKIT.GS_TITLE_OPTION_OK)
            F:TogglePanel(dd.__list)
        end

        local function ddOnEnter(dd)
            local classColor = _G.ANDROMEDA_ADB.WidgetHighlightClassColor
            local newColor = _G.ANDROMEDA_ADB.WidgetHighlightColor

            if classColor then
                dd.arrow:SetVertexColor(C.r, C.g, C.b)
            else
                dd.arrow:SetVertexColor(newColor.r, newColor.g, newColor.b)
            end
        end

        local function ddOnLeave(dd)
            dd.arrow:SetVertexColor(1, 1, 1)
        end

        function F:CreateDropdown(width, height, data)
            local outline = _G.ANDROMEDA_ADB.FontOutline
            local font = C.Assets.Fonts.Condensed

            local dd = CreateFrame('Frame', nil, self, 'BackdropTemplate')
            dd:SetSize(width, height)
            dd.bg = F.CreateBDFrame(dd, 0.25, true)
            F.SetBorderColor(dd.bg)
            F.CreateSD(dd.bg, 0.25)
            F.CreateTex(dd)

            dd.Text = F.CreateFS(dd, font, 11, outline or nil, '', nil, outline and 'NONE' or 'THICK', 'LEFT', 5, 0)
            dd.Text:SetPoint('RIGHT', -5, 0)
            dd.options = {}

            local bu = CreateFrame('Button', nil, dd)
            bu:SetPoint('RIGHT', -5, 0)
            bu:SetSize(18, 18)
            dd.button = bu

            local tex = bu:CreateTexture(nil, 'ARTWORK')
            tex:SetVertexColor(1, 1, 1)
            tex:SetAllPoints()
            F.SetupArrow(tex, 'down')
            bu.arrow = tex

            local list = CreateFrame('Frame', nil, dd, 'BackdropTemplate')
            list:SetPoint('TOP', dd, 'BOTTOM', 0, -2)
            RaiseFrameLevel(list)
            F.CreateBD(list, 0.75)
            F.CreateTex(list)
            list:Hide()
            bu.__list = list

            bu:SetScript('OnShow', ddOnShow)
            bu:SetScript('OnClick', ddOnClick)

            bu:HookScript('OnEnter', ddOnEnter)
            bu:HookScript('OnLeave', ddOnLeave)

            local opt, index = {}, 0
            for i, j in pairs(data) do
                opt[i] = CreateFrame('Button', nil, list, 'BackdropTemplate')
                opt[i]:SetPoint('TOPLEFT', 4, -4 - (i - 1) * (height + 2))
                opt[i]:SetSize(width - 8, height)
                F.CreateBD(opt[i])

                local text = F.CreateFS(opt[i], font, 11, outline or nil, j, nil, outline and 'NONE' or 'THICK', 'LEFT', 5, 0)
                text:SetPoint('RIGHT', -5, 0)
                opt[i].text = j
                opt[i].index = i
                opt[i].__owner = dd
                opt[i]:SetScript('OnClick', optOnClick)
                opt[i]:SetScript('OnEnter', optOnEnter)
                opt[i]:SetScript('OnLeave', optOnLeave)

                dd.options[i] = opt[i]
                index = index + 1
            end
            list:SetSize(width, index * (height + 2) + 6)

            dd.Type = 'dropdown'

            return dd
        end
    end

    -- Color Swatch

    do
        local function updatePicker()
            local swatch = _G.ColorPickerFrame.__swatch
            local r, g, b = _G.ColorPickerFrame:GetColorRGB()
            r = F:Round(r, 2)
            g = F:Round(g, 2)
            b = F:Round(b, 2)
            swatch.tex:SetVertexColor(r, g, b)
            swatch.color.r, swatch.color.g, swatch.color.b = r, g, b
            F.UpdateCustomClassColors()
        end

        local function cancelPicker()
            local swatch = _G.ColorPickerFrame.__swatch
            local r, g, b = _G.ColorPicker_GetPreviousValues()
            swatch.tex:SetVertexColor(r, g, b)
            swatch.color.r, swatch.color.g, swatch.color.b = r, g, b
        end

        local function pickerOnClick(self)
            local r, g, b = self.color.r, self.color.g, self.color.b
            _G.ColorPickerFrame.__swatch = self
            _G.ColorPickerFrame.func = updatePicker
            _G.ColorPickerFrame.previousValues = { r = r, g = g, b = b }
            _G.ColorPickerFrame.cancelFunc = cancelPicker
            _G.ColorPickerFrame:SetColorRGB(r, g, b)
            _G.ColorPickerFrame:Show()
        end

        local function GetSwatchTexColor(tex)
            local r, g, b = tex:GetVertexColor()
            r = F:Round(r, 2)
            g = F:Round(g, 2)
            b = F:Round(b, 2)
            return r, g, b
        end

        local function pickerOnDoubleClick(swatch)
            local defaultColor = swatch.__default
            if defaultColor then
                _G.ColorPickerFrame:SetColorRGB(defaultColor.r, defaultColor.g, defaultColor.b)
            end
        end

        local whiteColor = { r = 1, g = 1, b = 1 }
        function F:CreateColorSwatch(name, color)
            color = color or whiteColor

            local swatch = CreateFrame('Button', nil, self, 'BackdropTemplate')
            swatch:SetSize(20, 12)
            swatch.bg = F.CreateBDFrame(swatch, 1)
            F.SetBorderColor(swatch.bg)
            F.CreateSD(swatch.bg, 0.25)

            if name then
                local outline = _G.ANDROMEDA_ADB.FontOutline
                swatch.text = F.CreateFS(swatch, C.Assets.Fonts.Regular, 12, outline or nil, name, nil, outline and 'NONE' or 'THICK')
                swatch.text:SetPoint('LEFT', swatch, 'RIGHT', 6, 0)
            end

            local gradStyle = _G.ANDROMEDA_ADB.GradientStyle
            local normTex = C.Assets.Textures.StatusbarFlat
            local gradTex = C.Assets.Textures.StatusbarGradient

            local tex = swatch:CreateTexture()
            tex:SetInside(swatch, C.MULT, C.MULT)
            tex:SetTexture(gradStyle and gradTex or normTex)
            tex:SetVertexColor(color.r, color.g, color.b)
            tex.GetColor = GetSwatchTexColor

            swatch.tex = tex
            swatch.color = color
            swatch:SetScript('OnClick', pickerOnClick)
            swatch:SetScript('OnDoubleClick', pickerOnDoubleClick)

            return swatch
        end
    end

    -- Slider

    do
        local function updateSliderEditBox(self)
            local slider = self.__owner
            local minValue, maxValue = slider:GetMinMaxValues()
            local text = tonumber(self:GetText())
            if not text then
                return
            end
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

            local outline = _G.ANDROMEDA_ADB.FontOutline
            local font = C.Assets.Fonts.Condensed

            F.SetFS(slider.Low, font, 11, outline or nil, minValue, nil, outline and 'NONE' or 'THICK')
            slider.Low:ClearAllPoints()
            slider.Low:SetPoint('TOPLEFT', slider, 'BOTTOMLEFT', 10, -2)

            F.SetFS(slider.High, font, 11, outline or nil, maxValue, nil, outline and 'NONE' or 'THICK')
            slider.High:ClearAllPoints()
            slider.High:SetPoint('TOPRIGHT', slider, 'BOTTOMRIGHT', -10, -2)

            slider.Text = F.CreateFS(slider, font, 11, outline or nil, name, nil, outline and 'NONE' or 'THICK')
            slider.Text:ClearAllPoints()
            slider.Text:SetPoint('CENTER', 0, 16)

            slider.value = F.CreateEditbox(slider, 50, 20)
            slider.value:SetPoint('TOP', slider, 'BOTTOM', 0, -2)
            slider.value:SetJustifyH('CENTER')
            slider.value.__owner = slider
            slider.value:SetScript('OnEnterPressed', updateSliderEditBox)

            slider.clicker = CreateFrame('Button', nil, slider)
            slider.clicker:SetAllPoints(slider.Text)
            slider.clicker.__owner = slider
            slider.clicker:SetScript('OnDoubleClick', resetSliderValue)

            return slider
        end
    end

    -- Button

    function F:CreateButton(width, height, text, fontSize)
        local outline = _G.ANDROMEDA_ADB.FontOutline
        local bu = CreateFrame('Button', nil, self, 'BackdropTemplate')
        bu:SetSize(width, height)
        if type(text) == 'boolean' then
            F.PixelIcon(bu, fontSize, true)
        else
            F.ReskinButton(bu)
            bu.text = F.CreateFS(bu, C.Assets.Fonts.Regular, fontSize or 12, outline or nil, text, nil, outline and 'NONE' or 'THICK')
        end

        return bu
    end

    -- Checkbox

    function F:CreateCheckbox(flat)
        local cb = CreateFrame('CheckButton', nil, self, 'InterfaceOptionsBaseCheckButtonTemplate')
        cb:SetScript('OnClick', nil) -- reset onclick handler
        F.ReskinCheckbox(cb, flat, true)

        cb.Type = 'checkbox'

        return cb
    end

    -- Glow Parent

    function F:CreateGlowFrame(size)
        local frame = CreateFrame('Frame', nil, self)
        frame:SetPoint('CENTER')
        frame:SetSize(size + 8, size + 8)

        return frame
    end
end

-- UI Skins

do
    -- Kill region

    do
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
            self:SetScale(0.0001)
        end

        local blizzTextures = {
            'Inset',
            'inset',
            'InsetFrame',
            'LeftInset',
            'RightInset',
            'NineSlice',
            'BG',
            'Bg',
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
            for _, texture in pairs(blizzTextures) do
                local blizzFrame = self[texture] or (frameName and _G[frameName .. texture])
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
                                region:SetAtlas('')
                            end
                        else
                            region:SetTexture('')
                        end
                    end
                end
            end
        end
    end

    -- Handle icon

    do
        local x1, x2, y1, y2 = unpack(C.TEX_COORD)
        function F:ReskinIcon(shadow)
            self:SetTexCoord(x1, x2, y1, y2)
            local bg = F.CreateBDFrame(self, 0.25) -- exclude from opacity control
            bg:SetBackdropBorderColor(0, 0, 0)
            if shadow then
                F.CreateSD(bg)
            end
            return bg
        end

        function F:PixelIcon(texture, highlight, shadow)
            self.bg = F.CreateBDFrame(self)
            self.bg:SetBackdropBorderColor(0, 0, 0)
            self.bg:SetAllPoints()

            if shadow then
                F.CreateSD(self.bg)
            end

            self.Icon = self:CreateTexture(nil, 'ARTWORK')
            self.Icon:SetInside()
            self.Icon:SetTexCoord(x1, x2, y1, y2)

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
                self.HL:SetColorTexture(1, 1, 1, 0.25)
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

        local atlasToQuality = {
            ['error'] = 99,
            ['uncollected'] = Enum.ItemQuality.Poor,
            ['gray'] = Enum.ItemQuality.Poor,
            ['white'] = Enum.ItemQuality.Common,
            ['green'] = Enum.ItemQuality.Uncommon,
            ['blue'] = Enum.ItemQuality.Rare,
            ['purple'] = Enum.ItemQuality.Epic,
            ['orange'] = Enum.ItemQuality.Legendary,
            ['artifact'] = Enum.ItemQuality.Artifact,
            ['account'] = Enum.ItemQuality.Heirloom,
        }

        local function updateIconBorderColorByAtlas(border, atlas)
            local atlasAbbr = atlas and strmatch(atlas, '%-(%w+)$')
            local quality = atlasAbbr and atlasToQuality[atlasAbbr]
            local color = C.QualityColors[quality or 1]

            border.__owner.bg:SetBackdropBorderColor(color.r, color.g, color.b)
        end

        local greyRGB = C.QualityColors[0].r
        local function updateIconBorderColor(border, r, g, b)
            if not r or r == greyRGB or (r > 0.99 and g > 0.99 and b > 0.99) then
                r, g, b = 0, 0, 0
            end

            border.__owner.bg:SetBackdropBorderColor(r, g, b)
            border:Hide(true) -- fix icon border
        end

        local function resetIconBorderColor(border, texture)
            if not texture then
                border.__owner.bg:SetBackdropBorderColor(0, 0, 0)
            end
        end

        local function iconBorderShown(border, show)
            if not show then
                resetIconBorderColor(border)
            end
        end

        function F:ReskinIconBorder(needInit, useAtlas)
            self:SetAlpha(0)
            self.__owner = self:GetParent()
            if not self.__owner.bg then
                return
            end
            if useAtlas or self.__owner.useCircularIconBorder then -- for auction item display
                hooksecurefunc(self, 'SetAtlas', updateIconBorderColorByAtlas)
                hooksecurefunc(self, 'SetTexture', resetIconBorderColor)
                if needInit then
                    self:SetAtlas(self:GetAtlas()) -- for border with color before hook
                end
            else
                hooksecurefunc(self, 'SetVertexColor', updateIconBorderColor)
                if needInit then
                    self:SetVertexColor(self:GetVertexColor()) -- for border with color before hook
                end
            end
            hooksecurefunc(self, 'Hide', resetIconBorderColor)
            hooksecurefunc(self, 'SetShown', iconBorderShown)
        end
    end

    -- Handle button

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

    do
        local function updateButtonGlow(frame, stop)
            local speed = 0.05
            local mult = 1
            local alpha = 1
            local last = 0

            local classColor = _G.ANDROMEDA_ADB.WidgetHighlightClassColor
            local newColor = _G.ANDROMEDA_ADB.WidgetHighlightColor

            frame:SetScript('OnUpdate', function(self, elapsed)
                if not stop then
                    if classColor then
                        self:SetBackdropBorderColor(C.r, C.g, C.b)
                    else
                        self:SetBackdropBorderColor(newColor.r, newColor.g, newColor.b)
                    end

                    last = last + elapsed
                    if last > speed then
                        last = 0
                        self:SetAlpha(F.TempFixSetAlpha(alpha))
                    end

                    alpha = alpha - elapsed * mult
                    if alpha < 0 and mult > 0 then
                        mult = mult * -1
                        alpha = 0
                    elseif alpha > 1 and mult < 0 then
                        mult = mult * -1
                    end
                else
                    self:SetBackdropBorderColor(0, 0, 0)
                    self:SetAlpha(0.25)
                end
            end)
        end

        local function startGlow(self)
            if not self:IsEnabled() then
                return
            end

            if not self.__shadow then
                return
            end

            updateButtonGlow(self.__shadow)
        end

        local function stopGlow(self)
            if not self.__shadow then
                return
            end

            updateButtonGlow(self.__shadow, true)
        end

        local function buttonOnEnter(self)
            if not self:IsEnabled() then
                return
            end

            local classColor = _G.ANDROMEDA_ADB.WidgetHighlightClassColor
            local newColor = _G.ANDROMEDA_ADB.WidgetHighlightColor

            if classColor then
                self.__bg:SetBackdropColor(C.r, C.g, C.b, 0.25)
                self.__bg:SetBackdropBorderColor(C.r, C.g, C.b)
            else
                self.__bg:SetBackdropColor(newColor.r, newColor.g, newColor.b, 0.25)
                self.__bg:SetBackdropBorderColor(newColor.r, newColor.g, newColor.b)
            end
        end

        local function buttonOnLeave(self)
            self.__bg:SetBackdropColor(0, 0, 0, 0.25)
            F.SetBorderColor(self.__bg)

            -- if gradStyle then
            --     self.__gradient:SetGradientAlpha('Vertical', color.r, color.g, color.b, alpha, 0, 0, 0, 0.25)
            -- else
            --     self.__gradient:SetVertexColor(color.r, color.g, color.b, alpha)
            -- end
        end

        function F:ReskinButton(noGlow, override)
            if self.SetNormalTexture and not override then
                self:SetNormalTexture(0)
            end
            if self.SetHighlightTexture then
                self:SetHighlightTexture(0)
            end
            if self.SetPushedTexture then
                self:SetPushedTexture(0)
            end
            if self.SetDisabledTexture then
                self:SetDisabledTexture(0)
            end

            local buttonName = self.GetName and self:GetName()
            for _, region in pairs(blizzRegions) do
                region = buttonName and _G[buttonName .. region] or self[region]
                if region then
                    region:SetAlpha(0)
                    region:Hide()
                end
            end

            F.CreateTex(self)
            self.__bg = F.CreateBDFrame(self, 0, true)

            local gradStyle = _G.ANDROMEDA_ADB.GradientStyle
            local color = _G.ANDROMEDA_ADB.ButtonBackdropColor
            local alpha = _G.ANDROMEDA_ADB.ButtonBackdropAlpha

            self.__bg:SetBackdropColor(0, 0, 0, 0.25)
            F.SetBorderColor(self.__bg)

            if gradStyle then
                self.__gradient:SetGradient('Vertical', CreateColor(color.r, color.g, color.b, alpha), CreateColor(0, 0, 0, 0.25))
            else
                self.__gradient:SetVertexColor(color.r, color.g, color.b, alpha)
            end

            self:HookScript('OnEnter', buttonOnEnter)
            self:HookScript('OnLeave', buttonOnLeave)

            local buttonAnima = _G.ANDROMEDA_ADB.ButtonHoverAnimation
            if not noGlow and buttonAnima then
                self.__shadow = F.CreateSD(self.__bg, 0.25)

                self:HookScript('OnEnter', startGlow)
                self:HookScript('OnLeave', stopGlow)
            end
        end
    end

    -- Handle tab

    do
        function F:ReskinTab()
            self:DisableDrawLayer('BACKGROUND')

            if self.LeftHighlight then
                self.LeftHighlight:SetAlpha(0)
            end

            if self.RightHighlight then
                self.RightHighlight:SetAlpha(0)
            end

            if self.MiddleHighlight then
                self.MiddleHighlight:SetAlpha(0)
            end

            local bg = F.CreateBDFrame(self)
            bg:SetPoint('TOPLEFT', 8, -3)
            bg:SetPoint('BOTTOMRIGHT', -8, 0)
            F.CreateSD(bg)
            self.bg = bg

            local classColor = _G.ANDROMEDA_ADB.WidgetHighlightClassColor
            local newColor = _G.ANDROMEDA_ADB.WidgetHighlightColor

            self:SetHighlightTexture(C.Assets.Textures.Backdrop)
            local hl = self:GetHighlightTexture()
            hl:ClearAllPoints()
            hl:SetInside(bg)

            if classColor then
                hl:SetVertexColor(C.r, C.g, C.b, 0.25)
            else
                hl:SetVertexColor(newColor.r, newColor.g, newColor.b, 0.25)
            end
        end

        function F:ResetTabAnchor()
            local text = self.Text or (self.GetName and _G[self:GetName() .. 'Text'])
            if text then
                text:SetPoint('CENTER', self)
            end
        end

        hooksecurefunc('PanelTemplates_SelectTab', F.ResetTabAnchor)
        hooksecurefunc('PanelTemplates_DeselectTab', F.ResetTabAnchor)
    end

    -- Handle scrollframe

    do
        local function thumbOnEnter(frame)
            local classColor = _G.ANDROMEDA_ADB.WidgetHighlightClassColor
            local newColor = _G.ANDROMEDA_ADB.WidgetHighlightColor
            local thumb = frame.thumb or frame

            if classColor then
                thumb.bg:SetBackdropColor(C.r, C.g, C.b, 0.45)
            else
                thumb.bg:SetBackdropColor(newColor.r, newColor.g, newColor.b, 0.45)
            end
        end

        local function thumbOnLeave(frame)
            local thumb = frame.thumb or frame
            if thumb.__isActive then
                return
            end

            local color = _G.ANDROMEDA_ADB.ButtonBackdropColor
            local alpha = _G.ANDROMEDA_ADB.ButtonBackdropAlpha
            thumb.bg:SetBackdropColor(color.r, color.g, color.b, alpha)
        end

        local function thumbOnMouseDown(frame)
            local classColor = _G.ANDROMEDA_ADB.WidgetHighlightClassColor
            local newColor = _G.ANDROMEDA_ADB.WidgetHighlightColor
            local thumb = frame.thumb or frame
            thumb.__isActive = true

            if classColor then
                thumb.bg:SetBackdropColor(C.r, C.g, C.b, 0.45)
            else
                thumb.bg:SetBackdropColor(newColor.r, newColor.g, newColor.b, 0.45)
            end
        end

        local function thumbOnMouseUp(frame)
            local thumb = frame.thumb or frame
            thumb.__isActive = nil

            local color = _G.ANDROMEDA_ADB.ButtonBackdropColor
            local alpha = _G.ANDROMEDA_ADB.ButtonBackdropAlpha
            thumb.bg:SetBackdropColor(color.r, color.g, color.b, alpha)
        end

        local function updateScrollArrow(arrow)
            if not arrow.__texture then
                return
            end

            if arrow:IsEnabled() then
                arrow.__texture:SetVertexColor(1, 1, 1)
            else
                arrow.__texture:SetVertexColor(0.5, 0.5, 0.5)
            end
        end

        local function updateTrimScrollArrow(frame, atlas)
            local arrow = frame.__owner
            if not arrow.__texture then
                return
            end

            if atlas == arrow.disabledTexture then
                arrow.__texture:SetVertexColor(0.5, 0.5, 0.5)
            else
                arrow.__texture:SetVertexColor(1, 1, 1)
            end
        end

        local function reskinScrollArrow(frame, direction, minimal)
            if not frame then
                return
            end

            if frame.Texture then
                frame.Texture:SetAlpha(0)
                if frame.Overlay then
                    frame.Overlay:SetAlpha(0)
                end
                if minimal then
                    frame:SetHeight(17)
                end
            else
                F.StripTextures(frame)
            end

            local tex = frame:CreateTexture(nil, 'ARTWORK')
            tex:SetAllPoints()
            F.SetupArrow(tex, direction)
            frame.__texture = tex

            frame:HookScript('OnEnter', F.Texture_OnEnter)
            frame:HookScript('OnLeave', F.Texture_OnLeave)

            if frame.Texture then
                if minimal then
                    return
                end
                frame.Texture.__owner = frame
                hooksecurefunc(frame.Texture, 'SetAtlas', updateTrimScrollArrow)
                updateTrimScrollArrow(frame.Texture, frame.Texture:GetAtlas())
            else
                hooksecurefunc(frame, 'Enable', updateScrollArrow)
                hooksecurefunc(frame, 'Disable', updateScrollArrow)
            end
        end

        function F:ReskinScroll()
            F.StripTextures(self:GetParent())
            F.StripTextures(self)

            local color = _G.ANDROMEDA_ADB.ButtonBackdropColor
            local alpha = _G.ANDROMEDA_ADB.ButtonBackdropAlpha
            local thumb = self:GetThumbTexture()
            if thumb then
                thumb:SetAlpha(0)
                thumb.bg = F.CreateBDFrame(thumb)
                thumb.bg:SetBackdropColor(color.r, color.g, color.b, alpha)
                thumb.bg:SetPoint('TOPLEFT', thumb, 4, -1)
                thumb.bg:SetPoint('BOTTOMRIGHT', thumb, -4, 1)
                self.thumb = thumb

                self:HookScript('OnEnter', thumbOnEnter)
                self:HookScript('OnLeave', thumbOnLeave)
                self:HookScript('OnMouseDown', thumbOnMouseDown)
                self:HookScript('OnMouseUp', thumbOnMouseUp)
            end

            local up, down = self:GetChildren()
            reskinScrollArrow(up, 'up')
            reskinScrollArrow(down, 'down')
        end

        -- WowTrimScrollBar
        function F:ReskinTrimScroll()
            local minimal = self:GetWidth() < 10

            F.StripTextures(self)
            reskinScrollArrow(self.Back, 'up', minimal)
            reskinScrollArrow(self.Forward, 'down', minimal)
            if self.Track then
                self.Track:DisableDrawLayer('ARTWORK')
            end

            local color = _G.ANDROMEDA_ADB.ButtonBackdropColor
            local alpha = _G.ANDROMEDA_ADB.ButtonBackdropAlpha
            local thumb = self:GetThumb()
            if thumb then
                thumb:DisableDrawLayer('ARTWORK')
                thumb:DisableDrawLayer('BACKGROUND')
                thumb.bg = F.CreateBDFrame(thumb)
                thumb.bg:SetBackdropColor(color.r, color.g, color.b, alpha)
                if not minimal then
                    thumb.bg:SetPoint('TOPLEFT', 4, -1)
                    thumb.bg:SetPoint('BOTTOMRIGHT', -4, 1)
                end

                thumb:HookScript('OnEnter', thumbOnEnter)
                thumb:HookScript('OnLeave', thumbOnLeave)
                thumb:HookScript('OnMouseDown', thumbOnMouseDown)
                thumb:HookScript('OnMouseUp', thumbOnMouseUp)
            end
        end
    end

    -- Handle close button

    do
        function F:Texture_OnEnter()
            if self:IsEnabled() then
                if self.__texture then
                    local classColor = _G.ANDROMEDA_ADB.WidgetHighlightClassColor
                    local newColor = _G.ANDROMEDA_ADB.WidgetHighlightColor

                    if classColor then
                        self.__texture:SetVertexColor(C.r, C.g, C.b)
                    else
                        self.__texture:SetVertexColor(newColor.r, newColor.g, newColor.b)
                    end
                end
            end
        end

        function F:Texture_OnLeave()
            if self.__texture then
                self.__texture:SetVertexColor(1, 1, 1)
            end
        end

        local function resetCloseButtonAnchor(button)
            if button.isSetting then
                return
            end

            button.isSetting = true
            button:ClearAllPoints()
            button:SetPoint('TOPRIGHT', button.__owner, 'TOPRIGHT', button.__xOffset, button.__yOffset)

            button.isSetting = nil
        end

        function F:ReskinClose(parent, xOffset, yOffset, override)
            parent = parent or self:GetParent()
            xOffset = xOffset or -6
            yOffset = yOffset or -6

            self:SetSize(16, 16)
            if not override then
                self:ClearAllPoints()
                self:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', xOffset, yOffset)
                self.__owner = parent
                self.__xOffset = xOffset
                self.__yOffset = yOffset

                hooksecurefunc(self, 'SetPoint', resetCloseButtonAnchor)
            end

            F.StripTextures(self)
            if self.Border then
                self.Border:SetAlpha(0)
            end
            local bg = F.CreateBDFrame(self, 0, true)
            bg:SetAllPoints()

            self:SetDisabledTexture(C.Assets.Textures.Backdrop)
            local dis = self:GetDisabledTexture()
            dis:SetVertexColor(0, 0, 0, 0.4)
            dis:SetDrawLayer('OVERLAY')
            dis:SetAllPoints()

            local tex = self:CreateTexture()
            tex:SetTexture(C.Assets.Textures.Close)
            tex:SetVertexColor(1, 1, 1)
            tex:SetAllPoints()

            self.__texture = tex

            self:HookScript('OnEnter', F.Texture_OnEnter)
            self:HookScript('OnLeave', F.Texture_OnLeave)
        end
    end

    -- Handle arrows

    do
        local arrowDegree = {
            ['up'] = 0,
            ['down'] = 180,
            ['left'] = 90,
            ['right'] = -90,
        }

        function F:SetupArrow(direction)
            self:SetTexture(C.Assets.Textures.Arrow)
            self:SetRotation(rad(arrowDegree[direction]))
        end

        function F:ReskinArrow(direction)
            F.StripTextures(self)
            self:SetSize(16, 16)
            -- self:SetDisabledTexture(C.Assets.Textures.Backdrop)

            -- local dis = self:GetDisabledTexture()
            -- dis:SetVertexColor(0, 0, 0, .3)
            -- dis:SetDrawLayer('OVERLAY')
            -- dis:SetAllPoints()

            F.CreateBDFrame(self, 0.25)

            local tex = self:CreateTexture(nil, 'ARTWORK')
            tex:SetVertexColor(1, 1, 1)
            tex:SetAllPoints()
            F.SetupArrow(tex, direction)
            self.__texture = tex

            self:HookScript('OnEnter', F.Texture_OnEnter)
            self:HookScript('OnLeave', F.Texture_OnLeave)
        end

        function F:ReskinFilterReset()
            F.StripTextures(self)
            self:ClearAllPoints()
            self:SetPoint('TOPRIGHT', -5, 10)

            local tex = self:CreateTexture(nil, 'ARTWORK')
            tex:SetInside(nil, 2, 2)
            tex:SetTexture(C.Assets.Textures.Close)
            tex:SetVertexColor(1, 0, 0)
        end

        function F:ReskinFilterButton()
            F.StripTextures(self)
            F.ReskinButton(self)

            if self.Text then
                self.Text:SetPoint('CENTER')
            end

            if self.Icon then
                F.SetupArrow(self.Icon, 'right')
                self.Icon:SetPoint('RIGHT')
                self.Icon:SetSize(14, 14)
            end
            if self.ResetButton then
                F.ReskinFilterReset(self.ResetButton)
            end
        end

        function F:ReskinNavBar()
            if self.navBarStyled then
                return
            end

            local homeButton = self.homeButton
            local overflowButton = self.overflowButton

            self:GetRegions():Hide()
            self:DisableDrawLayer('BORDER')
            self.overlay:Hide()
            homeButton:GetRegions():Hide()
            F.ReskinButton(homeButton)
            F.ReskinButton(overflowButton, true)

            local tex = overflowButton:CreateTexture(nil, 'ARTWORK')
            tex:SetTexture(C.Assets.Textures.Arrow)
            tex:SetSize(8, 8)
            tex:SetPoint('CENTER')
            overflowButton.__texture = tex

            overflowButton:HookScript('OnEnter', F.Texture_OnEnter)
            overflowButton:HookScript('OnLeave', F.Texture_OnLeave)

            self.navBarStyled = true
        end
    end

    -- Handle slider

    do
        function F:ReskinSlider(vertical)
            F.StripTextures(self)

            local bg = F.CreateBDFrame(self, 0.25, true)
            bg:SetPoint('TOPLEFT', 14, -2)
            bg:SetPoint('BOTTOMRIGHT', -15, 3)
            F.SetBorderColor(bg)
            F.CreateSD(bg, 0.25)
            F.CreateTex(bg)

            local thumb = self:GetThumbTexture()
            thumb:SetTexture(C.Assets.Textures.Spark)
            thumb:SetSize(20, 20)
            thumb:SetBlendMode('ADD')

            if vertical then
                thumb:SetRotation(rad(90))
            end

            local gradStyle = _G.ANDROMEDA_ADB.GradientStyle
            local normTex = C.Assets.Textures.StatusbarFlat
            local gradTex = C.Assets.Textures.StatusbarGradient
            local classColor = _G.ANDROMEDA_ADB.WidgetHighlightClassColor
            local newColor = _G.ANDROMEDA_ADB.WidgetHighlightColor

            local bar = CreateFrame('StatusBar', nil, bg)
            bar:SetStatusBarTexture(gradStyle and gradTex or normTex)

            if classColor then
                bar:SetStatusBarColor(C.r, C.g, C.b, 0.85)
            else
                bar:SetStatusBarColor(newColor.r, newColor.g, newColor.b, 0.85)
            end

            if vertical then
                bar:SetPoint('BOTTOMLEFT', bg, C.MULT, C.MULT)
                bar:SetPoint('BOTTOMRIGHT', bg, -C.MULT, C.MULT)
                bar:SetPoint('TOP', thumb, 'CENTER')
                bar:SetOrientation('VERTICAL')
            else
                bar:SetPoint('TOPLEFT', bg, C.MULT, -C.MULT)
                bar:SetPoint('BOTTOMLEFT', bg, C.MULT, C.MULT)
                bar:SetPoint('RIGHT', thumb, 'CENTER')
            end
        end

        local function reskinStepper(stepper, direction)
            F.StripTextures(stepper)
            stepper:SetWidth(19)

            local tex = stepper:CreateTexture(nil, 'ARTWORK')
            tex:SetAllPoints()
            F.SetupArrow(tex, direction)
            stepper.__texture = tex

            stepper:HookScript('OnEnter', F.Texture_OnEnter)
            stepper:HookScript('OnLeave', F.Texture_OnLeave)
        end

        function F:ReskinStepperSlider(minimal)
            F.StripTextures(self)
            reskinStepper(self.Back, 'left')
            reskinStepper(self.Forward, 'right')
            self.Slider:DisableDrawLayer('ARTWORK')

            local thumb = self.Slider.Thumb
            thumb:SetTexture(C.Assets.Textures.Spark)
            thumb:SetBlendMode('ADD')
            thumb:SetSize(20, 30)

            local bg = F.CreateBDFrame(self.Slider, 0, true)
            local offset = minimal and 10 or 13
            bg:SetPoint('TOPLEFT', 10, -offset)
            bg:SetPoint('BOTTOMRIGHT', -10, offset)

            local bar = CreateFrame('StatusBar', nil, bg)
            bar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
            bar:SetStatusBarColor(1, 0.8, 0, 0.5)
            bar:SetPoint('TOPLEFT', bg, C.MULT, -C.MULT)
            bar:SetPoint('BOTTOMLEFT', bg, C.MULT, C.MULT)
            bar:SetPoint('RIGHT', thumb, 'CENTER')
        end
    end

    -- Handle collapse

    do
        local function updateCollapseTexture(texture, collapsed)
            local atlas = collapsed and 'Soulbinds_Collection_CategoryHeader_Expand' or 'Soulbinds_Collection_CategoryHeader_Collapse'
            texture:SetAtlas(atlas, true)
        end

        local function resetCollapseTexture(frame, texture)
            if frame.settingTexture then
                return
            end
            frame.settingTexture = true
            frame:SetNormalTexture(0)

            if texture and texture ~= '' then
                if strfind(texture, 'Plus') or strfind(texture, '[Cc]losed') then
                    frame.__texture:DoCollapse(true)
                elseif strfind(texture, 'Minus') or strfind(texture, '[Oo]pen') then
                    frame.__texture:DoCollapse(false)
                end
                frame.bg:Show()
            else
                frame.bg:Hide()
            end

            frame.settingTexture = nil
        end

        function F:ReskinCollapse(isAtlas)
            self:SetNormalTexture(0)
            self:SetHighlightTexture(0)
            self:SetPushedTexture(0)

            local bg = F.CreateBDFrame(self)
            bg:ClearAllPoints()
            bg:SetSize(13, 13)
            bg:SetPoint('TOPLEFT', self:GetNormalTexture())
            F.CreateSD(bg, 0.25)
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

        local buttonNames = { 'MaximizeButton', 'MinimizeButton' }
        function F:ReskinMinMax()
            for _, name in next, buttonNames do
                local button = self[name]
                if button then
                    button:SetSize(16, 16)
                    button:ClearAllPoints()
                    button:SetPoint('CENTER', -3, 0)
                    button:SetHitRectInsets(1, 1, 1, 1)
                    F.ReskinButton(button)

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
    end

    -- UI templates

    do
        function F:ReskinPortraitFrame()
            F.StripTextures(self)
            local bg = F.SetBD(self)
            bg:SetAllPoints(self)

            local frameName = self.GetName and self:GetName()
            local portrait = self.PortraitTexture or self.portrait or (frameName and _G[frameName .. 'Portrait'])
            if portrait then
                portrait:SetAlpha(0)
            end

            local closeButton = self.CloseButton or (frameName and _G[frameName .. 'CloseButton'])
            if closeButton then
                F.ReskinClose(closeButton)
            end

            return bg
        end

        local replacedRoleTex = {
            ['Adventures-Tank'] = 'Soulbinds_Tree_Conduit_Icon_Protect',
            ['Adventures-Healer'] = 'ui_adv_health',
            ['Adventures-DPS'] = 'ui_adv_atk',
            ['Adventures-DPS-Ranged'] = 'Soulbinds_Tree_Conduit_Icon_Utility',
        }

        local function replaceFollowerRole(roleIcon, atlas)
            local newAtlas = replacedRoleTex[atlas]
            if newAtlas then
                roleIcon:SetAtlas(newAtlas)
            end
        end

        function F:ReskinGarrisonPortrait()
            self.squareBG = F.CreateBDFrame(self.Portrait, 1)

            local level = self.Level or self.LevelText
            if level then
                level:ClearAllPoints()
                level:SetPoint('BOTTOM', self.squareBG)
                if self.LevelCircle then
                    self.LevelCircle:Hide()
                end
                if self.LevelBorder then
                    self.LevelBorder:SetScale(0.0001)
                end
            end

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
            if self.Highlight then
                self.Highlight:Hide()
            end
            if self.PuckBorder then
                self.PuckBorder:SetAlpha(0)
            end
            if self.TroopStackBorder1 then
                self.TroopStackBorder1:SetAlpha(0)
            end
            if self.TroopStackBorder2 then
                self.TroopStackBorder2:SetAlpha(0)
            end

            if self.HealthBar then
                self.HealthBar.Border:Hide()

                local roleIcon = self.HealthBar.RoleIcon
                roleIcon:ClearAllPoints()
                roleIcon:SetPoint('CENTER', self.squareBG, 'TOPRIGHT', -2, -2)
                replaceFollowerRole(roleIcon, roleIcon:GetAtlas())
                hooksecurefunc(roleIcon, 'SetAtlas', replaceFollowerRole)

                local background = self.HealthBar.Background
                background:SetAlpha(0)
                background:ClearAllPoints()
                background:SetPoint('TOPLEFT', self.squareBG, 'BOTTOMLEFT', 0, -2)
                background:SetPoint('TOPRIGHT', self.squareBG, 'BOTTOMRIGHT', -2, -2)
                background:SetHeight(2)
                self.HealthBar.Health:SetTexture(C.Assets.Textures.StatusbarNormal)
            end
        end

        function F:StyleSearchButton()
            F.StripTextures(self)
            local bg = F.CreateBDFrame(self, 0.25)
            bg:SetInside()

            local icon = self.icon or self.Icon
            if icon then
                F.ReskinIcon(icon)
            end

            self:SetHighlightTexture(C.Assets.Textures.Backdrop)
            local hl = self:GetHighlightTexture()
            hl:SetVertexColor(C.r, C.g, C.b, 0.25)
            hl:SetInside(bg)
        end

        function F:AffixesSetup()
            local list = self.AffixesContainer and self.AffixesContainer.Affixes or self.Affixes
            if not list then
                return
            end

            for _, frame in ipairs(list) do
                frame.Border:SetTexture(nil)
                frame.Portrait:SetTexture(nil)
                if not frame.bg then
                    frame.bg = F.ReskinIcon(frame.Portrait)
                end

                if frame.info then
                    frame.Portrait:SetTexture(_G.CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
                elseif frame.affixID then
                    local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
                    frame.Portrait:SetTexture(filedataid)
                end
            end
        end
    end

    -- Role Icons
    function F:GetRoleTex()
        if self == 'TANK' then
            return C.Assets.Textures.RoleTank
        elseif self == 'DPS' or self == 'DAMAGER' then
            return C.Assets.Textures.RoleDamager
        elseif self == 'HEALER' then
            return C.Assets.Textures.RoleHealer
        end
    end

    function F:ReskinSmallRole(role)
        self:SetTexture(F.GetRoleTex(role))
        self:SetTexCoord(0, 1, 0, 1)
        self:SetSize(32, 32)
    end

    function F:ReskinRole()
        if self.background then
            self.background:SetTexture('')
        end

        local cover = self.cover or self.Cover
        if cover then
            cover:SetTexture('')
        end

        local checkButton = self.checkButton or self.CheckButton or self.CheckBox
        if checkButton then
            checkButton:SetFrameLevel(self:GetFrameLevel() + 2)
            checkButton:SetPoint('BOTTOMLEFT', -2, -2)
            checkButton:SetSize(20, 20)
            F.ReskinCheckbox(checkButton, true)
        end
    end

    -- Handle checkbox

    function F:ReskinCheckbox(flat, forceSaturation)
        self:SetNormalTexture(0)
        self:SetPushedTexture(0)

        self.bg = F.CreateBDFrame(self, 0.25, true)
        F.SetBorderColor(self.bg)
        self.bg:SetInside(self)
        self.shadow = F.CreateSD(self.bg, 0.25)

        if self.SetHighlightTexture then
            local highligh = self:CreateTexture(nil, 'HIGHLIGHT')
            highligh:SetColorTexture(1, 1, 1, 0.25)
            -- highligh:SetPoint('TOPLEFT', self, 6, -6)
            -- highligh:SetPoint('BOTTOMRIGHT', self, -6, 6)
            highligh:SetInside(self.bg, 1, 1)
            self:SetHighlightTexture(highligh)
        end

        if flat then
            local gradStyle = _G.ANDROMEDA_ADB.GradientStyle
            local normTex = C.Assets.Textures.StatusbarFlat
            local gradTex = C.Assets.Textures.StatusbarGradient
            local classColor = _G.ANDROMEDA_ADB.WidgetHighlightClassColor
            local newColor = _G.ANDROMEDA_ADB.WidgetHighlightColor

            if self.SetCheckedTexture then
                local checked = self:CreateTexture()
                checked:SetTexture(gradStyle and gradTex or normTex)
                checked:SetInside(self.bg, 1, 1)
                checked:SetDesaturated(true)

                if classColor then
                    checked:SetVertexColor(C.r, C.g, C.b)
                else
                    checked:SetVertexColor(newColor.r, newColor.g, newColor.b)
                end

                self:SetCheckedTexture(checked)
            end

            if self.SetDisabledCheckedTexture then
                local disabled = self:CreateTexture()
                disabled:SetTexture(gradStyle and gradTex or normTex)
                disabled:SetInside(self.bg, 1, 1)
                self:SetDisabledCheckedTexture(disabled)
            end
        else
            self:SetCheckedTexture(C.Assets.Textures.Tick)
            self:SetDisabledCheckedTexture(C.Assets.Textures.Tick)

            if self.SetCheckedTexture then
                -- local checked = self:GetCheckedTexture()
                -- checked:SetVertexColor(C.r, C.g, C.b)
                -- checked:SetInside(self.bg, 1, 1)
                -- checked:SetDesaturated(true)

                local checked = self:GetCheckedTexture()
                checked:SetAtlas('checkmark-minimal')
                checked:SetDesaturated(true)
                checked:SetTexCoord(0, 1, 0, 1)
                checked:SetVertexColor(C.r, C.g, C.b)
            end

            if self.SetDisabledCheckedTexture then
                local disabled = self:GetDisabledCheckedTexture()
                disabled:SetVertexColor(0.3, 0.3, 0.3)
                disabled:SetInside(self.bg, 1, 1)
            end
        end

        self.forceSaturation = forceSaturation
    end

    -- Handle radio

    function F:ReskinRadio()
        self:GetNormalTexture():SetAlpha(0)
        self:GetHighlightTexture():SetAlpha(0)
        self:SetCheckedTexture(C.Assets.Textures.Backdrop)

        local ch = self:GetCheckedTexture()
        ch:SetPoint('TOPLEFT', 4, -4)
        ch:SetPoint('BOTTOMRIGHT', -4, 4)
        ch:SetVertexColor(C.r, C.g, C.b, 0.6)

        local bd = F.CreateBDFrame(self, 0)
        bd:SetPoint('TOPLEFT', 3, -3)
        bd:SetPoint('BOTTOMRIGHT', -3, 3)
        F.CreateGradient(bd)
        self.bd = bd

        self:HookScript('OnEnter', F.Texture_OnEnter)
        self:HookScript('OnLeave', F.Texture_OnLeave)
    end

    -- Handle editbox

    function F:ReskinEditbox(height, width)
        local frameName = self.GetName and self:GetName()
        for _, region in pairs(blizzRegions) do
            region = frameName and _G[frameName .. region] or self[region]
            if region then
                region:SetAlpha(0)
            end
        end

        local bg = F.CreateBDFrame(self)
        bg:SetPoint('TOPLEFT', -2, 0)
        bg:SetPoint('BOTTOMRIGHT')
        F.CreateSD(bg, 0.25)
        self.__bg = bg

        if height then
            self:SetHeight(height)
        end
        if width then
            self:SetWidth(width)
        end
    end
    F.ReskinInput = F.ReskinEditbox -- Deprecated

    -- Handle color swatch

    function F:ReskinColorSwatch()
        local frameName = self.GetName and self:GetName()
        local swatchBg = frameName and _G[frameName .. 'SwatchBg']
        if swatchBg then
            swatchBg:SetColorTexture(0, 0, 0)
            swatchBg:SetInside(nil, 2, 2)
        end

        self:SetNormalTexture(C.Assets.Textures.Backdrop)
        self:GetNormalTexture():SetInside(self, 3, 3)
    end

    -- Handle dropdown

    function F:ReskinDropdown()
        F.StripTextures(self)

        local frameName = self.GetName and self:GetName()
        local down = self.Button or frameName and (_G[frameName .. 'Button'] or _G[frameName .. '_Button'])

        local bg = F.CreateBDFrame(self, 0.45)
        bg:SetPoint('TOPLEFT', 16, -4)
        bg:SetPoint('BOTTOMRIGHT', -18, 8)
        F.CreateSD(bg, 0.25)

        down:ClearAllPoints()
        down:SetPoint('RIGHT', bg, -2, 0)
        F.ReskinArrow(down, 'down')
    end

    -- Handle class icon

    function F:ClassIconTexCoord(class)
        local tcoords = _G.CLASS_ICON_TCOORDS[class]
        self:SetTexCoord(tcoords[1] + 0.022, tcoords[2] - 0.025, tcoords[3] + 0.022, tcoords[4] - 0.025)
    end
end

-- Add APIs

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

    local function SetOutside(frame, anchor, xOffset, yOffset, anchor2)
        xOffset = xOffset or C.MULT
        yOffset = yOffset or C.MULT
        anchor = anchor or frame:GetParent()

        DisablePixelSnap(frame)
        frame:ClearAllPoints()
        frame:SetPoint('TOPLEFT', anchor, 'TOPLEFT', -xOffset, yOffset)
        frame:SetPoint('BOTTOMRIGHT', anchor2 or anchor, 'BOTTOMRIGHT', xOffset, -yOffset)
    end

    local function SetInside(frame, anchor, xOffset, yOffset, anchor2)
        xOffset = xOffset or C.MULT
        yOffset = yOffset or C.MULT
        anchor = anchor or frame:GetParent()

        DisablePixelSnap(frame)
        frame:ClearAllPoints()
        frame:SetPoint('TOPLEFT', anchor, 'TOPLEFT', xOffset, -yOffset)
        frame:SetPoint('BOTTOMRIGHT', anchor2 or anchor, 'BOTTOMRIGHT', -xOffset, yOffset)
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

    local StripTexturesBlizzFrames = {
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
        'ScrollUpBorder',
        'ScrollDownBorder',
    }

    local STRIP_TEX = 'Texture'
    local STRIP_FONT = 'FontString'
    local function StripRegion(which, object, kill, alpha)
        if kill then
            object:Kill()
        elseif which == STRIP_TEX then
            object:SetTexture('')
            object:SetAtlas('')
        elseif which == STRIP_FONT then
            object:SetText('')
        end

        if alpha then
            object:SetAlpha(0)
        end
    end

    local function StripType(which, object, kill, alpha)
        if object:IsObjectType(which) then
            StripRegion(which, object, kill, alpha)
        else
            if which == STRIP_TEX then
                local FrameName = object.GetName and object:GetName()
                for _, Blizzard in pairs(StripTexturesBlizzFrames) do
                    local BlizzFrame = object[Blizzard] or (FrameName and _G[FrameName .. Blizzard])
                    if BlizzFrame and BlizzFrame.StripTextures then
                        BlizzFrame:StripTextures(kill, alpha)
                    end
                end
            end

            if object.GetNumRegions then
                for i = 1, object:GetNumRegions() do
                    local region = select(i, object:GetRegions())
                    if region and region.IsObjectType and region:IsObjectType(which) then
                        StripRegion(which, region, kill, alpha)
                    end
                end
            end
        end
    end

    local function StripTextures(object, kill, alpha)
        StripType(STRIP_TEX, object, kill, alpha)
    end

    local function StripTexts(object, kill, alpha)
        StripType(STRIP_FONT, object, kill, alpha)
    end

    local function GetNamedChild(frame, childName, index)
        local name = frame and frame.GetName and frame:GetName()
        if not name or not childName then
            return nil
        end
        return _G[name .. childName .. (index or '')]
    end

    local function HideBackdrop(frame)
        if frame.NineSlice then
            frame.NineSlice:SetAlpha(0)
        end
        if frame.SetBackdrop then
            frame:SetBackdrop(nil)
        end
    end

    local function AddAPI(object)
        local mt = getmetatable(object).__index
        if not object.Kill then
            mt.Kill = Kill
        end
        if not object.SetInside then
            mt.SetInside = SetInside
        end
        if not object.SetOutside then
            mt.SetOutside = SetOutside
        end

        if not object.HideBackdrop then
            mt.HideBackdrop = HideBackdrop
        end

        if not object.StripTextures then
            mt.StripTextures = StripTextures
        end
        if not object.StripTexts then
            mt.StripTexts = StripTexts
        end

        if not object.GetNamedChild then
            mt.GetNamedChild = GetNamedChild
        end

        if not object.DisabledPixelSnap then
            if mt.SetTexture then
                hooksecurefunc(mt, 'SetTexture', DisablePixelSnap)
            end
            if mt.SetTexCoord then
                hooksecurefunc(mt, 'SetTexCoord', DisablePixelSnap)
            end
            if mt.CreateTexture then
                hooksecurefunc(mt, 'CreateTexture', DisablePixelSnap)
            end
            if mt.SetVertexColor then
                hooksecurefunc(mt, 'SetVertexColor', DisablePixelSnap)
            end
            if mt.SetColorTexture then
                hooksecurefunc(mt, 'SetColorTexture', DisablePixelSnap)
            end
            if mt.SetSnapToPixelGrid then
                hooksecurefunc(mt, 'SetSnapToPixelGrid', WatchPixelSnap)
            end
            if mt.SetStatusBarTexture then
                hooksecurefunc(mt, 'SetStatusBarTexture', DisablePixelSnap)
            end
            mt.DisabledPixelSnap = true
        end
    end

    local handled = { ['Frame'] = true }
    local object = CreateFrame('Frame')
    AddAPI(object)
    AddAPI(object:CreateTexture())
    AddAPI(object:CreateMaskTexture())

    object = _G.EnumerateFrames()
    while object do
        if not object:IsForbidden() and not handled[object:GetObjectType()] then
            AddAPI(object)
            handled[object:GetObjectType()] = true
        end

        object = _G.EnumerateFrames(object)
    end
end
