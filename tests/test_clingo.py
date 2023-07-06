"""
Tests checking the configuration encoding in clingo.
"""
from tests import solve
import unittest


class TestMain(unittest.TestCase):

    def test_connection(self):
        self.assertEqual(
            len(
                solve(['encoding.lp', 'tests/connection_port.lp'],
                      ['--opt-mode=enum', '0', '-c', 'num_hdd=1'])), 3)

        self.assertEqual(
            len(
                solve(['encoding.lp', 'tests/connection_port.lp'],
                      ['--opt-mode=enum', '0', '-c', 'num_hdd=2'])), 8)

        self.assertEqual(
            len(
                solve(['encoding.lp', 'tests/connection_port.lp'],
                      ['--opt-mode=enum', '0', '-c', 'num_hdd=3'])), 17)

        self.assertEqual(
            len(
                solve(['encoding.lp', 'tests/connection_port.lp'],
                      ['--opt-mode=enum', '0', '-c', 'num_hdd=4'])), 34)
