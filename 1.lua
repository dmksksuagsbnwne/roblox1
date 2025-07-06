local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Humanoid = nil
local CurrentWalkSpeed = 16
local InfiniteJumpActive = false
local GodModeActive = false
local InfiniteJumpConnection = nil
local GodModeConnection = nil

-- Function to safely get the Humanoid
local function GetHumanoid()
    if LocalPlayer and LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChild("Humanoid")
    end
    return nil
end

-- --- Main ScreenGui for the menu ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AllInOneMenuGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
print("ScreenGui created and parented to PlayerGui.")

-- --- Main menu frame ---
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainMenuFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
print("MainFrame created and parented to ScreenGui.")

-- --- Menu title ---
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Text = "Functions Menu"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextScaled = true
TitleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TitleLabel.Parent = MainFrame
print("TitleLabel created.")

-- --- Minimize button ---
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0.15, 0, 0, 25)
MinimizeButton.Position = UDim2.new(0.83, 0, 0, 5)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.TextScaled = true
MinimizeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
MinimizeButton.Parent = MainFrame
print("MinimizeButton created.")

-- --- Minimized icon (heart) ---
local MinimizedIcon = Instance.new("TextButton")
MinimizedIcon.Name = "MinimizedHeartIcon"
MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizedIcon.Position = UDim2.new(0, 10, 0, 10)
MinimizedIcon.BackgroundColor3 = Color3.new(1, 1, 1)
MinimizedIcon.BorderColor3 = Color3.new(0, 0, 0)
MinimizedIcon.BorderSizePixel = 2
MinimizedIcon.Text = "❤"
MinimizedIcon.Font = Enum.Font.SourceSansBold
MinimizedIcon.TextColor3 = Color3.new(0.8, 0.2, 0.2)
MinimizedIcon.TextScaled = true
MinimizedIcon.ZIndex = 10
MinimizedIcon.BackgroundTransparency = 0
MinimizedIcon.Parent = ScreenGui
MinimizedIcon.Visible = false
MinimizedIcon.CornerRadius = UDim.new(0.5, 0)
print("MinimizedIcon created.")

-- --- Show/Hide menu functions ---
local function ShowMenu()
    MainFrame.Visible = true
    MinimizedIcon.Visible = false
    print("Menu shown.")
end

local function HideMenu()
    MainFrame.Visible = false
    MinimizedIcon.Visible = true
    print("Menu hidden, icon shown.")
}

-- --- Toggle Button Creator ---
local function CreateToggle(name, yOffset, onColor, offColor, defaultState, onToggleFunc)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.9, 0, 0, 40)
    Container.Position = UDim2.new(0.05, 0, 0, 40 + yOffset)
    Container.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Container.Parent = MainFrame
    print("Toggle Container for " .. name .. " created.")

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Text = name
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextScaled = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.Parent = Container
    print("Label for " .. name .. " created.")

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.25, 0, 0.8, 0)
    ToggleButton.Position = UDim2.new(0.72, 0, 0.1, 0)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.TextScaled = true
    ToggleButton.Parent = Container
    print("ToggleButton for " .. name .. " created.")

    local currentState = defaultState
    local function UpdateToggleState()
        if currentState then
            ToggleButton.BackgroundColor3 = onColor
            ToggleButton.Text = "ON"
        else
            ToggleButton.BackgroundColor3 = offColor
            ToggleButton.Text = "OFF"
        end
        onToggleFunc(currentState)
    end

    ToggleButton.MouseButton1Click:Connect(function()
        currentState = not currentState
        UpdateToggleState()
    end)

    UpdateToggleState()
    return ToggleButton, function(newState) currentState = newState UpdateToggleState() end
end

-- --- Slider Creator ---
local function CreateSlider(name, yOffset, minVal, maxVal, defaultVal, onValueChangedFunc)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.9, 0, 0, 50)
    Container.Position = UDim2.new(0.05, 0, 0, 40 + yOffset)
    Container.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Container.Parent = MainFrame
    print("Slider Container for " .. name .. " created.")

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0.4, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Text = name .. ": " .. defaultVal
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextScaled = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    print("Slider Label for " .. name .. " created.")

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0.4, 0)
    SliderFrame.Position = UDim2.new(0, 0, 0.6, 0)
    SliderFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    SliderFrame.BorderSizePixel = 1
    SliderFrame.BorderColor3 = Color3.new(0.1, 0.1, 0.1)
    SliderFrame.Parent = Container
    print("SliderFrame for " .. name .. " created.")

    local Handle = Instance.new("TextButton")
    Handle.Size = UDim2.new(0, 15, 1, 0)
    Handle.BackgroundColor3 = Color3.new(0.3, 0.5, 0.7)
    Handle.Parent = SliderFrame
    print("Slider Handle for " .. name .. " created.")

    local isDragging = false
    local currentValue = defaultVal
    local mouse = Players.LocalPlayer:GetMouse()

    Handle.MouseButton1Down:Connect(function()
        isDragging = true
        Handle.BackgroundColor3 = Color3.new(0.4, 0.6, 0.8)
    end)

    mouse.Button1Up:Connect(function()
        isDragging = false
        Handle.BackgroundColor3 = Color3.new(0.3, 0.5, 0.7)
    end)

    mouse.Move:Connect(function()
        if isDragging then
            local mouseX = math.clamp(mouse.X - SliderFrame.AbsolutePosition.X, 0, SliderFrame.AbsoluteSize.X)
            local ratio = mouseX / SliderFrame.AbsoluteSize.X
            currentValue = math.floor(minVal + (maxVal - minVal) * ratio)
            Handle.Position = UDim2.new(ratio, 0, 0, 0)
            Label.Text = name .. ": " .. currentValue
            onValueChangedFunc(currentValue)
        end
    end)

    local function SetSliderValue(value)
        currentValue = math.clamp(value, minVal, maxVal)
        local ratio = (currentValue - minVal) / (maxVal - minVal)
        Handle.Position = UDim2.new(ratio, 0, 0, 0)
        Label.Text = name .. ": " .. currentValue
        onValueChangedFunc(currentValue)
    end

    SetSliderValue(defaultVal)
    return SetSliderValue
end

-- --- Cheat Activation/Deactivation Functions ---
local function OnInfiniteJumpToggle(active)
    InfiniteJumpActive = active
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end

    if InfiniteJumpActive then
        InfiniteJumpConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if input.UserInputType == Enum.UserInputType.Keyboard and not gameProcessedEvent then
                Humanoid = GetHumanoid()
                if Humanoid then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
    print("Infinite Jump: " .. (active and "ON" or "OFF"))
end

local function OnGodModeToggle(active)
    GodModeActive = active
    if GodModeConnection then
        GodModeConnection:Disconnect()
        GodModeConnection = nil
    end

    if GodModeActive then
        GodModeConnection = RunService.Heartbeat:Connect(function()
            Humanoid = GetHumanoid()
            if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    end
    print("God Mode: " .. (active and "ON" or "OFF"))
end

local function OnWalkSpeedChange(value)
    CurrentWalkSpeed = value
    Humanoid = GetHumanoid()
    if Humanoid then
        Humanoid.WalkSpeed = CurrentWalkSpeed
    end
    print("WalkSpeed set to: " .. value)
end

-- --- Create UI elements ---
-- The yOffset parameter is the vertical position relative to the top of the menu frame.
-- Each item adds about 50 units (40 for toggle/50 for slider + padding)
local _, setInfiniteJumpToggle = CreateToggle("Infinite Jump", 0, Color3.new(0.2, 0.7, 0.2), Color3.new(0.7, 0.2, 0.2), false, OnInfiniteJumpToggle)
local _, setGodModeToggle = CreateToggle("God Mode", 50, Color3.new(0.2, 0.7, 0.2), Color3.new(0.7, 0.2, 0.2), false, OnGodModeToggle)
local setSpeedSliderValue = CreateSlider("WalkSpeed", 100, 1, 500, 16, OnWalkSpeedChange)

-- --- Event Handlers ---
MinimizeButton.MouseButton1Click:Connect(function()
    HideMenu()
})

MinimizedIcon.MouseButton1Click:Connect(function()
    ShowMenu()
})

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Z and not gameProcessedEvent then
        if MainFrame.Visible then
            HideMenu()
        else
            ShowMenu()
        end
    end
end)

-- --- Initialization on script start and character spawn ---
LocalPlayer.CharacterAdded:Connect(function(char)
    Humanoid = char:WaitForChild("Humanoid")
    CurrentWalkSpeed = Humanoid.WalkSpeed
    setSpeedSliderValue(CurrentWalkSpeed) -- Update slider with current speed
    if GodModeActive then
        OnGodModeToggle(true) -- Re-activate God Mode for new Humanoid
    end
    print("Character spawned, Humanoid initialized.")
})

-- Initial setup if character already loaded
if LocalPlayer.Character then
    Humanoid = GetHumanoid()
    if Humanoid then
        CurrentWalkSpeed = Humanoid.WalkSpeed
        setSpeedSliderValue(CurrentWalkSpeed)
    end
end

print("Functions Menu script loaded. Press 'Z' to toggle visibility.")
print("If the menu is empty, check the console for errors and ensure the script is loaded properly.")
