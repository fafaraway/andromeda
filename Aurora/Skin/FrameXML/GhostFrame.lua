local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local F = _G.unpack(private.Aurora)

function private.FrameXML.GhostFrame()
    Skin.UIPanelLargeSilverButton(_G.GhostFrame)
    Base.CropIcon(_G.GhostFrameContentsFrameIcon, _G.GhostFrameContentsFrame)

	F.CreateBD(_G.GhostFrame)
    F.CreateSD(_G.GhostFrame)
end
