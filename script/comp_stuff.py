import py_compile
import dis
import re

res = py_compile.compile('./script/bounds.py')
print(res)

with open('./script/__pycache__/bounds.cpython-312.pyc', 'rb') as f:
    data = f.read()

# print(dis.dis(data))
print(dis.opname)

ops = list(filter(lambda s: re.match(r'\w+', s), dis.opname))
print(ops)
print(f'len(ops): {len(ops)}')
