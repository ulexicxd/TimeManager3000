
-- default config simply makes a timer
local defaultConfig = {
    Interval = 1,
    CurrentTick = 0,
    CountingUp = true,
    AutoStart = false,
    Started = false,
    Ended = false
}

local TimeManager = {}
TimeManager.__index = TimeManager

function TimeManager.new(config)
    local self = setmetatable(table.clone(defaultConfig), TimeManager)

    for key, value in pairs(config) do
        self[key] = value
    end

    if self.AutoStart then
        self:Start()
    end

    task.spawn(function()
        while task.wait(self.Interval) do
            if self.Ended then
                break
            else
                if self.Started then
                    self.CurrentTick = self.CurrentTick + (self.CountingUp and 1 or -1)

                    if self.OnTick then self.OnTick(self.CurrentTick) end

                    if self.TargetTick then
                        if self.CurrentTick == self.TargetTick then
                            self:Stop()
                            if self.OnEnd  then self.OnEnd(self.CurrentTick)  end
                            self.Ended = true
                            break
                        end
                    end
                end
            end
        end
    end)

    return self
end

function TimeManager:Start()
    self.Started = true
end

function TimeManager:Stop()
    self.Started = false
end

function TimeManager:End()
    self.Ended = true
end

return TimeManager