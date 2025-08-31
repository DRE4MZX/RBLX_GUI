--// DMZ GUI Framework v3
--// Author: Dreamz
--// Style: RayHub/NFT Inspired
--// Features: Drag, Resize, Toggle, Slider, Dropdown

local DMZ = {}
DMZ.__index = DMZ

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--// Utility
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

--// Main Window
function DMZ:CreateWindow(title)
    local ScreenGui = create("ScreenGui", {Parent = LocalPlayer:WaitForChild("PlayerGui"), ResetOnSpawn = false})
    local Frame = create("Frame", {
        Parent = ScreenGui,
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.3, -200, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(20, 20, 30),
        BorderSizePixel = 0,
    })
    Frame.ClipsDescendants = true
    create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 12)})
    create("UIStroke", {Parent = Frame, Color = Color3.fromRGB(85,0,255), Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})

    local TitleBar = create("Frame", {Parent = Frame, Size = UDim2.new(1,0,0,30), BackgroundColor3 = Color3.fromRGB(30,30,40), BorderSizePixel = 0})
    create("UICorner", {Parent = TitleBar, CornerRadius = UDim.new(0,12)})
    local TitleText = create("TextLabel", {
        Parent = TitleBar, Text = title,
        Size = UDim2.new(1,-60,1,0), Position = UDim2.new(0,10,0,0),
        Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 16, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
    })
    local CloseButton = create("TextButton", {
        Parent = TitleBar,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0, 2),
        Text = "X",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 100, 100),
        TextSize = 20,
        BackgroundColor3 = Color3.fromRGB(30,30,40),
        ZIndex = 5,
    })

    create("UICorner", {Parent = CloseButton, CornerRadius = UDim.new(0,4)})

    -- Hover effect
    CloseButton.MouseEnter:Connect(function()
        tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255,50,50)}, 0.15)
    end)
    CloseButton.MouseLeave:Connect(function()
        tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(30,30,40)}, 0.15)
    end)

    -- Close logic
    CloseButton.MouseButton1Click:Connect(function()
        tween(Frame, {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.4,0,0.5,0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)

    local Content = create("Frame", {Parent = Frame, Size = UDim2.new(1,0,1,-30), Position = UDim2.new(0,0,0,30), BackgroundTransparency = 1})

    -- Drag
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Resize
    local ResizeHandle = create("Frame", {
        Parent = Frame,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 1, -20),
        BackgroundTransparency = 1,
        ZIndex = 2
    })
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local startSize = Frame.Size
            local startPosMouse = input.Position
            local conn
            conn = UserInputService.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = i.Position - startPosMouse
                    Frame.Size = UDim2.new(
                        startSize.X.Scale, math.max(200, startSize.X.Offset + delta.X),
                        startSize.Y.Scale, math.max(150, startSize.Y.Offset + delta.Y)
                    )
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    conn:Disconnect()
                end
            end)
        end
    end)

    -- Close
    CloseButton.MouseButton1Click:Connect(function()
        tween(Frame, {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)

    local window = setmetatable({}, DMZ)
    window.Content = Content
    window._yOffset = 0
    return window
end

-- Toggle (sama seperti sebelumnya)
function DMZ:CreateToggle(name, default, callback)
    local Toggle = create("TextButton", {
        Parent = self.Content, Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,self._yOffset),
        BackgroundColor3 = Color3.fromRGB(35,35,50), Text = ""
    })
    create("UICorner", {Parent = Toggle, CornerRadius = UDim.new(0,8)})

    local Label = create("TextLabel", {
        Parent = Toggle, Text = name, Size = UDim2.new(1,-50,1,0), Position = UDim2.new(0,10,0,0),
        Font = Enum.Font.Gotham, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 14, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
    })

    local State = default or false
    local Indicator = create("Frame", {
        Parent = Toggle, Size = UDim2.new(0,20,0,20), Position = UDim2.new(1,-30,0.5,-10),
        BackgroundColor3 = State and Color3.fromRGB(0,255,140) or Color3.fromRGB(70,70,90)
    })
    create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1,0)})

    Toggle.MouseButton1Click:Connect(function()
        State = not State
        tween(Indicator, {BackgroundColor3 = State and Color3.fromRGB(0,255,140) or Color3.fromRGB(70,70,90)},0.2)
        if callback then callback(State) end
    end)

    self._yOffset = self._yOffset + 45
end

-- Slider (fix bug dengan AbsoluteSize update)
function DMZ:CreateSlider(name, min, max, default, callback)
    local SliderFrame = create("Frame", {
        Parent = self.Content, Size = UDim2.new(1,-20,0,50), Position = UDim2.new(0,10,0,self._yOffset),
        BackgroundColor3 = Color3.fromRGB(35,35,50)
    })
    create("UICorner", {Parent = SliderFrame, CornerRadius = UDim.new(0,8)})

    local Label = create("TextLabel", {
        Parent = SliderFrame, Text = name.." "..default, Size = UDim2.new(1,-20,0,20), Position = UDim2.new(0,10,0,5),
        Font = Enum.Font.Gotham, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 14, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
    })

    local Bar = create("Frame", {Parent = SliderFrame, Size = UDim2.new(1,-20,0,8), Position = UDim2.new(0,10,0,30), BackgroundColor3 = Color3.fromRGB(70,70,90)})
    create("UICorner", {Parent = Bar, CornerRadius = UDim.new(0,4)})
    local Knob = create("Frame", {Parent = Bar, Size = UDim2.new((default-min)/(max-min),0,1,0), BackgroundColor3 = Color3.fromRGB(0,255,140)})
    create("UICorner", {Parent = Knob, CornerRadius = UDim.new(0,4)})

    local dragging = false
    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    local function updateSlider()
        if Bar.AbsoluteSize.X > 0 then
            local mouseX = math.clamp(UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X, 0, Bar.AbsoluteSize.X)
            local value = min + (mouseX / Bar.AbsoluteSize.X) * (max - min)
            Knob.Size = UDim2.new(mouseX/Bar.AbsoluteSize.X,0,1,0)
            Label.Text = name.." "..math.floor(value)
            if callback then callback(value) end
        end
    end
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider()
        end
    end)

    self._yOffset = self._yOffset + 55
end

-- Dropdown (fix bug clipping & scroll)
function DMZ:CreateDropdown(name, options, callback)
    local Dropped = false
    local Dropdown = create("TextButton", {
        Parent = self.Content, Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,self._yOffset),
        BackgroundColor3 = Color3.fromRGB(35,35,50), Text = ""
    })
    create("UICorner", {Parent = Dropdown, CornerRadius = UDim.new(0,8)})

    local Label = create("TextLabel", {
        Parent = Dropdown, Text = name, Size = UDim2.new(1,-40,1,0), Position = UDim2.new(0,10,0,0),
        Font = Enum.Font.Gotham, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 14, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
    })
    local Arrow = create("TextLabel", {Parent = Dropdown, Text = "▼", Size = UDim2.new(0,20,0,20), Position = UDim2.new(1,-30,0.5,-10),
        Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 14, BackgroundTransparency = 1
    })

    local OptionsFrame = create("Frame", {Parent = self.Content, Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,10,0, self._yOffset + 40),
        BackgroundColor3 = Color3.fromRGB(40,40,60), Visible = false, ClipsDescendants = true
    })
    create("UICorner", {Parent = OptionsFrame, CornerRadius = UDim.new(0,8)})
    local UIListLayout = create("UIListLayout", {Parent = OptionsFrame, Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder})

    for _,opt in pairs(options) do
        local Btn = create("TextButton", {
            Parent = OptionsFrame, Text = opt, Size = UDim2.new(1,0,0,30),
            BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.Gotham, TextSize = 14
        })
        Btn.MouseButton1Click:Connect(function()
            Label.Text = name.." - "..opt
            if callback then callback(opt) end
            OptionsFrame.Visible = false
            Dropped = false
            Arrow.Text = "▼"
        end)
    end

    Dropdown.MouseButton1Click:Connect(function()
        Dropped = not Dropped
        if Dropped then
            OptionsFrame.Visible = true
            local totalHeight = #OptionsFrame:GetChildren() * 32
            tween(OptionsFrame, {Size = UDim2.new(1,0,0,totalHeight)}, 0.2)
            Arrow.Text = "▲"
        else
            tween(OptionsFrame, {Size = UDim2.new(1,0,0,0)}, 0.2)
            wait(0.2)
            OptionsFrame.Visible = false
            Arrow.Text = "▼"
        end
    end)

    self._yOffset = self._yOffset + 45
end

return DMZ
