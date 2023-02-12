import requests
import json

api_key = "484f654760142c97321906e5b5325199"
tag = "sunrise%2CDenver"
#text = "sunrise+Denver"
#text = "sunrise"
lat = "39.7392"
lon = "-104.9903"
radius = "20"
page = "1"
page_num = int(page)
num_valid = 0

#already in file
"""
response = requests.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key="+api_key+
	"&text="+text+"&has_geo=1&lat="+lat+"&lon="+lon+"&radius="+radius+
	"&radius_units=mi&extras=date_taken&page="+page+"&format=json&nojsoncallback=1").text
"""
"""
#haven't used  yet, might not be as accurate
response = requests.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key="+api_key+
	"&text="+text+"&extras=date_taken&page="+page+"&format=json&nojsoncallback=1").text
"""

response = requests.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key="+api_key+
	"&tags="+tag+"&tag_mode=all&extras=date_taken&page="+page+"&format=json&nojsoncallback=1").text


response_info = json.loads(response)

num_pages = response_info['photos']['pages']
#print(response_info)

photo_dict = response_info['photos']['photo']

date_list = []

for photo in photo_dict:
	this_date = photo['datetaken']
	date_list.append(this_date)
	num_valid+=1

if(num_pages > 1):
	while page_num < num_pages:
		page_num += 1
		page = str(page_num)
		
		
		response = requests.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key="+api_key+
			"&tags="+tag+"&tag_mode=all&extras=date_taken&page="+page+"&format=json&nojsoncallback=1").text
		
		response_info = json.loads(response)
		#print(response_info)

		num_pages = response_info['photos']['pages']

		photo_dict = response_info['photos']['photo']

		for photo in photo_dict:
			this_date = photo['datetaken']
			num_valid += 1
			date_list.append(this_date)


f = open("date_and_time_denver_sunrise.csv", "a")

for date in date_list:
	f.write(date+"\n")

f.close()
