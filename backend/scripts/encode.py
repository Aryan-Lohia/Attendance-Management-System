import os
import pickle
import face_recognition
import cv2

# IMPORT STUDENT IMAGES
def encoding_pictures(folder_path):
    mode_folder_path = folder_path
    mode_path_list = os.listdir(mode_folder_path)
    img_list=[]
    student_Id = []
    for path in mode_path_list:
        if path == '.DS_Store':
            continue
        img_list.append(cv2.imread(os.path.join(mode_folder_path,path)))
        student_Id.append(os.path.splitext(path)[0])

    def findEncodings(imagesList):
        encodeList = []
        for img in imagesList:
            img = cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
            encode = face_recognition.face_encodings(img)[0]
            encodeList.append(encode)

        return encodeList

    print('Encoding Started')
    encodeListKnown = findEncodings(img_list)
    encodeListKnownwithIds = [encodeListKnown,student_Id]
    print('Encoding Completed')

    file = open("EncodedFile.p",'wb')
    pickle.dump(encodeListKnownwithIds,file)
    file.close()
    print('File Saved')