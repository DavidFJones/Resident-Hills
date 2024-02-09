extends HTTPRequest

#url for items spreadsheet
const ITEM_URL = "https://opensheet.elk.sh/13Kv-zEaHI4GvTb2z1juSxBfkQQ6vFU9kxZFO5NwF01s/items"
#holds all our collectables in the scene
var customItems = []
#booleon to see if we should
var runningHTTPItemRequest = false

func make_HTTP_item_request(itemsArray):
	customItems = itemsArray
	self.request_completed.connect(_on_http_item_request_completed)
	self.request(ITEM_URL)

func _on_http_item_request_completed(_result, _response_code, _headers, body):
	#get our json from the http request
	var data = JSON.parse_string(body.get_string_from_utf8())

	#loop through our items and see if we have any relevent json data
	#if so write over the customitem with the json data
	for item in customItems:
		if item.ignoreHTTP == true:
			print(item)
			continue
		var sheetData = find_id_in_dict(data,item.ID)
		if sheetData != null:
			item.Name = sheetData.Name
			item.Description = sheetData.Description
			#not sure if there is a better way to convert TRUE to true?
			if sheetData.Stackable == "TRUE":
				item.Stackable = true
			else:
				item.Stackable = false
			item.Description = sheetData.Description
			if sheetData.Equipable == "TRUE":
				item.Equipable = true
			else:
				item.Equipable = false
			if sheetData.CanCombine == "TRUE":
				item.CanCombine = true
			else:
				item.CanCombine = false
			if sheetData.CanDrop == "TRUE":
				item.CanDrop = true
			else:
				item.CanDrop = false
			item.MaxAmmo = sheetData.MaxAmmo
			item.StartingAmmo = sheetData.StartingAmmo

	runningHTTPItemRequest = false

func find_id_in_dict(dict, id):
	var entry = null
	for item in dict:
		if item.ID == str(id):
			entry = item
			break
	return entry
