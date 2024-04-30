from face import find_faces
from encode import encoding_pictures
import requests
import streamlit as st
import tempfile
import pandas as pd

dept = st.selectbox('Department',['AI&DS','CSE','IT','ME','ECE','EEE','CE'])
sec = st.selectbox('Section',['A','B','C'])
sub_code = st.text_input('Subject Code')
date = st.date_input('Class Scheduled On ')
string = dept+'_'+sec+'_'+sub_code+".csv"
f = st.file_uploader("Upload file")
def convert_df(df):
   return df.to_csv(index=False).encode('utf-8')
def fun(f):
    tfile = tempfile.NamedTemporaryFile(delete=False)
    tfile.write(f.read())


    #encoding_pictures('../assets/students/')

    registration_id = find_faces(tfile.name)
    values = list(registration_id)
    dic = {'reg_no':values}
    df = pd.DataFrame(dic)
    csv = convert_df(df)
    print(dic)
    st.text(dic)
    st.download_button(
        "Press to Download",
        csv,
        string,
        "text/csv",
        key='download-csv'
        )
s = st.button(label="Submit")
if s:
    with st.spinner('Wait for it...'):
        fun(f)
    st.success('Done!')
    







#requests.post('http://localhost:3001/misc/post',dic)