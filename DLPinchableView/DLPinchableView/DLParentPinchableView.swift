//
//  DLParentPinchableView.swift
//  DLPinchableView
//
//  Created by Dheina Lundi Ahirsya on 08/12/2016.
//  Copyright © 2016 dheina.com. All rights reserved.
//

import UIKit


@objc protocol DLParentPinchableViewDelegate{
    optional func dLParentPinchableView(view:DLParentPinchableView,onDissmisedFinish:Bool)
}

class DLParentPinchableView: UIView,UIGestureRecognizerDelegate {
    
    var delegate:DLParentPinchableViewDelegate! = nil
    var srcView:UIImageView!
    var cloneView:UIImageView!
    var backgroundView:UIButton!
    var originFrame:CGRect!
    var scaleTemp:CGFloat!
    
    
    //Required by Apple
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(src: UIImageView) {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.srcView = src
        self.initialization(src)
    }
    
    //Layout Initialization
    func initialization(src:UIImageView) {
        
        self.layoutIfNeeded()
        let app = UIApplication.sharedApplication().delegate as? AppDelegate
        let mainWindow = app?.window
        var pointInScreen:CGPoint = src.superview!.convertPoint(srcView.center, toView: nil)
        
        pointInScreen.x = pointInScreen.x-(src.frame.size.width/2);
        pointInScreen.y = pointInScreen.y-(src.frame.size.height/2);
        
        self.frame = CGRectMake(0, 0, mainWindow!.frame.size.width, mainWindow!.frame.size.height)
        self.backgroundColor = UIColor.clearColor()
        self.backgroundView = UIButton.init(frame: self.frame)
        self.backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        self.backgroundView.addTarget(self, action: #selector(DLParentPinchableView.dismiss), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.backgroundView)

        self.originFrame = CGRectMake(pointInScreen.x, pointInScreen.y, src.frame.size.width, src.frame.size.height)
        
        self.cloneView = UIImageView.init(frame: self.originFrame)
        self.cloneView.image = src.image
        self.cloneView.contentMode = src.contentMode
        self.cloneView.userInteractionEnabled = true;
        self.cloneView.becomeFirstResponder()
        self.addSubview(self.cloneView)
        mainWindow?.addSubview(self)
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        let notif:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notif.addObserver(self, selector: #selector(DLParentPinchableView.orientationChanged(_:)), name: UIDeviceOrientationDidChangeNotification, object: UIDevice.currentDevice())
        
    }
    
    
    
    func orientationChanged(note:NSNotification)
    {
        self.dismiss()
    }

    
    func dismiss()
    {
        self.delegate?.dLParentPinchableView?(self, onDissmisedFinish: false)
        UIView.animateWithDuration(0.2, animations: {
            self.cloneView.center = CGPointMake(self.originFrame.origin.x+(self.originFrame.size.width/2), self.originFrame.origin.y+(self.originFrame.size.height/2))
            self.cloneView.transform = CGAffineTransformMakeScale(1,1)
            self.cloneView.transform = CGAffineTransformMakeRotation(0)
            self.alpha = 1
            
            }, completion: { (finished: Bool) -> Void in
                if(finished){
                    self.delegate?.dLParentPinchableView?(self, onDissmisedFinish: true)
                    self.removeFromSuperview()
                }
        })
    }
    
    func handlePanA(recognizer:UIPanGestureRecognizer!){
        
        let translation:CGPoint = recognizer.translationInView(self.cloneView?.superview)
        self.cloneView.center = CGPointMake(self.cloneView.center.x + translation.x, self.cloneView.center.y + translation.y)
        recognizer.setTranslation(CGPointMake(0, 0), inView: self.cloneView.superview)
        if (recognizer.state == UIGestureRecognizerState.Ended) {
            self.dismiss()
        }
    }
    
    func handlePinchA(recognizer:UIPinchGestureRecognizer!){

        self.scaleTemp = recognizer.scale
        self.cloneView.transform = CGAffineTransformScale(self.cloneView.transform, recognizer.scale, recognizer.scale)
        
        var backgroundAlpha:CGFloat = (self.cloneView.transform.a+(max(self.cloneView.transform.b, self.cloneView.transform.c)))-1;
        if(self.cloneView.transform.a<=0){
            backgroundAlpha = ((self.cloneView.transform.a)-1) * -1;
        }
        self.backgroundView.alpha = backgroundAlpha;
        recognizer.scale = 1;
    }
    
    func handleRotateA(recognizer:UIRotationGestureRecognizer!){
        
        self.cloneView.transform = CGAffineTransformRotate(self.cloneView.transform, recognizer.rotation);
        recognizer.rotation = 0;
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
}

