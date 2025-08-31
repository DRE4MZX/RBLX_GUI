--// DMZ GUI Framework
--// Author: Dreamz
--// Style: RayHub/NFT Inspired
--// Features: Drag, Resize, Toggle, Slider, Dropdown

-- Create a library table
local DMZ = {}
DMZ.__index = DMZ

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
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
        Position = UDim2.new(0.5, -200, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(20, 20, 30),
        BorderSizePixel = 0,
    })
    Frame.ClipsDescendants = true

    local UICorner = create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 12)})
    local UIStroke = create("UIStroke", {
        Parent = Frame,
        Color = Color3.fromRGB(85, 0, 255),
        Thickness = 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })

    local TitleBar = create("Frame", {
        Parent = Frame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
    })
    create("UICorner", {Parent = TitleBar, CornerRadius = UDim.new(0, 12)})

    local TitleText = create("TextLabel", {
        Parent = TitleBar,
        Text = title,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local CloseButton = create("TextButton", {
        Parent = TitleBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 100, 100),
        TextSize = 18,
        BackgroundTransparency = 1,
    })

    local Content = create("Frame", {
        Parent = Frame,
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
    })

    --// Dragging
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

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    --// Close
    CloseButton.MouseButton1Click:Connect(function()
        tween(Frame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)

    local window = setmetatable({}, DMZ)
    window.Content = Content
    return window
end

--// Toggle
function DMZ:CreateToggle(name, default, callback)
    local Toggle = create("TextButton", {
        Parent = self.Content,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, #self.Content:GetChildren()*45),
        BackgroundColor3 = Color3.fromRGB(35, 35, 50),
        Text = "",
    })
    create("UICorner", {Parent = Toggle, CornerRadius = UDim.new(0, 8)})

    local Label = create("TextLabel", {
        Parent = Toggle,
        Text = name,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local State = default or false
    local Indicator = create("Frame", {
        Parent = Toggle,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundColor3 = State and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(70, 70, 90),
    })
    create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1, 0)})

    Toggle.MouseButton1Click:Connect(function()
        State = not State
        tween(Indicator, {BackgroundColor3 = State and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(70, 70, 90)}, 0.2)
        if callback then callback(State) end
    end)
end

return DMZ
