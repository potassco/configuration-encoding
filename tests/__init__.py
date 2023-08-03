'''
Basic functions to run tests in clingo and fclingo
'''
import json
from os import remove
from subprocess import PIPE, Popen

from clingo.control import Control

TMP_FILE = 'tests/instances/tmp.lp'


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
            sorted([str(sym)
                    for sym in m.symbols(shown=True)])))  # TODO: Add sorted()?
        ret.sort()
        return ret


def solve(f, options=()):
    solver = SolverClingo(options)
    ret = solver.solve(f)
    return ret


def fsolve(f, options=()):
    if f.endswith('.lp'):
        instance = f'tests/instances/fclingo/{f}'
    else:
        with open(TMP_FILE, 'w') as tmp:
            tmp.write(f)
        instance = TMP_FILE

    solve = Popen(['fclingo', 'encoding_fclingo.lp', instance, '0'] +
                  list(options),
                  stdout=PIPE,
                  stderr=PIPE)

    out, _ = solve.communicate()
    out = out.decode('utf-8')

    # Remove temp file
    if instance == TMP_FILE:
        remove(TMP_FILE)

    if 'UNSATISFIABLE' in out:
        return []
    else:
        out = out.split('\n')
        models = out[out.index('Answer: 1'):out.index('SATISFIABLE')][1::2]
        models = [sorted(m.split(' ')) for m in models]
        models.sort()
        return models


# def fsolve(f, options=()):
#     if f.endswith('.lp'):
#         instance = f'tests/instances/fclingo/{f}'
#     else:
#         with open(TMP_FILE, 'w') as tmp:
#             tmp.write(f)
#         instance = TMP_FILE

#     solve = Popen(
#         ['fclingo', 'encoding_fclingo.lp', instance, '0', '--outf=2'] +
#         list(options),
#         stdout=PIPE,
#         stderr=PIPE)

#     out, _ = solve.communicate()
#     out = json.loads(out.decode('utf-8').replace('__csp', 'val'))
#     # Remove temp file
#     if instance == TMP_FILE:
#         remove(TMP_FILE)

#     if out['Result'] == 'SATISFIABLE':
#         models = out['Call'][0]['Witnesses']
#         models = [sorted(m['Value']) for m in models]
#         models.sort()
#         return models
#     else:
#         return []
