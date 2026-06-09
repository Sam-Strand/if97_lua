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
