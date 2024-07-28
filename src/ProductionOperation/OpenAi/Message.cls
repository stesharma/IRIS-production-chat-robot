Class ProductionOperation.OpenAi.Message Extends %RegisteredObject
{

/// d ##class(ProductionOperation.OpenAi.Message).MethodName()
ClassMethod MethodName(key, message) [ Language = python ]
{
from openai import OpenAI

client = OpenAI(
    # defaults to os.environ.get("OPENAI_API_KEY")
    api_key= key,
    base_url="https://api.chatanywhere.tech/v1"
)
messages = [{'role': 'user','content': ''}]
messages[0]['content'] =message
completion = client.chat.completions.create(model="gpt-3.5-turbo", messages=messages)
return(completion.choices[0].message.content)
}

}

