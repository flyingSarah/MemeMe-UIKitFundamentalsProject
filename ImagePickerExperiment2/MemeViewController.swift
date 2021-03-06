//
//  ViewController.swift
//  MemeMe
//
//  Created by Sarah Howe on 7/19/15.
//  Copyright (c) 2015 SarahHowe. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let topTextFieldDefaultText = "ENTER MEME TEXT"
    let bottomTextFieldDefaultText = "ENTER MEME TEXT"
    
    var activityViewController: UIActivityViewController?
    
    //------------------------- VIEW APPEARENCE AND LOADING FUNCTIONS -------------------------
    
    override func viewWillAppear(animated: Bool) {
        hidesBottomBarWhenPushed = true
        
        //enable keyboard notifications so I can move the view up for the bottom text field
        subscribeToKeyboardNotifications()
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad()
    {
        //if the device this app is running on doensn't have access to a camera, the camera button should be disabled
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //disable the share button so it doesn't show up until after an image is chosen
        shareButton.enabled = false
        
        //set the text field delegates and their default text
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.text = topTextFieldDefaultText
        bottomTextField.text = bottomTextFieldDefaultText
        
        //set text field attributes
        let memeTextAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "AvenirNext-Heavy", size: 20)!, NSStrokeWidthAttributeName: -3.0]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        //set text filed allignment and make sure they are in front of the image view
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        view.bringSubviewToFront(topTextField)
        view.bringSubviewToFront(bottomTextField)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //----------------------------------- TEXT FIELD STUFF ------------------------------------
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        //clear the text field only when the default text is showing
        if(textField.text == topTextFieldDefaultText || textField.text == bottomTextFieldDefaultText)
        {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        //make the keyboard dissapear whenever the user hits return
        view.endEditing(true)
        return true
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if(bottomTextField.editing) //only move the view up if editing the bottom text field
        {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if(bottomTextField.editing) //only move the view back down if editing the bottom text field
        {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //---------------------------------- IMAGE PICKER STUFF -----------------------------------

    @IBAction func pickAnImageFromAlbum(sender: AnyObject)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        //set this to make sure the image fills up the view
        imagePickerView.contentMode = UIViewContentMode.ScaleAspectFill
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imagePickerView.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    //------------------------------------ MEME APP STUFF -------------------------------------

    @IBAction func shareButton(sender: AnyObject)
    {
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        /*  was clued in on how to do this from Eden's response to this thread in the discussion forum:  https://discussions.udacity.com/t/how-to-start-a-tabbarcontroller-from-activityviewcontroller/20416 */
        activityViewController.completionWithItemsHandler = { (activity, completed, items, error) in
            if (completed)
            {
                self.save(memedImage)
                self.hidesBottomBarWhenPushed = false
                self.navigationController?.popViewControllerAnimated(true)
            }
            else
            {
                print("image not saved, try again")
            }
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    //Create the meme structure and add it to the array of memes
    func save(memedImage: UIImage)
    {
        //create the meme
        let meme = Meme(topText: topTextField.text!, memedImage: memedImage)
        
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        applicationDelegate.memes.append(meme)
    }
    
    //Create a UIImage of the combined image and labels
    func generateMemedImage() -> UIImage
    {
        //hide toolbar and nav bar while the image is generating
        navigationController?.setNavigationBarHidden(true, animated: true)
        toolBar.hidden = true
        
        //render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show toolbar and navbar now that image is done generating
        navigationController?.setNavigationBarHidden(false, animated: true)
        toolBar.hidden = false
        
        return memedImage
    }
    @IBAction func backToTableViewButton(sender: AnyObject)
    {
        hidesBottomBarWhenPushed = false
        navigationController?.popViewControllerAnimated(true)
    }
}


