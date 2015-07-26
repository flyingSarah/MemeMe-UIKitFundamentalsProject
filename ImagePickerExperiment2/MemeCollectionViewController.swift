//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Sarah Howe on 7/22/15.
//  Copyright (c) 2015 SarahHowe. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController : UICollectionViewController {
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //get all the memes from the app delegate
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = applicationDelegate.memes
        
        //refresh everytime the view appears
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        //pass each memed image to each cell
        let meme = memes[indexPath.item]
        let thisImage = meme.memedImage
        cell.setNewMemedImage(thisImage)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let detailedController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        //pass the selected meme into the detailed view
        detailedController.meme = self.memes[indexPath.item]
        
        //present the view controller
        self.navigationController?.showViewController(detailedController, sender: self)
    }
    
    @IBAction func makeNewButton(sender: AnyObject)
    {
        var editorVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeViewController
        
        //we don't want to see the bottom tab bar in the editor view
        editorVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.showViewController(editorVC, sender: self)
    }
    
}
