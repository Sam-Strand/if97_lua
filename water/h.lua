local R = require'consts'.R
local gamma = require 'water.gamma'

local h = {}

function h.t_p(t, p)
    local pi = get_pi(p)
    local tau = get_tau(t)
    local gamma_tau_val = gamma.tau(pi, tau)
    return R * 1386 * gamma_tau_val
end

return h
