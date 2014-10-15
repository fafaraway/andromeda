local F, C = unpack(select(2, ...))

if not C.menubar.enable or not C.menubar.enableButtons then return end

C.themes["KayrChat"] = function()
	local menuButton

	local function updateText(self)
		menuButton.Text:SetText(self:GetText())
	end

	hooksecurefunc(KayrChat, "CreateLangButton", function()
		local button = KC_LangButton

		button:Hide()
		button.Show = function() end

		menuButton = FreeUIMenubar.addButton("KayrChat", 1, function()
			button:Click()
		end)

		hooksecurefunc(button, "Update", updateText)
		updateText(button)
	end)
end