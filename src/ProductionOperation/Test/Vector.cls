Class ProductionOperation.Test.Vector Extends %RegisteredObject
{

/// /{
/// /  "Name": "JH0002患者信息更新服务",
/// /  "Comment": "患者信息更新",
/// /  "Enabled": "1",
/// /  "PoolSize": "0",
/// /  "ClassName": "JHIPLIB.SOAP.BS.Service",
/// /  "Settings": [
/// /    {
/// /      "Target": "Host",
/// /      "Name": "IsSync",
/// /      "Value": "1"
/// /    },
/// /    {
/// /      "Target": "Host",
/// /      "Name": "BusinessPartner",
/// /      "Value": "HIS"
/// /    },
/// /    {
/// /      "Target": "Host",
/// /      "Name": "AlertOnError",
/// /      "Value": "0"
/// /    }
/// /  ]
/// /}
/// d ##class(ProductionOperation.Test.Vector).Test()
ClassMethod Test()
{
    #; Set name ="1221",message="Create a SOAP Service"
    #; Set Util =##class(ProductionOperation.Operation.VS).%New()
    #; Set abc= Util.ChatAdd(name,message)
    #; zw abc

    #; S message ="Can you help me determine if this statement is about creating a service called 'create soap service'? If so, return 1"
    #; S key ="sk-Bb1211M5yo3qnzirDHffvFV3narHYjMcb267F902gpF8Y9LI"
    #; Set Util =##class(ProductionOperation.OpenAi.Message).%New()    
    #; Set res =Util.MethodName(key,message)
    #; zw res

    
    set sbc =..checkOperation("Create  Service ")
    &SQL(insert into ProductionOperation_DB.Chat (Name,Chat) values (:user,:message) )
    if sbc="create"{
        zw "111"
    }
    zw sbc
                    Set Name ="EnsLib.SOAP.GenericService"
                    Set tSC = ##class(Ens.Director).GetProductionStatus(.productionName,.tState,,1)
                    Set i=1
                    while 1{
	                    
                        &sql(select count(1) into :num FROM Ens_Config.Item where Name=:Name and Production = :productionName)
                        if num >0{
                            Set Name =  Name_i  
                        }else{
                            break
                        }
                        Set i =i+1
                    }
                    zw Name
}

ClassMethod checkOperation(phrase) [ Language = python ]
{
    
    substrings = ["create", "delete", "update"]
    phrase_lower = phrase.lower()
    
    for substring in substrings:
        if substring in phrase_lower:
            return substring
    
    return False
}

ClassMethod search(num) [ Language = python ]
{
    print("{:.2f}%".format(num))
    return  "{:.2f}%".format(num)
}

/// Description
ClassMethod check(phrase) As %Status [ Language = python ]
{
    substrings = ["Service", "BS", "Operation", "BO"]
    phrase_lower = phrase.lower()
    for substring in substrings:
        if substring.lower() in phrase_lower:
            return True
    return False
}

/// d ##class(ProductionOperation.Test.Vector).Embedding()
ClassMethod Embedding(Test) [ Language = python ]
{

from transformers import AutoTokenizer, AutoModel
import torch
import torch.nn.functional as F

#Mean Pooling - Take attention mask into account for correct averaging
def mean_pooling(model_output, attention_mask):
    token_embeddings = model_output[0] #First element of model_output contains all token embeddings
    input_mask_expanded = attention_mask.unsqueeze(-1).expand(token_embeddings.size()).float()
    return torch.sum(token_embeddings * input_mask_expanded, 1) / torch.clamp(input_mask_expanded.sum(1), min=1e-9)


# Sentences we want sentence embeddings for
# sentences = ['This is an example sentence', 'Each sentence is converted']
sentences = [Test]
# Load model from HuggingFace Hub
tokenizer = AutoTokenizer.from_pretrained('/home/irisowner/dev/all-MiniLM-L6-v2')
model = AutoModel.from_pretrained('/home/irisowner/dev/all-MiniLM-L6-v2')

# Tokenize sentences
encoded_input = tokenizer(sentences, padding=True, truncation=True, return_tensors='pt')

# Compute token embeddings
with torch.no_grad():
    model_output = model(**encoded_input)

# Perform pooling
sentence_embeddings = mean_pooling(model_output, encoded_input['attention_mask'])

# Normalize embeddings
sentence_embeddings = F.normalize(sentence_embeddings, p=2, dim=1)

#print(sentence_embeddings)
return str(sentence_embeddings[0].tolist())
}

/// d ##class(ProductionOperation.Test.Vector).EmbeddingPy("abvc")
ClassMethod EmbeddingPy(text) As %String [ Language = python, SqlProc ]
{
 from transformers import AutoTokenizer,AutoModel
 import torch
 import torch.nn.functional as F
 try:
  sentences = [text]
  #Mean Pooling - Take attention mask into account for correct averaging
  def mean_pooling(model_output,attention_mask):
   token_embeddings = model_output[0] #First element of model_output contains all token embeddings
   input_mask_expanded = attention_mask.unsqueeze(-1).expand(token_embeddings.size()).float()
   return torch.sum(token_embeddings * input_mask_expanded,1) / torch.clamp(input_mask_expanded.sum(1),min=1e-9)

  # Load model from local place
  tokenizer = AutoTokenizer.from_pretrained('/home/irisowner/dev/all-MiniLM-L6-v2')
  model = AutoModel.from_pretrained('/home/irisowner/dev/all-MiniLM-L6-v2')

  # Tokenize sentences
  encoded_input = tokenizer(sentences,padding=True,truncation=True,return_tensors='pt')

  # Compute token embeddings
  with torch.no_grad():
   model_output = model(**encoded_input)

  # Perform pooling
  sentence_embeddings = mean_pooling(model_output,encoded_input['attention_mask'])

  # Normalize embeddings
  sentence_embeddings = F.normalize(sentence_embeddings,p=2,dim=1)
  print(sentence_embeddings)       
  return str(sentence_embeddings[0].tolist())       
        
 except Exception as e:
  errorMsg = "SplitAndEmbed Error: "+ str(e)
  print(errorMsg)
  return errorMsg
}

}

