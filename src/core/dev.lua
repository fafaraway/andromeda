local F, C = unpack(select(2, ...))

C.DevsList = {
    ['Farfaraway-白银之手'] = true,
    ['Fionorolah-白银之手'] = true,
    ['Orchestra-白银之手'] = true,
    ['Rhonesaia-白银之手'] = true,
    ['歸雁入胡天-白银之手'] = true,
    ['單方只一味-白银之手'] = true,
    ['池魚故淵-白银之手'] = true,
    ['盡在不言中-白银之手'] = true,
    ['終是意難平-白银之手'] = true,
    ['神而明之-白银之手'] = true,
    ['雨色入青山-白银之手'] = true,
    ['Dontbeshy-死亡之翼'] = true,
    ['熒惑-死亡之翼'] = true,
    ['Kangrinboqe-霜之哀伤'] = true,
    ['哞夫人-霜之哀伤'] = true,
    ['烽火夜長歌-霜之哀伤'] = true,
    ['瑪格漢之光-霜之哀伤'] = true,
}

do
    if C.IS_DEVELOPER then
        C.DevsList[C.MY_FULL_NAME] = true
    end
end

function F:Debug(object)
    if type(object) == 'table' then
        local cache = {}
        local function printLoop(subject, indent)
            if cache[tostring(subject)] then
                print(indent .. '*' .. tostring(subject))
            else
                cache[tostring(subject)] = true
                if type(subject) == 'table' then
                    for pos, val in pairs(subject) do
                        if type(val) == 'table' then
                            print(indent .. '[' .. pos .. '] => ' .. tostring(subject) .. ' {')
                            printLoop(val, indent .. strrep(' ', strlen(pos) + 8))
                            print(indent .. strrep(' ', strlen(pos) + 6) .. '}')
                        elseif type(val) == 'string' then
                            print(indent .. '[' .. pos .. '] => "' .. val .. '"')
                        else
                            print(indent .. '[' .. pos .. '] => ' .. tostring(val))
                        end
                    end
                else
                    print(indent .. tostring(subject))
                end
            end
        end
        if type(object) == 'table' then
            print(tostring(object) .. ' {')
            printLoop(object, '  ')
            print('}')
        else
            printLoop(object, '  ')
        end
        print()
    elseif type(object) == 'string' then
        print('|cffff2020[Debug]|r ' .. object)
    else
        print('(' .. type(object) .. ') ' .. tostring(object))
    end
end

function F:ThrowError(...)
    local message = strjoin(' ', ...)
    geterrorhandler()(format('%s |cffff3860%s|r\n', C.ADDON_TITLE, '[ERROR]') .. message)
end

function F:Dump(object, inspect)
    if GetAddOnEnableState(C.MY_NAME, 'Blizzard_DebugTools') == 0 then
        F:Print('Blizzard_DebugTools is disabled.')
        return
    end

    local debugTools = IsAddOnLoaded('Blizzard_DebugTools')
    if not debugTools then
        UIParentLoadAddOn('Blizzard_DebugTools')
    end

    if inspect then
        local tableType = type(object)
        if tableType == 'table' then
            _G.DisplayTableInspectorWindow(object)
        else
            F:Print('Failed: ', tostring(object), ' is type: ', tableType, '. Requires table object.')
        end
    else
        _G.DevTools_Dump(object)
    end
end
