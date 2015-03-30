//
//  ShopLookViewController.swift
//  FashionStash
//
//  Created by Yao Li on 3/27/15.
//
//

import UIKit

class ShopLookController: UIViewController, UIActionSheetDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var editPostButton: UIButton!
    @IBOutlet var goToWebpageButton: UIButton!
    @IBOutlet var shopLookTableView: UITableView!
    @IBOutlet var descriptionTextField: LinkFilledTextView!
    
    @IBOutlet var descTextFieldConstraint: NSLayoutConstraint!
    
    var currentPost : ImagePostStructure?
    var alerter : CompatibleAlertViews?
    var shopLookList : Array<ShopLook> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = UIColor.blackColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.translucent = true;
        
//        editPostButton.hidden = true;
        editPostButton.enabled = false
        
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
        self.navigationController?.navigationBar.topItem?.title = "Shop The Look"
        
        if (currentPost!.isOwnedByMe()) {
//           editPostButton.hidden = false;
            editPostButton.titleLabel?.textColor = UIColor.whiteColor()
            editPostButton.enabled = true
        }
        else {
//            editPostButton.hidden = true;
            editPostButton.titleLabel?.textColor = UIColor.grayColor()
            editPostButton.enabled = false
        }
        
        currentPost?.getAuthorFriend().getWebURL({(webURL : String?) -> Void in
            if webURL == nil {
                self.goToWebpageButton.titleLabel?.textColor = UIColor.grayColor()
                self.goToWebpageButton.enabled = false
            } else {
                self.goToWebpageButton.titleLabel?.textColor = UIColor.whiteColor()
                self.goToWebpageButton.enabled = true
            }
        })
    }
    
    @IBAction func backPress(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true);
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        (self.navigationController!.parentViewController as SideMenuManagingViewController).openMenu();
    }
    

    @IBAction func editPostAction(sender: AnyObject) {
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Edit Post", "Delete Post");
        actionSheet.showInView(UIApplication.sharedApplication().keyWindow)
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            NSLog("Cancelled");
        case 1:
            //edit this post, segue to imagepreviewcontroller with right specs
            currentPost!.loadAllImages({(result: Array<UIImage>) in
                var imageEditingControl = self.storyboard!.instantiateViewControllerWithIdentifier("ImagePreview") as ImagePreviewController;
                imageEditingControl.receiveImage(result, post: self.currentPost!)
                self.navigationController!.pushViewController(imageEditingControl, animated: true);
            })
        case 2:
            alerter = CompatibleAlertViews(presenter: self);
            alerter!.makeNoticeWithAction("Confirm Delete", message: "Deleting this post will delete all images in this post's gallery. Are you sure you want to delete this post?", actionName: "Delete", buttonAction: {
                () in
                //delete this post!
                ServerInteractor.removePost(self.currentPost!);
            });
            
        default:
            break;
        }
    }
    
    
    @IBAction func goToWebpage(sender: AnyObject) {
        currentPost?.getAuthorFriend().getWebURL({(webURL : String?) -> Void in
            if webURL == nil {
                NSLog("post author has no web url")
            } else {
                UIApplication.sharedApplication().openURL(NSURL(string: self.checkHTTPHeader(webURL!))!)
            }
        })
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
    }
    
    func checkHTTPHeader(url : String) -> String {
        var retURL = url
        let rangeOfHTTP = Range(start: url.startIndex, end: advance(url.startIndex, 4))
        let rangeOfHTTPS = Range(start: url.startIndex, end: advance(url.startIndex, 5))
        if url.substringWithRange(rangeOfHTTP) != "http" || url.substringWithRange(rangeOfHTTPS) != "https" {
            retURL = "http://" + url
        }
        return retURL
    }
    
    //--------------------TableView delegate methods-------------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopLookList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ShopLookTableViewCell = tableView.dequeueReusableCellWithIdentifier("ShopLookCell", forIndexPath: indexPath) as ShopLookTableViewCell
        
        var index: Int = indexPath.row;
        cell.textLabel?.text = shopLookList[index].title; NSLog("got shop look: \(cell.textLabel?.text)")
        cell.shopLookURL = checkHTTPHeader(shopLookList[index].urlLink)
        return cell;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var index: Int = indexPath.row;
        var url = shopLookList[index].urlLink
        NSLog("shop look url: \(url)")
        if url == "" || url.isEmpty {
            return
        }
        
        url = checkHTTPHeader(url)
        
        if UIApplication.sharedApplication().openURL(NSURL(string: url)!) == false {
            NSLog("fail to open url: \(url.debugDescription)")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)->CGFloat {
        var cellText: NSString?;
        cellText = shopLookList[indexPath.row].title
        
        var cell: CGRect = tableView.frame;
        
        var textCell = UILabel();
        textCell.text = cellText;
        textCell.numberOfLines = 10;
        var maxSize: CGSize = CGSizeMake(cell.width, 9999);
        var expectedSize: CGSize = textCell.sizeThatFits(maxSize);
        return expectedSize.height + 20;
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
    }
}