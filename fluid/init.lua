local fluid = {}
local n1 = 1.0658070028513
local data = require 'fluid.data'

local case = {
    --[1] φ
    function(tau, delta, energy)
        energy = n1 * math.log(delta)
        for _, k in ipairs(data) do
            energy = energy + k[3] * delta ^ k[1] * tau ^ k[2]
        end
        return energy
    end,
    --[2] φτ
    function(tau, delta, energy)
        for _, k in ipairs(data) do
            energy = energy + k[3] * delta ^ k[1] * k[2] * tau ^ (k[2] - 1)
        end
        return energy
    end,
    --[3] φττ
    function(tau, delta, energy)
        for _, k in ipairs(data) do
            energy = energy + k[3] * delta ^ k[1] * k[2] * (k[2] - 1) * tau ^ (k[2] - 2)
        end
        return energy
    end,
    --[4] φδ
    function(tau, delta, energy)
        energy = n1 / delta
        for _, k in ipairs(data) do
            energy = energy + k[3] * k[1] * delta ^ (k[1] - 1) * tau ^ k[2]
        end
        return energy
    end,
    --[5] φδδ
    function(tau, delta, energy)
        energy = -n1 / delta ^ 2
        for _, k in ipairs(data) do
            energy = energy + k[3] * k[1] * (k[1] - 1) * delta ^ (k[1] - 2) * tau ^ k[2]
        end
        return energy
    end,
    --[6] φδτ
    function(tau, delta, energy)
        for _, k in ipairs(data) do
            energy = energy + k[3] * k[1] * delta ^ (k[1] - 1) * k[2] * tau ^ (k[2] - 1)
        end
        return energy
    end
}
local function JF(tau, delta, trigger)
    return case[trigger](tau, delta, 0)
end

local t0 = 373.946
local rho0 = 322
local CtoK = 273.15
local R = 461.526

fluid.i = {
    t_rho = function(t, rho)
        t = t + CtoK
        local tau, delta = t0 / t, rho / rho0
        return (tau * JF(tau, delta, 2) + delta * JF(tau, delta, 4)) * R * t
    end
}

fluid.w = {
    t_rho = function(t, rho)
        t = t + CtoK
        local tau, delta = t0 / t, rho / rho0
        local JF4 = JF(tau, delta, 4)
        return
            ((
                2 * JF4 / delta +
                JF(tau, delta, 5) -
                (JF4 - tau * JF(tau, delta, 6)) ^ 2 /
                (tau ^ 2 * JF(tau, delta, 3))
            ) * R * t * delta ^ 2) ^ 0.5
    end
}

fluid.cv = {
    t_rho = function(t, rho)
        local tau, delta = t0 / (t + CtoK), rho / rho0
        return -(tau) ^ 2 * JF(tau, delta, 3) * R
    end
}

fluid.cp = {
    t_rho = function(t, rho)
        local tau, delta = t0 / (t + CtoK), rho / rho0
        local JF4 = JF(tau, delta, 4)
        return (
            -tau ^ 2 * JF(tau, delta, 3) +
            ((JF4 - tau * JF(tau, delta, 6))) ^ 2 /
            (2 * JF4 / delta + JF(tau, delta, 5))
        ) * R
    end
}

fluid.s = {
    t_rho = function(t, rho)
        local tau, delta = t0 / (t + CtoK), rho / rho0
        return R * (tau * JF(tau, delta, 2) - JF(tau, delta, 1))
    end
}

fluid.p = {
    t_rho = function(t, rho)
        t = t + CtoK
        local tau, delta = t0 / t, rho / rho0
        return JF(tau, delta, 4) * rho * delta * R * t
    end
}


return fluid
