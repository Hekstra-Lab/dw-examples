import reciprocalspaceship as rs
from argparse import ArgumentParser

parser = ArgumentParser("Combine two half anomalous data sets into a single mtz")
parser.add_argument("plus_mtz")
parser.add_argument("minus_mtz")
parser.add_argument("out_mtz")
parser = parser.parse_args()

plus = rs.read_mtz(parser.plus_mtz)
minus = rs.read_mtz(parser.minus_mtz)
# anom_keys = ['F(+)', 'SigF(+)', 'F(-)', 'SigF(-)', 'N(+)', 'N(-)']

out = rs.concat([
    plus,
    minus.apply_symop("-x,-y,-z"),
])

half_repeats=[]
for repeat in out.repeat.unique():
    for half in range(2):
        half_repeat=out.loc[(out.repeat==repeat) & (out.half==half),["F","SigF","I","SigI","N","high","loc","low","scale"]] # discarding some columns
        half_repeat=half_repeat.unstack_anomalous()
        half_repeat["half"]=half
        half_repeat["half"]=half_repeat["half"].astype('MTZInt')
        half_repeat["repeat"]=repeat
        half_repeat["repeat"]=half_repeat["repeat"].astype('MTZInt')
        half_repeats.append(half_repeat)

out2=rs.concat(half_repeats)

out2.write_mtz(parser.out_mtz)
