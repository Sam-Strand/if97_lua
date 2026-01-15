local gamma = require 'water.gamma'
local kTps, kTph = require 'water.data'
local t = require 'water.t'

local water = {}

water.t = t

water.h = h
water.w = {
    t_p = function(t, p)
        local pi = get_pi(p)
        local tau = get_tau(t)
        
        local gamma_pitau_val = gamma.pi_tau(pi, tau)
        local gamma_tautau_val = gamma.tau_tau(pi, tau)
        local gamma_pi_val = gamma.pi(pi, tau)
        local gamma_pipi_val = gamma.pi_pi(pi, tau)
        
        return math.sqrt(R * t * gamma_pitau_val ^ 2 /
            ((gamma_pitau_val - tau * gamma_tautau_val) ^ 2 / 
            (tau ^ 2 * gamma_pi_val) - gamma_pipi_val))
    end
}

water.v = {
    t_p = function(t, p)
        local pi = get_pi(p)
        local tau = get_tau(t)
        local gamma_pi_val = gamma.pi(pi, tau)
        return t * R * gamma_pi_val / 16530000
    end
}

water.cv = {
    t_p = function(t, p)
        local pi = get_pi(p)
        local tau = get_tau(t)
        local tf = 1386 / t
        
        local gamma_pitau_val = gamma.pi_tau(pi, tau)
        local gamma_tautau_val = gamma.tau_tau(pi, tau)
        local gamma_pi_val = gamma.pi(pi, tau)
        local gamma_pipi_val = gamma.pi_pi(pi, tau)
        
        return R * (-tf ^ 2 * gamma_tautau_val + 
            (gamma_pitau_val - tf * gamma_tautau_val) ^ 2 / gamma_pipi_val)
    end
}

water.cp = {
    t_p = function(t, p)
        local pi = get_pi(p)
        local tau = get_tau(t)
        local gamma_tautau_val = gamma.tau_tau(pi, tau)
        return -R * (1386 / t) ^ 2 * gamma_tautau_val
    end
}

water.s = {
    t_p = function(t, p)
        local pi = get_pi(p)
        local tau = get_tau(t)
        local gamma_val = gamma(pi, tau)
        local gamma_tau_val = gamma.tau(pi, tau)
        return R * (1386 / t * gamma_tau_val - gamma_val)
    end
}

water.rho = {
    t_p = function(t, p)
        local pi = get_pi(p)
        local tau = get_tau(t)
        local gamma_pi_val = gamma.pi(pi, tau)
        return 1 / (t * R * gamma_pi_val / 16530000)
    end
}

water.u = {
    t_rho = u
}

return water
