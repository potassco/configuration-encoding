"""
Tests checking the configuration encoding in fclingo.
"""
from unittest import TestCase
from tests import fsolve


class TestMain(TestCase):

    def test_attribute(self):
        self.assertEqual(
            fsolve('simple_sum.lp'),
            [[
                'selected((),a)', 'selected((b,((),0)),b)',
                'selected((b,((),1)),b)', 'val(((b,((),0)),c),1)',
                'val(((b,((),1)),c),1)', 'val(((),s),2)'
            ],
             [
                 'selected((),a)', 'selected((b,((),0)),b)',
                 'selected((b,((),1)),b)', 'val(((b,((),0)),c),1)',
                 'val(((b,((),1)),c),2)', 'val(((),s),3)'
             ],
             [
                 'selected((),a)', 'selected((b,((),0)),b)',
                 'selected((b,((),1)),b)', 'val(((b,((),0)),c),2)',
                 'val(((b,((),1)),c),2)', 'val(((),s),4)'
             ],
             [
                 'selected((),a)', 'selected((b,((),0)),b)',
                 'selected((b,((),1)),b)', 'val(((b,((),1)),c),1)',
                 'val(((b,((),0)),c),2)', 'val(((),s),3)'
             ]])
