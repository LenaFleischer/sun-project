import requests
import json

#some of these values change! change tag, text based on type of call you want to make, lat and lon if you make geolocation call
#don't change api_key, page, page_num, radius
#num_valid isn't used for anything i believe i was using it as a checker at some point
api_key = "484f654760142c97321906e5b5325199"
tag = "sunrise%2CColorado+Springs"
#text = "sunrise+Colorado+Springs"
#text = "sunrise"
lat = "38.8339"
lon = "-104.8214"
radius = "20"
page = "1"
page_num = int(page)
num_valid = 0


#UNCOMMENT THE CALL YOU WANT TO MAKE, COMMENT THE OTHERS OUT. !!!!IMPORTANT!!!!! COPY THE RESPONSE CALL HERE AND PASTE IT INTO THE RESPONSE CALL ON LINE 64
"""
#this is the geolocation call, use text "sunrise"
response = requests.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key="+api_key+
	"&text="+text+"&has_geo=1&lat="+lat+"&lon="+lon+"&radius="+radius+
	"&radius_units=mi&extras=date_taken&page="+page+"&format=json&nojsoncallback=1").text

"""
"""
#the largest, most results call, use text "sunrise+Denver"
response = requests.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key="+api_key+
	"&text="+text+"&extras=date_taken&page="+page+"&format=json&nojsoncallback=1").text
"""

#gets photos tagged sunrise and Denver, use tag "sunrise%2CDenver"
response = requests.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key="+api_key+
	"&tags="+tag+"&tag_mode=all&extras=date_taken&page="+page+"&format=json&nojsoncallback=1").text


response_info = json.loads(response)

num_pages = response_info['photos']['pages']
#print(num_pages)

photo_dict = response_info['photos']['photo']

date_list = []

for photo in photo_dict:
	this_date = photo['datetaken']
	this_time = this_date[11:]
	#you can get rid of these "if" checkers if you're checking for sunrise times in the ML part
	#if(this_time < "10:00:00"):
	if(this_time < "10:00:00" and photo['owner']!= "33499543@N08"):
		#print(this_date)
		date_list.append(this_date)
		num_valid+=1

if(num_pages > 1):
	while page_num < num_pages:
		page_num += 1
		page = str(page_num)
		

		#IMPORTANT!!!!!!!: MAKE SURE THIS MATCHES THE API CALL THAT YOU'RE USING ON LINES 19-31 JUST COPY AND PASTE THE SAME THING
		response = requests.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key="+api_key+
			"&tags="+tag+"&tag_mode=all&extras=date_taken&page="+page+"&format=json&nojsoncallback=1").text

		response_info = json.loads(response)
		#print(response_info)

		num_pages = response_info['photos']['pages']

		photo_dict = response_info['photos']['photo']

		for photo in photo_dict:
			this_date = photo['datetaken']
			this_time = this_date[11:]
			#print(this_time)
			#get rid of these if checkers
			if(this_time < "10:00:00" and photo['owner']!= "33499543@N08"):
			#if(this_time < "10:00:00"):
				num_valid += 1
				date_list.append(this_date)
				#print(num_valid)


f = open("dates.csv", "a")

for date in date_list:
	date_only = date[:10]
	f.write(date_only+"\n")

f.close()

