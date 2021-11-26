#!/usr/bin/env python3
from pmsp.english.phonemes import Phonemes
from pmsp.english.graphemes import Graphemes
from pmsp.english.frequencies import Frequencies
import pandas as pd

import sys

graphemes = Graphemes()
phonemes = Phonemes()


def generate_probes():
    count = 0
    df = pd.read_csv('./usr/mccann-fix.csv')
    phonology_df = pd.read_csv('./usr/pmsp-data.csv')
    last_item = ''
    out = ''
    for idx, row in df.iterrows():
        # print(row)

        if row['Cat'] != 'PH':
            continue
        item_id = row['Item ID']
        item = (row['Item'] if str(row['Item'])
                != 'nan' else last_item).strip()
        last_item = item
        pa = (row['Item'] if row['Paired Associate'] ==
              ' - ' else row['Paired Associate']).strip()

        # locate item in phonology df that matches `pa`
        pa_row = phonology_df.loc[ phonology_df['orth'] == pa ]

        # if a corresponding phonology is found, generate this example
        if pa_row['phon'].any():
            out += f"name: {{{item_id}_{item}_{pa}}}\n"

            grapheme_vector = graphemes.get_graphemes(item)
            out += f"I: {' '.join([str(x) for x in grapheme_vector])}\n"
            print(f"orthography     {item} {graphemes._get_graphemes(item)}")

            
            phonology = pa_row['phon'].iloc[0]

            phonology_vector = phonemes.get_phonemes(phonology)
            print(f"phonology       {item} {phonology} {phonemes.get_phonemes(phonology)}")

            out += f"T: {' '.join([str(x) for x in phonology_vector])};\n\n"
        else:
            print(f"no match for {pa}")
            # sys.exit(1)

    f = open("./var/mccann.ex", "w")
    f.write(out)
    f.close()


if __name__ == "__main__":
    generate_probes()
