//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sarah Howe on 7/24/15.
//  Copyright (c) 2015 SarahHowe. All rights reserved.
//

import UIKit

class MemeDetailViewController : UIViewController {
    
    @IBOutlet weak var imageViewer: UIImageView!
    
    var meme: Meme!
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)

        //don't show the tab bar controller here
        self.tabBarController?.tabBar.hidden = true

        //set the image for this view to the memed image that was passed in
        imageViewer.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        //let the tab bar show up again
        self.tabBarController?.tabBar.hidden = false
    }
}
