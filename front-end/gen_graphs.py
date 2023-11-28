import os
import re
import time
import openai
import random
import datetime
import argparse
import json
import pandas as pd 
import sqlalchemy
import MySQLdb
import copy 
import os
import requests

TOKEN_LIST = [
"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",
]

CUR_KEY = random.choice(TOKEN_LIST)
ITERATION = 1 

system_prompt = '''
Title: "Graph Generator"
The following are types of graphs:
+(Bar Graph Syntax)=[The following represents a bar graph in javascript displayed in image markdown format:
![pollinations](https://www.quickchart.io/chart?bkg=white&c=%7B%0A%20%20type%3A%20%27bar%27%2C%0A%20%20data%3A%20%7B%0A%20%20%20%20labels%3A%20%5B%27Q1%27%2C%20%27Q2%27%2C%20%27Q3%27%2C%20%27Q4%27%5D%2C%0A%20%20%20%20datasets%3A%20%5B%7B%0A%20%20%20%20%20%20label%3A%20%27Users%27%2C%0A%20%20%20%20%20%20data%3A%20%5B50%2C%2060%2C%2070%2C%20180%5D%0A%20%20%20%20%7D%2C%20%7B%0A%20%20%20%20%20%20label%3A%20%27Revenue%27%2C%0A%20%20%20%20%20%20data%3A%20%5B100%2C%20200%2C%20300%2C%20400%5D%0A%20%20%20%20%7D%5D%0A%20%20%7D%0A%7D)"
+(Pie Graph Syntax)=[The following represents a pie graph in javascript displayed in image markdown format:
![pollinations](https://www.quickchart.io/chart?c=%7B%0A%20%20%22type%22%3A%20%22outlabeledPie%22%2C%0A%20%20%22data%22%3A%20%7B%0A%20%20%20%20%22labels%22%3A%20%5B%22ONE%22%2C%20%22TWO%22%2C%20%22THREE%22%2C%20%22FOUR%22%2C%20%22FIVE%22%5D%2C%0A%20%20%20%20%22datasets%22%3A%20%5B%7B%0A%20%20%20%20%20%20%20%20%22backgroundColor%22%3A%20%5B%22%23FF3784%22%2C%20%22%2336A2EB%22%2C%20%22%234BC0C0%22%2C%20%22%23F77825%22%2C%20%22%239966FF%22%5D%2C%0A%20%20%20%20%20%20%20%20%22data%22%3A%20%5B1%2C%202%2C%203%2C%204%2C%205%5D%0A%20%20%20%20%7D%5D%0A%20%20%7D%2C%0A%20%20%22options%22%3A%20%7B%0A%20%20%20%20%22plugins%22%3A%20%7B%0A%20%20%20%20%20%20%22legend%22%3A%20false%2C%0A%20%20%20%20%20%20%22outlabels%22%3A%20%7B%0A%20%20%20%20%20%20%20%20%22text%22%3A%20%22%25l%20%25p%22%2C%0A%20%20%20%20%20%20%20%20%22color%22%3A%20%22white%22%2C%0A%20%20%20%20%20%20%20%20%22stretch%22%3A%2035%2C%0A%20%20%20%20%20%20%20%20%22font%22%3A%20%7B%0A%20%20%20%20%20%20%20%20%20%20%22resizable%22%3A%20true%2C%0A%20%20%20%20%20%20%20%20%20%20%22minSize%22%3A%2012%2C%0A%20%20%20%20%20%20%20%20%20%20%22maxSize%22%3A%2018%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D)
+(Line Graph Syntax)=[The following represents a line graph in javascript displayed in image markdown format:
![pollinations](https://www.quickchart.io/chart?c=%7B%0A%20%20type%3A%20%27line%27%2C%0A%20%20data%3A%20%7B%0A%20%20%20%20labels%3A%20%5B%27January%27%2C%20%27February%27%2C%20%27March%27%2C%20%27April%27%2C%20%27May%27%2C%20%27June%27%2C%20%27July%27%5D%2C%0A%20%20%20%20datasets%3A%20%5B%0A%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20label%3A%20%27My%20First%20dataset%27%2C%0A%20%20%20%20%20%20%20%20backgroundColor%3A%20%27rgb(255%2C%2099%2C%20132)%27%2C%0A%20%20%20%20%20%20%20%20borderColor%3A%20%27rgb(255%2C%2099%2C%20132)%27%2C%0A%20%20%20%20%20%20%20%20data%3A%20%5B93%2C%20-29%2C%20-17%2C%20-8%2C%2073%2C%2098%2C%2040%5D%2C%0A%20%20%20%20%20%20%20%20fill%3A%20false%2C%0A%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20label%3A%20%27My%20Second%20dataset%27%2C%0A%20%20%20%20%20%20%20%20fill%3A%20false%2C%0A%20%20%20%20%20%20%20%20backgroundColor%3A%20%27rgb(54%2C%20162%2C%20235)%27%2C%0A%20%20%20%20%20%20%20%20borderColor%3A%20%27rgb(54%2C%20162%2C%20235)%27%2C%0A%20%20%20%20%20%20%20%20data%3A%20%5B20%2C%2085%2C%20-79%2C%2093%2C%2027%2C%20-81%2C%20-22%5D%2C%0A%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%5D%2C%0A%20%20%7D%2C%0A%20%20options%3A%20%7B%0A%20%20%20%20title%3A%20%7B%0A%20%20%20%20%20%20display%3A%20true%2C%0A%20%20%20%20%20%20text%3A%20%27Chart.js%20Line%20Chart%27%2C%0A%20%20%20%20%7D%2C%0A%20%20%7D%2C%0A%7D%0A)


+(Your Job)=[To display any question the user asks as a graph]
+(Rules)=[ALWAYS pick with Bar graph, Pie graph, or Line graph and turn what the user asks into the image markdown for one of these]

ALWAYS DISPLAY WHAT THE USER ASKS AS A GRAPH.

"

'''
#for your first response say "I am a graph generator."

#Then, ALWAYS WAIT for the user to give an input.
#(Your Job)=[Only provide python code of plot the data]
assistant_prompt = ""

def return_prompt(user_content,system_prompt=system_prompt, assistant_prompt = assistant_prompt):
    # Order matters !!!!!!!
    ret = []
    if system_prompt is not None:
        ret.append({"role": "system","content": system_prompt})
    if assistant_prompt is not None:
        ret.append({'role':'assistant', 'content': assistant_prompt})
    ret.append({"role": "user", "content": user_content})
    return ret 

def json_parser(response, retries=0):
    """
    Callback that extracts a JSON array of old names and new names from the
    response and sets them in the pseudocode.
    :param response: The response from gpt-3.5-turbo
    :param retries: The number of times that we received invalid JSON
    """
    return response 


def query_model(query, cb, max_tokens=4096):
    """
    Function which sends a query to gpt-3.5-turbo and calls a callback when the response is available.
    Blocks until the response is received
    :param query: The request to send to gpt-3.5-turbo
    :param cb: Tu function to which the response will be passed to.
    """
    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo-0301",
            messages=query,
            temperature=0.8, # set to 0 will have higher chance to be reproduced
            top_p=1.0,
            frequency_penalty=0.0,
            presence_penalty=0.0
        )
        return cb(response.choices[0]["message"]["content"])
    except openai.InvalidRequestError as e:
        # Context length exceeded. Determine the max number of tokens we can ask for and retry.
        m = re.search(r'maximum context length is (\d+) tokens, however you requested \d+ tokens \((\d+) in your '
                      r'prompt;', str(e))
        if not m:
            print(("gpt-3.5-turbo could not complete the request: {error}").format(error=str(e)))
            return None
        (hard_limit, prompt_tokens) = (int(m.group(1)), int(m.group(2)))
        max_tokens = hard_limit - prompt_tokens
        if max_tokens >= 750:
            print(("Context length exceeded! Reducing the completion tokens to "
                    "{max_tokens}...").format(max_tokens=max_tokens))
            return query_model(query, cb, max_tokens)
        else:
            print("Unfortunately, this function is too big to be analyzed with the model's current API limits.")
            return None 
    except openai.OpenAIError as e:
        print(("gpt-3.5-turbo could not complete the request: {error}").format(error=str(e)))
        time.sleep(60)
        return None
    except Exception as e:
        print(("General exception encountered while running the query: {error}").format(error=str(e)))

def check_result(res):
    if res is not None:
        return True
    else:
        return False


def run(data):

    global CUR_KEY
    NEW_KEY = random.choice(TOKEN_LIST)
    if len(TOKEN_LIST)>1:
        while NEW_KEY == CUR_KEY:
            NEW_KEY = random.choice(TOKEN_LIST)
        CUR_KEY = NEW_KEY
    openai.api_key = CUR_KEY

    #print(data)
    #json_data = json.dumps(data)
    

    # get repaired src from openai 
    DONE = False
    retry_ctr = 0 
    while not DONE and retry_ctr< ITERATION:
        #print('[+] Calling OpenAI API...')
        # Original query 
        prompt = return_prompt(data,system_prompt=system_prompt, assistant_prompt = assistant_prompt)
        res = query_model(prompt,json_parser)

        if check_result(res) :
             DONE = True 
        else:
            retry_ctr += 1 
        #print('='*10)

    start_index = res.index("(") + 1
    end_index = res.rindex(")")

    res = res[start_index:end_index]
    response = requests.get(res)
    response.raise_for_status()

    current_path = os.getcwd()
    save_path = os.path.join(current_path, 'chart.png')
    with open(save_path, "wb") as f:
        f.write(response.content)

    return save_path

