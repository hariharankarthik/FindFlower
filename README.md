# A FLOWER RECOGNITION APP THAT USES COREML TO PERFORM IMAGE RECOGNITION

* This iOS app utilizes a pre-trained Caffe ML model which is trained on a dataset of 102 various types of flowers.
* Using Python and CoreML tools, the Caffe model is coverted to a MLModel to perform image recogition in the app.
* An UIImagePickerController is setup to enable a user to take a picture of any flower.
* The ML model is further trained using more data and CreateML to increase the accuracy of the image recogition model to ~85%.
* Next, we get classifications from the flower classifier model by making and handling a request with CoreML and the Vision framework.
* Using the Alamofire cocoapod and REST, we make HTTP GET requests to get the description of the flower name (name of the flower with the highest prediction score from classification results) from wikipedia.
* Another cocoapod SwiftyJSON is used to parse the JSON result we get back from wikipedia, whereas the SDWebImage cocoapod gets the image of the flower from a URL.
* Finally, the UI is updated to reflect the image and description of the flower with the highest prediction score.

## SCREENSHOTS

1. Initial screen of the app:
![IMG-5963](https://user-images.githubusercontent.com/30194665/64126658-36ec7780-cdcc-11e9-8bb5-63ff030adb7e.JPG)

1. The app enables you to take a picture using your phone's camera:
![IMG-5964](https://user-images.githubusercontent.com/30194665/64126704-6c916080-cdcc-11e9-9ff8-e36d6a8f2128.JPG)

1. The resulting screen after the picture of a sunflower is taken:
![IMG-5966](https://user-images.githubusercontent.com/30194665/64126745-93e82d80-cdcc-11e9-8d72-1c5aa751bf2b.JPG)

1. The resulting screen after the picture of a rose is taken:
![IMG-5968](https://user-images.githubusercontent.com/30194665/64122757-1d453300-cdc0-11e9-8061-4ab37d8a34e4.JPG)
