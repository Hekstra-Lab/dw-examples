import csv
import sys
import argparse

def concat_anom_peak_csv(output_csv_filename, frames_list, csv_list):
    with open(output_csv_filename, 'w', newline='') as output:
        writer = csv.writer(output)
        with open(csv_list[0], 'r') as file:
            reader = csv.reader(file)
            data = [row for row in reader]
            residues = data[0]
            
        overall_row = ["frames"] + residues
        writer.writerow(overall_row) 
        
        for i in range(len(csv_list)):
            
            with open(csv_list[i], 'r') as f:
                freader = csv.reader(f)
                data2 = [row for row in freader]
                peak_height = data2[1]
                
            overall_row_2 = [frames_list[i]] + peak_height    
            writer.writerow(overall_row_2)

def main():
    """
    THIS SCRIPT IS DESIGNED FOR USE AFTER ANOMALOUS_PEAK_HEIGHTS.PY, WHEN THAT SCRIPT HAS BEEN RUN ON A SUCCESSION OF DATASETS THAT DIFFER ONLY IN THE NUMBER OF FRAMES INCLUDED FROM ONE LARGER DATASET.
    If that is not the case, or if the assumptions listed in anomalous_peak_height.py are not met, this script likely will not work as intended!!!
    
    Call from the command line as:
        python concatenate_anomalous_peak_csv.py var1 var2

    Where the input variable are as follows
        var1: path/filename for final output csv
        var2: list of frame numbers
        var3+: list of csv files
    """
    csv_list = []
    for i in sys.argv[3:]:
        csv_list.append(i)
        
    frames_list = list(sys.argv[2].split(" "))
    
    concat_anom_peak_csv(sys.argv[1], frames_list, csv_list)

if __name__ == '__main__':
    main()