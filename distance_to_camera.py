# import numpy as np
# import cv2
#
# def find_marker(image):
#
#     # convert the image to grayscale, blur it, and detect edges
#     gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
#     gray = cv2.GaussianBlur(gray,(5,5),0)
#     edged = cv2.Canny(gray,35,125)
#
#     # find the contours in the edged image and keep the largest one;
#     # we'll assume that this is our piece of paper in the image
#     (image,cnts,hierarchy) = cv2.findContours(edged.copy(),cv2.RETR_LIST,cv2.CHAIN_APPROX_SIMPLE)
#     c = max(cnts,key = cv2.contourArea)
#
#     # cv2.imshow("woc",image)
#     # cv2.waitKey(0)
#     # pass
#     # compute the bounding box of the paper region and return it
#     return cv2.minAreaRect(c)
#
# def distance_to_camera(knownWidth, focalLength, perWidth):
#     # knownWidth: a known object width in the real world
#     # in this case, a paper of 8.5 x 11 inch
#     # perWidth: the formal object width in pixels
#
#     # compute and return the distance from the marker to the camera
#     return (knownWidth * focalLength) / perWidth
#
#
# # initialize the known distance from the camera to the object, which
# # in this case is 24 inches
# KNOWN_DISTANCE = 24.0
#
# # initialize the known object width, which in this case, the piece of
# # paper is 11 inches wide
# KNOWN_WIDTH = 11.0
#
# # initialize the list of images that we'll be using
# # raw: IMAGE_PATHS = ["images_2ft.png", "images_3ft.png", "images_4ft.png"]
# IMAGE_PATHS = ["images_60cm.png", "images_70cm.png", "images_80cm.png"]
#
# # load the first image that contains an object that is KNOWN TO BE 2 feet
# # from our camera, then find the paper marker in the image, and initialize
# # the focal length
# image = cv2.imread(IMAGE_PATHS[0])
# marker = find_marker(image)
# focalLength = (marker[1][0] * KNOWN_DISTANCE) / KNOWN_WIDTH
# # print(marker)
# # print(marker[1][0])
#
# # loop over the images
# for imagePath in IMAGE_PATHS:
#     # load the image, find the marker in the image, then compute the
#     # distance to the marker from the camera
#     image = cv2.imread(imagePath)
#     marker = find_marker(image)
#     inches = distance_to_camera(KNOWN_WIDTH, focalLength, marker[1][0])
#
#     # draw a bounding box around the image and display it
#     box = np.int0(cv2.boxPoints(marker))
#     cv2.drawContours(image, [box], -1, (0, 255, 0), 2)
#     cv2.putText(image, "%.2fft" % (inches / 12),
#     (image.shape[1] - 200, image.shape[0] - 20), cv2.FONT_HERSHEY_SIMPLEX,
#     2.0, (0, 255, 0), 3)
#     cv2.imshow("image", image)
#     cv2.waitKey(0)

import numpy as np
import cv2

def find_marker(image):

    # convert the image to grayscale, blur it, and detect edges
    gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray,(5,5),0)
    edged = cv2.Canny(gray,35,125)

    # find the contours in the edged image and keep the largest one;
    # we'll assume that this is our piece of paper in the image
    (image,cnts,hierarchy) = cv2.findContours(edged.copy(),cv2.RETR_LIST,cv2.CHAIN_APPROX_SIMPLE)
    c = max(cnts,key = cv2.contourArea)

    # compute the bounding box of the paper region and return it
    return cv2.minAreaRect(c)

def distance_to_camera(knownWidth, focalLength, perWidth):
    # knownWidth: a known object width in the real world
    # in this case, a paper of 8.5 x 11 inch
    # perWidth: the formal object width in pixels

    # compute and return the distance from the marker to the camera
    return (knownWidth * focalLength) / perWidth


# initialize the known distance from the camera to the object, which
# in this case is 60 cms
KNOWN_DISTANCE = 60.0

# initialize the known object width, which in this case, the piece of
# paper is 26 cms wide
KNOWN_WIDTH = 14.25

# initialize the list of images that we'll be using
IMAGE_PATHS = ["images_60cm.png", "images_70cm.png", "images_80cm.png", "images_90cm.png"]

# load the first image that contains an object that is KNOWN TO BE 2 feet
# from our camera, then find the paper marker in the image, and initialize
# the focal length
image = cv2.imread(IMAGE_PATHS[0])
marker = find_marker(image)
focalLength = (marker[1][0] * KNOWN_DISTANCE) / KNOWN_WIDTH
# print(marker)
# print(marker[1][0])

# loop over the images
for imagePath in IMAGE_PATHS:
    # load the image, find the marker in the image, then compute the
    # distance to the marker from the camera
    image = cv2.imread(imagePath)
    marker = find_marker(image)
    if imagePath == "images_70cm.png":
        KNOWN_WIDTH = 10.0
    cms = distance_to_camera(KNOWN_WIDTH, focalLength, marker[1][0])

    # draw a bounding box around the image and display it
    box = np.int0(cv2.boxPoints(marker))
    cv2.drawContours(image, [box], -1, (0, 255, 0), 2)
    cv2.putText(image, "%.2fcm" % (cms),
    (image.shape[1] - 800, image.shape[0] - 100), cv2.FONT_HERSHEY_SIMPLEX,
    5.0, (0, 255, 0), 3)
    # cv2.imshow("image", image)
    # cv2.waitKey(0)
    cv2.imwrite("result_" + imagePath , image, [100])
