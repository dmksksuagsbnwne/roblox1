local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name, gui.IgnoreGuiInset = "CustomMenu", true

local neon, dark, MAX = Color3.fromRGB(0,178,255), Color3.fromRGB(20,20,20), 250
local settings = {speed=16, speedOn=true, infJump=false, god=false, noclip=false}
local path = "CustomMenuSettings.json"
if isfile and isfile(path) then
    local ok,data = pcall(readfile, path)
    if ok then
        local s = HttpService:JSONDecode(data)
        for k,v in pairs(s) do if settings[k]~=nil then settings[k]=v end end
    end
end

local function save()
    if writefile then
        writefile(path, HttpService:JSONEncode(settings))
    end
end

local function center(w,h)
    local v = workspace.CurrentCamera.ViewportSize
    return UDim2.new(0,(v.X-w)/2,0,(v.Y-h)/2)
end

local icon = Instance.new("TextButton", gui)
icon.Size, icon.Position = UDim2.new(0,50,0,50), UDim2.new(1,-60,0.5,-25)
icon.Text, icon.Font, icon.TextScaled = "1", Enum.Font.GothamBold, true
icon.TextColor3, icon.BackgroundColor3 = neon, dark
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

local menu = Instance.new("Frame", gui)
menu.Size, menu.Position = UDim2.new(0,340,0,380), center(340,380)
menu.BackgroundColor3, menu.BackgroundTransparency = dark, 0.25
menu.BorderColor3, menu.Active, menu.Visible = neon, true, false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,12)

local function placeIcon()
    icon.Position = menu.Position + UDim2.new(0, menu.Size.X.Offset+10, 0, 10)
end
local function placeMenu()
    menu.Position = icon.Position - UDim2.new(0, menu.Size.X.Offset+10, 0, 10)
end
placeIcon()

local close = Instance.new("TextButton", menu)
close.Size, close.Position, close.Text, close.Font, close.TextScaled = UDim2.new(0,28,0,28), UDim2.new(1,-38,0,10), "X", Enum.Font.GothamBold, true
close.TextColor3, close.BackgroundColor3, close.BorderColor3 = neon, dark, neon
Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

local function tgl(text,y,key)
    local b = Instance.new("TextButton", menu)
    b.Size, b.Position = UDim2.new(1,-20,0,35), UDim2.new(0,10,0,y)
    b.BackgroundColor3, b.BorderColor3 = dark, neon
    b.Font, b.TextScaled, b.TextColor3 = Enum.Font.Gotham, true, neon
    b.AutoButtonColor = false
    b.Text = text..": "..(settings[key] and "ON" or "OFF")
    b.MouseButton1Click:Connect(function()
        settings[key] = not settings[key]
        b.Text = text..": "..(settings[key] and "ON" or "OFF")
        save()
    end)
    return b
end

local infB = tgl("Infinite Jump",60,"infJump")
local godB = tgl("God Mode",100,"god")
local nocB = tgl("Noclip",140,"noclip")
local spdB = tgl("Enable Speed",180,"speedOn")

local lbl = Instance.new("TextLabel", menu)
lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(1,-20,0,25), UDim2.new(0,10,0,220), 1
lbl.Font, lbl.TextScaled, lbl.TextColor3 = Enum.Font.Gotham, true, neon
lbl.TextXAlignment = Enum.TextXAlignment.Left

local inp = Instance.new("TextBox", menu)
inp.Size, inp.Position = UDim2.new(0,60,0,30), UDim2.new(0,10,0,260)
inp.BackgroundColor3, inp.BorderColor3 = dark, neon
inp.Font, inp.TextScaled, inp.TextColor3 = Enum.Font.Gotham, true, neon
inp.ClearTextOnFocus = false

local bar = Instance.new("Frame", menu)
bar.Size, bar.Position = UDim2.new(1,-90,0,20), UDim2.new(0,80,0,270)
bar.BackgroundColor3, bar.BorderColor3 = dark, neon
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,10)

local handle = Instance.new("Frame", bar)
handle.BackgroundColor3, handle.BorderColor3 = neon, neon
handle.Active = true
Instance.new("UICorner", handle).CornerRadius = UDim.new(0,10)

local function updSpeed(v)
    v = math.clamp(tonumber(v) or settings.speed,1,MAX)
    settings.speed = v
    lbl.Text = "Speed: "..v
    inp.Text = tostring(v)
    handle.Size = UDim2.new(v/MAX,0,1,0)
    if settings.speedOn and player.Character then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end
    save()
end

inp.Text = tostring(settings.speed)
inp.FocusLost:Connect(function() updSpeed(inp.Text) end)

local sliding = false
local function barInput(beg)
    sliding = beg
end
bar.InputBegan:Connect(function(i) if i.UserInputType.Value>=0 then barInput(true) end end)
bar.InputEnded:Connect(function() barInput(false) end)
handle.InputBegan:Connect(function(i) if i.UserInputType.Value>=0 then barInput(true) end end)
handle.InputEnded:Connect(function() barInput(false) end)

UserInputService.InputChanged:Connect(function(i)
    if sliding then
        local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
        updSpeed(1 + math.floor(rel*(MAX-1)))
    end
end)

icon.MouseButton1Click:Connect(function()
    placeMenu(); menu.Visible=true; icon.Visible=false
end)
close.MouseButton1Click:Connect(function()
    menu.Visible=false; placeIcon(); icon.Visible=true
end)

UserInputService.JumpRequest:Connect(function()
    if settings.infJump and player.Character then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    local c = player.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    local root = c:FindFirstChild("HumanoidRootPart")
    if settings.god and h then h.Health=h.MaxHealth; h:SetStateEnabled(Enum.HumanoidStateType.Dead,false) end
    if root and root.Position.Y<workspace.FallenPartsDestroyHeight then root.CFrame=CFrame.new(0,10,0); if h then h.Health=h.MaxHealth end end
    for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = not settings.noclip end end
    if h and settings.speedOn then h.WalkSpeed = settings.speed end
end)

player.CharacterAdded:Connect(function(c) c:WaitForChild("Humanoid").WalkSpeed = settings.speed end)

updSpeed(settings.speed)
