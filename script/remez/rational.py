from typing import Callable
from mpmath import mpf, polyval, findroot
from .utils import solve_lin


def rational(ps: list[mpf], qs: list[mpf]) -> Callable[[mpf], mpf]:
    cs = ps[::-1]
    bs = qs[::-1] + [0]
    return lambda x: polyval(cs, x) / (mpf(1) + polyval(bs, x))


def _solve_and_get_error(
    n: int, m: int,
    guessed_err: mpf,
    ref: list[mpf],
    ys: list[mpf]
) -> tuple[list[mpf], list[mpf], mpf]:
    signs = [(1, -1)[i % 2] for i in range(len(ref))]

    matrix = [
        [
            xi ** j
            for j in range(0, n + 1)

        ] + [
            (s * guessed_err - yi) * xi ** j
            for j in range(1, m + 1)
        ] + [s]
        for xi, yi, s in zip(ref, ys, signs)
    ]

    params = solve_lin(matrix, ys)

    ps = params[:n+1]
    qs = params[n+1:n+1+m]
    solved_err = params[-1]

    return ps, qs, solved_err


def rational_remez(
    n: int,
    m: int,
    start: mpf,
    end: mpf,
    f: Callable[[mpf], mpf],
    tol: mpf
) -> list[mpf]:
    assert start < end

    # From [Remco's Approximation blog post](https://xn--2-umb.com/22/approximation/)

    # width
    w = n + m + 2

    ref = [
        start + (end - start) * i / (w - 1)
        for i in range(w)
    ]

    # # Solve the non-linear equation by using a guessed error term and having them converge
    # while True:
    #     # Generalized for arbitrary rational function
    #     matrix = [
    #         [
    #             xi ** j
    #             for j in range(0, n + 1)

    #         ] + [
    #             (s * guessed_err - yi) * xi ** j
    #             for j in range(1, m + 1)
    #         ] + [s]
    #         for xi, yi, s in zip(ref, ys, signs)
    #     ]
    #     # for row in matrix:
    #     #     print(row)

    #     params = solve_lin(matrix, ys)
    #     err = params[-1]

    #     if almosteq(guessed_err, err, tol):
    #         break

    #     guessed_err = (err + guessed_err) / mpf(2)

    # ps = params[:n+1]
    # qs = params[n+1:n+1+m]
    # approx_f = rational(ps, qs)

    # points = [start] + ref + [end]

    # def err_func(x):
    #     return fabs(f(x) - approx_f(x))

    # # for a, b in zip(points[:-1], points[1:]):
    # #     x_maxed = findroot(lambda x: diff(err_func, x), (a + b) / 2)
    # #     print(f'x_maxed: {x_maxed} ({err_func(x_maxed)})')

    # print(err, guessed_err)

    # for x, s in zip(ref, signs):
    #     print(approx_f(x) + s * guessed_err, f(x))

    return []
