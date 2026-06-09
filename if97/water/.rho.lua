water.rho = {
    t_p = function(t, p)
        local pi = get_pi(p)
        local tau = get_tau(t)
        local gamma_pi_val = gamma.pi(pi, tau)
        return 1 / (t * R * gamma_pi_val / 16530000)
    end
}
