local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local Humanoid = nil
local Character = nil
local CurrentWalkSpeed = 16
local InfiniteJumpActive = false
local GodModeActive = false
local InfiniteJumpConnection = nil
local GodModeConnection = nil

local function GetHumanoid()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChild("Humanoid")
    end
    return nil
end

-- --- Основной ScreenGui для меню ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AllInOneMenuGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- --- Главный фрейм меню ---
local Frame = Instance.new("Frame")
Frame.Name = "MainMenuFrame"
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.5, -125, 0.5, -150)
Frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
Frame.Draggable = true
Frame.Parent = ScreenGui

-- --- Заголовок меню ---
local Title = Instance.new("TextLabel")
Title.Name = "TitleLabel"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "Меню функций"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Title.Parent = Frame

-- --- Кнопка сворачивания меню ---
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0.15, 0, 0, 25)
MinimizeButton.Position = UDim2.new(0.83, 0, 0, 5)
MinimizeButton.Text = "-" -- Теперь это кнопка сворачивания
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.TextScaled = true
MinimizeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
MinimizeButton.Parent = Frame

-- --- Иконка для свернутого состояния ---
local MinimizedIcon = Instance.new("TextButton")
MinimizedIcon.Name = "MinimizedHeartIcon"
MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizedIcon.Position = UDim2.new(0, 10, 0, 10) -- Положение иконки
MinimizedIcon.BackgroundColor3 = Color3.new(1, 1, 1) -- Белый фон
MinimizedIcon.BorderColor3 = Color3.new(0, 0, 0) -- Черная обводка
MinimizedIcon.BorderSizePixel = 2
MinimizedIcon.Text = "❤" -- Сердечко (или любой другой символ)
MinimizedIcon.Font = Enum.Font.SourceSansBold
MinimizedIcon.TextColor3 = Color3.new(0.8, 0.2, 0.2) -- Красное сердечко
MinimizedIcon.TextScaled = true
MinimizedIcon.ZIndex = 10 -- Убедимся, что иконка поверх других UI
MinimizedIcon.BackgroundTransparency = 0
MinimizedIcon.Parent = ScreenGui
MinimizedIcon.Visible = false -- Сначала скрыта

-- Сделаем иконку круглой (работает только в Roblox Studio или с UI-плагинами,
-- но для эксплойтера это будет просто квадрат с закруглением, если поддерживается)
MinimizedIcon.BackgroundTransparency = 0
MinimizedIcon.CornerRadius = UDim.new(0.5, 0) -- Закругляем углы на 50%

-- --- Функции показа/скрытия меню и иконки ---
local function ShowMenu()
    Frame.Visible = true
    MinimizedIcon.Visible = false
    ScreenGui.Enabled = true -- Включаем ScreenGui, если был выключен
end

local function HideMenu()
    Frame.Visible = false
    MinimizedIcon.Visible = true
end

-- --- Логика переключателей (Toggle Buttons) ---
local function CreateToggle(name, yOffset, onColor, offColor, defaultState, onToggleFunc)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.9, 0, 0, 40)
    Container.Position = UDim2.new(0.05, 0, 0, 40 + yOffset)
    Container.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Container.Parent = Frame

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

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.25, 0, 0.8, 0)
    ToggleButton.Position = UDim2.new(0.72, 0, 0.1, 0)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.TextScaled = true
    ToggleButton.Parent = Container

    local currentState = defaultState
    local function UpdateToggleState()
        if currentState then
            ToggleButton.BackgroundColor3 = onColor
            ToggleButton.Text = "ВКЛ"
        else
            ToggleButton.BackgroundColor3 = offColor
            ToggleButton.Text = "ВЫКЛ"
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

-- --- Логика слайдера (ползунка) ---
local function CreateSlider(name, yOffset, minVal, maxVal, defaultVal, onValueChangedFunc)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.9, 0, 0, 50)
    Container.Position = UDim2.new(0.05, 0, 0, 40 + yOffset)
    Container.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Container.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0.4, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Text = name .. ": " .. defaultVal
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextScaled = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, 0, 0.4, 0)
    Slider.Position = UDim2.new(0, 0, 0.6, 0)
    Slider.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    Slider.BorderSizePixel = 1
    Slider.BorderColor3 = Color3.new(0.1, 0.1, 0.1)
    Slider.Parent = Container

    local Handle = Instance.new("TextButton")
    Handle.Size = UDim2.new(0, 15, 1, 0)
    Handle.BackgroundColor3 = Color3.new(0.3, 0.5, 0.7)
    Handle.Parent = Slider

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
            local mouseX = math.clamp(mouse.X - Slider.AbsolutePosition.X, 0, Slider.AbsoluteSize.X)
            local ratio = mouseX / Slider.AbsoluteSize.X
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

-- --- Подключения функционала к персонажу ---
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    CurrentWalkSpeed = Humanoid.WalkSpeed
    speedSliderSetter(CurrentWalkSpeed)
    if GodModeActive then
        GodModeConnection = RunService.Heartbeat:Connect(function()
            if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    end
end)

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
end

local function OnGodModeToggle(active)
    GodModeActive = active
    if GodModeConnection then
        GodModeConnection:Disconnect()
        GodModeConnection = nil
    end

    if GodModeActive then
        Humanoid = GetHumanoid()
        if Humanoid then
            GodModeConnection = RunService.Heartbeat:Connect(function()
                if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
                    Humanoid.Health = Humanoid.MaxHealth
                end
            end)
        end
    end
end

local function OnSpeedSliderChange(value)
    CurrentWalkSpeed = value
    Humanoid = GetHumanoid()
    if Humanoid then
        Humanoid.WalkSpeed = CurrentWalkSpeed
    end
end

-- --- Создание элементов управления ---
local infiniteJumpToggle, setInfiniteJumpToggle = CreateToggle("Бесконечный прыжок", 0, Color3.new(0.2, 0.7, 0.2), Color3.new(0.7, 0.2, 0.2), false, OnInfiniteJumpToggle)
local godModeToggle, setGodModeToggle = CreateToggle("Бессмертие", 50, Color3.new(0.2, 0.7, 0.2), Color3.new(0.7, 0.2, 0.2), false, OnGodModeToggle)
local speedSliderSetter = CreateSlider("Скорость", 100, 1, 500, 16, OnSpeedSliderChange)

-- --- Обработчики кнопок и клавиш ---
MinimizeButton.MouseButton1Click:Connect(function()
    HideMenu()
    print("Меню свернуто в иконку. Нажмите на иконку или 'Z' для разворачивания.")
end)

MinimizedIcon.MouseButton1Click:Connect(function()
    ShowMenu()
    print("Меню развернуто.")
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Z and not gameProcessedEvent then
        if Frame.Visible then
            HideMenu()
            print("Меню свернуто в иконку.")
        else
            ShowMenu()
            print("Меню развернуто.")
        end
    end
end)

-- --- Инициализация при первом запуске ---
print("Скрипт меню функций загружен. Нажмите 'Z' для отображения/скрытия меню.")
if LocalPlayer.Character then
    Character = LocalPlayer.Character
    Humanoid = GetHumanoid()
    if Humanoid then
        CurrentWalkSpeed = Humanoid.WalkSpeed
        speedSliderSetter(CurrentWalkSpeed)
    end
end
