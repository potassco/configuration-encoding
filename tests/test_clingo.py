"""
Tests checking the configuration encoding in clingo.
"""
from unittest import TestCase
from tests import solve


class TestMain(TestCase):

    def test_object_part(self):
        self.assertEqual(solve('type(a).'), [['selected((),a)']])
        self.assertEqual(solve('type(a). type(b).'), [])

        self.assertEqual(
            solve('type(a). type(b). part(a,b,b). multiplicity(a,b,b,1).'),
            [['selected((),a)', 'selected((b,((),0)),b)']])

        self.assertEqual(
            solve('type(a). type(b). part(a,b,b). multiplicity(a,b,b,0).'),
            [['selected((),a)']])

        self.assertEqual(
            solve(
                'type(a). type(b). part(a,b,b). multiplicity(a,b,b,1). part(b,a,a). multiplicity(b,a,a,1).'
            ), [])

        self.assertEqual(
            solve(
                'type(a). type(b). part(a,b,b). multiplicity(a,b,b,0). multiplicity(a,b,b,1).'
            ),
            [['selected((),a)'], ['selected((),a)', 'selected((b,((),0)),b)']])

        self.assertEqual(
            solve(
                'type(a). type(b). part(a,b,b). multiplicity(a,b,b,1). multiplicity(a,b,b,2).'
            ), [['selected((),a)', 'selected((b,((),0)),b)'],
                [
                    'selected((),a)', 'selected((b,((),0)),b)',
                    'selected((b,((),1)),b)'
                ]])

        self.assertEqual(
            solve(
                'type(a). type(b). type(c). part(a,b,b). multiplicity(a,b,b,2). part(b,c,c). multiplicity(b,c,c,1).'
            ), [[
                'selected((),a)', 'selected((b,((),0)),b)',
                'selected((b,((),1)),b)', 'selected((c,((b,((),0)),0)),c)',
                'selected((c,((b,((),1)),0)),c)'
            ]])

    def test_connection(self):
        self.assertEqual(len(solve('connection.lp', ['-c', 'num_hdd=1'])), 3)

        self.assertEqual(len(solve('connection.lp', ['-c', 'num_hdd=2'])), 8)

        self.assertEqual(len(solve('connection.lp', ['-c', 'num_hdd=3'])), 17)

        self.assertEqual(len(solve('connection.lp', ['-c', 'num_hdd=4'])), 34)

        self.assertEqual(
            solve('connection_constraint.lp', []),
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
            solve('type(a). attr(a,b,"discrete"). dom(a,b,(1;2;3)).'),
            [['selected((),a)', 'val(((),b),1)'],
             ['selected((),a)', 'val(((),b),2)'],
             ['selected((),a)', 'val(((),b),3)']])
        self.assertEqual(solve('simple_sum.lp'),
                         [[
                             'selected((),a)', 'selected((b,((),0)),b)',
                             'selected((b,((),1)),b)', 'val(((),s),2)',
                             'val(((b,((),0)),c),1)', 'val(((b,((),1)),c),1)'
                         ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'selected((b,((),1)),b)', 'val(((),s),3)',
                              'val(((b,((),0)),c),1)', 'val(((b,((),1)),c),2)'
                          ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'selected((b,((),1)),b)', 'val(((),s),3)',
                              'val(((b,((),0)),c),2)', 'val(((b,((),1)),c),1)'
                          ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'selected((b,((),1)),b)', 'val(((),s),4)',
                              'val(((b,((),0)),c),2)', 'val(((b,((),1)),c),2)'
                          ]])

        self.assertEqual(solve('simple_object_count.lp'), [[
            'selected((),a)', 'selected((b,((),0)),b)',
            'selected((b,((),1)),b)', 'val(((),c),2)'
        ], ['selected((),a)', 'selected((b,((),0)),b)', 'val(((),c),1)'
            ], ['selected((),a)', 'val(((),c),0)']])

        self.assertEqual(solve('simple_attr_count.lp'),
                         [[
                             'selected((),a)', 'val(((),b1),1)',
                             'val(((),b2),1)', 'val(((),c),1)'
                         ],
                          [
                              'selected((),a)', 'val(((),b1),1)',
                              'val(((),b2),2)', 'val(((),c),2)'
                          ],
                          [
                              'selected((),a)', 'val(((),b1),2)',
                              'val(((),b2),1)', 'val(((),c),2)'
                          ],
                          [
                              'selected((),a)', 'val(((),b1),2)',
                              'val(((),b2),2)', 'val(((),c),1)'
                          ]])
        self.assertEqual(solve('count_mixed.lp'),
                         [[
                             'selected((),a)', 'selected((b,((),0)),b)',
                             'selected((b,((),1)),b)', 'val(((),c),3)',
                             'val(((b,((),0)),d),1)', 'val(((b,((),1)),d),1)'
                         ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'selected((b,((),1)),b)', 'val(((),c),3)',
                              'val(((b,((),0)),d),2)', 'val(((b,((),1)),d),2)'
                          ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'selected((b,((),1)),b)', 'val(((),c),4)',
                              'val(((b,((),0)),d),1)', 'val(((b,((),1)),d),2)'
                          ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'selected((b,((),1)),b)', 'val(((),c),4)',
                              'val(((b,((),0)),d),2)', 'val(((b,((),1)),d),1)'
                          ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'val(((),c),2)', 'val(((b,((),0)),d),1)'
                          ],
                          [
                              'selected((),a)', 'selected((b,((),0)),b)',
                              'val(((),c),2)', 'val(((b,((),0)),d),2)'
                          ], ['selected((),a)', 'val(((),c),0)']])
        self.assertEqual(solve('simple_min.lp'), [[
            'selected((),a)', 'val(((),b),1)', 'val(((),c),2)', 'val(((),m),1)'
        ], [
            'selected((),a)', 'val(((),b),1)', 'val(((),c),4)', 'val(((),m),1)'
        ], [
            'selected((),a)', 'val(((),b),3)', 'val(((),c),2)', 'val(((),m),2)'
        ], [
            'selected((),a)', 'val(((),b),3)', 'val(((),c),4)', 'val(((),m),3)'
        ]])

        self.assertEqual(solve('simple_max.lp'), [[
            'selected((),a)', 'val(((),b),1)', 'val(((),c),2)', 'val(((),m),2)'
        ], [
            'selected((),a)', 'val(((),b),1)', 'val(((),c),4)', 'val(((),m),4)'
        ], [
            'selected((),a)', 'val(((),b),3)', 'val(((),c),2)', 'val(((),m),3)'
        ], [
            'selected((),a)', 'val(((),b),3)', 'val(((),c),4)', 'val(((),m),4)'
        ]])

        self.assertEqual(
            solve('count_at_optional.lp'),
            [['selected((),a)'],
             [
                 'selected((),a)', 'selected((b,((),0)),b)',
                 'selected((c,((b,((),0)),0)),c)', 'val(((b,((),0)),cou),1)'
             ]])

    def test_constraint(self):
        self.assertEqual(
            solve('tb_basic.lp'),
            [['selected((),a)', 'val(((),b),"b1")', 'val(((),c),"c1")'],
             ['selected((),a)', 'val(((),b),"b2")', 'val(((),c),"c2")']])
        self.assertEqual(len(solve('tb_colors.lp')), 8)

        self.assertEqual(len(solve('tb_with_optional.lp')), 4)
        self.assertEqual(len(solve('tb_with_optional_reverse.lp')), 4)

        self.assertEqual(
            solve('comparison.lp', ['-c', 'type="eq"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),2)']])
        self.assertEqual(
            solve('comparison.lp', ['-c', 'type="neq"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),2)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),1)']])
        self.assertEqual(
            solve('comparison.lp', ['-c', 'type="lt"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),2)']])
        self.assertEqual(
            solve('comparison.lp', ['-c', 'type="lte"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),1)', 'val(((),c),2)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),2)']])
        self.assertEqual(
            solve('comparison.lp', ['-c', 'type="gt"']),
            [['selected((),a)', 'val(((),b),2)', 'val(((),c),1)']])
        self.assertEqual(
            solve('comparison.lp', ['-c', 'type="gte"']),
            [['selected((),a)', 'val(((),b),1)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),1)'],
             ['selected((),a)', 'val(((),b),2)', 'val(((),c),2)']])

        self.assertEqual(len(solve('comparison_of_optional.lp')), 3)

        self.assertEqual(len(solve('alldiff.lp', ['-c', 'n=2'])), 2)
        self.assertEqual(len(solve('alldiff.lp', ['-c', 'n=3'])), 6)
        self.assertEqual(len(solve('alldiff.lp', ['-c', 'n=4'])), 24)
        self.assertEqual(len(solve('alldiff.lp', ['-c', 'n=5'])), 120)

        self.assertEqual(
            solve('incompatible.lp'),
            [['selected((),a)', 'val(((),b),"b1")', 'val(((),c),"c2")'],
             ['selected((),a)', 'val(((),b),"b2")', 'val(((),c),"c1")'],
             ['selected((),a)', 'val(((),b),"b2")', 'val(((),c),"c2")']])
