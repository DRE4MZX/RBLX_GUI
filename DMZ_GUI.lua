--// DMZ GUI Framework v4 (Module)
local DMZ = {}
DMZ.__index = DMZ

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function create(instance, props)
	local obj = Instance.new(instance)
	for i, v in pairs(props) do
		obj[i] = v
	end
	return obj
end

local function tween(obj, props, time)
	TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

function DMZ:CreateWindow(title)
	local selfObj = setmetatable({}, DMZ)

	local ScreenGui = create("ScreenGui", { Parent = LocalPlayer:WaitForChild("PlayerGui"), ResetOnSpawn = false })
	local Frame = create(
		"Frame",
		{
			Parent = ScreenGui,
			Size = UDim2.new(0, 500, 0, 350),
			Position = UDim2.new(0.3, -250, 0.3, -175),
			BackgroundColor3 = Color3.fromRGB(20, 20, 30),
			BorderSizePixel = 0,
		}
	)
	Frame.ClipsDescendants = true
	create("UICorner", { Parent = Frame, CornerRadius = UDim.new(0, 12) })
	create(
		"UIStroke",
		{ Parent = Frame, Color = Color3.fromRGB(85, 0, 255), Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }
	)

	-- Title Bar
	local TitleBar = create(
		"Frame",
		{ Parent = Frame, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(30, 30, 40) }
	)
	create("UICorner", { Parent = TitleBar, CornerRadius = UDim.new(0, 12) })
	local TitleText = create(
		"TextLabel",
		{
			Parent = TitleBar,
			Text = title,
			Size = UDim2.new(1, -60, 1, 0),
			Position = UDim2.new(0, 15, 0, 0),
			Font = Enum.Font.GothamBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 16,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
		}
	)

	-- Close Button
	local CloseButton = create(
		"TextButton",
		{
			Parent = TitleBar,
			Size = UDim2.new(0, 25, 0, 25),
			Position = UDim2.new(1, -30, 0, 2),
			Text = "x",
			Font = Enum.Font.GothamBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 20,
			BackgroundColor3 = Color3.fromRGB(30, 30, 40),
		}
	)
	create("UICorner", { Parent = CloseButton, CornerRadius = UDim.new(0, 4) })
	CloseButton.MouseEnter:Connect(function()
		tween(CloseButton, { BackgroundColor3 = Color3.fromRGB(255, 50, 50) }, 0.15)
	end)
	CloseButton.MouseLeave:Connect(function()
		tween(CloseButton, { BackgroundColor3 = Color3.fromRGB(30, 30, 40) }, 0.15)
	end)
	CloseButton.MouseButton1Click:Connect(function()
		tween(Frame, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }, 0.3)
		wait(0.3)
		ScreenGui:Destroy()
	end)

	-- Minimize Button
	local MinimizeButton = create(
		"TextButton",
		{
			Parent = TitleBar,
			Size = UDim2.new(0, 25, 0, 25),
			Position = UDim2.new(1, -60, 0, 2),
			Text = "_",
			Font = Enum.Font.GothamBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 20,
			BackgroundColor3 = Color3.fromRGB(30, 30, 40),
		}
	)
	create("UICorner", { Parent = MinimizeButton, CornerRadius = UDim.new(0, 4) })
	MinimizeButton.MouseEnter:Connect(function()
		tween(MinimizeButton, { BackgroundColor3 = Color3.fromRGB(100, 100, 100) }, 0.15)
	end)
	MinimizeButton.MouseLeave:Connect(function()
		tween(MinimizeButton, { BackgroundColor3 = Color3.fromRGB(30, 30, 40) }, 0.15)
	end)

	local minimized = false
	MinimizeButton.MouseButton1Click:Connect(function()
		if not minimized then
			Frame.Size = UDim2.new(Frame.Size.X.Scale, Frame.Size.X.Offset, 0, 30) -- hanya title bar
			minimized = true
		else
			Frame.Size = UDim2.new(0, 500, 0, 350) -- kembalikan ke ukuran normal
			minimized = false
		end
	end)

	-- Tabs Container
	local TabsFrame = create(
		"Frame",
		{
			Parent = Frame,
			Size = UDim2.new(0, 120, 1, -40),
			Position = UDim2.new(0, 0, 0, 40),
			BackgroundColor3 = Color3.fromRGB(25, 25, 35),
		}
	)
	create("UICorner", { Parent = TabsFrame, CornerRadius = UDim.new(0, 8) })
	local ScrollTabs = create(
		"ScrollingFrame",
		{
			Parent = TabsFrame,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			ScrollBarThickness = 4,
		}
	)
	local ListTabs = create(
		"UIListLayout",
		{ Parent = ScrollTabs, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) }
	)

	-- Content Area
	local ContentFrame = create("Frame", {
		Parent = Frame,
		Size = UDim2.new(1, -130, 1, -40),
		Position = UDim2.new(0, 130, 0, 40),
		BackgroundTransparency = 1,
	})

	local ScrollContent = create("ScrollingFrame", {
		Parent = ContentFrame,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 4,
	})

	local ListContent = create("UIListLayout", {
		Parent = ScrollContent,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
	})

	-- Tambahkan gap di atas konten
	local topGap = create("Frame", {
		Parent = ScrollContent,
		Size = UDim2.new(1, 0, 0, 15), -- tinggi 15px
		BackgroundTransparency = 1,
	})

	-- Drag & Resize
	local dragging, startPos, dragStart
	TitleBar.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragStart = input.Position
			startPos = Frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if
			dragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			local delta = input.Position - dragStart
			Frame.Position =
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- Resize (desktop + mobile)
	local ResizeHandle = create("Frame", {
		Parent = Frame,
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(1, -20, 1, -20),
		BackgroundTransparency = 1,
		ZIndex = 2,
	})

	local resizing = false
	local startSize, startInput

	ResizeHandle.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			resizing = true
			startSize = Frame.Size
			startInput = input.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if
			resizing
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			local delta = input.Position - startInput
			Frame.Size = UDim2.new(
				startSize.X.Scale,
				math.max(300, startSize.X.Offset + delta.X),
				startSize.Y.Scale,
				math.max(200, startSize.Y.Offset + delta.Y)
			)
		end
	end)

	-- Responsive Text
	local function updateTextSize()
		local width = Frame.AbsoluteSize.X
		local scaleFactor = math.clamp(width / 500, 0.5, 1)
		TitleText.TextSize = math.floor(16 * scaleFactor)
		CloseButton.TextSize = math.floor(20 * scaleFactor)
		MinimizeButton.TextSize = math.floor(20 * scaleFactor)
		for _, btn in ipairs(ScrollTabs:GetChildren()) do
			if btn:IsA("TextButton") then
				for _, c in ipairs(btn:GetChildren()) do
					if c:IsA("TextLabel") then
						c.TextSize = math.max(10, math.floor(14 * scaleFactor))
					end
				end
			end
		end
		for _, tabFrame in ipairs(ScrollContent:GetChildren()) do
			if tabFrame:IsA("Frame") then
				for _, item in ipairs(tabFrame:GetChildren()) do
					if item:IsA("ScrollingFrame") then
						for _, elem in ipairs(item:GetChildren()) do
							if elem:IsA("TextLabel") or elem:IsA("TextButton") then
								elem.TextSize = math.max(10, math.floor(14 * scaleFactor))
							end
						end
					end
				end
			end
		end
	end
	Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateTextSize)

	-- Tab System
	function selfObj:AddTab(name)
		local tabBtn = create(
			"TextButton",
			{
				Parent = ScrollTabs,
				Text = name,
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = Color3.fromRGB(40, 40, 60),
				TextColor3 = Color3.fromRGB(255, 255, 255),
			}
		)
		create("UICorner", { Parent = tabBtn, CornerRadius = UDim.new(0, 4) })

		local tabFrame = create(
			"Frame",
			{ Parent = ScrollContent, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false }
		)
		local tabScroll = create(
			"ScrollingFrame",
			{
				Parent = tabFrame,
				Size = UDim2.new(1, 0, 1, 0),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = 4,
			}
		)
		local listLayout = create(
			"UIListLayout",
			{ Parent = tabScroll, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) }
		)

		tabBtn.MouseButton1Click:Connect(function()
			for _, c in pairs(ScrollContent:GetChildren()) do
				if c:IsA("Frame") then
					c.Visible = false
				end
			end
			tabFrame.Visible = true
		end)

		local tabObj = {}
		function tabObj:AddButton(name, callback)
			local btn = create("TextButton", {
				Parent = tabScroll,
				Size = UDim2.new(1, -10, 0, 35),
				BackgroundColor3 = Color3.fromRGB(35, 35, 50),
				Text = "",
			})
			create("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 6) })

			local lbl = create("TextLabel", {
				Parent = btn,
				Text = name,
				Size = UDim2.new(1, -20, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				Font = Enum.Font.Gotham,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			btn.MouseButton1Click:Connect(function()
				if callback then
					callback()
				end
			end)

			tabScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
			return btn
		end

		function tabObj:AddToggle(name, callback)
			local btn = create(
				"TextButton",
				{ Parent = tabScroll, Size = UDim2.new(1, -10, 0, 35), BackgroundColor3 = Color3.fromRGB(35, 35, 50), Text = "" }
			)
			create("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 6) })
			local lbl = create(
				"TextLabel",
				{
					Parent = btn,
					Text = name,
					Size = UDim2.new(1, -50, 1, 0),
					Position = UDim2.new(0, 10, 0, 0),
					Font = Enum.Font.Gotham,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
				}
			)
			local state = false
			local indicator = create(
				"Frame",
				{
					Parent = btn,
					Size = UDim2.new(0, 20, 0, 20),
					Position = UDim2.new(1, -30, 0.5, -10),
					BackgroundColor3 = Color3.fromRGB(70, 70, 90),
				}
			)
			create("UICorner", { Parent = indicator, CornerRadius = UDim.new(1, 0) })
			btn.MouseButton1Click:Connect(function()
				state = not state
				tween(
					indicator,
					{ BackgroundColor3 = state and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(70, 70, 90) },
					0.2
				)
				if callback then
					callback(state)
				end
			end)
			tabScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
		end

		function tabObj:AddSlider(name, min, max, default, callback)
			local sf = create(
				"Frame",
				{ Parent = tabScroll, Size = UDim2.new(1, -10, 0, 50), BackgroundColor3 = Color3.fromRGB(35, 35, 50) }
			)
			create("UICorner", { Parent = sf, CornerRadius = UDim.new(0, 6) })
			local lbl = create(
				"TextLabel",
				{
					Parent = sf,
					Text = name .. " " .. default,
					Size = UDim2.new(1, -10, 0, 20),
					Position = UDim2.new(0, 5, 0, 5),
					Font = Enum.Font.Gotham,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
				}
			)
			local bar = create(
				"Frame",
				{
					Parent = sf,
					Size = UDim2.new(1, -10, 0, 8),
					Position = UDim2.new(0, 5, 0, 30),
					BackgroundColor3 = Color3.fromRGB(70, 70, 90),
				}
			)
			create("UICorner", { Parent = bar, CornerRadius = UDim.new(0, 4) })
			local knob = create(
				"Frame",
				{ Parent = bar, Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = Color3.fromRGB(
					0,
					255,
					140
				) }
			)
			create("UICorner", { Parent = knob, CornerRadius = UDim.new(0, 4) })

			local dragging = false

			local function updateSlider(inputPosX)
				local mouseX = math.clamp(inputPosX - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
				local value = min + (mouseX / bar.AbsoluteSize.X) * (max - min)
				knob.Size = UDim2.new(mouseX / bar.AbsoluteSize.X, 0, 1, 0)
				lbl.Text = name .. " " .. math.floor(value)
				if callback then
					callback(value)
				end
			end

			knob.InputBegan:Connect(function(input)
				if
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch
				then
					dragging = true
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragging = false
						end
					end)
				end
			end)

			bar.InputBegan:Connect(function(input)
				if
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch
				then
					updateSlider(input.Position.X)
					dragging = true
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragging = false
						end
					end)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if
					dragging
					and (
						input.UserInputType == Enum.UserInputType.MouseMovement
						or input.UserInputType == Enum.UserInputType.Touch
					)
				then
					updateSlider(input.Position.X)
				end
			end)

			tabScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
		end

		function tabObj:AddLabel(text)
			local lbl = create(
				"TextLabel",
				{
					Parent = tabScroll,
					Text = text,
					Size = UDim2.new(1, -10, 0, 30),
					Font = Enum.Font.Gotham,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
				}
			)
			tabScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
		end

		-- DropDown
		function tabObj:AddDropdown(name, options)
			local container = create("Frame", {
				Parent = tabScroll,
				Size = UDim2.new(1, -10, 0, 80),
				BackgroundColor3 = Color3.fromRGB(35, 35, 50),
			})
			create("UICorner", { Parent = container, CornerRadius = UDim.new(0, 6) })

			local label = create("TextLabel", {
				Parent = container,
				Text = name,
				Size = UDim2.new(1, -10, 0, 20),
				Position = UDim2.new(0, 5, 0, 5),
				Font = Enum.Font.Gotham,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local dropdown = create("TextButton", {
				Parent = container,
				Size = UDim2.new(1, -10, 0, 25),
				Position = UDim2.new(0, 5, 0, 25),
				Text = "Select...",
				BackgroundColor3 = Color3.fromRGB(50, 50, 70),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.Gotham,
				TextSize = 14,
			})
			create("UICorner", { Parent = dropdown, CornerRadius = UDim.new(0, 6) })

			local submitBtn = create("TextButton", {
				Parent = container,
				Size = UDim2.new(1, -10, 0, 25),
				Position = UDim2.new(0, 5, 0, 55),
				Text = "Submit",
				BackgroundColor3 = Color3.fromRGB(0, 170, 255),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.Gotham,
				TextSize = 14,
			})
			create("UICorner", { Parent = submitBtn, CornerRadius = UDim.new(0, 6) })

			local listOpen = false
			local selection = nil

			-- Options Frame (hanya muncul ketika dropdown dibuka)
			local optionsFrame = create("Frame", {
				Parent = container,
				Size = UDim2.new(1, 0, 0, #options * 25),
				Position = UDim2.new(0, 0, 0, 50),
				BackgroundColor3 = Color3.fromRGB(40, 40, 60),
				Visible = false,
				ZIndex = 10,
			})
			create("UICorner", { Parent = optionsFrame, CornerRadius = UDim.new(0, 6) })

			for i, opt in ipairs(options) do
				local btn = create("TextButton", {
					Parent = optionsFrame,
					Size = UDim2.new(1, 0, 0, 25),
					Position = UDim2.new(0, 0, 0, (i - 1) * 25),
					Text = opt,
					BackgroundColor3 = Color3.fromRGB(50, 50, 70),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.Gotham,
					TextSize = 14,
					ZIndex = 10,
				})
				btn.MouseButton1Click:Connect(function()
					selection = opt
					dropdown.Text = opt
					optionsFrame.Visible = false
					listOpen = false
				end)
			end

			dropdown.MouseButton1Click:Connect(function()
				listOpen = not listOpen
				optionsFrame.Visible = listOpen
			end)

			submitBtn.MouseButton1Click:Connect(function()
				if selection then
					print("Selected option:", selection)
				else
					print("No option selected")
				end
			end)

			tabScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
		end

		return tabObj
	end

	return selfObj
end

return DMZ
