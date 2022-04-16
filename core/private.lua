local F, C = unpack(select(2, ...))

if not C.DEV_MODE then
    return
end

--[[ local function test()
    if _G.oUF_Player then
        print('_G.oUF_Player', 'found')
    else
        print('_G.oUF_Player', 'not found')
    end

    if _G.ClassNameplateManaBarFrame then
        print('_G.ClassNameplateManaBarFrame', 'found')
    else
        print('_G.ClassNameplateManaBarFrame', 'not found')
    end

    local player = _G.oUF_Player
    local np = _G.ClassNameplateManaBarFrame

    if np and player then
        player:ClearAllPoints()
        player:SetPoint('CENTER', np, 0, -40)
    end
end

F:RegisterEvent('PLAYER_ENTERING_WORLD', test) ]]
