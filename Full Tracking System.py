import tkinter
from tkinter import *
from tkinter import filedialog as fd 
import imutils
import cv2
from random import randint
import numpy as np
import datetime
import math
from math import sqrt



root = Tk(className='Object Tracking System')
root.configure(bg='#FF6F61')
root.geometry("2000x2000") 
root1 = Tk(className='RESULTS')
root1.configure(bg='#FF6F61')
root1.geometry("2000x500") 
v = Scrollbar(root)
v.pack(side = RIGHT, fill = Y) 
def simple_track():
    trackerName = 'csrt'
    if Checkbutton1.get()==1:
        videoPath=0
    else:
        videoPath=filename
    
    OPENCV_OBJECT_TRACKERS = {
    "csrt": cv2.TrackerCSRT_create,
    "kcf": cv2.TrackerKCF_create,
    "boosting": cv2.TrackerBoosting_create,
    "mil": cv2.TrackerMIL_create,
    "tld": cv2.TrackerTLD_create,
    "medianflow": cv2.TrackerMedianFlow_create,
    "mosse": cv2.TrackerMOSSE_create
    }
    # initialize OpenCV's special multi-object tracker
    trackers = cv2.MultiTracker_create()
    cap = cv2.VideoCapture(videoPath)
    while cap.isOpened():
        ret, frame = cap.read()
        if frame is None:
            break
        frame = imutils.resize(frame, width=600)
        (success, boxes) = trackers.update(frame)
        # loop over the bounding boxes and draw them on the frame
        for box in boxes:
            (x, y, w, h) = [int(v) for v in box]
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
        
        cv2.imshow("Frame", frame)
        key = cv2.waitKey(1) & 0xFF

        # if the 's' key is selected, we are going to "select" a bounding
        # box to track
        if key == ord("s"):
            colors = []
            # select the bounding box of the object we want to track (make
            # sure you press ENTER or SPACE after selecting the ROI)
            box = cv2.selectROIs("Frame", frame, fromCenter=False,showCrosshair=True)
            box = tuple(map(tuple, box)) 
            for bb in box:
                tracker = OPENCV_OBJECT_TRACKERS[trackerName]()
                trackers.add(tracker, frame, bb)

        # if you want to reset bounding box, select the 'r' key 
        elif key == ord("r"):
            trackers.clear()
            trackers = cv2.MultiTracker_create()
            box = cv2.selectROIs("Frame", frame, fromCenter=False,showCrosshair=True)
            box = tuple(map(tuple, box))
            for bb in box:
                tracker = OPENCV_OBJECT_TRACKERS[trackerName]()
                trackers.add(tracker, frame, bb)
        elif key == ord("q"):
            break
    cap.release()
    cv2.destroyAllWindows()

def calc_speed(i,x1,y1,x2,y2,timeinsec):
    
    

    print("Object No: ",i)
    objres1 = Label(master=root1, text ="Object No:", font = "20", fg="#800000",bg="#eeeeee")  
    objres1.grid(row=0,column=i,padx=4) 
    objres = Label(master=root1,  text =i, font = "20", fg="#800000",bg="#eeeeee")  
    objres.grid(row=1,column=i,padx=4) 

    dist = sqrt( (x2 - x1)**2 + (y2 - y1)**2 )
    dist= round(dist, 2)
    print("distance: ",dist)
    disres1 = Label(master=root1,  text ="Distance:", font = "20", fg="#800000",bg="#eeeeee")  
    disres1.grid(row=2,column=i,padx=4)  
    disres = Label(master=root1,  text =dist, font = "20", fg="#800000",bg="#eeeeee")  
    disres.grid(row=3,column=i,padx=4) 
    speed=dist/timeinsec
    speed=speed*10 
    speed= round(speed, 2)
    print("Speed: ",speed)
    speedres1 = Label(master=root1,  text ="Speed", font = "20", fg="#DC793E",bg="#eeeeee")  
    speedres1.grid(row=4,column=i,padx=4) 
    speedres = Label(master=root1, text =speed, font = "20", fg="#DC793E",bg="#eeeeee")  
    speedres.grid(row=5,column=i,padx=4) 
   
    

    



def detail_track():
    trackerName = 'csrt'
    if Checkbutton1.get()==1:
        videoPath=0
    else:
        videoPath=filename
    OPENCV_OBJECT_TRACKERS = {
    "csrt": cv2.TrackerCSRT_create,
    "kcf": cv2.TrackerKCF_create,
    "boosting": cv2.TrackerBoosting_create,
    "mil": cv2.TrackerMIL_create,
    "tld": cv2.TrackerTLD_create,
    "medianflow": cv2.TrackerMedianFlow_create,
    "mosse": cv2.TrackerMOSSE_create
    }
    # initialize OpenCV's special multi-object tracker
    trackers = cv2.MultiTracker_create()
    cap = cv2.VideoCapture(videoPath)
    x1=[0]
    y1=[0]
    w1=[0]
    h1=[0]
    obj1=[]
    while cap.isOpened():
        ret, frame = cap.read()
        if frame is None:
            break
        frame = imutils.resize(frame, width=600)
        (success, boxes) = trackers.update(frame)
        i=0
        while i<len(x1):
            cv2.rectangle(frame,(int(x1[i]),int(y1[i])),(int(x1[i]) + int(w1[i]), int(y1[i]) + int(h1[i])),(220,220,220),2)
            i=i+1

        # loop over the bounding boxes and draw them on the frame
        for box in boxes:
            (x, y, w, h) = [int(v) for v in box]
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
            print(x,y,w,h)
            x1.append(x)
            y1.append(y)
            w1.append(w)
            h1.append(h)

        cv2.imshow("Frame", frame)
        key = cv2.waitKey(1) & 0xFF

        # if the 's' key is selected, we are going to "select" a bounding
        # box to track
        if key == ord("s"):
            colors = []
            # select the bounding box of the object we want to track (make
            # sure you press ENTER or SPACE after selecting the ROI)
            box = cv2.selectROIs("Frame", frame, fromCenter=False,showCrosshair=True)
            box = tuple(map(tuple, box)) 
            for bb in box:
                tracker = OPENCV_OBJECT_TRACKERS[trackerName]()
                trackers.add(tracker, frame, bb)
                print('original: ',bb)
                obj1.append(bb)
                a = datetime.datetime.now().replace(microsecond=0)
                print(a)
        # if you want to reset bounding box, select the 'r' key 
        elif key == ord("r"):
            trackers.clear()
            trackers = cv2.MultiTracker_create()
            box = cv2.selectROIs("Frame", frame, fromCenter=False,showCrosshair=True)
            box = tuple(map(tuple, box))
            for bb in box:
                tracker = OPENCV_OBJECT_TRACKERS[trackerName]()
                trackers.add(tracker, frame, bb)
        elif key == ord("q"):
            break
    cap.release()
    b = datetime.datetime.now().replace(microsecond=0)
    print(b)
    timetaken=b-a
    print('Difference ',timetaken)
    timestr = str(timetaken)
    ftr = [3600,60,1]
    timeinsec=sum([a*b for a,b in zip(ftr, map(int,timestr.split(':')))])
    print("time taken in sec: ",timeinsec)
    print(obj1)
    resx = [lis[0] for lis in obj1] 
    resy = [lis[1] for lis in obj1] 
    print("Starting x ",resx)
    print("Starting y ",resy)
    xfinals=[]
    yfinals=[]
    totobj=len(obj1)
    i=1
    while i<=totobj:
        xfinals.append(x1[len(x1)-i])
        yfinals.append(y1[len(y1)-i])
        i=i+1 
    print("Ending x ",xfinals)
    print("Ending y ",yfinals)
    resx = [int(i) for i in resx]
    resy = [int(i) for i in resy]
    it=0
    jt=len(xfinals)-1
    while it<totobj:
        calc_speed(it,resx[it],resy[it],xfinals[jt],yfinals[jt],timeinsec)
        it=it+1
        jt=jt-1
    cv2.destroyAllWindows()

        





def browsefunc():
    global filename
    filename = fd.askopenfilename()
    pathlabel.config(text=filename)
    print(filename)
    start["state"]=NORMAL
    Button1["state"]=DISABLED

def uselive():
    if Checkbutton1.get()==1:
        browsebutton["state"]=DISABLED
        start["state"]=NORMAL
    else:
        browsebutton["state"]=NORMAL
        start["state"]=DISABLED
        



def tracking():
    if Checkbutton2.get()==1:
        detail_track()
    else:
        simple_track()
    
    

def details():
    Button2["state"]=NORMAL
    done["state"]=NORMAL

greeting =Label(root,text="Settings",
    foreground="white", background="#E8A798",font="90",width=50,height=2)
greeting.pack()

w = Label(root, text ='Use Device Camera?', font = "50", fg="#6B5B95", bg="black")  
w.pack() 

Checkbutton1 = IntVar() 
Button1 = Checkbutton(root, 
                      variable = Checkbutton1, 
                      onvalue = 1, 
                      offvalue = 0,bg="black",command=uselive) 


Button1.pack()   


browsebutton = Button(root, text="Choose Video",font="50", width=15,
    height=1,
    bg="#DD4124",
    fg="#DFCFBE",command=browsefunc)
browsebutton.pack()

pathlabel = Label(root, font = "50", fg="#88B04B", bg="black")
pathlabel.pack()

start = Button(root, text="Confirm",font="80", width=20,
    height=2,
    bg="#34568B",
    fg="#FFA500", command=details)
start.pack()
start["state"]=DISABLED
w = Label(root, text ='Show Paths and Speeds?', font = "50", fg="#6B5B95", bg="black")  
w.pack() 
Checkbutton2 = IntVar() 
Button2 = Checkbutton(root,
                      variable = Checkbutton2, 
                      onvalue = 1, 
                      offvalue = 0, bg="black") 


Button2.pack()
Button2["state"]=DISABLED 
done = Button(root, text="Done",font="80", width=20,
    height=2,
    bg="#34568B",
    fg="#FFA500", command=tracking)
done.pack()
done["state"]=DISABLED 
root1.mainloop()
root.mainloop()