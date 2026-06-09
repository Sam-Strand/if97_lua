local n_1 = 1.0658070028513
local data = require 'if97.fluid.data'

local phi = {}

--[1] φ
function phi:__call(tau, delta)
    local energy = n_1 * math.log(delta)
    for _, k in ipairs(data) do
        energy = energy + k[3] * delta ^ k[1] * tau ^ k[2]
    end
    return energy
end

--[2] φ_τ
function phi:tau(tau, delta)
    local energy = 0.0
    for _, k in ipairs(data) do
        energy = energy + k[3] * delta ^ k[1] * k[2] * tau ^ (k[2] - 1)
    end
    return energy
end

--[3] φ_ττ
function phi:tau_tau(tau, delta)
    local energy = 0.0
    for _, k in ipairs(data) do
        energy = energy + k[3] * delta ^ k[1] * k[2] * (k[2] - 1) * tau ^ (k[2] - 2)
    end
    return energy
end

--[4] φ_δ
function phi:delta(tau, delta)
    local energy = n_1 / delta
    for _, k in ipairs(data) do
        energy = energy + k[3] * k[1] * delta ^ (k[1] - 1) * tau ^ k[2]
    end
    return energy
end

--[5] φ_δδ
function phi:delta_delta(tau, delta)
    local energy = -n_1 / delta ^ 2
    for _, k in ipairs(data) do
        energy = energy + k[3] * k[1] * (k[1] - 1) * delta ^ (k[1] - 2) * tau ^ k[2]
    end
    return energy
end

--[6] φ_δτ
function phi:delta_tau(tau, delta)
    local energy = 0.0
    for _, k in ipairs(data) do
        energy = energy + k[3] * k[1] * delta ^ (k[1] - 1) * k[2] * tau ^ (k[2] - 1)
    end
    return energy
end

local function get_tau(t)
    return 647.096 / t
end

local function get_delta(rho)
    return rho / 322
end

local phi_mt = {
    __call = phi.__call,
    __index = phi
}

return setmetatable({}, phi_mt), get_tau, get_delta
