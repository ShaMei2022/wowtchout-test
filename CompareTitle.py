# 互相比對selenium跟requests的資料

from selenium import webdriver
import json
from turtle import title
import requests

# 此段為request
url = "https://www.wowtchout.com/api/graphql"

payload = "{\"operationName\":\"Videos\",\"variables\":{\"type\":\"QUADRILATERAL\",\"limit\":10,\"xmin\":\"25.185046759272\",\"ymin\":\"121.4631424507324\",\"xmax\":\"24.915385147152584\",\"ymax\":\"121.62004094926756\"},\"query\":\"query Videos($type: EVideosType!, $limit: Int, $lat: String, $lng: String, $xmin: String, $ymin: String, $xmax: String, $ymax: String) {\\n  videos(\\n    type: $type\\n    limit: $limit\\n    lat: $lat\\n    lng: $lng\\n    xmin: $xmin\\n    ymin: $ymin\\n    xmax: $xmax\\n    ymax: $ymax\\n  ) {\\n    ...VideoFragment\\n    __typename\\n  }\\n}\\n\\nfragment VideoFragment on Video {\\n  video_id\\n  title\\n  youtube_uri\\n  description\\n  user_id\\n  lat\\n  lng\\n  address\\n  happened_time\\n  start_time\\n  end_time\\n  views\\n  created_at\\n  published_at\\n  status\\n  is_anonymous\\n  feedback\\n  user {\\n    id\\n    name\\n    image\\n    __typename\\n  }\\n  tags {\\n    tag {\\n      tag_id\\n      name\\n      __typename\\n    }\\n    __typename\\n  }\\n  images {\\n    image {\\n      image_id\\n      url\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\"}"
headers = {
    'content-type': "application/json",
}

response = requests.request("POST", url, data=payload, headers=headers)

dictinfo = json.loads(response.text)
print(json.loads(response.text))

# 此段為selenium
Path = "./chromedriver"
driver = webdriver.Chrome(Path)
driver.get("https://www.wowtchout.com/map")
title = driver.find_elements_by_xpath(
    '//*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]/div[*]/a/div[2]/h3')

for i in range(len(title)):
    print("實際的:"+title[i].text+"\n"+"預期的:" +
          dictinfo["data"]["videos"][i]["title"])
