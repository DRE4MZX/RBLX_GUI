--// Module: GUIManager
local GUIManager = {}
GUIManager.__index = GUIManager

-- Helper to make UI objects
local function create(instanceType, props)
    local obj = Instance.new(instanceType)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

-- Constructor
function GUIManager.new()
    local self = setmetatable({}, GUIManager)

    -- ScreenGui
    self.ScreenGui = create("ScreenGui", {
        Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false
    })

    -- Main Frame
    self.MainFrame = create("Frame", {
        Parent = self.ScreenGui,
        Size = UDim2.new(0, 300, 0, 200),
        Position = UDim2.new(0.3, 0, 0.3, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })

    -- Top Bar
    self.TopBar = create("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 0
    })

    -- Title
    self.Title = create("TextLabel", {
        Parent = self.TopBar,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = "My GUI Panel",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Close Button
    self.CloseButton = create("TextButton", {
        Parent = self.TopBar,
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })

    self.CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)

    -- Resize Handle
    self.ResizeHandle = create("TextButton", {
        Parent = self.MainFrame,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 1, -20),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        Text = "↘",
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })

    local UIS = game:GetService("UserInputService")
    local resizing = false
    self.ResizeHandle.MouseButton1Down:Connect(function()
        resizing = true
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UIS:GetMouseLocation()
            local guiPos = self.MainFrame.AbsolutePosition
            self.MainFrame.Size = UDim2.new(0, mousePos.X - guiPos.X, 0, mousePos.Y - guiPos.Y)
        end
    end)

    return self
end

-- Add Toggle Button
function GUIManager:AddToggle(name, callback)
    local toggle = create("TextButton", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
        callback(state)
    end)
end

-- Add Slider
function GUIManager:AddSlider(name, min, max, callback)
    local sliderFrame = create("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 80),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0
    })

    local slider = create("Frame", {
        Parent = sliderFrame,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 170, 0),
        BorderSizePixel = 0
    })

    local UIS = game:GetService("UserInputService")
    local dragging = false
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            slider.Size = UDim2.new(relX, 0, 1, 0)
            local value = min + (max - min) * relX
            callback(value)
        end
    end)
end

-- Add Dropdown
function GUIManager:AddDropdown(name, options, callback)
    local dropdown = create("TextButton", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 120),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })

    local frame = create("Frame", {
        Parent = dropdown,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, #options * 30),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Visible = false
    })

    for i, opt in ipairs(options) do
        local optBtn = create("TextButton", {
            Parent = frame,
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, (i - 1) * 30),
            Text = opt,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })
        optBtn.MouseButton1Click:Connect(function()
            callback(opt)
            frame.Visible = false
            dropdown.Text = opt
        end)
    end

    dropdown.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)
end

return GUIManager
