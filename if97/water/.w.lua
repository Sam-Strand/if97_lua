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