local Gibbs = require 'if97.steam.Gibbs'

local w = {}

---Скорость звука [м/с]
---@param t number
---@param p number
---@return number
function w.t_p(t, p)
    local pi = p
    local tau = Gibbs.get_tau(t)
    local gamma_i_tau_tau = Gibbs.gamma:ideal_tau_tau(tau)
    local gamma_r_pi = Gibbs.gamma:residual_pi(pi, tau)
    local gamma_r_pi_tau = Gibbs.gamma:residual_pi_tau(pi, tau)
    local gamma_r_pi_pi = Gibbs.gamma:residual_pi_pi(pi, tau)
    local gamma_r_tau_tau = Gibbs.gamma:residual_tau_tau(pi, tau)
    return math.sqrt(
        461.526 * t * (1 + 2 * pi * gamma_r_pi + pi ^ 2 * gamma_r_pi ^ 2)
        / (
            1 - pi ^ 2 * gamma_r_pi_pi + (1 + pi * gamma_r_pi - tau * pi * gamma_r_pi_tau) ^ 2
            / tau ^ 2
            / (gamma_i_tau_tau + gamma_r_tau_tau)
        )
    )
end

return w
