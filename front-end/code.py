import gradio as gr
import random
import PIL
import numpy as np
import time
from PIL import Image,ImageFilter,ImageEnhance
import os
import shutil
#import db_chat_demo
#import db_creator_demo
import pandas as pd
import psycopg2
import mysql.connector
import csv
import gen_graphs

ans = ""
user_name = ""
dir = r"C:\Users\Administrator\Desktop\test"
sql = "SELECT e.emp_no, e.first_name, e.last_name, MAX(s.salary) AS highest_salary FROM employees e JOIN salaries s ON e.emp_no = s.emp_no WHERE s.from_date >= '1989-01-01' AND s.to_date <= '1990-01-01' GROUP BY e.emp_no ORDER BY highest_salary DESC LIMIT 10;"
# 数据库连接配置
db_config = {
    'user': 'root',
    'password': '123456',
    'host': '175.178.0.29',
    'port': 3306,
    'database': 'employees'
}

# 连接到数据库
try:
    db_connection = mysql.connector.connect(**db_config)
    print("成功连接到数据库")
except mysql.connector.Error as error:
    print("连接数据库失败:", error)
    db_connection = None

# 查询字符串
dbquery = "SELECT first_name, last_name FROM employees WHERE emp_no = 88888;"

# 执行查询并获取结果
def get_information():
    ret = ""
    ret = ret + "Here is the sql code to get your information from the database:\n"
    global sql
    ret = ret + sql + "\n"
    ret = ret + "The following messages are the information:\n"
    if db_connection:
        cursor = db_connection.cursor()
        cursor.execute(sql)

        # 获取查询结果
        output = cursor.fetchall()

    # 打印输出结果
        for row in output:
            ret = ret + "{}".format(row) + '\n'

    # 关闭cursor和连接
        cursor.close()
        db_connection.close()

        global ans
        ans = ret
        with open(dir + r'\data.csv','w',newline='') as csvfile:
            writer = csv.writer(csvfile)
            for i in ans:
                writer.writerow([i])
        data = csvfile
        return ret,data
#成比例缩放图像
def reset_image(img,scale):
    #读取图像
    x = img.height
    y = img.width

    #更改尺寸
    new_x = int(x * scale)
    new_y = int(y * scale)
    new_img = img.resize((new_x,new_y))

    return new_img

#修复图片，增加图片清晰度，用于调整装饰界面
def repair_image(img):

    #亮度调节
    enh_bri = ImageEnhance.Brightness(img)
    brightness = 1
    image_brightened = enh_bri.enhance(brightness)

    #色度调节
    enh_col = ImageEnhance.Color(image_brightened)
    color = 1.5
    image_colored = enh_col.enhance(color)

    #对比读调节
    enh_con = ImageEnhance.Contrast(image_colored)
    contrast = 1.2
    image_contrasted = enh_con.enhance(contrast)

    #锐度调节
    enh_sha = ImageEnhance.Sharpness(image_contrasted)
    sharp = 2.0
    image_sharpened = enh_sha.enhance(sharp)
    return image_sharpened

def respond_help(message,history):
    ret = ""
    if message == 'What is DBchat':
        ret = 'It is a Natural language and database interaction system based on NL to SQL.'
    elif message == "How to use DBchat":
        ret = 'Go to the model tab and enter your input at the Textbox on the left!'
    elif message == 'Where can I find more information of DBchat':
        link = "<a href = 'https://github.com/PLUTOXXXX/DBChat'>DBchat</a>"
        ret = "You can find more details at {}".format(link)
    elif message == 'Do you have any reference':
        link = "<a href = 'https://github.com/PLUTOXXXX/DBChat'>DBchat</a>"
        ret = "You can find more details at {}".format(link)
    else:
        ret = "You can contact us by sending us emails"
    history.append([message,ret])
    return "", history

def interact_with_model(message,history):
    #调用模型，message为输入信息，history为记录信息
    if schema == '':
        bot_respond = "Warning! You should upload your library first"
    else:
        #加载进度条
        gr.Progress(0)
        global sql
        #sql,bot_respond = db_chat_demo.chat_with_db(message,user_name)
        #bot_respond = random.choince(['1','2'])
        bot_respond = pd.read_sql("SELECT e.emp_no, e.first_name, e.last_name, MAX(s.salary) AS highest_salary FROM employees e JOIN salaries s ON e.emp_no = s.emp_no WHERE s.from_date >= '1989-01-01' AND s.to_date <= '1990-01-01' GROUP BY e.emp_no ORDER BY highest_salary DESC LIMIT 10;",con=connection_string)
        print(bot_respond)
        time.sleep(0.1)
        gr.Progress(0.25)
        history.append([message,bot_respond])
        time.sleep(0.1)
        gr.Progress(0.5)
        time.sleep(0.1)
        gr.Progress(0.75)
        time.sleep(0.1)
    return "",history

decorate_6 = PIL.Image.open("C:\\Users\\Administrator\\Desktop\\I\\decorate_6.jpg")
decorate_6 = repair_image(decorate_6)

def same_auth(username,passward):
    global user_name
    user_name = username
    return username == passward

def set_file(user_file,progress = gr.Progress()):
    if not os.path.exists(dir + '\\' + user_name):
        os.mkdir(dir + '\\' + user_name)
    new_path = dir + '\\' + user_name
    file_path = user_file.name
    shutil.copy(file_path,new_path)
    #db_creator_demo.build_user_database(user_name)
    for i in range(20):
        progress(i * 0.05,desc='Please wait us to deal with your file')
        gr.Markdown('Please wait us to deal with your file')
        time.sleep(1)
    return "Deal with your file successfully!"

def get_graph(data):
    path = gen_graphs.run(data)
    with open(path,'r') as img:
        return img

with gr.Blocks(theme = gr.themes.Soft()) as demo:

    def respond(message,history):
        bot_message = random.choice(["yes",'no'])
        history.append([message,history])
        time.sleep(2)
        return "",bot_message

    #Decorate images
    with gr.Row():
        gr.Markdown(scale = 1)
        d = gr.Image(value=decorate_6, height=449, show_label=False,min_width= 400,scale = 5)

    #The first Tab, interact with the model
    with gr.Tab("Model"):

        with gr.Row():

            #input textbox
            with gr.Column():
                gr.Markdown('This project is DBchat, a naive nature language to database SQL project.Here in the textbox below, you can interact with our language model or inquery some database information using natural language.',scale = 1)
                schema = gr.File(show_label=False,visible=True)
                text = gr.Textbox(lines = 1,show_label= False)
                schema.change(set_file,inputs = schema,outputs = text,show_progress=True)
                text1 = gr.Textbox(lines = 10,placeholder = 'input your idea',scale = 20,show_label=False)

            #output textbox
            text2 = gr.Chatbot()

        #submit button
        inp = gr.Button("Submit your context!")
        reset = gr.ClearButton([text1,text2])
        inp.click(
            interact_with_model,
            [text1,text2],
            [text1,text2],
            queue = True
        ).then()

    with gr.Tab('Database'):
        gr.Markdown("Here we will show you the information from the database")
        temptext = gr.Textbox(lines = 20)
        bf = gr.Button("Click the button and get your information")
        tempfile = gr.File(visble = False)
        bf.click(fn = get_information,outputs = [temptext,tempfile])
        tempimage = gr.Image(lines = 20)
        bf2 = gr.Button("Click here to see the graph results")
        bf2.click(fn = get_graph,inputs = tempfile,outputs = tempimage)
        os.removedirs(dir + r'\data.csv')
    #set basic help
    with gr.Tab("Tips"):
        #introduction
        gr.Markdown('Here you can check some common questions by interacting with the chat bot')
       #auto chatbox to give some help
        chatbot = gr.Chatbot(show_label = False)
        msg = gr.Radio(['What is DBchat', 'How to use DBchat', 'Where can I find more information of DBchat',
                              'Do you have any reference', 'Others'], label = 'What do you want to know?')

        clear = gr.ClearButton([msg,chatbot])
        msg.change(respond_help,[msg,chatbot],[msg,chatbot])

demo.queue().launch(share = True,auth = same_auth,auth_message = "Put your name on the username and the passward is the same as your username")
