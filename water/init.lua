local gamma = require 'water.gamma'
local kTps, kTph = require 'water.data'
local R = 461.526

local function get_pi(p)
    return p / 16.53
end

local function get_tau(t)
    return 1386 / t
end

local water = {}

water.t = {
    p_s = function(p, s)
        p = p * 1e-6
        local t = 0
        s = s / 1000 + 2
        for _, k in ipairs(kTps) do
            t = t + k[3] * p ^ k[1] * s ^ k[2]
        end
        return t
    end,
    p_h = function(p, i)
        p = p * 1e-6
        i = i / 2500000 + 1
        local t = 0
        for _, k in ipairs(kTph) do
            t = t + k[3] * p ^ k[1] * i ^ k[2]
        end
        return t
    end
}

water.i = {
    t_p = function(t, p)
        local pi = get_pi(p)
        local tau = get_tau(t)
        local gamma_tau_val = gamma.tau(pi, tau)
        return R * 1386 * gamma_tau_val
    end
}

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
