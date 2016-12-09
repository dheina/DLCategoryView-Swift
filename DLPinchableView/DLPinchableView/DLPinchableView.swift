//
//  DLPinchableView.swift
//  DLPinchableView
//
//  Created by Dheina Lundi Ahirsya on 08/12/2016.
//  Copyright © 2016 dheina.com. All rights reserved.
//

import UIKit

class DLPinchableView: UIImageView,UIGestureRecognizerDelegate,DLParentPinchableViewDelegate {
    
    var parentView:DLParentPinchableView?
    
    
    //Required by Apple
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialization()
    }
    
    //Initialization
    override init(frame: CGRect) {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.initialization()
    }
    
    //Layout Initialization
    func initialization() {
        
        self.userInteractionEnabled = true
        
        let pinchGesture:UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action:#selector(DLPinchableView.handlePinch(_:)))
        pinchGesture.delegate = self
        self.addGestureRecognizer(pinchGesture)
        
        let rotateGesture:UIRotationGestureRecognizer = UIRotationGestureRecognizer.init(target: self, action: #selector(DLPinchableView.handleRotate(_:)))
        rotateGesture.delegate = self
        self.addGestureRecognizer(rotateGesture)
        
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(DLPinchableView.handlePan(_:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)

    }
    
    @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer!) {
        self.duplicateCurrentView()
        self.parentView?.handlePinchA(recognizer)
        self.alpha = 0
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer!) {
        self.parentView?.handlePanA(recognizer)
    }
    
    @IBAction func handleRotate(recognizer: UIRotationGestureRecognizer!) {
        self.parentView?.handleRotateA(recognizer)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func duplicateCurrentView()
    {
        if(self.parentView == nil){
            self.parentView = DLParentPinchableView.init(src: self)
            self.parentView?.delegate = self
            self.setParent(self.superview!, userInteraction: false)
        }
    }
    
    
    func dLParentPinchableView(view: DLParentPinchableView, onDissmisedFinish: Bool) {
        if(onDissmisedFinish){
            self.alpha = 1;
            self.parentView = nil;
            self.setParent(self.superview!, userInteraction: true)
        }
    }
    

    func setParent(view:UIView,userInteraction:Bool) {
        if(view.superview != nil){
            view.superview?.userInteractionEnabled = true
            if superview?.superview is UIScrollView {
                self.setParent(view.superview!, userInteraction: userInteraction)
            }
        }
    }
    }
