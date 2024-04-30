
import streamlit as st
reg = st.text_input('Name')
reg = st.text_input('Registration_no')
dept = st.selectbox('Department',['AI&DS','CSE','IT','ME','ECE','EEE','CE'])
sec = st.selectbox('Section',['A','B','C'])
f = st.file_uploader("Upload Image")