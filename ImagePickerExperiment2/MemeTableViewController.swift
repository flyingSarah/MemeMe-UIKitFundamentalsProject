//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Sarah Howe on 7/22/15.
//  Copyright (c) 2015 SarahHowe. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //get all the memes from the app delegate
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = applicationDelegate.memes
        
        //refresh everytime the view appears
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! UITableViewCell
        
        //pass each meme image and the top text into each tabel cell
        let meme = memes[indexPath.row]
        cell.textLabel?.text = meme.topText

        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //Grab the detailedVC from Storyboard
        let object:AnyObject = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")!
        
        let detailedVC = object as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailedVC.meme = self.memes[indexPath.row]
        
        //Present the view controller using navigation
        navigationController?.showViewController(detailedVC, sender: self)
    }
    
    @IBAction func makeNewButton(sender: AnyObject)
    {
        var editorVC = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeViewController
        
        //we don't want to see the bottom tab bar in the editor view
        editorVC.hidesBottomBarWhenPushed = true
        
        navigationController?.showViewController(editorVC, sender: true)
    }
}