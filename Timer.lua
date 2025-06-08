
timer = {}
timer.__index = timer

function timer.New(iName,iType,iTime,otherArgs)
    local newTimer = {}

    newTimer.Name = iName
    newTimer.Type = iType
    newTimer.Wait = iTime
    newTimer.ElaspedTime = 0
    newTimer.Finished = false

    if iType=="FireCooldown" then
        newTimer.Unit = otherArgs[1]
    end

    setmetatable(newTimer, timer)
    return newTimer
end

function timer:OnFinish()
    self.Finished = true
    if self.Type=="FireCooldown" then
        products = self.Unit:Fire()
        local newTimer = self.New(self.Name,self.Type,(self.Wait+(math.random(-8,8)/10)),{self.Unit})
        return {newTimer,products}
    end
end

return timer