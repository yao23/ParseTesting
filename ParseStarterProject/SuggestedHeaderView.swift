//
//  SuggestedHeaderView.swift
//  ParseStarterProject
//
//  Created by Eric Oh on 8/6/14.
//
//

import UIKit

class SuggestedHeaderView: UICollectionReusableView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var friendButton: UIButton!
    
    var friend: FriendEncapsulator?;
    
    var owner: UIViewController?;
    
    var friendAction: Bool = false;
    
    
    func extraConfigurations(involvedUser: FriendEncapsulator?, sender: UIViewController) {
        //clicking on the image segues to that user's profile page
        //clicking on the message is handled by the linkfilledtextview
        //clicking on the (optional) right button allows you to follow that user
        owner = sender;
        self.iconImage!.image = nil;
        if (involvedUser != nil) {
            involvedUser!.fetchImage({(fetchedImage: UIImage)->Void in
                //var newUserIcon: UIImage = ServerInteractor.imageWithImage(fetchedImage, scaledToSize: CGSize(width: 40, height: 40))
                self.iconImage!.image = fetchedImage;
                self.iconImage!.autoresizingMask = UIViewAutoresizing.None;
                //self.userImage!.layer.cornerRadius = (self.userImage!.frame.size.width) / 2
                self.iconImage!.layer.cornerRadius = (40.0) / 2
                //self.userImage!.layer.cornerRadius = (40.0) / 2
                self.iconImage!.layer.masksToBounds = true
                //self.userImage!.layer.borderWidth = 0
                //self.userImage!.clipsToBounds = true;
            });
            friend = involvedUser;
            ServerInteractor.amFollowingUser(involvedUser!.username, retFunction: {(amFollowing: Bool) in
                self.friendAction = amFollowing;
                self.friendButton.hidden = false;
                if (amFollowing == true) {
                    self.friendButton.setBackgroundImage(FOLLOWED_ME_ICON, forState: UIControlState.Normal);
                }
                else if (amFollowing == false) {
                    self.friendButton.setBackgroundImage(FOLLOW_ME_ICON, forState: UIControlState.Normal)
                }
                else {
                    //do nothing, server failed to fetch!
                    NSLog("Failure? \(amFollowing)")
                }
            });
        }
        //check if I am already friends with this dude
        nameLabel.text = involvedUser!.username;
        self.backgroundColor = UIColor.clearColor();
    }
    
    
    @IBAction func friendMe(sender: UIButton) {
        var username = friend!.username;
        if (friendAction == false) {
            //follow me
            ServerInteractor.postFollowerNotif(username, controller: self.owner!);
            ServerInteractor.addAsFollower(username);
            
            //update button
            self.friendAction = true
            self.friendButton.setBackgroundImage(FOLLOWED_ME_ICON, forState: UIControlState.Normal);
        }
        else if (friendAction == true) {
            //unfollow me (if u wish!)
            let alert: UIAlertController = UIAlertController(title: "Unfollow "+username, message: "Unfollow "+username+"?", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Unfollow", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void in
                ServerInteractor.removeAsFollower(username);
                //update button
                self.friendAction = false
                self.friendButton.setBackgroundImage(FOLLOW_ME_ICON, forState: UIControlState.Normal)
            }));
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void in
                //canceled
            }));
            self.owner!.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            //no action
        }

    }
}