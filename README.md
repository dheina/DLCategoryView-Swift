# DLPinchableView - Swift Version

Preview :

![N|Solid](https://github.com/dheina/DLPinchableView/blob/master/preview.gif?raw=true)

DLPinchableView is Custom Library for iOS written in Swift.
Pinch, Rotate, and Pan your Image View. :)

Supported OS : 7.0

### How to use :
##### Using xib/ storyboard
1. Just drag UIView in xib/ storyboard.
2. Change the class to DLPinchableView


##### Programmatically
1. Add this code for init
```
let pinchV:DLPinchableView = DLPinchableView.init(frame: CGRectMake(0, 0, 100, 100))
pinchV.image = UIImage.init(named: "ImgCat1")
self.view.addSubview(pinchV)
```


Powered by dheina.com

[![N|Solid](https://dheina.com/img/user.jpg)](https://dheina.com)
