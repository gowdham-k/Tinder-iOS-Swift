//
//  TinderViewController.swift
//  Tinder
//
//  Created by Rob Percival on 17/10/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit

class TinderViewController: UIViewController {

    
    var xFromCenter: CGFloat = 0
    
    var usernames = [String]()
    var userImages = [NSData]()
    var currentUser = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
            if error == nil {
                
                println(geopoint)
                
                var user = PFUser.currentUser()
                
                user["location"] = geopoint
                
                
                var query = PFUser.query()
                query.whereKey("location", nearGeoPoint:geopoint)
                
                
                /*
                query.whereKey("username", notEqualTo: PFUser.currentUser().username)
                query.whereKey("gender", equalTo: PFUser.currentUser()["InterestedIn"])
                
             */
                
                
                query.limit = 10
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                    
                    var accepted = [String]()
                    
                    if PFUser.currentUser()["accepted"] != nil {
                    
                        accepted = PFUser.currentUser()["accepted"] as! [String]
                    }
                    
                    //var accepted = PFUser.currentUser()["accepted"] as! [String]
                    //var rejected = PFUser.currentUser()["rejected"] as! [String]
                    
                    var rejected = [String]()
                    
                    if PFUser.currentUser()["rejected"] != nil {
                        
                        rejected = PFUser.currentUser()["rejected"] as! [String]
                    }
                    
                    for user in users {
                        
                        
                        var gender1 = user["gender"] as? NSString
                        var gender2 = PFUser.currentUser()["interestedIn"] as? NSString
                        
                        
                        
                        if gender1 == gender2 && PFUser.currentUser().username != user.username && !contains(accepted, user.username) && !contains(rejected, user.username) {
                            
                        
                            self.usernames.append(user.username)
                            self.userImages.append(user["image"] as! NSData)
                            
                           
                        
                        }
                        
                        
                    }
                    
                    var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                    userImage.image = UIImage(data: self.userImages[0])
                    userImage.contentMode = UIViewContentMode.ScaleAspectFit
                    self.view.addSubview(userImage)
                    
                    var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                    userImage.addGestureRecognizer(gesture)
                    
                    userImage.userInteractionEnabled = true
                    
                    
                    
                })
                
                
            }
            
        }
        /*
         var i = 10
        
        func addPerson(urlString: String) {
            var newUser = PFUser()
            
            let url = NSURL(string: urlString)
            
            let urlRequest = NSURLRequest(URL: url!)
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                response, data, error in
                
                
                newUser["image"] = data
                newUser["gender"] = "female"
                
                var lat = Double(12 + i)
                var lon = Double(80 + i)
                
                i = i + 10
                
                var location = PFGeoPoint(latitude: 12, longitude: 80)
                
                newUser["location"] = location
                
                newUser.username = "\(i)"
                newUser.password = "password"
                newUser.signUp()

            })
            
            
        }
        
            addPerson("http://s3.amazonaws.com/readers/2010/12/07/3186885154021fda16b1_1.jpg")
            addPerson("http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=44643840")
    */    
    }

    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        
        
        let translation = gesture.translationInView(self.view) // translation
        var label = gesture.view! // a view in the gesture
        
        
        xFromCenter += translation.x
        
        var scale = min(100 / abs(xFromCenter), 1) //the number we stretch by , absolute function - +ve value. biggest no-> 1 , anything lesser that is fine.
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200) //angle - a radian divides circle into two pi little bits, one radian is around 6degrees.
        
        var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
       
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if label.center.x < 100 {
                
                println("Not Chosen")
                
                PFUser.currentUser().addUniqueObject(self.usernames[self.currentUser], forKey:"rejected")
                PFUser.currentUser().save()
                
                self.currentUser++
                
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                println("Chosen")
                
                
                PFUser.currentUser().addUniqueObject(self.usernames[self.currentUser], forKey:"accepted")
                PFUser.currentUser().save()
                
                self.currentUser++
                
            }
            
            
            
            label.removeFromSuperview()
            
            if self.currentUser < self.userImages.count {
            
            var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
            userImage.image = UIImage(data: self.userImages[self.currentUser])
            userImage.contentMode = UIViewContentMode.ScaleAspectFit
            self.view.addSubview(userImage)
            
            var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
            userImage.addGestureRecognizer(gesture)
            
            userImage.userInteractionEnabled = true
            
            xFromCenter = 0
                
            } else {
                
                println("No more users")
                
            }
            
        }
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

       
    }
    

    /*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
