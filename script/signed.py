def uint(x: int) -> int:
    return x % (1 << 256)


def to_int(x: int) -> int:
    return x if x < (1 << 255) else -((1 << 256) - x)


x = uint(-(1 << 254) - 283)

print('mul:', to_int(uint(x * 2**128)))
print('shift:', to_int(uint(x << 128)))
