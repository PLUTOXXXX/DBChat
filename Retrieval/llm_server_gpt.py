#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import openai
from langchain.chat_models import ChatOpenAI
from langchain.callbacks.manager import CallbackManager
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
import warnings
warnings.filterwarnings("ignore")


chatgpt_model_name = "gpt-3.5-turbo"
openai.api_type = "azure"
openai.api_key = "7e75283a54c942bdaadb2800105d560f"
openai.api_base = "https://dia.openai.azure.com"
openai.api_version = "2023-03-15-preview"
model_kwargs = {"engine":"gpt-3.5-turbo"}

class LLM_Server(object):

    def llm_provider(self):
        llm = ChatOpenAI(
            model=chatgpt_model_name,
            model_kwargs=model_kwargs,
            streaming=True,
            openai_api_key=openai.api_key,
            temperature=0,
            max_tokens=3000,
            openai_api_base=openai.api_base,
            openai_organization=openai.api_type,
            callback_manager=CallbackManager([StreamingStdOutCallbackHandler()])
        )
        return llm


if __name__ == '__main__':
    llm = LLM_Server().llm_provider()
    print(llm.predict("Hello!"))