"""
Tests checking the configuration encoding in fclingo.
"""
from unittest import TestCase
from tests import fsolve


class TestMain(TestCase):

    def test_object_part(self):
        self.assertEqual(fsolve('type(a).'), [['selected((),a)']])
        self.assertEqual(fsolve('type(a). type(b).'), [])

        self.assertEqual(
            fsolve('type(a). type(b). part(a,b,b). multiplicity(a,b,b,1).'),
            [['selected((),a)', 'selected((b,((),0)),b)']])

        self.assertEqual(
            fsolve('type(a). type(b). part(a,b,b). multiplicity(a,b,b,0).'),
            [['selected((),a)']])

        self.assertEqual(
            fsolve(
                'type(a). type(b). part(a,b,b). multiplicity(a,b,b,1). part(b,a,a). multiplicity(b,a,a,1).'
            ), [])

        self.assertEqual(
            fsolve(
                'type(a). type(b). part(a,b,b). multiplicity(a,b,b,0). multiplicity(a,b,b,1).'
            ),
            [['selected((),a)'], ['selected((),a)', 'selected((b,((),0)),b)']])

        self.assertEqual(
            fsolve(
                'type(a). type(b). part(a,b,b). multiplicity(a,b,b,1). multiplicity(a,b,b,2).'
            ), [['selected((),a)', 'selected((b,((),0)),b)'],
                [
                    'selected((),a)', 'selected((b,((),0)),b)',
                    'selected((b,((),1)),b)'
                ]])

        self.assertEqual(
            fsolve(
                'type(a). type(b). type(c). part(a,b,b). multiplicity(a,b,b,2). part(b,c,c). multiplicity(b,c,c,1).'
            ), [[
                'selected((),a)', 'selected((b,((),0)),b)',
                'selected((b,((),1)),b)', 'selected((c,((b,((),0)),0)),c)',
                'selected((c,((b,((),1)),0)),c)'
            ]])

    def test_connection(self):
        self.assertEqual(
            len(fsolve('connection.lp', options=['-c', 'num_hdd=1'])), 3)

        self.assertEqual(
            len(fsolve('connection.lp', options=['-c', 'num_hdd=2'])), 8)

        self.assertEqual(
            len(fsolve('connection.lp', options=['-c', 'num_hdd=3'])), 17)

        self.assertEqual(
            len(fsolve('connection.lp', options=['-c', 'num_hdd=4'])), 34)

        self.assertEqual(
            fsolve('connection_constraint.lp'),
            [[
                'connected(((b,0),((),0)),((b,0),((),0)),previous)',
                'connected(((b,1),((),0)),((b,0),((),0)),previous)',
                'selected(((b,0),((),0)),b)', 'selected(((b,1),((),0)),b)',
                'selected((),a)', 'val((((b,0),((),0)),id),0)',
                'val((((b,1),((),0)),id),1)'
            ],
             [
                 'connected(((b,0),((),0)),((b,0),((),0)),previous)',
                 'selected(((b,0),((),0)),b)', 'selected((),a)',
                 'val((((b,0),((),0)),id),0)'
             ], ['selected((),a)']])

    def test_attribute(self):
        self.assertEqual(
            fsolve('type(a). attr(a,b,"discrete"). dom(a,b,(1;2;3)).'),
            [['selected((),a)', 'val(((),b),1)'],
             ['selected((),a)', 'val(((),b),2)'],
             ['selected((),a)', 'val(((),b),3)']])
        self.assertEqual(fsolve('simple_sum.lp'),
                         [[
                             'selected((),a)', 'selected((b,((),0)),b)',
                             'selected((b,((),1)),b)', ('((),s)', 2),
                             ('((b,((),0)),c)', 1), ('((b,((),1)),c)', 1)
                         ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'selected((b,((),1)),b)', ('((),s)', 3),
                              ('((b,((),0)),c)', 1), ('((b,((),1)),c)', 2)
                          ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'selected((b,((),1)),b)', ('((),s)', 3),
                              ('((b,((),0)),c)', 2), ('((b,((),1)),c)', 1)
                          ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'selected((b,((),1)),b)', ('((),s)', 4),
                              ('((b,((),0)),c)', 2), ('((b,((),1)),c)', 2)
                          ]])

        self.assertEqual(
            fsolve('simple_count.lp'),
            [['selected((),a)', ('((),c)', 0)],
             ['selected((),a)', 'selected((b,((),0)),b)', ('((),c)', 1)],
             [
                 'selected((),a)', 'selected((b,((),0)),b)',
                 'selected((b,((),1)),b)', ('((),c)', 2)
             ]])

        self.assertEqual(
            fsolve('simple_min.lp'),
            [['selected((),a)', ('((),b)', 1), ('((),c)', 2), ('((),m)', 1)],
             ['selected((),a)', ('((),b)', 1), ('((),c)', 3), ('((),m)', 1)],
             ['selected((),a)', ('((),b)', 2), ('((),c)', 2), ('((),m)', 2)],
             ['selected((),a)', ('((),b)', 2), ('((),c)', 3), ('((),m)', 2)],
             ['selected((),a)', ('((),b)', 3), ('((),c)', 2), ('((),m)', 2)],
             ['selected((),a)', ('((),b)', 3), ('((),c)', 3), ('((),m)', 3)]])

        self.assertEqual(
            fsolve('simple_max.lp'),
            [['selected((),a)', ('((),b)', 1), ('((),c)', 2), ('((),m)', 2)],
             ['selected((),a)', ('((),b)', 1), ('((),c)', 3), ('((),m)', 3)],
             ['selected((),a)', ('((),b)', 2), ('((),c)', 2), ('((),m)', 2)],
             ['selected((),a)', ('((),b)', 2), ('((),c)', 3), ('((),m)', 3)],
             ['selected((),a)', ('((),b)', 3), ('((),c)', 2), ('((),m)', 3)],
             ['selected((),a)', ('((),b)', 3), ('((),c)', 3), ('((),m)', 3)]])

        self.assertEqual(
            fsolve('count_at_optional.lp'),
            [['selected((),a)'],
             [
                 'selected((),a)', 'selected((b,((),0)),b)',
                 'selected((c,((b,((),0)),0)),c)', 'val(((b,((),0)),cou),1)'
             ]], [['selected((),a)', ('((b,((),0)),cou)', 0)],
                  [
                      'selected((),a)', 'selected((b,((),0)),b)',
                      'selected((c,((b,((),0)),0)),c)', ('((b,((),0)),cou)', 1)
                  ]])

    def test_constraint(self):
        self.assertEqual(
            fsolve('tb_basic.lp'),
            [['selected((),a)', 'val(((),b),"b1")', 'val(((),c),"c1")'],
             ['selected((),a)', 'val(((),b),"b2")', 'val(((),c),"c2")']])
        self.assertEqual(
            fsolve('tb_mixed.lp'),
            [['selected((),a)', 'val(((),b),"b1")', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),"b2")', 'val(((),c),2)']])

        self.assertEqual(len(fsolve('tb_colors.lp')), 8)

        self.assertEqual(len(fsolve('tb_with_optional.lp')), 4)
        self.assertEqual(len(fsolve('tb_with_optional_reverse.lp')), 4)

        self.assertEqual(len(fsolve('comparison_of_optional.lp')), 3)

        self.assertEqual(
            fsolve('comparison_discrete.lp', ['-c', 'type="eq"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),2)']])
        self.assertEqual(
            fsolve('comparison_discrete.lp', ['-c', 'type="neq"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),2)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),1)']])
        self.assertEqual(
            fsolve('comparison_discrete.lp', ['-c', 'type="lt"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),2)']])
        self.assertEqual(
            fsolve('comparison_discrete.lp', ['-c', 'type="lte"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),1)', 'val(((),c),2)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),2)']])
        self.assertEqual(
            fsolve('comparison_discrete.lp', ['-c', 'type="gt"']),
            [['selected((),a)', 'val(((),b),2)', 'val(((),c),1)']])
        self.assertEqual(
            fsolve('comparison_discrete.lp', ['-c', 'type="gte"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),2)']])

        self.assertEqual(
            fsolve('comparison_numeric.lp', ['-c', 'type="eq"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),2)']])
        self.assertEqual(
            fsolve('comparison_numeric.lp', ['-c', 'type="neq"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),2)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),1)']])
        self.assertEqual(
            fsolve('comparison_numeric.lp', ['-c', 'type="lt"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),2)']])
        self.assertEqual(
            fsolve('comparison_numeric.lp', ['-c', 'type="lte"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),1)', 'val(((),c),2)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),2)']])
        self.assertEqual(
            fsolve('comparison_numeric.lp', ['-c', 'type="gt"']),
            [['selected((),a)', 'val(((),b),2)', 'val(((),c),1)']])
        self.assertEqual(
            fsolve('comparison_numeric.lp', ['-c', 'type="gte"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),2)']])

        self.assertEqual(len(fsolve('alldiff_discrete.lp', ['-c', 'n=2'])), 2)
        self.assertEqual(len(fsolve('alldiff_discrete.lp', ['-c', 'n=3'])), 6)
        self.assertEqual(len(fsolve('alldiff_discrete.lp', ['-c', 'n=4'])), 24)
        self.assertEqual(len(fsolve('alldiff_discrete.lp', ['-c', 'n=5'])),
                         120)

        self.assertEqual(len(fsolve('alldiff_numeric.lp', ['-c', 'n=2'])), 2)
        self.assertEqual(len(fsolve('alldiff_numeric.lp', ['-c', 'n=3'])), 6)
        self.assertEqual(len(fsolve('alldiff_numeric.lp', ['-c', 'n=4'])), 24)
        self.assertEqual(len(fsolve('alldiff_numeric.lp', ['-c', 'n=5'])), 120)
