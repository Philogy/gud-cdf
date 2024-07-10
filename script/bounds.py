from typing import Callable
from mpmath import mp, mpf, erf, erfinv, sqrt
from remez.rational import rational_remez, Rational
from remez.utils import InsufficientExtremaError
import sys
import json

mp.dps = 60
mp.pretty = True

TOLERANCE = mpf('1.0e-30')
TARGET_ERROR = mpf('1.0e-8')

N = 3
M = 3
START = mpf(0)
END = erfinv(mpf('1.0') - mpf('1.0e-18'))
DEFAULT_ROUNDS = 20


def erf_sqrt(x):
    return erf(x / sqrt(2))


def safe_run_remez(start: mpf, end: mpf, fn: Callable[[mpf], mpf]) -> tuple[Rational, None | mpf]:
    try:
        return rational_remez(
            N, M,
            start, end,
            fn,
            TOLERANCE,
            rounds=DEFAULT_ROUNDS
        )
    except InsufficientExtremaError:
        print(f'  (extrema fail)')
        return Rational([], []), None


def build_tree_fn(start: mpf, end: mpf, fn: Callable[[mpf], mpf]) -> list[tuple[mpf, mpf, Rational, mpf]]:
    print(f'Trying [{float(start):.8f}; {float(end):.8f}]')
    res_fn, peak_err = safe_run_remez(start, end, fn)
    if peak_err is None or peak_err > TARGET_ERROR:
        print(f'  failed, peak_err: {peak_err}')
        mid = (end + start) / 2
        return build_tree_fn(start, mid, fn) + build_tree_fn(mid, end, fn)
    print(f'  success, peak_err: {peak_err}')

    return [(start, end, res_fn, peak_err)]


# fn, peak_err = rational_remez(
#     N, M,
#     mpf(0.5), mpf(2.5),
#     erf_sqrt, TOLERANCE,
#     rounds=DEFAULT_ROUNDS
# )

# print(f'ps: {fn.ps}')
# print(f'qs: {fn.qs}')


# print(f'peak_err: {peak_err}')
# print(fn.show())


funcs = build_tree_fn(START, END, erf_sqrt)

print(f'len(funcs): {len(funcs)}')
print(f'done')

path = 'result.json' if len(sys.argv) < 2 else sys.argv[1]

n = 4

for start, end, fn, err in funcs:
    print()
    print(f'fn.ps: {fn.ps}')
    print(f'fn.qs: {fn.qs}')
    for i in range(n):
        x = (end - start) * i / (n - 1) + start
        print(f'f({float(x):.4f}) = {float(fn(x)):.4f} [{float(erf_sqrt(x)):.4f}]')

print(f'saving to {path}')
with open(path, 'w') as f:
    json.dump([
        {
            'start': str(start),
            'end': str(end),
            'fn': {
                'ps': list(map(str, fn.ps)),
                'qs': list(map(str, fn.qs)),
            },
            'err': str(err)
        }
        for start, end, fn, err in funcs
    ], f, indent=2)
