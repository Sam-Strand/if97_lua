local R = require 'if97.consts'.R
local Gibbs = require 'if97.water.Gibbs'

local s = {}
function s.t_p(t, p)
    local pi = Gibbs.get_pi(p)
    local tau = Gibbs.get_tau(t)
    local gamma = Gibbs.gamma(pi, tau)
    local gamma_tau = Gibbs.gamma:tau(pi, tau)
    return R * (tau * gamma_tau - gamma)
end

return s
