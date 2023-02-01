
import json
import csv
 
filename = "data1.json"

# open as a json
with open(filename) as json_file:
    jsondata = json.load(json_file)

out_file = filename[:-5] + '.csv'

# open an output file
data_file = open(out_file, 'w', newline='')
csv_writer = csv.writer(data_file)
 
count = 0

# colorado springs data is stored in locations, cos, values
cos = jsondata['locations']['ColoradoSprings,CO,US']['values']
for val in cos:
    if count == 0:
        # the value's key is the column heading, or label (ex: temp)
        header = val.keys()
        csv_writer.writerow(header)
        count += 1
    # the value's value, (ex: 76 if label is temp)
    csv_writer.writerow(val.values())

data_file.close()

