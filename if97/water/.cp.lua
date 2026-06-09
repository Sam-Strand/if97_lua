water.cp = {
    t_p = function(t, p)
        local pi = get_pi(p)
        local tau = get_tau(t)
        local gamma_tautau_val = gamma.tau_tau(pi, tau)
        return -R * (1386 / t) ^ 2 * gamma_tautau_val
    end
}
