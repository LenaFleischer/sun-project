import requests
import json

response = requests.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=484f654760142c97321906e5b5325199&text=sunset+Denver&min_taken_date=2022-01-01+00%3A00%3A00&max_taken_date=2022-12-31+23%3A59%3A59&extras=date_taken&page=1&format=json&nojsoncallback=1").text
response_info = json.loads(response)
photo_dict = response_info['photos']['photo']

for photo in photo_dict:
	this_date = photo['datetaken']
	print(this_date)


response = requests.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=484f654760142c97321906e5b5325199&text=sunset+Denver&min_taken_date=2022-01-01+00%3A00%3A00&max_taken_date=2022-12-31+23%3A59%3A59&extras=date_taken&page=2&format=json&nojsoncallback=1").text
response_info = json.loads(response)
photo_dict = response_info['photos']['photo']

for photo in photo_dict:
	this_date = photo['datetaken']
	print(this_date)