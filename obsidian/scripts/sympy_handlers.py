from handler import handler

sympy_preamble = """
try:
    from sympy import *
except ImportError:
    SYMPY_AVAILABLE = False
else:
    SYMPY_AVAILABLE = True

if SYMPY_AVAILABLE:
    x, y, z, t = symbols('x y z t')
    X = MatrixSymbol("X", 3, 3)
    I = Identity(3)
"""
sympy_namespace = dict()
exec(sympy_preamble, sympy_namespace)

@handler.command(prefix="sympy:", cut_prefix=True)
def sympy_handler(text, context):
    if not sympy_namespace["SYMPY_AVAILABLE"]:
        raise UserWarning("Sympy not available, install it with pip")
    return eval(f"latex({text})", sympy_namespace)
