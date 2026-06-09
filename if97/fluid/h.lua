local R = require 'if97.consts'.R
local phi, get_tau, get_delta = require 'if97.fluid.Helmholtz'
local sqrt = require 'math'.sqrt

local h = {}

h.t_rho = function(t, rho)
    local tau = get_tau(t)
    local delta = get_delta(rho)
    return R * t * (tau * phi:tau(tau, delta) + delta * phi:delta(tau, delta))
end

return h
