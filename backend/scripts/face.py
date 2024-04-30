import os
import cv2
import pickle
import face_recognition
import numpy as np
import sys
import time

def find_faces(video_path):
    cap = cv2.VideoCapture(video_path)
    cap.set(3,640)
    cap.set(4,480)


    # LOADING THE ENCODING FILE
    print('Loading Encoded File')
    file = open('EncodedFile.p','rb')
    encodeListKnownWithIds = pickle.load(file)
    file.close()
    encodeListKnown,student_Id = encodeListKnownWithIds
    print('Encoded File Loaded ')
    id = None
    threshold = 1
    overall = set()

    if not cap.isOpened():
        sys.exit()

    t1 = time.time()

    while cap.read():
        success,img = cap.read()
        #imgS = cv2.resize(img,(0,0),None,0.25,0.25)
        if success:
            img = cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
            faceCurrFrame = face_recognition.face_locations(img)
            encodeCurrFrame = face_recognition.face_encodings(img,faceCurrFrame)

            for encodeface,faceloc in zip(encodeCurrFrame,faceCurrFrame):
                matches = face_recognition.compare_faces(encodeListKnown,encodeface)
                faceDis = face_recognition.face_distance(encodeListKnown,encodeface)
                matchIndex = np.argmin(faceDis)
                threshold = faceDis[matchIndex]
                y1,x2,y2,x1 = faceloc
                bbox = x1,y1,x2-x1,y2-y1
                
                
                
                if matches[matchIndex] == True and threshold<0.56:
                    cv2.rectangle(img,(x1,y1),(x2,y2),(0,255,0),2)
                    id = student_Id[matchIndex]
                    overall.add(id)
                else:
                    cv2.rectangle(img,(x1,y1),(x2,y2),(255,0,0),2)
        else:
            break
        
        
        #cv2.imshow("Live Feed ",cv2.cvtColor(img,cv2.COLOR_RGB2BGR))
        #if cv2.waitKey(1) & 0xFF == ord('q'):
            #break

    print('Time taken :',time.time()-t1)

    cap.release()
    cv2.destroyAllWindows()
    return overall
