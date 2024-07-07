from typing import Callable
from mpmath import mpf


def muls(x: mpf, v: list[mpf]) -> list[mpf]:
    return [u * x for u in v]


def mulv(a: list[mpf], b: list[mpf]) -> list[mpf]:
    assert len(a) == len(b)
    return [x * y for x, y in zip(a, b)]


def addv(a: list[mpf], b: list[mpf]) -> list[mpf]:
    assert len(a) == len(b)
    return [x + y for x, y in zip(a, b)]


def subv(a: list[mpf], b: list[mpf]) -> list[mpf]:
    assert len(a) == len(b)
    return [x - y for x, y in zip(a, b)]


def solve_lin(matrix: list[list[mpf]], out: list[mpf]) -> list[mpf]:
    # O(n^3) algo but who cares, it works
    # Transforms matrix into identity matrix via valid operations on the individual rows.
    # - Can multiply any row by a factor
    # - Can add/subtract rows to each other

    out = out.copy()

    n = len(matrix)
    assert n > 0
    assert n == len(out)
    assert all(len(row) == n for row in matrix)

    for i in range(n):
        row = matrix[i]

        # Number we want to equal 1 in our end-matrix
        x = row[i]

        # Multiply row by inverse to get the target cell to 1
        f = mpf(1) / x
        out[i] *= f
        matrix[i] = row = muls(f, row)

        # Subtract our row from all others to get their values in the target column to be 0
        for j, alt_row in enumerate(matrix):
            if i == j:
                continue
            u = alt_row[i]
            matrix[j] = subv(alt_row, muls(u, row))
            out[j] = out[j] - u * out[i]

    return out


def find_extrema(f: Callable[[mpf], mpf], a: mpf, b: mpf, tol: mpf) -> mpf:
    sa = sign(diff(f, a))
    sb = sign(diff(f, b))
    assert sa != sb and sa != 0 and sb != 0
    mid = (a + b) / 2

    while fabs(a - b) > tol:
        ma = sign(diff(f, mid))

        if ma == 0:
            return mid
        if ma == sa:
            a = mid
        else:
            b = mid

        sa = sign(diff(f, a))
        sb = sign(diff(f, b))
        mid = (a + b) / 2

    return mid
