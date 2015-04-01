//
//  ShopLookViewController.swift
//  FashionStash
//
//  Created by Yao Li on 3/27/15.
//
//

import UIKit

class ShopLookController: UIViewController, UIActionSheetDelegate, UIGestureRecognizerDelegate { //, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var editPostButton: UIButton!
    @IBOutlet var shopLookButton: UIButton!
    @IBOutlet var shopLookTableView: UITableView!
    @IBOutlet var descriptionTextField: LinkFilledTextView!
    
    @IBOutlet var descTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet var shopLookHeightConstraint: NSLayoutConstraint!
    
    var currentPost : ImagePostStructure?
    var alerter : CompatibleAlertViews?
    var shopLookList : Array<ShopLook> = []
    var currentShopDelegate: ShopLookDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = UIColor.blackColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.translucent = true;
        
        editPostButton.titleLabel?.textColor = UIColor.grayColor()
        editPostButton.layer.borderWidth = CGFloat(1.0)
        editPostButton.layer.borderColor = UIColor.grayColor().CGColor
        
        descriptionTextField.owner = self;
        self.descriptionTextField.scrollEnabled = true;
        self.descriptionTextField.userInteractionEnabled = true;
        self.descTextFieldConstraint.constant = MIN_SHOPLOOK_CONSTRAINT;
        
        var descripTextToSet = currentPost!.getDescriptionWithTag();
        if (descripTextToSet == "") {
            descripTextToSet = "Gallery of images by @"+currentPost!.getAuthor();
        }
        descriptionTextField.setTextAfterAttributing(false, text: descripTextToSet);
        var descripPreferredHeight = descriptionTextField.sizeThatFits(CGSizeMake(descriptionTextField.frame.size.width, CGFloat.max)).height;
        var descripHeightToSet = min(descripPreferredHeight, MIN_SHOPLOOK_DESCRIP_CONSTRAINT);
        self.descTextFieldConstraint.constant = descripHeightToSet;
        descriptionTextField.layoutIfNeeded();
    }
    
    override func viewWillAppear(animated: Bool) { NSLog("viewWillAppear")
        super.viewWillAppear(animated)
        getShopLooks()
        self.navigationController?.navigationBar.topItem?.title = "Info"
    }
    
    override func viewDidAppear(animated: Bool) { NSLog("viewDidAppear")
        super.viewDidAppear(animated)

        configEditPostButton()
        self.navigationController?.navigationBar.topItem?.title = "Info"
    }
    
    @IBAction func backPress(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true);
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        (self.navigationController!.parentViewController as SideMenuManagingViewController).openMenu();
    }
    

    @IBAction func editPostAction(sender: AnyObject) {
        if currentPost!.isOwnedByMe() {
            var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
            actionSheet.addButtonWithTitle("Edit Post")
            actionSheet.addButtonWithTitle("Delete Post")
            actionSheet.addButtonWithTitle("Cancel")
            actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1
            actionSheet.showInView(UIApplication.sharedApplication().keyWindow)
        } else { // TODO: necessary when disable rather than hide the button
            CompatibleAlertViews.makeNotice("Invalid Edit", message: "you can not edit others' post", presenter: self)
            self.configEditPostButton()
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
            case 0:
                //edit this post, segue to imagepreviewcontroller with right specs
                currentPost!.loadAllImages({(result: Array<UIImage>) in
                    var imageEditingControl = self.storyboard!.instantiateViewControllerWithIdentifier("ImagePreview") as ImagePreviewController;
                    imageEditingControl.receiveImage(result, post: self.currentPost!)
                    self.navigationController!.pushViewController(imageEditingControl, animated: true);
                })
                
            case 1:
                alerter = CompatibleAlertViews(presenter: self);
                alerter!.makeNoticeWithAction("Confirm Delete", message: "Deleting this post will delete all images in this post's gallery. Are you sure you want to delete this post?", actionName: "Delete", buttonAction: {
                    () in
                    //delete this post!
                    ServerInteractor.removePost(self.currentPost!);
                });
                
            case 2:
                NSLog("Cancelled");
            
            default:
                break;
        }
    }
    
    func receiveFromPrevious(post: ImagePostStructure, backgroundImg: UIImage) {
        self.currentPost = post;
//        if (backgroundImg != nil) { TODO: figure it out why nil
//        self.backImage.image = backgroundImg;
//        }
    }
    
    
    func getShopLooks() { NSLog("get shop looks")
        self.shopLookList = Array<ShopLook>();
        currentPost!.fetchShopLooks({(slList : Array<ShopLook>) -> Void in
            for index in 0..<slList.count {
                self.shopLookList.append(slList[index]); NSLog("shop look info: \(slList[index].title)---\(slList[index].urlLink))")
            }
            
            self.shopLookTableView.reloadData()
        })
        
        currentPost!.fetchShopLooks({(input: Array<ShopLook>) in
            self.currentShopDelegate = ShopLookDelegate(looks: input, owner: self);
            self.currentShopDelegate!.initialSetup(self.shopLookTableView);
/*            var descripPreferredHeight = self.descriptionTextField.sizeThatFits(CGSizeMake(self.descriptionTextField.frame.size.width, CGFloat.max)).height;
            var descripHeightToSet = min(descripPreferredHeight, MIN_SHOPLOOK_DESCRIP_CONSTRAINT);
            
            var preferredTableHeight = self.shopLookTableView.contentSize.height;
            var tableHeightToSet = min(preferredTableHeight, MIN_SHOPLOOK_TOTAL_FLEXIBLE_CONSTRAINT - descripHeightToSet);       //343->300->333
            self.shopLookHeightConstraint.constant = tableHeightToSet;
*/          
            self.configShopLookButton(input.count)
        })
    }
    
    func configEditPostButton() {
        if (currentPost!.isOwnedByMe()) {
            editPostButton.titleLabel?.textColor = UIColor.whiteColor()
            editPostButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
        else {
            editPostButton.titleLabel?.textColor = UIColor.grayColor()
            editPostButton.layer.borderColor = UIColor.grayColor().CGColor
            editPostButton.hidden = true
        }
    }
    
    func configShopLookButton(shopLookCount : Int) {
        if shopLookCount == 0 {
            self.shopLookButton.hidden = true
        } else {
            self.shopLookButton.hidden = false
            
            // add a top separator in shop look table
            let tableFrame : CGRect = self.shopLookTableView.bounds
            let headerHeight : CGFloat = 2
            let headerView : UIView = UIView(frame: CGRectMake(0,0,tableFrame.size.width, headerHeight))
            
            // Create separator
            let lineView : UIView = UIView(frame:CGRectMake(0, headerHeight-1, tableFrame.size.width, 1))
            lineView.backgroundColor = UIColor(red: 103/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1.0)
            headerView.addSubview(lineView)
            
            self.shopLookTableView.tableHeaderView = headerView;
        }
    }
}