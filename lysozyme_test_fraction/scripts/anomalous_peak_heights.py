import pandas as pd
import numpy as np
import gemmi
import sys
import csv

def get_anom_peak_heights(mtz_filename, pdb_filename, atom_list):

    # Read in mtz and pdb as gemmi objects
    mtz_file = gemmi.read_mtz_file(mtz_filename)
    st = gemmi.read_pdb(pdb_filename)

    # Prep VAE structure
    real_grid = mtz_file.transform_f_phi_to_map('ANOM', 'PHANOM', sample_rate=3.0)
    real_grid.normalize()

    # Identify relevant atoms in the model
    sel = gemmi.Selection(f"{atom_list}")
    sel_model = sel.copy_model_selection(st[0])
    anom_atoms = [i for i in list(sel_model.all())]

    # Initialize lists of residue/ion id & types and anomalous peak heights. 
    # Note that the indexing of these lists will match! 
    anom_res = []
    anom_peaks = []

    # Loop through each atom and quantify the anomalous signal at those coordinates
    for cra in anom_atoms:
        # Get all equivalent sites
        eq_points = []
        ops = real_grid.spacegroup.operations()
        atom = cra.atom

        # Check the highest peak
        a,b,c = np.unravel_index(real_grid.array.argmax(), real_grid.array.shape)
        tmp = real_grid.get_fractional(a,b,c)
        peak_pos = st.cell.orthogonalize(gemmi.Fractional(tmp.x, tmp.y, tmp.z))
        dis_list = []

        # Calculate symmetry related points
        for op in ops:
            SG_mapped = op.apply_to_xyz(st.cell.fractionalize(atom.pos).tolist())
            tmp = SG_mapped - np.floor(np.array(SG_mapped))
            SG_mapped = gemmi.Fractional(*tmp)
            eq_points.append(SG_mapped)
            SG_mapped_orth = st.cell.orthogonalize(SG_mapped)
            dis_list.append(np.sqrt(np.sum(np.array((peak_pos - SG_mapped_orth).tolist())**2)))

        # Get the value of the nearest voxel across all symmetry-related points
        peak_value = []
        for pos in eq_points:
            a = round(pos.x * real_grid.nu)
            b = round(pos.y * real_grid.nv)
            c = round(pos.z * real_grid.nw)
            peak_value.append(real_grid.get_value(a, b, c))

        # Take the average anomalous signal across the equivalent points
        anom_height = np.average(peak_value)
        anom_height = round(anom_height, 3)

        # Append to list
        anom_res.append(f"{cra.residue.name} {cra.residue.seqid.num}")
        anom_peaks.append(anom_height)

    # Return lists of residue/ion name + number and anomalous peak height
    return anom_res, anom_peaks
            
def main():
    """
    This script calculates the anomalous signal/anomalous peak heights from a given map (mtz file) for a given list of anomalous atom types (e.g S and I) in a pdb model.
    It assumes that all atoms of that type produce relevant anomalous signal, and that the relevant mtz column labels are 'ANOM' and 'PHANOM'.

    Call from the command line as:
        python anomalous_peak_heights.py var1 var2 var3 var4

    Whre the input variables are as follows:
        var1 = path to the mtz file
        var2 = path to the pdb file
        var3 = list of relevant atom types (e.g. [S,I])
        var4 = path/filename for output csv
    """
    # Calculate peak heights
    anom_res, anom_peaks = get_anom_peak_heights(mtz_filename=sys.argv[1], pdb_filename=sys.argv[2], atom_list=sys.argv[3])

    # Write out csv
    with open(sys.argv[4], 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(anom_res)
        writer.writerow(anom_peaks)

if __name__ == '__main__':
    main()
    