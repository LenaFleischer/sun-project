import requests
import csv


hours = "24" # 1 is hourly, 24 is daily
#start = "2022-01-01T00:00:00"
#end = "2022-12-31T00:00:00"
location = "ColoradoSprings,CO,US"
type = "csv" # or json
# history, not forecast


import datetime

startDate = datetime.datetime(2017, 12, 31)
endDate = datetime.datetime(2018, 1, 1)

f = open("data.csv", "a")
f.write("Address,Date time,Minimum Temperature,Maximum Temperature,Temperature,Dew Point,Relative Humidity,Heat Index,Wind Speed,Wind Gust,Wind Direction,Wind Chill,Precipitation,Precipitation Cover,Snow Depth,Visibility,Cloud Cover,Sea Level Pressure,Weather Type,Latitude,Longitude,Resolved Address,Name,Info,Sunrise,Sunset,Moon Phase,Conditions\n")
f.close()


#Previous_Date = x - datetime.timedelta(days=1)
#print(Previous_Date.strftime("%Y-%m-%d"))
	
def get_data(api):
	print("running")
	response = requests.get(f"{api}")
	if response.status_code == 200:
		print("successfully fetched the data")
		text = response.text
		linebreak = text.find('\n')
		text = text[linebreak:]

		f = open("data.csv", "a")
		f.write(text+"\n")
		f.close()
	else:
		print(
			f"Hello person, there's a {response.status_code} error with your request")

for x in range(2557):
	newStartDate = startDate - datetime.timedelta(days=x)
	newEndDate = endDate - datetime.timedelta(days=x)

	start = newStartDate.strftime("%Y-%m-%d") + "T00:00:00"
	end = newEndDate.strftime("%Y-%m-%d") + "T00:00:00"

	location = "Denver,CO,US"
	hours = "1" # 1 is hourly, 24 is daily
	type = "csv"
	api_link = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/history?&aggregateHours="+hours+"&outputDateTimeFormat=yyyy-MM-dd'T'HH:mm:ss&startDateTime="+start+"&endDateTime="+end+"&unitGroup=us&contentType="+type+"&dayStartTime=0:0:00&dayEndTime=0:0:00&includeAstronomy=true&location="+location+"&key=L3ECDBLQ675PXHQS3BX4HQM8U"
	api_call = get_data(api_link)

