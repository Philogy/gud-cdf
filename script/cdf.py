from mpmath import *

mp.dps = 15
mp.pretty = True
one = mpf(1)


def erf_sqrt(x):
    return erf(x / sqrt(2))


M = 8
N = 8

a = taylor(erf_sqrt, 1.2, M + N)
p, q = pade(a, M, N)
p = p[::-1]
q = q[::-1]

# x = 0.23
# res = polyval(p, x)/polyval(q, x)


def show_poly(coeffs: list[int]) -> str:
    items = [
        {
            0: f'{float(c):.9f}',
            1: f'{float(c):.9f}\\cdot x'
        }.get(i, f'{float(c):.9f}\\cdot x^{i}')
        for i, c in enumerate(coeffs[::-1])
        if c
    ]
    return ' + '.join(items[::-1])


print(show_poly(p))
print(show_poly(q))
