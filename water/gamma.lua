local gamma_data = require 'water.gamma_data'

local gamma = {}

function gamma:__call(pi, tau)
    local energy = 0
    for _, k in ipairs(gamma_data) do
        energy = energy + k[3] * (7.1 - pi) ^ k[1] * (tau - 1.222) ^ k[2]
    end
    return energy
end

function gamma:tau(pi, tau)
    local energy = 0
    for _, k in ipairs(gamma_data) do
        energy = energy + k[3] * k[2] * (7.1 - pi) ^ k[1] * (tau - 1.222) ^ (k[2] - 1)
    end
    return energy
end

function gamma:tau_tau(pi, tau)
    local energy = 0
    for _, k in ipairs(gamma_data) do
        energy = energy + k[3] * k[2] * (k[2] - 1) * (7.1 - pi) ^ k[1] * (tau - 1.222) ^ (k[2] - 2)
    end
    return energy
end

function gamma:pi_tau(pi, tau)
    local energy = 0
    for _, k in ipairs(gamma_data) do
        energy = energy - k[3] * k[1] * k[2] * (7.1 - pi) ^ (k[1] - 1) * (tau - 1.222) ^ (k[2] - 1)
    end
    return energy
end

function gamma:pi(pi, tau)
    local energy = 0
    for _, k in ipairs(gamma_data) do
        energy = energy - k[3] * k[1] * (7.1 - pi) ^ (k[1] - 1) * (tau - 1.222) ^ k[2]
    end
    return energy
end

function gamma:pi_pi(pi, tau)
    local energy = 0
    for _, k in ipairs(gamma_data) do
        energy = energy + k[3] * k[1] * (k[1] - 1) * (7.1 - pi) ^ (k[1] - 2) * (tau - 1.222) ^ k[2]
    end
    return energy
end

local gamma_mt = {
    __call = gamma.__call,
    __index = gamma
}

return setmetatable({}, gamma_mt)
