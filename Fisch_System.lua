repeat  task.wait() until game:IsLoaded()
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local VIM = game:GetService('VirtualInputManager')
local tloading = tick() + 5
local function SendKey(key,dur)
    VIM:SendKeyEvent(true,key,false,game) task.wait(dur)
    VIM:SendKeyEvent(false,key,false,game)
end
task.spawn(function()
    while true do
        SendKey("Space",.01)
        task.wait(10)
    end
end)