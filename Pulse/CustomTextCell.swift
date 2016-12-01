//
//  CustomTextCell.swift
//  Pulse
//
//  Created by Bianca Curutan on 11/10/16.
//  Copyright © 2016 ABI. All rights reserved.
//

import UIKit

class CustomTextCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submessageLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    var message: String! {
        didSet {
            messageLabel.text = message
        }
    }
    
    var submessage: String? {
        didSet {
            if let submessage = submessage {
                submessageLabel.text = submessage
            }
        }
    }
    
    var imageName: String? {
        didSet {
            if let imageName = imageName {
                cellImageView.image = UIImage(named: imageName)
                cellImageView.tintColor = UIColor.pulseAccentColor()
            }
        }
    }
}
