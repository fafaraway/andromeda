local F, C = unpack(select(2, ...))

--if not C.actionbars.enable then return end



local A = ...



-- Fader

local fader = {
	fadeInAlpha = 1,
	fadeInDuration = 0.3,
	fadeInSmooth = "OUT",
	fadeOutAlpha = 0,
	fadeOutDuration = 0.9,
	fadeOutSmooth = "OUT",
	fadeOutDelay = 0,
}

-- BagBar
local bagbar = {
	framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 5 },
	frameScale      = 1,
	framePadding    = 5,
	buttonWidth     = 32,
	buttonHeight    = 32,
	buttonMargin    = 2,
	numCols         = 6, --number of buttons per column
	startPoint      = "BOTTOMRIGHT", --start postion of first button: BOTTOMLEFT, TOPLEFT, TOPRIGHT, BOTTOMRIGHT
	fader           = nil,
	frameVisibility = "hide"
}
--create
rActionBar:CreateBagBar(A, bagbar)


-- MicroMenuBar
local micromenubar = {
	framePoint      = { "TOP", UIParent, "TOP", 0, 0 },
	frameScale      = 0.8,
	framePadding    = 5,
	buttonWidth     = 28,
	buttonHeight    = 58,
	buttonMargin    = 0,
	numCols         = 12,
	startPoint      = "BOTTOMLEFT",
	fader           = nil,
	frameVisibility = "hide"
}
--create
rActionBar:CreateMicroMenuBar(A, micromenubar)


if C.actionbars.bar1_mouseOver then
	-- Bar1
	local bar1 = {
		framePoint      = { "BOTTOM", UIParent, "BOTTOM", 0, 6 },
		frameScale      = 1,
		framePadding    = 0,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 4,
		numCols         = 12,
		startPoint      = "BOTTOMLEFT",
		fader 			= fader,
		--frameVisibility = "[combat][modifier][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide"
	}
	--create
	rActionBar:CreateActionBar1(A, bar1)
else
	-- Bar1
	local bar1 = {
		framePoint      = { "BOTTOM", UIParent, "BOTTOM", 0, 6 },
		frameScale      = 1,
		framePadding    = 0,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 4,
		numCols         = 12,
		startPoint      = "BOTTOMLEFT",
		--frameVisibility = "[combat][modifier][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide"
	}
	--create
	rActionBar:CreateActionBar1(A, bar1)
end


if C.actionbars.bar2_mouseOver then
	-- Bar2
	local bar2 = {
		framePoint      = { "BOTTOM", A.."Bar1", "TOP", 0, 4 },
		frameScale      = 1,
		framePadding    = 0,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 4,
		numCols         = 12,
		startPoint      = "BOTTOMLEFT",
		fader 			= fader,
		--frameVisibility = "[combat][modifier][@target,exists,nodead] show; hide"
	}
	--create
	rActionBar:CreateActionBar2(A, bar2)
else
	-- Bar2
	local bar2 = {
		framePoint      = { "BOTTOM", A.."Bar1", "TOP", 0, 4 },
		frameScale      = 1,
		framePadding    = 0,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 4,
		numCols         = 12,
		startPoint      = "BOTTOMLEFT",
		--frameVisibility = "[combat][modifier][@target,exists,nodead] show; hide"
	}
	--create
	rActionBar:CreateActionBar2(A, bar2)
end


if C.actionbars.bar3_mouseOver then

	-- Bar3
	local bar3 = {
		framePoint      = { "BOTTOM", A.."Bar2", "TOP", 0, 4 },
		frameScale      = 1,
		framePadding    = 0,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 4,
		numCols         = 12,
		startPoint      = "BOTTOMLEFT",
		fader 			= fader,
	}
	--create
	rActionBar:CreateActionBar3(A, bar3)
else
	-- Bar3
	local bar3 = {
		framePoint      = { "BOTTOM", A.."Bar2", "TOP", 0, 4 },
		frameScale      = 1,
		framePadding    = 0,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 4,
		numCols         = 12,
		startPoint      = "BOTTOMLEFT",
		--frameVisibility = "[combat][modifier][@target,exists,nodead] show; hide"
	}
	--create
	rActionBar:CreateActionBar3(A, bar3)
end

	



if C.actionbars.sideBar_mouseOver then
	-- Bar4
	local bar4 = {
		framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 200 },
		frameScale      = 1,
		framePadding    = 0,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 4,
		numCols         = 1,
		startPoint      = "TOPRIGHT",
		fader 			= fader,
	}
	--create
	rActionBar:CreateActionBar4(A, bar4)

	-- Bar5
	local bar5 = {
		framePoint      = { "RIGHT", A.."Bar4", "LEFT", -4, 0 },
		frameScale      = 1,
		framePadding    = 0,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 4,
		numCols         = 1,
		startPoint      = "BOTTOMLEFT",
		fader 			= fader,
	}
	--create
	rActionBar:CreateActionBar5(A, bar5)
else
	-- Bar4
	local bar4 = {
		framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 200 },
		frameScale      = 1,
		framePadding    = 0,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 4,
		numCols         = 1,
		startPoint      = "TOPRIGHT",
		--frameVisibility = "hide"
	}
	--create
	rActionBar:CreateActionBar4(A, bar4)

	-- Bar5
	local bar5 = {
		framePoint      = { "RIGHT", A.."Bar4", "LEFT", -4, 0 },
		frameScale      = 1,
		framePadding    = 0,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 4,
		numCols         = 1,
		startPoint      = "BOTTOMLEFT",
		--frameVisibility = "hide"
	}
	--create
	rActionBar:CreateActionBar5(A, bar5)
end


if C.actionbars.stanceBar_show then
	-- StanceBar
	local stancebar = {
		framePoint      = { "BOTTOM", A.."Bar3", "TOP", 0, 0 },
		frameScale      = 1,
		framePadding    = 5,
		buttonWidth     = 32,
		buttonHeight    = 32,
		buttonMargin    = 5,
		numCols         = 12,
		startPoint      = "BOTTOMLEFT",
	}
	--create
	rActionBar:CreateStanceBar(A, stancebar)
else
	-- StanceBar
	local stancebar = {
		framePoint      = { "BOTTOM", A.."Bar3", "TOP", 0, 0 },
		frameScale      = 1,
		framePadding    = 5,
		buttonWidth     = 32,
		buttonHeight    = 32,
		buttonMargin    = 5,
		numCols         = 12,
		startPoint      = "BOTTOMLEFT",
		frameVisibility = "hide",
	}
	--create
	rActionBar:CreateStanceBar(A, stancebar)
end

if C.actionbars.petBar_mouseOver then
	-- petbar
	local petbar = {
		framePoint      = { "BOTTOM", A.."Bar2", "TOP", 0, 40 },
		frameScale      = 1,
		framePadding    = 2,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 8,
		numCols         = 12,
		startPoint      = "BOTTOMLEFT",
		fader 			= fader,
	}
	--create
	rActionBar:CreatePetBar(A, petbar)
else
	-- petbar
	local petbar = {
		framePoint      = { "BOTTOM", A.."Bar2", "TOP", 0, 40 },
		frameScale      = 1,
		framePadding    = 2,
		buttonWidth     = 24,
		buttonHeight    = 24,
		buttonMargin    = 8,
		numCols         = 12,
		startPoint      = "BOTTOMLEFT",
	}
	--create
	rActionBar:CreatePetBar(A, petbar)
end


-- ExtraBar
local extrabar = {
	framePoint      = { "BOTTOM", UIParent, "BOTTOM", 0, 320 },
	frameScale      = 1,
	framePadding    = 4,
	buttonWidth     = 36,
	buttonHeight    = 36,
	buttonMargin    = 4,
	numCols         = 1,
	startPoint      = "BOTTOMLEFT",
}
--create
rActionBar:CreateExtraBar(A, extrabar)


-- VehicleExitBar
--[[local vehicleexitbar = {
	framePoint      = C.actionbars.leaveVehicleButton,
	frameScale      = 1,
	framePadding    = 0,
	buttonWidth     = 24,
	buttonHeight    = 24,
	buttonMargin    = 0,
	numCols         = 1,
	startPoint      = "BOTTOMLEFT",
	frameVisibility = "hide"
}
--create
rActionBar:CreateVehicleExitBar(A, vehicleexitbar)]]


-- PossessExitBar
--[[possessexitbar.frameVisibility = nil --need to reset the value that is given to vehicleexitbar
--create
rActionBar:CreatePossessExitBar(A, possessexitbar)]]
