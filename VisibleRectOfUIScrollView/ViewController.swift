//
//  ViewController.swift
//  VisibleRectOfUIScrollView
//
//  Created by Maysam Shahsavari on 6/7/16.
//  Copyright © 2016 Maysam Shahsavari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageViewTrailingConstraint: NSLayoutConstraint!
    private var yellowView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateMinZoomScaleForSize(scrollView.bounds.size)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(scrollView.bounds.size)
    }
    
    @IBAction func markVisibleRect(sender: UIBarButtonItem) {
        rectForVisibleArea()
    }
    
    @IBAction func hideVisibleRect(sender: UIBarButtonItem) {
        if (yellowView.isDescendantOfView(self.view)) {
            yellowView.removeFromSuperview()
        }
    }
    
    func rectForVisibleArea(){
        let visibleRect = imageView.bounds
        let scale = scrollView.zoomScale
        let xOffset = scrollView.frame.origin.x
        let yOffset = scrollView.frame.origin.y
        let xOrigin = imageViewLeadingConstraint.constant
        let yOrigin = imageViewTopConstraint.constant
        var visibleWidth = visibleRect.width * scale
        if (visibleWidth + xOffset) > scrollView.bounds.width {
            visibleWidth = scrollView.bounds.width - xOrigin
        }
        var visibleHeight = visibleRect.height * scale
        if (visibleHeight + yOffset) > scrollView.bounds.height {
            visibleHeight = scrollView.bounds.height - yOrigin
        }
        
        let maskRect = CGRectMake(xOrigin+xOffset, yOrigin+yOffset, visibleWidth, visibleHeight)
        yellowView.frame = maskRect
        yellowView.backgroundColor = UIColor.yellowColor()
        if !(yellowView.isDescendantOfView(self.view)) {
            self.view.addSubview(yellowView)
        }
        
        //Save image to the camra roll
        /*
         let previewRect: CGRect = maskRect
         UIGraphicsBeginImageContextWithOptions(previewRect.size, false, UIScreen.mainScreen().scale)
         let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
         CGContextTranslateCTM(ctx,-(xOrigin+xOffset),-(yOrigin+yOffset))
         UIColor.blackColor().set()
         CGContextFillRect(ctx, previewRect)
         
         view.layer.renderInContext(ctx)
         
         let previewImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         let imageData = UIImageJPEGRepresentation(previewImage, 1)
         let compressedJPGImage = UIImage(data: imageData!)
         UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
         */
    }
    
    private func updateMinZoomScaleForSize(size: CGSize) {
            let widthScale = size.width / imageView.bounds.width
            let heightScale = size.height / imageView.bounds.height
            let minScale = min(widthScale, heightScale)
            
            UIView.animateWithDuration(0.2, animations: {
                self.scrollView.minimumZoomScale = minScale * 0.7
                self.scrollView.zoomScale = minScale
            })
    }
    
    private func updateConstraintsForSize(size: CGSize) {
            let yOffset = max(0, (size.height - imageView.frame.height) / 2)
            imageViewTopConstraint.constant = yOffset
            imageViewBottomConstraint.constant = yOffset
            let xOffset = max(0, (size.width - imageView.frame.width) / 2)
            imageViewLeadingConstraint.constant = xOffset
            imageViewTrailingConstraint.constant = xOffset
            
            UIView.animateWithDuration(0.2, animations: {
                self.view.layoutIfNeeded()
            })
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraintsForSize(scrollView.bounds.size)
    }
    
    
}

