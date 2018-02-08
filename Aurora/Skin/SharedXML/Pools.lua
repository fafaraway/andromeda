local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ SharedXML\Pools.lua ]]
    function Hook.ObjectPoolMixin_Acquire(self)
        local template = self.frameTemplate or self.textureTemplate or self.fontStringTemplate or self.actorTemplate
        if template and Skin[template] then
            for obj in self:EnumerateActive() do
                if not obj._auroraSkinned then
                    Skin[template](obj)
                    obj._auroraSkinned = true
                end
            end
        end
    end
end


function private.SharedXML.Pools()
    --[[
    ]]
end
