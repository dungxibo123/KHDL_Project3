import streamlit as st
import pandas as pd
import numpy as np

import pickle

import pipeline
from pipeline import *

import tensorflow

SVMclf = pickle.load(open('Model/svm_rbf_kernel.pkl', 'rb'))
MLPclf = pickle.load(open('Model/MLP.pkl', 'rb'))
LRclf = pickle.load(open('Model/linear_classifier.pkl', 'rb'))


def predict_from_raw(model, raw, domain):
    raw = text_preprocess(raw)
    sequences_data = tokenizer.texts_to_sequences([raw])
    # print(sequences_data)
    sequences_data = pad_raw(sequences_data[0])
    # print(sequences_data.shape)
    normalized_data = normalization(sequences_data)
    # print(normalized_data[:10])

    try:
        page_rank = get_page_rank([domain])[domain]
    except:
        page_rank = 0

    final_data = np.hstack((normalized_data, page_rank))
    # print(final_data.shape)
    return "Đây là tin thật" if model.predict([final_data])[0] == 0.0 else "Đây là tin giả"

def main():
    st.title("Fake news detection")

    options = st.selectbox(
         'Choose model:',
         ['None', 'Logistic Regression', 'MLP Classifier', 'SVM with kernel RBF'])

    st.write('Options: ', options)

    with st.form(key="text"):
        raw_domain = st.text_area("Domain")
        raw_text = st.text_area("News")
        submit = st.form_submit_button(label='Submit')

#    st.write('Text: ', raw_text)
#    st.write('Domain: ', raw_domain)



    st.write('Submit: ', submit)

    if submit:
        if options == 'Logistic Regression':
            model = LRclf
            st.write(predict_from_raw(model, raw_text, raw_domain))
        if options == 'MLP Classifier':
            model = MLPclf
            st.write(predict_from_raw(model, raw_text, raw_domain))
        if options == 'SVM with kernel RBF':
            model = SVMclf
            st.write(predict_from_raw(model, raw_text, raw_domain))

if __name__ == '__main__':
    main()












