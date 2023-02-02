import requests
import json
import csv
import pandas as pd

FILE_PREFIX = '2022_data'

### NOTE: the csv out function is COLORADO SPRINGS specific. Can only deal with one location at a time
### The get_user_data function is unecessary for this, since we don't need to pass in specific user data
    # but it doesn't hurt. takes in parameters defined in __init__

class MakeApiCall:
    def get_data(self, api):
        response = requests.get(f"{api}")
        if response.status_code == 200:
            print("sucessfully fetched the data")
#            self.formatted_print(response.json())
            self.csv_out(response.json())
            self.json_out(response.json())
        else:
            print(
                  f"Hello person, there's a {response.status_code} error with your request")
    
#    # if we need specific user data
#    def get_user_data(self, api, parameters):
#        response = requests.get(f"{api}", params=parameters)
#        if response.status_code == 200:
#            print("sucessfully fetched the data with parameters provided")
##            self.formatted_print(response.json())
#            self.csv_out(response.json())
#            self.json_out(response.json())
#
#        else:
#            print(
#                  f"Hello person, there's a {response.status_code} error with your request")
#
    def formatted_print(self, obj):
        text = json.dumps(obj, sort_keys=True, indent=4)
        print(text)
#        writeFile = open('data1.json', 'w')
#        writeFile.write(json.dumps(obj))
#        writeFile.close()
#        print("written!")
            
    def json_out(self, obj):
        out_file = FILE_PREFIX + '.json'
        writeFile = open(out_file, 'w')
        writeFile.write(json.dumps(obj))
        writeFile.close()
        print("Successfully written to " + out_file)
    
    def csv_out(self, obj):
        jsondata = obj
        
        out_file = FILE_PREFIX + '.csv'
        # open an output file
        writeFile = open(out_file, 'w', newline='')
        csv_writer = csv.writer(writeFile)
        count = 0
        # colorado springs data is stored in locations, cos, values
        cos = obj['locations']['ColoradoSprings,CO,US']['values']
        for val in cos:
            if count == 0:
                # the value's key is the column heading, or label (ex: temp)
                header = val.keys()
                csv_writer.writerow(header)
                count += 1
            # the value's value, (ex: 76 if label is temp)
            csv_writer.writerow(val.values())

        writeFile.close()
        print("Successfully written to " + out_file)
    

    def __init__(self, api):
         self.get_data(api)
#
#        parameters = {
#            "username": "lena"
#        }
#        self.get_user_data(api, parameters)

if __name__ == "__main__":
    hours = "24" # 1 is hourly, 24 is daily
    start = "2022-01-01T00:00:00"
    end = "2022-12-31T00:00:00"
    location = "ColoradoSprings,CO,US"
    type = "json" # or csv
    # history, not forecast
    api_link = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/history?&aggregateHours="+hours+"&startDateTime="+start+"&endDateTime="+end+"&unitGroup=us&contentType="+type+"&dayStartTime=0:0:00&dayEndTime=0:0:00&location="+location+"&key=L3ECDBLQ675PXHQS3BX4HQM8U"
    
    api_call = MakeApiCall(api_link)



#
#def get_api_link():
##        full_link = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/history?&aggregateHours=24&startDateTime=2019-06-13T00:00:00&endDateTime=2019-06-13T00:00:00&unitGroup=us&contentType=json&dayStartTime=0:0:00&dayEndTime=0:0:00&location=ColoradoSprings,CO,US&key=L3ECDBLQ675PXHQS3BX4HQM8U"
#    hours = "24"
#    start = "2022-05-23T00:00:00"
#    end = "2022-05-24T00:00:00"
#    location = "ColoradoSprings,CO,US"
#    api_link = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/history?&aggregateHours="+hours"&startDateTime="+start+"&endDateTime="+end+"&unitGroup=us&contentType=json&dayStartTime=0:0:00&dayEndTime=0:0:00&location="+location+"&key=L3ECDBLQ675PXHQS3BX4HQM8U"
#    return api_link
