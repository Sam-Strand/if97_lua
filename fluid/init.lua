local R = require'consts'.R
local phi, get_tau, get_delta = require'fluid.Helmholtz'
local sqrt = require'math'.sqrt

local fluid = {}

fluid.i = {
    t_rho = function(t, rho)
        local tau = get_tau(t)
        local delta = get_delta(rho)
        return (tau * phi:tau((tau, delta) + delta * phi:delta(tau, delta)) * R * t
    end
}

fluid.w = {
    t_rho = function(t, rho)
        local tau = get_tau(t)
        local delta = get_delta(rho)
        local phi_delta = phi:delta(tau, delta)
        return
            sqrt((
                2 * phi_delta / delta +
                phi:delta_delta(tau, delta) -
                (phi_delta - tau * phi:delta_tau(tau, delta)) ^ 2 /
                (tau ^ 2 * phi:tau_tau(tau, delta))
            ) * R * t * delta ^ 2)
    end
}

fluid.cv = {
    t_rho = function(t, rho)
        local tau = get_tau(t)
        local delta = get_delta(rho)
        return -(tau) ^ 2 * phi:tau_tau(tau, delta) * R
    end
}

fluid.cp = {
    t_rho = function(t, rho)
        local tau = get_tau(t)
        local delta = get_delta(rho)
        local phi_delta = phi:delta(tau, delta)
        return (
            -tau ^ 2 * phi:tau_tau(tau, delta) +
            ((phi_delta - tau * phi:delta_tau(tau, delta))) ^ 2 /
            (2 * phi_delta / delta + phi:delta_delta(tau, delta))
        ) * R
    end
}

fluid.s = {
    t_rho = function(t, rho)
        local tau = get_tau(t)
        local delta = get_delta(rho)
        return R * (tau * phi:tau((tau, delta) - phi(tau, delta))
    end
}

fluid.p = {
    t_rho = function(t, rho)
        local tau = get_tau(t)
        local delta = get_delta(rho)
        return phi:delta(tau, delta) * rho * delta * R * t
    end
}

return fluid
