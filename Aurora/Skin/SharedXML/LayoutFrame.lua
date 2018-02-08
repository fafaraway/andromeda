local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select ipairs
-- luacheck: globals table max

--[[ Core ]]
local Aurora = private.Aurora
local Scale = Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ SharedXML\LayoutFrame.lua ]]
    local LayoutMixin do
        LayoutMixin = {}
        function LayoutMixin:GetPadding(frame)
            private.debug("LayoutMixin:GetPadding")
            if frame then
                return Scale.Value(frame.leftPadding or 0),
                       Scale.Value(frame.rightPadding or 0),
                       Scale.Value(frame.topPadding or 0),
                       Scale.Value(frame.bottomPadding or 0)
            end
        end

        function LayoutMixin:AddLayoutChildren(layoutChildren, ...)
            for i = 1, select("#", ...) do
                local region = select(i, ...)
                if region.layoutIndex and region:IsVisible() then
                    layoutChildren[#layoutChildren + 1] = region
                end
            end
        end

        function LayoutMixin:CalculateFrameSize(childrenWidth, childrenHeight)
            private.debug("LayoutMixin:CalculateFrameSize", childrenWidth, childrenHeight)
            local frameWidth, frameHeight
            local leftPadding, rightPadding, topPadding, bottomPadding = self:GetPadding(self)

            childrenWidth = childrenWidth + leftPadding + rightPadding
            childrenHeight = childrenHeight + topPadding + bottomPadding

            -- Expand this frame if the "expand" keyvalue is set and children width or height is larger.
            -- Otherwise, set this frame size to the fixed size if set, or the size of the children
            local fixedWidth = self.fixedWidth and Scale.Value(self.fixedWidth)
            if (self.expand and fixedWidth and childrenWidth > fixedWidth) then
                frameWidth = childrenWidth
            else
                frameWidth = fixedWidth or childrenWidth
            end

            local fixedHeight = self.fixedHeight and Scale.Value(self.fixedHeight)
            if (self.expand and fixedHeight and childrenHeight > fixedHeight) then
                frameHeight = childrenHeight
            else
                frameHeight = fixedHeight or childrenHeight
            end
            return frameWidth, frameHeight
        end

        local function LayoutIndexComparator(left, right)
            return left.layoutIndex < right.layoutIndex
        end

        function LayoutMixin:Layout()
            private.debug("LayoutMixin:Layout")
            self.dirty = false

            local children = {}
            self:AddLayoutChildren(children, self:GetChildren())
            self:AddLayoutChildren(children, self:GetRegions())
            table.sort(children, LayoutIndexComparator)

            local childrenWidth, childrenHeight, hasExpandableChild = self:LayoutChildren(children)

            local frameWidth, frameHeight = self:CalculateFrameSize(childrenWidth, childrenHeight)

            -- If at least one child had "expand" set and we did not already expand them, call LayoutChildren() again to expand them
            if (hasExpandableChild) then
                childrenWidth, childrenHeight = self:LayoutChildren(children, frameWidth, frameHeight)
                frameWidth, frameHeight = self:CalculateFrameSize(childrenWidth, childrenHeight)
            end

            Scale.RawSetSize(self, frameWidth, frameHeight)
        end

        function LayoutMixin:OnUpdate()
            private.debug("LayoutMixin:OnUpdate")
            if self:IsDirty() then
                self:Layout()
            end
        end

        function LayoutMixin:MarkDirty()
            self.dirty = true
        end

        function LayoutMixin:IsDirty()
            private.debug("LayoutMixin:IsDirty")
            return self.dirty
        end
    end
    Hook.LayoutMixin = LayoutMixin

    local VerticalLayoutMixin do
        VerticalLayoutMixin = {}
        function VerticalLayoutMixin:LayoutChildren(children, expandToWidth)
            private.debug("VerticalLayoutMixin:LayoutChildren", children, expandToWidth)
            local frameLeftPadding, frameRightPadding, topOffset = self:GetPadding(self)
            local spacing = Scale.Value(self.spacing or 0)
            local childrenWidth, childrenHeight = 0, 0
            local hasExpandableChild = false

            -- Calculate width and height based on children
            for i, child in ipairs(children) do
                local childWidth, childHeight = child:GetSize()
                local leftPadding, rightPadding, topPadding, bottomPadding = self:GetPadding(child)
                if (child.expand) then
                    hasExpandableChild = true
                end

                -- Expand child width if it is set to expand and we also have an expandToWidth value.
                if (child.expand and expandToWidth) then
                    childWidth = expandToWidth - leftPadding - rightPadding - frameLeftPadding - frameRightPadding
                    Scale.RawSetWidth(child, childWidth)
                    childHeight = child:GetHeight()
                end
                childrenWidth = max(childrenWidth, childWidth + leftPadding + rightPadding)
                childrenHeight = childrenHeight + childHeight + topPadding + bottomPadding
                if (i > 1) then
                    childrenHeight = childrenHeight + spacing
                end

                -- Set child position
                child:ClearAllPoints()
                topOffset = topOffset + topPadding
                if (child.align == "right") then
                    local rightOffset = frameRightPadding + rightPadding
                    Scale.RawSetPoint(child, "TOPRIGHT", -rightOffset, -topOffset)
                elseif (child.align == "center") then
                    local leftOffset = (frameLeftPadding - frameRightPadding + leftPadding - rightPadding) / 2
                    Scale.RawSetPoint(child, "TOP", leftOffset, -topOffset)
                else
                    local leftOffset = frameLeftPadding + leftPadding
                    Scale.RawSetPoint(child, "TOPLEFT", leftOffset, -topOffset)
                end
                topOffset = topOffset + childHeight + bottomPadding + spacing
            end

            return childrenWidth, childrenHeight, hasExpandableChild
        end
    end
    Hook.VerticalLayoutMixin = VerticalLayoutMixin

    local HorizontalLayoutMixin do
        HorizontalLayoutMixin = {}
        function HorizontalLayoutMixin:LayoutChildren(children, ignored, expandToHeight)
            private.debug("HorizontalLayoutMixin:LayoutChildren", children, ignored, expandToHeight)
            local leftOffset, _, frameTopPadding, frameBottomPadding = self:GetPadding(self)
            local spacing = Scale.Value(self.spacing or 0)
            local childrenWidth, childrenHeight = 0, 0
            local hasExpandableChild = false

            -- Calculate width and height based on children
            for i, child in ipairs(children) do
                local childWidth, childHeight = child:GetSize()
                local leftPadding, rightPadding, topPadding, bottomPadding = self:GetPadding(child)
                if (child.expand) then
                    hasExpandableChild = true
                end

                -- Expand child height if it is set to expand and we also have an expandToHeight value.
                if (child.expand and expandToHeight) then
                    childHeight = expandToHeight - topPadding - bottomPadding - frameTopPadding - frameBottomPadding
                    Scale.RawSetHeight(child, childHeight)
                    childWidth = child:GetWidth()
                end
                childrenHeight = max(childrenHeight, childHeight + topPadding + bottomPadding)
                childrenWidth = childrenWidth + childWidth + leftPadding + rightPadding
                if (i > 1) then
                    childrenWidth = childrenWidth + spacing
                end

                -- Set child position
                child:ClearAllPoints()
                leftOffset = leftOffset + leftPadding
                if (child.align == "bottom") then
                    local bottomOffset = frameBottomPadding + bottomPadding
                    Scale.RawSetPoint(child, "BOTTOMLEFT", leftOffset, bottomOffset)
                elseif (child.align == "center") then
                    local topOffset = (frameTopPadding - frameBottomPadding + topPadding - bottomPadding) / 2
                    Scale.RawSetPoint(child, "LEFT", leftOffset, -topOffset)
                else
                    local topOffset = frameTopPadding + topPadding
                    Scale.RawSetPoint(child, "TOPLEFT", leftOffset, -topOffset)
                end
                leftOffset = leftOffset + childWidth + rightPadding + spacing
            end

            return childrenWidth, childrenHeight, hasExpandableChild
        end
    end
    Hook.HorizontalLayoutMixin = HorizontalLayoutMixin
end

do --[[ SharedXML\LayoutFrame.xml ]]
    function Skin.VerticalLayoutFrame(frame)
        _G.Mixin(frame, Hook.LayoutMixin, Hook.VerticalLayoutMixin)
    end
    function Skin.HorizontalLayoutFrame(frame)
        _G.Mixin(frame, Hook.LayoutMixin, Hook.HorizontalLayoutMixin)
    end
end

function private.SharedXML.LayoutFrame()
    --[[
    ]]
end
