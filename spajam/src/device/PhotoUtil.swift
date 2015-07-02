//
//  PhotoUtil.swift
//  test2
//
//  Created by 坂本　尚嗣 on 2015/05/27.
//  Copyright (c) 2015年 坂本　尚嗣. All rights reserved.
//

import UIKit
import PromiseKit


public class PhotoUtil {
    
    
    public class func imagePickPromise(vc : UIViewController) -> Promise<UIImage> {
        let picker = PhotoPicker()
        picker.showWithParentVC(vc)
        return picker.promise
    }
    
    public class func cameraPromise(view : UIView) -> Promise<UIImage> {
        let camera = CameraDelegate()
        camera.showWithParentView(view)
        return camera.promise
    }
    
}

//MARK: image picker
private class PhotoPicker : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let (promise, fulfill, reject) = Promise<UIImage>.defer()
    var imagePicker : UIImagePickerController? = nil
    var selfRetain : PhotoPicker! = nil
    
    func showWithParentVC(parent : UIViewController) {
        let vc = UIImagePickerController()
        vc.sourceType = .PhotoLibrary
        //vc.allowsEditing = true
        vc.delegate = self
        self.imagePicker = vc
        parent.presentViewController(vc, animated: true, completion: nil)
        
        self.selfRetain = self
    }
    
    @objc func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        switch image {
        case .Some(let v): fulfill(v)
        case .None:reject(NSError(domain: "Can't cast image", code: -1, userInfo: nil))
        }
        
        self.imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        
        self.dispose()
    }
    @objc func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        reject(NSError.userAbortedError())
        self.imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        
        self.dispose()
    }
    
    private func dispose() {
        self.imagePicker = nil
        self.selfRetain = nil
    }
}

//Camera
private class CameraDelegate : NSObject, CACameraSessionDelegate {
    let (promise, fulfill, reject) = Promise<UIImage>.defer()
    var camView : CameraSessionView? = nil
    var selfRetain : CameraDelegate? = nil
    
    func showWithParentView(view : UIView) {
        let camView = CameraSessionView(frame: view.frame)
        camView.delegate = self
        view .addSubview(camView)
        
        self.camView = camView
        self.selfRetain = self
    }
    
    @objc func didCaptureImage(image : UIImage) {
        fulfill(image)
        self.camView?.dismissView()
        dispose()
    }
    @objc func didCancelCapture() {
        reject(NSError.userAbortedError())
        dispose()
    }
    private func dispose() {
        self.camView = nil
        self.selfRetain = nil
    }

    
}











