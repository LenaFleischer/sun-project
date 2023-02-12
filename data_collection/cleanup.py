

with open('date_and_time_denver_sunrise.csv', 'r') as in_file, open('2011_2017_denver_sunrise.csv', 'w') as out_file:
    seen = set() # set for fast O(1) amortized lookup
    out_file.write("Sunrise Dates\n")
    for line in in_file:
        space_index = line.rfind(" ")
        date = line[:space_index]
        if(date[2] == "1"):
            if(date[3] == "1" or date[3] == "2" or date[3] == "3" or date[3] == "4" or date[3] == "5"
                or date[3] == "6" or date[3] == "7"):
                    out_file.write(line)