//
//  SideTableViewCell.swift
//  ParseStarterProject
//
//  Created by Eric Oh on 7/28/14.
//
//

import UIKit

class SideTableViewCell: UITableViewCell {
    
    var cellImage: UIImageView?;
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder);
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        //var currentFrame: CGRect = self.frame;
        //self.frame = currentFrame;
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var currentFrame: CGRect = self.frame;
        if (cellImage != nil) {
            
        }
        else {
            cellImage = UIImageView(frame: CGRectMake(0, 0, currentFrame.height, currentFrame.width));
            /*cellImage!.contentMode = UIViewContentMode.ScaleToFill;
            cellImage!.clipsToBounds = true;
            self.contentView.addSubview(cellImage!);*/
            self.backgroundView = cellImage!;
        }
        
        //self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        
        //NSLog("\(currentFrame.origin.x) and \(currentFrame.origin.y)");
        //self.frame = CGRectMake(currentFrame.origin.y, currentFrame.origin.x, currentFrame.height, currentFrame.width);
        //self.frame = currentFrame;
        
        
        /*cellImage.transform = CGAffineTransformMakeRotation(M_PI / 2);
        var currentFrame2: CGRect = cellImage.frame;
        cellImage.frame = CGRectMake(currentFrame2.origin.y, currentFrame2.origin.x, currentFrame2.height, currentFrame2.width);*/
        //cellImage.frame = currentFrame2;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setImage(img: UIImage) {
        var rotImg = UIImage(CGImage: img.CGImage, scale: 0.25, orientation: UIImageOrientation.Right);
        cellImage!.image = rotImg;
    }

}