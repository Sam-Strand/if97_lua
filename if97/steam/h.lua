local gamma = require 'if97.steam.Gibbs'.gamma
local Gibbs = require 'if97.steam.Gibbs'
local get_tau = require 'if97.steam.Gibbs'.get_tau
local R = require 'if97.consts'.R
local bounds = require 'if97.bounds'
local consts = require 'if97.consts'


local s_t_p = require 'if97.steam.s'.t_p

local h = {}

---@param t number температура в K
---@param p number давление в МПа
---@return number энтальпия в кДж/кг
function h.t_p(t, p)
    local tau = get_tau(t)
    local pi = p
    local gamma_0_tau = gamma:ideal_tau(tau)        -- ∂γ⁰/∂τ
    local gamma_r_tau = gamma:residual_tau(pi, tau) -- ∂γʳ/∂τ
    return R * t * tau * (gamma_0_tau + gamma_r_tau)
end

---@param p number давление в МПа
---@param s number энтропия в кДж/(кг⋅K)
---@return number энтальпия в кДж/кг
function h.p_s(p, s)
    -- Коэффициенты для подрегионов 2a, 2b, 2c...
    -- Table 25. Page 26 coefficients for subregion 2a, Eq.(25)
    local coeff_2a = {
        { -1.5,  -24, -0.39235983861984e6 },
        { -1.5,  -23, 0.51526573827270e6 },
        { -1.5,  -19, 0.40482443161048e5 },
        { -1.5,  -13, -0.32193790923902e3 },
        { -1.5,  -11, 0.96961424218694e2 },
        { -1.5,  -10, -0.22867846371773e2 },
        { -1.25, -19, -0.44942914124357e6 },
        { -1.25, -15, -0.50118336020166e4 },
        { -1.25, -6,  0.35684463560015 },
        { -1.0,  -26, 0.44235335848190e5 },
        { -1.0,  -21, -0.13673388811708e5 },
        { -1.0,  -17, 0.42163260207864e6 },
        { -1.0,  -16, 0.22516925837475e5 },
        { -1.0,  -9,  0.47442144865646e3 },
        { -1.0,  -8,  -0.14931130797647e3 },
        { -0.75, -15, -0.19781126320452e6 },
        { -0.75, -14, -0.23554399470760e5 },
        { -0.5,  -26, -0.19070616302076e5 },
        { -0.5,  -13, 0.55375669883164e5 },
        { -0.5,  -9,  0.38293691437363e4 },
        { -0.5,  -7,  -0.60391860580567e3 },
        { -0.25, -27, 0.19363102620331e4 },
        { -0.25, -25, 0.42660643698610e4 },
        { -0.25, -11, -0.59780638872718e4 },
        { -0.25, -6,  -0.70401463926862e3 },
        { 0.25,  1,   0.33836784107553e3 },
        { 0.25,  4,   0.20862786635187e2 },
        { 0.25,  8,   0.33834172656196e-1 },
        { 0.25,  11,  -0.43124428414893e-4 },
        { 0.5,   0,   0.16653791356412e3 },
        { 0.5,   1,   -0.13986292055898e3 },
        { 0.5,   5,   -0.78849547999872 },
        { 0.5,   6,   0.72132411753872e-1 },
        { 0.5,   10,  -0.59754839398283e-2 },
        { 0.5,   14,  -0.12141358953904e-4 },
        { 0.5,   16,  0.23227096733871e-6 },
        { 0.75,  0,   -0.10538463566194e2 },
        { 0.75,  4,   0.20718925496502e1 },
        { 0.75,  9,   -0.72193155260427e-1 },
        { 0.75,  17,  0.20749887081120e-6 },
        { 1.0,   7,   -0.18340657911379e-1 },
        { 1.0,   18,  0.29036272348696e-6 },
        { 1.25,  3,   0.21037527893619 },
        { 1.25,  15,  0.25681239729990e-3 },
        { 1.5,   5,   -0.12799002933810e-1 },
        { 1.5,   18,  -0.82198102652018e-5 },
    }

    -- Table 26. Page 27 coefficients for subregion 2b, Eq.(26)
    local coeff_2b = {
        { -6, 0,  0.31687665083497e6 },
        { -6, 11, 0.20864175881858e2 },
        { -5, 0,  -0.39859399803599e6 },
        { -5, 11, -0.21816058518877e2 },
        { -4, 0,  0.22369785194242e6 },
        { -4, 1,  -0.27841703445817e4 },
        { -4, 11, 0.99207436071480e1 },
        { -3, 0,  -0.75197512299157e5 },
        { -3, 1,  0.29708605951158e4 },
        { -3, 11, -0.34406878548526e1 },
        { -3, 12, 0.38815564249115 },
        { -2, 0,  0.17511295085750e5 },
        { -2, 1,  -0.14237112854449e4 },
        { -2, 6,  0.10943803364167e1 },
        { -2, 10, 0.89971619308495 },
        { -1, 0,  -0.33759740098958e4 },
        { -1, 1,  0.47162885818355e3 },
        { -1, 5,  -0.19188241993679e1 },
        { -1, 8,  0.41078580492196 },
        { -1, 9,  -0.33465378172097 },
        { 0,  0,  0.13870034777505e4 },
        { 0,  1,  -0.40663326195838e3 },
        { 0,  2,  0.41727347159610e2 },
        { 0,  4,  0.21932549434532e1 },
        { 0,  5,  -0.10320050009077e1 },
        { 0,  6,  0.35882943516703 },
        { 0,  9,  0.52511453726066e-2 },
        { 1,  0,  0.12838916450705e2 },
        { 1,  1,  -0.28642437219381e1 },
        { 1,  2,  0.56912683664855 },
        { 1,  3,  -0.99962954584931e-1 },
        { 1,  7,  -0.32632037778459e-2 },
        { 1,  8,  0.23320922576723e-3 },
        { 2,  0,  -0.15334809857450 },
        { 2,  1,  0.29072288239902e-1 },
        { 2,  5,  0.37534702741167e-3 },
        { 3,  0,  0.17296691702411e-2 },
        { 3,  1,  -0.38556050844504e-3 },
        { 3,  3,  -0.35017712292608e-4 },
        { 4,  0,  -0.14566393631492e-4 },
        { 4,  1,  0.56420857267269e-5 },
        { 5,  0,  0.41286150074605e-7 },
        { 5,  1,  -0.20684671118824e-7 },
        { 5,  2,  0.16409393674725e-8 },
    }

    -- Table 27. Page 28 coefficients for subregion 2c, Eq.(27)
    local coeff_2c = {
        { -2, 0, 0.90968501005365e3 },
        { -2, 1, 0.24045667088420e4 },
        { -1, 0, -0.59162326387130e3 },
        { 0,  0, 0.54145404128074e3 },
        { 0,  1, -0.27098308411192e3 },
        { 0,  2, 0.97976525097926e3 },
        { 0,  3, -0.46966772959435e3 },
        { 1,  0, 0.14399274604723e2 },
        { 1,  1, -0.19104204230429e2 },
        { 1,  3, 0.53299167111971e1 },
        { 1,  4, -0.21252975375934e2 },
        { 2,  0, -0.31147334413760 },
        { 2,  1, 0.60334840894623 },
        { 2,  2, -0.42764839702509e-1 },
        { 3,  0, 0.58185597255259e-2 },
        { 3,  1, -0.14597008284753e-1 },
        { 3,  5, 0.56631175631027e-2 },
        { 4,  0, -0.76155864584577e-4 },
        { 4,  1, 0.22440342919332e-3 },
        { 4,  4, -0.12561095013413e-4 },
        { 5,  0, 0.63323132660934e-6 },
        { 5,  1, -0.20541989675375e-5 },
        { 5,  2, 0.36405370390082e-7 },
        { 6,  0, -0.29759897789215e-8 },
        { 6,  1, 0.10136618529763e-7 },
        { 7,  0, 0.59925719692351e-11 },
        { 7,  1, -0.20677870105164e-10 },
        { 7,  3, -0.20874278181886e-10 },
        { 7,  4, 0.10162166825089e-9 },
        { 7,  5, -0.16429828281347e-9 },
    }

    local theta = 0.0 -- T = theta (T* = 1)

    if p > 4.0 then
        if s < 5.85 then
            -- Subregion 2c
            local sigma = 2.0 - s / 2.9251
            local pi = p
            for _, coeff in ipairs(coeff_2c) do
                local I, J, n = coeff[1], coeff[2], coeff[3]
                theta = theta + n * pi ^ I * sigma ^ J
            end
        else
            -- Subregion 2b
            local sigma = 10.0 - s / 0.7853
            local pi = p
            for _, coeff in ipairs(coeff_2b) do
                local I, J, n = coeff[1], coeff[2], coeff[3]
                theta = theta + n * pi ^ I * sigma ^ J
            end
        end
    else
        -- Subregion 2a
        local sigma = s / 2.0
        local arg = sigma - 2.0
        local pi = p
        for _, coeff in ipairs(coeff_2a) do
            local I, J, n = coeff[1], coeff[2], coeff[3]
            theta = theta + n * pi ^ I * arg ^ J
        end
    end

    local T = theta -- T* = 1, so T = theta

    -- Используем основное уравнение Гиббса для региона 2
    local tau = get_tau(T)
    local pi = p
    local gamma_0_tau = gamma:ideal_tau(tau)
    local gamma_r_tau = gamma:residual_tau(pi, tau)

    -- h = R * T * τ * (γ⁰_τ + γʳ_τ)
    return R * T * tau * (gamma_0_tau + gamma_r_tau)
end

---@param t number температура в K
---@param s number энтропия в кДж/(кг⋅K)
---@param p_guess number|nil начальное приближение давления в МПа (опционально)
---@return number|nil энтальпия в кДж/кг или nil если не найдена
function h.t_s(t, s, p_guess)
    -- Определяем границы давления для поиска
    local p_min, p_max

    p_min = consts.minP
    local p_border = bounds.borderPressure_t(t)
    if p_border then
        p_max = p_border
    else
        p_max = consts.maxP
    end

    local function delta_s_t_p(p)
        return s_t_p(t, p) - s
    end

    -- Выбираем начальное приближение
    local p1, p2 = p_min, p_max
    local p_start = p_guess or ((p_min + p_max) / 2)

    local f1 = delta_s_t_p(p1)
    local f2 = delta_s_t_p(p2)
    -- Если знаки одинаковые, ищем интервал с разными знаками
    local iter = 0
    local max_iter = 50

    while f1 * f2 > 0 and iter < max_iter do
        if math.abs(f1) < math.abs(f2) then
            p1 = p1 * 0.7
            if p1 < p_min then
                p1 = p_min
                f1 = delta_s_t_p(p1)
                if f1 * f2 < 0 then break end
                p1 = p_min * 1.1
                if p1 > p_max then p1 = p_max * 0.9 end
            end
            f1 = delta_s_t_p(p1)
        else
            p2 = p2 * 1.3
            if p2 > p_max then
                p2 = p_max
                f2 = delta_s_t_p(p2)
                if f1 * f2 < 0 then break end
                p2 = p_max * 0.9
                if p2 < p_min then p2 = p_min * 1.1 end
            end
            f2 = delta_s_t_p(p2)
        end
        iter = iter + 1
    end

    -- Если знаки всё ещё одинаковые, возвращаем nil
    if f1 * f2 >= 0 then
        return nil
    end

    -- Метод секущей для уточнения корня
    local p = p2
    for i = 1, 40 do
        if math.abs(f2 - f1) < 1e-15 then break end
        p = p2 - f2 * (p2 - p1) / (f2 - f1)

        if p < p_min then p = p_min end
        if p > p_max then p = p_max end

        local f = delta_s_t_p(p)

        if math.abs(f) < 1e-9 then
            p2 = p
            break
        end

        p1 = p2
        f1 = f2
        p2 = p
        f2 = f
    end

    -- Вычисляем энтальпию по найденному давлению
    return h.t_p(t, p2)
end

return h
