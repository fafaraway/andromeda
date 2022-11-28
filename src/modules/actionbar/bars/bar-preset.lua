local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')
local LAYOUT = F:GetModule('Layout')

local optionValues = {
    [1] = 'Bar1ButtonSize',
    [2] = 'Bar1FontSize',
    [3] = 'Bar1ButtonNum',
    [4] = 'Bar1ButtonPerRow',

    [5] = 'Bar2ButtonSize',
    [6] = 'Bar2FontSize',
    [7] = 'Bar2ButtonNum',
    [8] = 'Bar2ButtonPerRow',

    [9] = 'Bar3ButtonSize',
    [10] = 'Bar3FontSize',
    [11] = 'Bar3ButtonNum',
    [12] = 'Bar3ButtonPerRow',

    [13] = 'Bar4ButtonSize',
    [14] = 'Bar4FontSize',
    [15] = 'Bar4ButtonNum',
    [16] = 'Bar4ButtonPerRow',

    [17] = 'Bar5ButtonSize',
    [18] = 'Bar5FontSize',
    [19] = 'Bar5ButtonNum',
    [20] = 'Bar5ButtonPerRow',

    [21] = 'Bar6ButtonSize',
    [22] = 'Bar6FontSize',
    [23] = 'Bar6ButtonNum',
    [24] = 'Bar6ButtonPerRow',

    [25] = 'Bar7ButtonSize',
    [26] = 'Bar7FontSize',
    [27] = 'Bar7ButtonNum',
    [28] = 'Bar7ButtonPerRow',

    [29] = 'Bar8ButtonSize',
    [30] = 'Bar8FontSize',
    [31] = 'Bar8ButtonNum',
    [32] = 'Bar8ButtonPerRow',

    [33] = 'BarPetButtonSize',
    [34] = 'BarPetFontSize',
    [35] = 'BarPetButtonPerRow',

    [36] = 'BarStanceButtonSize',
    [37] = 'BarStanceFontSize',
    [38] = 'BarStanceButtonPerRow',
}

local moverValues = {
    [1] = 'Bar1',
    [2] = 'Bar2',
    [3] = 'Bar3L',
    [4] = 'Bar3R',
    [5] = 'Bar4',
    [6] = 'Bar5',
    [7] = 'Bar6',
    [8] = 'Bar7',
    [9] = 'Bar8',
    [10] = 'BarPet',
    [11] = 'BarStance',
}

local abbrToAnchor = {
    ['TL'] = 'TOPLEFT',
    ['T'] = 'TOP',
    ['TR'] = 'TOPRIGHT',
    ['L'] = 'LEFT',
    ['R'] = 'RIGHT',
    ['BL'] = 'BOTTOMLEFT',
    ['B'] = 'BOTTOM',
    ['BR'] = 'BOTTOMRIGHT',
}

local anchorToAbbr = {}
for abbr, anchor in pairs(abbrToAnchor) do
    anchorToAbbr[anchor] = abbr
end

function ACTIONBAR:ImportBarLayout(preset)
    if not preset then
        return
    end

    local values = { strsplit(':', preset) }
    if values[1] ~= 'AAB' then
        return
    end -- Andromeda Actionbar

    local numValues = #values
    local maxOptions = #optionValues + 1

    for index = 2, maxOptions do
        local value = values[index]
        value = tonumber(value)
        if not value then -- stop if string incorrect
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Your actionbar layout string is incorrect.'])
            return
        end
        C.DB['Actionbar'][optionValues[index - 1]] = value
    end
    ACTIONBAR:UpdateAllSize()

    for index = maxOptions + 1, numValues do
        local moverIndex = index - maxOptions
        local mover = ACTIONBAR.movers[moverIndex]
        if mover then
            local x, point, y = strmatch(values[index], '(-*%d+)(%a+)(-*%d+)')
            x, y = tonumber(x), tonumber(y)
            point = abbrToAnchor[point]
            if point and x and y then
                mover:ClearAllPoints()
                mover:SetPoint(point, _G.UIParent, point, x, y)
                C.DB['UIAnchor'][moverValues[moverIndex]] = { point, 'UIParent', point, x, y }
            else
                _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Your actionbar layout string is incorrect.'])
                return
            end
        end
    end
end

function ACTIONBAR:ExportBarLayout()
    local styleStr = 'AAB'
    for _, value in ipairs(optionValues) do
        styleStr = styleStr .. ':' .. C.DB['Actionbar'][value]
    end

    for _, mover in ipairs(ACTIONBAR.movers) do
        local x, y, point = LAYOUT:CalculateMoverPoints(mover)
        styleStr = styleStr .. ':' .. x .. anchorToAbbr[point] .. y
    end

    return styleStr
end
