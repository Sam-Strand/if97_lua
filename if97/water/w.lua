local R = require 'if97.consts'.R
local Gibbs = require 'if97.water.Gibbs'

local w = {}

function w.t_p(t, p)
    local pi = Gibbs.get_pi(p)
    local tau = Gibbs.get_tau(t)

    local gamma_pi_tau = Gibbs.gamma:pi_tau(pi, tau)
    local gamma_tau_tau = Gibbs.gamma:tau_tau(pi, tau)
    local gamma_pi = Gibbs.gamma:pi(pi, tau)
    local gamma_pi_pi = Gibbs.gamma:pi_pi(pi, tau)

    return math.sqrt(461.526 * t * gamma_pi ^ 2
        /(
            (gamma_pi - tau * gamma_pi_tau) ^ 2
                / (tau ^ 2 * gamma_tau_tau)
                - gamma_pi_pi
        )
    )
end

return w
