Class ProductionOperation.Operation.Vector Extends %RegisteredObject
{

/// add chat
ClassMethod ChatAdd(name As %String, message As %String) As %Status
{
    Set sc = $$$OK
    // do something
    if $L(message) '=0{
        // Message vectorization
        Set messageVector =..Embedding(message)
        Set statement = ##class(%SQL.Statement).%New(1)
        Set sql = " insert into ProductionOperation_DB.Chat (Name,Chat,ChatVector) values (?,?,TO_VECTOR(?,double))"
        Set qStatus = statement.%Prepare(sql)
        set tResult = statement.%Execute(name,message,messageVector)
    }
    Return sc
}

ClassMethod ChatUpdate(id As %String, message As %String) As %Status
{
    Set sc = $$$OK
    // do something
    if $L(message) '=0{
        // Message vectorization
        Set messageVector =..Embedding(message)
        Set statement = ##class(%SQL.Statement).%New(1)
        Set sql = " update ProductionOperation_DB.Chat Set ChatVector =TO_VECTOR(?,double) where id =? "
        Set qStatus = statement.%Prepare(sql)
        set tResult = statement.%Execute(messageVector,id)
    }
    Return sc
}

/// d ##class(ProductionOperation.Operation.VS).Embedding()
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

}

