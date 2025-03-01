import requests

api_url = "https://uiuc.chat/api/chat-api/chat"
headers = {"Content-Type": "application/json"}

data = {
    "model": "Qwen/Qwen2.5-VL-72B-Instruct",
    "api_key": "uc_4bd07406e20340a1b61e75cc715f5277",
    "course_name": "Crop-Disease-Detection",
    "messages": [
        {
            "role": "system",
            "content": "You are a helpful AI assistant to help farmers learn more about the disease that their plant is affected by. Elaborate on the disease's potential causes and origins, symptoms, and suggestions for natural cures.  Follow instructions carefully. Assume low technical expertise & no programming experience when making suggestions. Do not promote chemical solutions; only promote natural alternatives. Respond using markdown."
        },
        {
            "role": "user",
            "content": [
                {
                  "type": "image_url",
                  "image_url": {
                    "url": "C:\\Users\\aljla\\Downloads\\sickplant2.jpg"
                  }
                },
                {
                  "type": "text",
                  "text": "My tomato plant is suffering from an unknown disease. Identify the disease and specific methods to cure the disease."
                }
            ]
        },
        {
            "role": "user",
            "content": "Continue with your previous response. Do not start from the beginning."
        },
        {
            "role": "user",
            "content": "Continue with your previous response. Do not start from the beginning."
        },
    ],
    "stream": True,
    "temperature": 0.1,
    "retrieval_only": False
}

response = requests.post(api_url, headers=headers, json=data)
print(response.text)

# curl -X POST https://uiuc.chat/api/chat-api/chat \
#   -H "Content-Type: application/json" \
#   -d '{
#     "model": "",
#     "messages": [
#       {
#         "role": "system",
#         "content": "You are a helpful AI assistant. Follow instructions carefully. Respond using markdown."
#       },
#       {
#         "role": "user",
#         "content": "What is in these documents?"
#       }
#     ],
#     "api_key": "uc_1c1ba05bdad4432a997d3994e5586577",
#     "course_name": "Crop-Disease-Detection",
#     "stream": true,
#     "temperature": 0.1,
#     "retrieval_only": false
#   }'

# import requests
#
# url = "https://uiuc.chat/api/chat-api/chat"
# headers = {
#     'Content-Type': 'application/json',
# }
# data = {
#     "model": "gpt-4o-mini",
#     "messages": [
#         {
#             "role": "system",
#             "content": "Your system prompt here"
#         },
#         {
#             "role": "user",
#             "content": "What is in these documents?"
#         }
#     ],
#     "openai_key": "YOUR-OPENAI-KEY-HERE",
#     "temperature": 0.1,
#     "course_name": "your-course-name",
#     "stream": True,
#     "api_key": "YOUR_API_KEY"
# }
#
# response = requests.post(url, headers=headers, json=data)
# print(response.text)