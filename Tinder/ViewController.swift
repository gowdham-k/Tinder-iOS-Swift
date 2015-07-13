//
//  ViewController.swift
//  Storing Images
//
//  Created by Rob Percival on 12/08/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var loginCancelledLabel: UILabel!
    
    @IBAction func signIn(sender: AnyObject) {
        
        var permissions = ["email", "public_profile"]
        
        self.loginCancelledLabel.alpha = 0
        
        
        PFFacebookUtils.logInWithPermissions(permissions, block: {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
                
                self.loginCancelledLabel.alpha = 1
                
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                
                self.performSegueWithIdentifier("signUp", sender: self)
                
            } else {
                NSLog("User logged in through Facebook!")
                
                self.performSegueWithIdentifier("signUp", sender: self)
                
            }
            
        })
        
        /*PFFacebookUtils.logInWithPermissions(permissions, block: {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
                
                self.loginCancelledLabel.alpha = 1
                
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                
                self.performSegueWithIdentifier("signUp", sender: self)
                
            } else {
                NSLog("User logged in through Facebook!")
                
                self.performSegueWithIdentifier("signUp", sender: self)
                
            }
            
        })*/
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      /*  var push = PFPush()
        push.setMessage("This is a Test")
        push.sendPushInBackgroundWithBlock({
            (isSuccessful: Bool, error: NSError!) -> Void in
            
            println(isSuccessful)
            
        })
        
       */
    
        if PFUser.currentUser() != nil {
            
         println("User logged in")
            
            //PFUser.logOut()
            
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

