repeat  task.wait() until game:IsLoaded()
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local VIM = game:GetService('VirtualInputManager')
local tloading = tick() + 5
local loading
repeat task.wait()
    loading = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("loading")
until tick() >= tloading or loading

while loading and loading.Enabled do task.wait()
    if loading.Enabled and loading.loading.skip.Visible then
        local skip = loading.loading.skip
        skip.AnchorPoint = Vector2.new(.5,.5)
        skip.Position = UDim2.fromScale(.5,.5)
        skip.Size = UDim2.fromScale(9999,9999)
        print("Skip")
    end
    local Vector = {workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2}
    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, true, game, 1)
    VIM:SendMouseButtonEvent(Vector[1],Vector[2], 0, false, game, 1)
end 
local function Press(args)
    game:GetService('VirtualInputManager'):SendKeyEvent(
        true,
        args,
        false,
        game.Players.LocalPlayer.Character.HumanoidRootPart
    )
    wait()
    game:GetService('VirtualInputManager'):SendKeyEvent(
        false,
        args,
        false,
        game.Players.LocalPlayer.Character.HumanoidRootPart
    )
end
task.spawn(function()
    while true do
        Press('Space')
        task.wait(10)
    end
end)