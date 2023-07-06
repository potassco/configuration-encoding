'''
Basic functions to run tests
'''

from clingo.control import Control
# from clingo.ast import ProgramBuilder, parse_string


class Solver():

    def __init__(self, options=()):
        # print(options)
        self.ctl = Control(list(options))  #["5", "--opt-mode=enum"])

        # self.ctl.configuration.solve.opt_mode = 'enum'
        # self.ctl.configuration.solve.models = 0

    def solve(self, files):
        for f in files:
            self.ctl.load(f)
        self.ctl.ground([("base", [])])

        ret = []
        self.ctl.solve(on_model=lambda m: ret.append(
            [str(sym) for sym in m.symbols(shown=True)]))

        return ret


def solve(files, options=()):
    solver = Solver(options)
    ret = solver.solve(files)
    return ret
