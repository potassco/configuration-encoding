"""
Tests checking the configuration encoding in clingo.
"""
from tests import solve
import unittest


class TestMain(unittest.TestCase):

    def test_object(self):
        self.assertEqual(solve('type(a).'), [['selected((),a)']])
        self.assertEqual(solve('type(a). type(b).'), [])

        self.assertEqual(
            solve('type(a). type(b). part(a,b,b). multiplicity(a,b,b,1).'),
            [['selected((),a)', 'selected((b,((),0)),b)']])
        self.assertEqual(
            solve(
                'type(a). type(b). part(a,b,b). multiplicity(a,b,b,1). multiplicity(a,b,b,2).'
            ), [['selected((),a)', 'selected((b,((),0)),b)'],
                [
                    'selected((),a)', 'selected((b,((),0)),b)',
                    'selected((b,((),1)),b)'
                ]])

    def test_connection(self):
        self.assertEqual(len(solve('connection.lp', ['-c', 'num_hdd=1'])), 3)

        self.assertEqual(len(solve('connection.lp', ['-c', 'num_hdd=2'])), 8)

        self.assertEqual(len(solve('connection.lp', ['-c', 'num_hdd=3'])), 17)

        self.assertEqual(len(solve('connection.lp', ['-c', 'num_hdd=4'])), 34)

    def test_table_constraint(self):
        self.assertEqual(
            solve('tb_basic.lp'),
            [['selected((),a)', 'val(((),b),"b1")', 'val(((),c),"c1")'],
             ['selected((),a)', 'val(((),b),"b2")', 'val(((),c),"c2")']])
        self.assertEqual(len(solve('tb_colors.lp')), 8)
