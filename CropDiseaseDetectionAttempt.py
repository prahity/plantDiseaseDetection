import requests

def uiuc_chat_call(plant, disease):
    if (disease == "healthy"):
        return "Your " + plant + " plant is healthy. Make sure to continue nurturing it."
    api_url = "https://uiuc.chat/api/chat-api/chat"
    headers = {"Content-Type": "application/json"}

    data = {
        "model": "Qwen/Qwen2.5-VL-72B-Instruct",
        "api_key": "uc_4bd07406e20340a1b61e75cc715f5277",
        "course_name": "Crop-Disease-Detection",
        "messages": [
            {
                "role": "system",
                "content": "You are a helpful AI assistant to help farmers with treating plant diseases. Follow instructions carefully. Assume no technical expertise or programming experience when making suggestions. Respond using markdown. Limit response to under 200 words."
                # "content": "You are a helpful AI assistant to help farmers with treating plant diseases. Deliver at least three potential causes and origins of the disease and at least three symptoms. Provide three suggestions for natural, non-chemical cures to the diseases. Follow instructions carefully. Assume no technical expertise or programming experience when making suggestions. Respond using markdown."
                # "content": "You are a helpful AI assistant to help farmers learn more about the disease that their plant is affected by. Elaborate on the disease's potential causes and origins, symptoms, and suggestions for natural cures.  Follow instructions carefully. Assume low technical expertise & no programming experience when making suggestions. Do not promote chemical solutions; only promote natural alternatives. Respond using markdown."
            }, 
            {
                "role": "user",
                "content": [
                    # {
                    #   "type": "image_url",
                    #   "image_url": {
                    #     "url": "C:\\Users\\aljla\\Downloads\\sickplant4.jpg"
                    #   }
                    # },
                    {
                      "type": "text",
                      "text": "My " + plant + " is suffering from " + disease + ". Give a description of "  + disease + " and its potential causes. Recommend three natural, no-chemical and no-pesticide treatment options."
                        # "text": "My tomato plant is suffering from scab disease. Give a description of scab disease. Recommend three natural, no-chemical and no-pesticide treatment options."  # Good example; output is very thorough.
                      # "text": "My TOMATO PLANT is suffering from SCAB DISEASE. Give a description of SCAB DISEASE. Recommend three natural, no-chemical and no-pesticide treatment options."
                      # keywords are in all capital letters
                    }
                ]
            },
            {
                "role": "user",
                "content": "Go on with your previous response. Do not start from the beginning."
            },
            {
                "role": "user",
                "content": "Finish your previous response. Do not start from the beginning."
            }
        ],
        "stream": True,
        "temperature": 0,
        "retrieval_only": False
    }

    response = requests.post(api_url, headers=headers, json=data)
    print(response.text)
    return response.text


# data = {
#     "model": "Qwen/Qwen2.5-VL-72B-Instruct",
#     "api_key": "uc_4bd07406e20340a1b61e75cc715f5277",
#     "course_name": "Crop-Disease-Detection",
#     "messages": [
#         {
#             "role": "system",
#             "content": "You are a helpful AI assistant to help farmers with treating plant diseases. Deliver at least three potential causes and origins of the disease and at least three symptoms. Provide three suggestions for natural, non-chemical cures to the diseases. Follow instructions carefully. Assume no technical expertise or programming experience when making suggestions. Respond using markdown."
#             # "content": "You are a helpful AI assistant to help farmers learn more about the disease that their plant is affected by. Elaborate on the disease's potential causes and origins, symptoms, and suggestions for natural cures.  Follow instructions carefully. Assume low technical expertise & no programming experience when making suggestions. Do not promote chemical solutions; only promote natural alternatives. Respond using markdown."
#         },
#         {
#             "role": "user",
#             "content": [
#                 {
#                   "type": "image_url",
#                   "image_url": {
#                     "url": "C:\\Users\\aljla\\Downloads\\sickplant2.jpg"
#                   }
#                 },
#                 {
#                   "type": "text",
#                   "text": "Tell me about George Washington Carver."  # This irrelevant question kind of crashes the model
#                   # "text": "My tomato plant is suffering from scab disease."
#                   # "text": "My tomato plant is suffering from scab disease. Identify potential origins or causes of this disease. Recommend three natural, no-chemical and no-pesticide treatment options."
#                 }
#             ]
#         },
#         {
#             "role": "user",
#             "content": "Continue with your previous response. Do not start from the beginning."
#         },
#         {
#             "role": "user",
#             "content": "Finish with your previous response. Do not start from the beginning."
#         }
#     ],
#     "stream": True,
#     "temperature": 0,
#     "retrieval_only": False
# }