local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals type max

--[[ Core ]]
local Aurora = private.Aurora
local Scale = Aurora.Scale
local Hook = Aurora.Hook

do --[[ FrameXML\FlowContainer.lua ]]
    function Hook.FlowContainer_DoLayout(container)
        if container.flowPauseUpdates then
            return
        end

        local primaryDirection, secondaryDirection
        local primarySpacing, secondarySpacing
        if container.flowOrientation == "horizontal" then
            primaryDirection = "Width"
            secondaryDirection  = "Height"
            primarySpacing = Scale.Value(container.flowHorizontalSpacing or 0)
            secondarySpacing = Scale.Value(container.flowVerticalSpacing or 0)
        else
            primaryDirection = "Height"
            secondaryDirection  = "Width"
            primarySpacing = Scale.Value(container.flowVerticalSpacing or 0)
            secondarySpacing = Scale.Value(container.flowHorizontalSpacing or 0)
        end

        --To make things easier to understand, I'll comment this as if it was horizontal. To see the vertical comments, just turn your head 90 degrees.
        local currentSecondaryLine, currentPrimaryLine = 1, 1
        local currentSecondaryOffset, currentPrimaryOffset = Scale.Value(container.startingSecondaryOffset or 0), Scale.Value(container.startingPrimaryOffset or 0)
        local lineMaxSize = 0
        local maxSecondaryOffset = 0
        local atomicAddStart = nil
        local atomicAtBeginning = nil
        local i = 1
        while i <= #container.flowFrames do
            local object = container.flowFrames[i]
            local doContinue = false
            --If it doesn't fit on the current row, move to the next.
            if object == "linebreak" or   --Force a new line
                type(object) == "table" and --Make sure this is an actual object before checking further.
                    ((container.flowMaxPerLine and currentPrimaryLine > container.flowMaxPerLine) or    --We went past the max number of columns
                        currentSecondaryOffset + object["Get"..primaryDirection](object) > container["Get"..primaryDirection](container)) then    --We went past the max pixel width.

                    if not (atomicAddStart and atomicAtBeginning) then  --If we're in an atomic add and we started at the beginning of the line, wrapping won't help us
                        currentSecondaryOffset = 0 --Move back all the way to the left
                        currentPrimaryLine = 1 --Reset column count
                        currentPrimaryOffset = currentPrimaryOffset + lineMaxSize + secondarySpacing   --Move down by the size of the biggest object in the last row
                        currentSecondaryLine = currentSecondaryLine + 1    --Move to the next row.
                        lineMaxSize = 0
                        if atomicAddStart then
                            --We wrapped around. So we want to move back to the first item in the atomic add and continue from the position we're leaving off (the new line).
                            i = atomicAddStart
                            atomicAtBeginning = true
                            doContinue = true
                        end
                    end
            end

            if not doContinue then
                local objectType = type(object)
                if objectType == "table" then   --This is an actual frame
                    --Did we completely run out of room? Assert for now. --Scratch that, we're just going to keep growing. When we have time, we'll probably want a "didn't fit" callback.
                    --assert(currentPrimaryOffset + object["Get"..secondaryDirection](object) < container["Get"..secondaryDirection](container))

                    --Add it.
                    object:ClearAllPoints()
                    if container.flowOrientation == "horizontal" then
                        Scale.RawSetPoint(object, "TOPLEFT", container, "TOPLEFT", currentSecondaryOffset, -currentPrimaryOffset)
                    else
                        Scale.RawSetPoint(object, "TOPLEFT", container, "TOPLEFT", currentPrimaryOffset, -currentSecondaryOffset)
                    end

                    currentSecondaryOffset = currentSecondaryOffset + object["Get"..primaryDirection](object) + primarySpacing

                    if not atomicAddStart then  --If we're in the middle of an atomic add, we'll save off the last part when we finish the add.
                        maxSecondaryOffset = max(maxSecondaryOffset, currentSecondaryOffset)
                    end

                    currentPrimaryLine = currentPrimaryLine + 1
                    lineMaxSize = max(lineMaxSize, object["Get"..secondaryDirection](object))
                elseif objectType == "number" then  --This is a spacer.
                    currentSecondaryOffset = currentSecondaryOffset + Scale.Value(object)
                elseif objectType == "string" then
                    if object == "beginatomic" then
                        if currentSecondaryOffset == 0 then
                            atomicAtBeginning = true       --If we're already at the top, we don't want to move anything to the next row. (There's no way it would help.)
                        end
                        atomicAddStart = i + 1
                    elseif object == "endatomic" then
                        maxSecondaryOffset = max(maxSecondaryOffset, currentSecondaryOffset)   --We weren't updating the max offset while in an atomic add, so we have to do it now.
                        atomicAddStart = nil
                        atomicAtBeginning = nil
                    end
                end
                i = i + 1
            end
        end

        --Save off how much we actually used.
        container.flowMaxPrimaryUsed = currentPrimaryOffset + lineMaxSize
        container.flowMaxSecondaryUsed = maxSecondaryOffset
    end
end

function private.FrameXML.FlowContainer()
    _G.hooksecurefunc("FlowContainer_DoLayout", Hook.FlowContainer_DoLayout)
end
