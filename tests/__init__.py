'''
Basic functions to run tests in clingo and fclingo
'''
from os import remove
from subprocess import PIPE, Popen

import clingo
from clingcon import ClingconTheory
from clingo.ast import Location, Position, ProgramBuilder, Rule, parse_string, parse_files

from fclingo import THEORY, Translator
from fclingo.__main__ import CSP, DEF
from fclingo.parsing import HeadBodyTransformer

TMP_FILE = 'tests/instances/tmp.lp'

class Config:
    def __init__(self, max_int, min_int, print_trans ,defined) -> None:
        self.max_int = max_int
        self.min_int = min_int
        self.print_trans = print_trans
        self.defined = defined

class SolverClingo():

    def __init__(self, options=()):
        self.ctl = clingo.Control(['--opt-mode=enum', '0'] + list(options))

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


class SolverFclingo(object):
    """
    Simplistic solver for multi-shot solving.
    """

    def __init__(self, minint=-20, maxint=20, threads=8, options=()):
        self.prg = clingo.Control(
            ["0", "-t", str(threads)] + list(options), message_limit=0
        )
        self.optimize = False
        self.bound = None
        self.propagator = ClingconTheory()
        self.propagator.register(self.prg)
        self.maxint = maxint
        self.minint = minint
        self.propagator.configure("max-int", str(maxint))
        self.propagator.configure("min-int", str(minint))

        self.prg.add("base", [], THEORY)

    def _parse_model(self, ret, model):
        """
        Combine model and assignment in one list.
        """
        self.propagator.on_model(model)
        m = []
        for sym in model.symbols(shown=True):
            s = str(sym)
            if not s.startswith("_"):
                m.append(s)

        a = [
            (str(assignment.arguments[0]), assignment.arguments[1].number)
            for assignment in model.symbols(theory=True)
            if assignment.name == CSP
            and len(assignment.arguments) == 2
            and not assignment.arguments[0].name.startswith("_")
        ]

        ret.append((sorted(m), sorted(a)))

    def solve(self, f):
        """
        Translate and solve program f.
        """
        # pylint: disable=unsubscriptable-object,cell-var-from-loop,no-member
        with ProgramBuilder(self.prg) as bld:
            hbt = HeadBodyTransformer()
            files = ['encoding_fclingo.lp']
            if f.endswith('.lp'):
                files.append(f'tests/instances/fclingo/{f}')
            else:
                parse_string(f,lambda ast: bld.add(hbt.visit(ast)))
            
            parse_files(
                files,
                lambda ast: bld.add(hbt.visit(ast))
            )

            pos = Position('<string>', 1, 1)
            loc = Location(pos, pos)
            for rule in hbt.rules_to_add:
                bld.add(Rule(loc,rule[0],rule[1]))

        self.prg.ground([("base", [])])
        translator = Translator(self.prg, Config(self.maxint, self.minint, False, DEF))
        translator.translate(self.prg.theory_atoms)

        ret = []
        self.propagator.prepare(self.prg)
        self.prg.solve(on_model=lambda m: self._parse_model(ret, m))
        ret.sort()

        return [m + a for m, a in ret]


def fsolve(f, minint=-20, maxint=20, threads=8, options=()):
    """
    Return the (optimal) models/assignments of the program in the given string.
    """
    fsolver = SolverFclingo(minint, maxint, threads, options)
    ret = fsolver.solve(f)
    print(ret)
    return ret


# def fsolve(f, options=()):
#     if f.endswith('.lp'):
#         instance = f'tests/instances/fclingo/{f}'
#     else:
#         with open(TMP_FILE, 'w') as tmp:
#             tmp.write(f)
#         instance = TMP_FILE

#     solve = Popen(['fclingo', 'encoding_fclingo.lp', instance, '0'] +
#                   list(options),
#                   stdout=PIPE,
#                   stderr=PIPE)

#     out, _ = solve.communicate()
#     out = out.decode('utf-8')

#     # Remove temp file
#     if instance == TMP_FILE:
#         remove(TMP_FILE)

#     if 'UNSATISFIABLE' in out:
#         return []
#     else:
#         out = out.split('\n')
#         models = out[out.index('Answer: 1'):out.index('SATISFIABLE')][1::2]
#         models = [sorted(m.split(' ')) for m in models]
#         models.sort()
#         return models
