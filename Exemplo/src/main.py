import requests
import json

def chuckNorris():

    api = "https://api.chucknorris.io/jokes/random"
    data = requests.get(api)
    jsonOut = json.loads(data.text)
    
    print(jsonOut["value"])

chuckNorris()
