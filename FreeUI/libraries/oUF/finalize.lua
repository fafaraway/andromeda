local F, C = unpack(select(2, ...))

if not C.unitframes.enable then return end

local parent, ns = ...

-- It's named Private for a reason!
ns.oUF.Private = nil