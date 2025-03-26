--Services
local Players = game:GetService("Players")

-- CONTANTS
local WAIT_INTERVAL = 2

-- Members
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network:Folder = ReplicatedStorage:WaitForChild("Network")
local InGameTimeUpdated:RemoteEvent = Network:WaitForChild("InGameTimeUpdated")
local minutesAfterMidnight:number
local actualTime = 540

while true do
    if actualTime >= 1440 then
        actualTime -= 1440
    end
    actualTime += 0.8
    InGameTimeUpdated:FireAllClients(actualTime)

    print("Actual Time: "..actualTime)
    task.wait(WAIT_INTERVAL)
end