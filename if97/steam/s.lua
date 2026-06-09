local gamma = require 'if97.steam.Gibbs'.gamma
local get_tau = require 'if97.steam.Gibbs'.get_tau
local R = require 'if97.consts'.R

local s = {}

function s.t_p(t, p)
    local tau = get_tau(t)
    local pi = p
    local gamma_0_tau = gamma:ideal_tau(tau)
    local gamma_r_tau = gamma:residual_tau(pi, tau)
    local gamma_0 = gamma:ideal(pi, tau)
    local gamma_r = gamma:residual(pi, tau)
    return R * (tau * (gamma_0_tau + gamma_r_tau) - (gamma_0 + gamma_r))
end

return s
