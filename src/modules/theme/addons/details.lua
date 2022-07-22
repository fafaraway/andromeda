local F, C = unpack(select(2, ...))

local function restyFont(obj)
    local font, size = C.Assets.Fonts.Condensed, 11
    obj:SetFont(font, size)
    obj:SetShadowColor(0, 0, 0, 1)
    obj:SetShadowOffset(2, -2)
end

local function refreshRows(instance)
    if not C.IS_DEVELOPER then
        return
    end

    if not instance.barras or not instance.barras[1] then
        return
    end

    for _, row in next, instance.barras do
        restyFont(row.lineText1)
        restyFont(row.lineText2)
        restyFont(row.lineText3)
        restyFont(row.lineText4)
    end
end

F:HookAddOn('Details', function()
    hooksecurefunc(_G._detalhes, 'InstanceRefreshRows', refreshRows)
end)
