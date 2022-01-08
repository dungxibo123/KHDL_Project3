import random as rd
import preprocessing
from preprocessing import *
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
import pickle
import numpy as np

tokenizer = Tokenizer(num_words=15000, 
                      oov_token='<OOV>', 
                      filters='!"#$%&()*+,-./:;<=>?@[\\]^`{|}~\t\n')

f = open('preprocess_document.txt', 'r')
preprocess_data = f.read().split('\n')

tokenizer.fit_on_texts(preprocess_data)


SVMclf = pickle.load(open('Model/svm_rbf_kernel.pkl', 'rb'))
MLPclf = pickle.load(open('Model/MLP.pkl', 'rb'))
LRclf = pickle.load(open('Model/linear_classifier.pkl', 'rb'))

def pad_raw(raw):
    raw = np.array(raw)
    if raw.shape[0] < 1850:
        raw = np.hstack((raw, np.zeros(1850 - raw.shape[0])))
    else:
        raw = raw[:1850]
    return raw

def normalization(array):
    return ( array - np.min(array) ) / (np.max(array) - np.min(array))

def predict_from_raw(model, raw, domain):
    raw = text_preprocess(raw)
    sequences_data = tokenizer.texts_to_sequences([raw])
    #print(sequences_data)
    sequences_data = pad_raw(sequences_data[0])
    #print(sequences_data.shape)
    normalized_data = normalization(sequences_data)
    #print(normalized_data[:10])
    
    try:
        page_rank = get_page_rank([domain])[domain]
    except:
        page_rank = 0
        
    final_data = np.hstack((normalized_data,page_rank))
    #print(final_data.shape)
    return model.predict([final_data])[0]
    
print(predict_from_raw(SVMclf, "Câu gì đó.", "thanhnien.vn") + 2)