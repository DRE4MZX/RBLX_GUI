--// Auto Seed Buyer GUI - CoreGui - Reexecute Safe

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

if getgenv().AutoSeedBuyer then
	getgenv().AutoSeedBuyer:Cleanup()
end

local Auto = {
	Enabled = false,
	Seed = "Bamboo",
	DelayBuy = 0.15,
	Buying = false,
	Connections = {},
	StockConnection = nil,
	Gui = nil,
	LastStock = nil,
}

getgenv().AutoSeedBuyer = Auto

local function disconnect(con)
	if con then
		pcall(function()
			con:Disconnect()
		end)
	end
end

local function pressGuiButton(node)
	if not node then return false, "button nil" end
	if not node:IsA("GuiButton") then
		return false, "not GuiButton (" .. node.ClassName .. ")"
	end

	local oldSelectedObject = GuiService.SelectedObject
	local oldSelectable = node.Selectable

	local ok, err = pcall(function()
		node.Selectable = true
		GuiService.SelectedObject = node
		task.wait(0.1)
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
		task.wait(0.05)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
		task.wait(0.05)
	end)

	pcall(function()
		GuiService.SelectedObject = oldSelectedObject
		node.Selectable = oldSelectable
	end)

	return ok, ok and ("OK -> " .. node:GetFullName()) or tostring(err)
end

function Auto:GetShop()
	return player.PlayerGui
		:WaitForChild("SeedShop")
		:WaitForChild("Frame")
		:WaitForChild("NormalShop")
end

function Auto:GetStockText()
	local shop = self:GetShop()
	local seedFrame = shop:FindFirstChild(self.Seed)

	if not seedFrame then
		return nil, "Seed frame tidak ditemukan: " .. self.Seed
	end

	local stockText = seedFrame:FindFirstChild("Stock_Text", true)
	if not stockText then
		return nil, "Stock_Text tidak ditemukan: " .. self.Seed
	end

	return stockText
end

function Auto:GetStock()
	local stockText, err = self:GetStockText()
	if not stockText then
		warn(err)
		return 0
	end

	return tonumber(stockText.Text:match("%d+")) or 0
end

function Auto:BuyStock()
	if not self.Enabled or self.Buying then return end

	self.Buying = true

	local ok, err = pcall(function()
		local shop = self:GetShop()
		local mainFrame = shop.Sheckles_Shelf.Main_Frame

		local seedName = mainFrame:WaitForChild("Seed_Name")
		local buyButton = mainFrame.Buttons:WaitForChild("BuyButton")

		local stock = self:GetStock()

		print(("Buying %s | Stock: %d"):format(self.Seed, stock))

		for i = 1, stock do
			if not self.Enabled then break end

			seedName.Value = self.Seed
			task.wait(0.05)

			local success, msg = pressGuiButton(buyButton)
			print(("[%s] %d/%d"):format(self.Seed, i, stock), success, msg)

			task.wait(self.DelayBuy)
		end
	end)

	if not ok then
		warn("BuyStock error:", err)
	end

	self.Buying = false
end

function Auto:WatchStock()
	disconnect(self.StockConnection)
	self.StockConnection = nil

	local stockText, err = self:GetStockText()
	if not stockText then
		warn(err)
		return
	end

	self.LastStock = tonumber(stockText.Text:match("%d+")) or 0

	self.StockConnection = stockText:GetPropertyChangedSignal("Text"):Connect(function()
		local newStock = tonumber(stockText.Text:match("%d+")) or 0
		print("Stock changed:", self.LastStock, "->", newStock)

		if self.Enabled and newStock > 0 and newStock ~= self.LastStock then
			self.LastStock = newStock
			task.spawn(function()
				self:BuyStock()
			end)
		else
			self.LastStock = newStock
		end
	end)
end

function Auto:SetEnabled(state)
	self.Enabled = state

	if self.ToggleButton then
		self.ToggleButton.Text = self.Enabled and "AUTO BUY: ON" or "AUTO BUY: OFF"
		self.ToggleButton.BackgroundColor3 = self.Enabled
			and Color3.fromRGB(40, 160, 90)
			or Color3.fromRGB(160, 60, 60)
	end

	print("AutoSeedBuyer:", self.Enabled and "ON" or "OFF")

	if self.Enabled then
		self:WatchStock()
		task.spawn(function()
			self:BuyStock()
		end)
	end
end

function Auto:Cleanup()
	self.Enabled = false
	self.Buying = false

	disconnect(self.StockConnection)
	self.StockConnection = nil

	for _, con in ipairs(self.Connections) do
		disconnect(con)
	end

	self.Connections = {}

	if self.Gui then
		pcall(function()
			self.Gui:Destroy()
		end)
	end

	print("AutoSeedBuyer cleaned")
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoSeedBuyer_CoreGui"
gui.ResetOnSpawn = false
gui.Parent = CoreGui
Auto.Gui = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 135)
frame.Position = UDim2.new(0, 30, 0, 220)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Auto Seed Buyer"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 0, 25)
minimize.Position = UDim2.new(1, -65, 0, 3)
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
minimize.Text = "-"
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 16
minimize.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 25)
close.Position = UDim2.new(1, -33, 0, 3)
close.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 13
close.Parent = frame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.Parent = frame

local seedBox = Instance.new("TextBox")
seedBox.Size = UDim2.new(1, -20, 0, 32)
seedBox.Position = UDim2.new(0, 10, 0, 8)
seedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
seedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
seedBox.PlaceholderText = "Seed Name"
seedBox.Text = Auto.Seed
seedBox.Font = Enum.Font.Gotham
seedBox.TextSize = 13
seedBox.ClearTextOnFocus = false
seedBox.Parent = content

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, 48)
toggle.BackgroundColor3 = Color3.fromRGB(160, 60, 60)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Text = "AUTO BUY: OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 13
toggle.Parent = content

Auto.ToggleButton = toggle

local minimized = false

table.insert(Auto.Connections, seedBox.FocusLost:Connect(function()
	if seedBox.Text ~= "" then
		Auto.Seed = seedBox.Text
		Auto.LastStock = nil
		Auto:WatchStock()
		print("Seed changed:", Auto.Seed)
	end
end))

table.insert(Auto.Connections, toggle.MouseButton1Click:Connect(function()
	Auto.Seed = seedBox.Text ~= "" and seedBox.Text or Auto.Seed
	Auto:SetEnabled(not Auto.Enabled)
end))

table.insert(Auto.Connections, minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	content.Visible = not minimized
	frame.Size = minimized and UDim2.new(0, 240, 0, 30) or UDim2.new(0, 240, 0, 135)
	minimize.Text = minimized and "+" or "-"
end))

table.insert(Auto.Connections, close.MouseButton1Click:Connect(function()
	Auto:Cleanup()
	getgenv().AutoSeedBuyer = nil
end))

Auto:WatchStock()

print("AutoSeedBuyer loaded")
print("Cleanup manual : getgenv().AutoSeedBuyer:Cleanup()")
