local R = require 'if97.consts'.R
local Gibbs = require 'if97.water.Gibbs'

local h = {}

function h.t_p(t, p)
    local pi = Gibbs.get_pi(p)
    local tau = Gibbs.get_tau(t)
    local gamma_tau = Gibbs.gamma.tau(pi, tau)
    return 639.675036 * gamma_tau
end

return h
