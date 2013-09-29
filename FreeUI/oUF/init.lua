local F, C = unpack(select(2, ...))

if not C.unitframes.enable then return end

local parent, ns = ...
ns.oUF = {}
ns.oUF.Private = {}