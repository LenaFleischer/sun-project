

with open('date_and_time_denver_sunset.csv', 'r') as in_file, open('2019_denver_sunset.csv', 'w') as out_file:
    seen = set() # set for fast O(1) amortized lookup
    out_file.write("Sunrise Dates\n")
    for line in in_file:
        space_index = line.rfind(" ")
        date = line[:space_index]
        if(date[2] == "1"):
            if(date[3] == "9"):
                    out_file.write(line)
