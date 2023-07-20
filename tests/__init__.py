'''
Basic functions to run tests in clingo and fclingo
'''
import json
from subprocess import PIPE, Popen
from clingo.control import Control


class SolverClingo():

    def __init__(self, options=()):
        self.ctl = Control(['--opt-mode=enum', '0'] + list(options))

    def solve(self, f):
        self.ctl.load('encoding.lp')
        if f.endswith('.lp'):
            self.ctl.load(f'tests/instances/clingo/{f}')
        else:
            self.ctl.add(f)

        self.ctl.ground([("base", [])])

        ret = []
        self.ctl.solve(on_model=lambda m: ret.append(
            [str(sym) for sym in m.symbols(shown=True)])) # TODO: Add sorted()?
        ret.sort()
        return ret


def solve(f, options=()):
    solver = SolverClingo(options)
    ret = solver.solve(f)
    return ret


def fsolve(f, options=()):
    instance = f'tests/instances/fclingo/{f}'
    solve = Popen(
        ['fclingo', 'encoding_fclingo.lp', instance, '0', '--outf=2'],
        stdout=PIPE,
        stderr=PIPE)

    out, _ = solve.communicate()
    models = json.loads(out.decode('utf-8').replace(
        '__csp', 'val'))['Call'][0]['Witnesses']
    models = [sorted(m['Value']) for m in models]
    models.sort()
    return models
