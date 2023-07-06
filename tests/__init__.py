'''
Basic functions to run tests
'''

from clingo.control import Control
# from clingo.ast import ProgramBuilder, parse_string


class Solver():

    def __init__(self, options=()):
        self.ctl = Control(['--opt-mode=enum', '0'] + list(options))

    def solve(self, f):
        self.ctl.load('encoding.lp')
        if f.endswith('.lp'):
            self.ctl.load(f'tests/instances/{f}')
        else:
            self.ctl.add(f)

        self.ctl.ground([("base", [])])

        ret = []
        self.ctl.solve(on_model=lambda m: ret.append(
            [str(sym) for sym in m.symbols(shown=True)]))
        ret.sort()
        return ret


def solve(f, options=()):
    solver = Solver(options)
    ret = solver.solve(f)
    return ret
