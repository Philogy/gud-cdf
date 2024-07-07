from mpmath import mp, mpf, polyval, erf, erfinv
from remez.rational import rational

# Determine bounds
# mp.dps = 1000
# value = mp.mpf('0.999999999999999999')
# cutoff = erfinv(value)

mp.dps = 60
mp.pretty = True


print()
end = erfinv(mpf('1.0') - mpf('1.0e-18'))

# m = 3
# n = 3
# rational_remez_round(
#     m, n,
#     mpf(0.1), end,
#     erf,
#     [*map(lambda x: mpf(x * 0.82 + 0.5), range(m + n + 2))]
# )

# x = gold_max(lambda x: x**2 - 6 * x + 15, mpf(0), mpf(4), mpf('1.0e-30'))
# print(f'x: {x}')
