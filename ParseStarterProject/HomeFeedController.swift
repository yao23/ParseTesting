//
//  HomeFeedController.swift
//  ParseStarterProject
//
//  Created by Eric Oh on 6/25/14.
//
//

import UIKit

class HomeFeedController: UIViewController {
    
    var frontImageView: UIImageView?;
    var backImageView: UIImageView?;
    

    /*init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        frontImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 280, height: 320));
        backImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 280, height: 320));
        //var imageHorn: UIImage = UIImage(named: "horned-logo.png");
        
        if let frontView = frontImageView {
            frontView.image = UIImage(named: "horned-logo.png");
        }
        if let backView = backImageView {
            backView.image = UIImage(named: "daniel-craig.jpg");
        }
        self.view.addSubview(frontImageView);
        self.view.addSubview(backImageView);
        
        self.view.bringSubviewToFront(frontImageView);

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        NSLog("Swiped Left");
        var location: CGPoint = sender.locationInView(self.view);
        location.x -= 220;
        
        if let frontView = frontImageView {
            UIView.animateWithDuration(0.5, animations: {
                frontView.alpha = 0.0;
                frontView.center = location;
            }
            , completion: { completed in
                NSLog("Finished!");
                //set frontView's image to backView's image
                if let backView = self.backImageView {
                    frontView.image = backView.image;
                    //reset frontView back to front
                    frontView.frame = CGRect(x: 20, y: 20, width: 280, height: 320);
                    frontView.alpha = 1.0;
                    //fetch new backView image for backView
                    //backView.image = METHOD FOR INSERTING NEW IMAGE HERE
                    backView.image = UIImage(named: "test image 3.jpg");
                    
                }
            });
        }
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        NSLog("Swiped Right");
        var location: CGPoint = sender.locationInView(self.view);
        location.x += 220;
        
        if let frontView = frontImageView {
            UIView.animateWithDuration(0.5, animations: {
                frontView.alpha = 0.0;
                frontView.center = location;
            }
            , completion: { completed in
                NSLog("Finished!");
                //set frontView's image to backView's image
                if let backView = self.backImageView {
                    frontView.image = backView.image;
                    //reset frontView back to front
                    frontView.frame = CGRect(x: 20, y: 20, width: 280, height: 320);
                    frontView.alpha = 1.0;
                    //fetch new backView image for backView
                    //backView.image = METHOD FOR INSERTING NEW IMAGE HERE
                    backView.image = UIImage(named: "test image 3.jpg");
                }
            });
        }
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}