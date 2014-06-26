//
//  HomeFeedController.swift
//  ParseStarterProject
//
//  Created by Eric Oh on 6/25/14.
//
//

import UIKit

class HomeFeedController: UIViewController {
    
    weak var frontImageView: UIImageView?;
    
    weak var backImageView: UIImageView?;
    

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        frontImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 280, height: 320));
        backImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 280, height: 320));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
