local _, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	hooksecurefunc("PanelTemplates_DeselectTab", function(tab)
		local text = tab.Text or _G[tab:GetName().."Text"]
		text:SetPoint("CENTER", tab, "CENTER")
	end)

	hooksecurefunc("PanelTemplates_SelectTab", function(tab)
		local text = tab.Text or _G[tab:GetName().."Text"]
		text:SetPoint("CENTER", tab, "CENTER")
	end)
end)