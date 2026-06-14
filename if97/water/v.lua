local R = require 'if97.consts'.R
local Gibbs = require 'if97.water.Gibbs'

local v = {}

function v.t_p(t, p)
    local pi = Gibbs.get_pi(p)
    local tau = Gibbs.get_tau(t)
    local gamma_pi = Gibbs.gamma:pi(pi, tau)
    return 2.7920508166969e-05 * t * gamma_pi
end

return v
