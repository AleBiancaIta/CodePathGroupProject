//
//  TeamTableViewCell.swift
//  Pulse
//
//  Created by Itasari on 11/14/16.
//  Copyright © 2016 ABI. All rights reserved.
//

import UIKit
import Parse

@objc protocol TeamTableViewCellDelegate {
    @objc optional func teamTableViewCell(_ teamTableViewCell: TeamTableViewCell, survey: PFObject)
}

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: PhotoImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var positionDescLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var contractEndLabel: UILabel!
    @IBOutlet weak var surveyValue1Button: UIButton!
    @IBOutlet weak var surveyValue2Button: UIButton!
    @IBOutlet weak var surveyValue3Button: UIButton!
    
    weak var delegate: TeamTableViewCellDelegate?
    
    var survey: PFObject? {
        didSet {
            if survey != nil {
                configureValidSurvey()
    
                let surveyValue1 = survey![ObjectKeys.Survey.surveyValueId1] as? Int ?? 99
                let surveyValue2 = survey![ObjectKeys.Survey.surveyValueId2] as? Int ?? 99
                let surveyValue3 = survey![ObjectKeys.Survey.surveyValueId3] as? Int ?? 99
                        
                setUpSurvey1(value: surveyValue1)
                setUpSurvey2(value: surveyValue2)
                setUpSurvey3(value: surveyValue3)
            } else {
                configureNilSurvey()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.pulseLightPrimaryColor()
        selectedBackgroundView = bgColorView
    }
    
    fileprivate func configureNilSurvey() {
        disableButtons()
        hideButtons()
    }
    
    fileprivate func configureValidSurvey() {
        enableButtons()
        unhideButtons()
    }
    
    fileprivate func enableButtons() {
        surveyValue1Button.isEnabled = true
        surveyValue2Button.isEnabled = true
        surveyValue3Button.isEnabled = true
    }
    
    fileprivate func disableButtons() {
        surveyValue1Button.isEnabled = false
        surveyValue2Button.isEnabled = false
        surveyValue3Button.isEnabled = false
    }
    
    fileprivate func unhideButtons() {
        surveyValue1Button.isHidden = false
        surveyValue2Button.isHidden = false
        surveyValue3Button.isHidden = false
    }
    
    fileprivate func hideButtons() {
        surveyValue1Button.isHidden = true
        surveyValue2Button.isHidden = true
        surveyValue3Button.isHidden = true
    }
    
    // happiness
    fileprivate func setUpSurvey1(value: Int) {
        switch value {
        case 0:
            surveyValue1Button.setImage(UIImage(named: "Grumpy"), for: .normal)
            surveyValue1Button.tintColor = UIColor.pulseBadSurveyColor() //UIColor.red
            surveyValue1Button.backgroundColor = UIColor.clear
        case 1:
            surveyValue1Button.setImage(UIImage(named: "Speechless"), for: .normal)
            surveyValue1Button.tintColor = UIColor.pulseNeutralSurveyColor() //UIColor.yellow
            surveyValue1Button.backgroundColor = UIColor.clear
        case 2:
            surveyValue1Button.setImage(UIImage(named: "Smiley"), for: .normal)
            surveyValue1Button.tintColor = UIColor.pulseGoodSurveyColor() //UIColor.green
            surveyValue1Button.backgroundColor = UIColor.clear
        default:
            surveyValue1Button.setImage(UIImage(named: "Smiley"), for: .normal)
            surveyValue1Button.tintColor = UIColor.pulseNoDataSurveyColor() //UIColor.darkGray
        }
    }
    
    // engagement
    fileprivate func setUpSurvey2(value: Int) {
        switch value {
        case 0:
            surveyValue2Button.setImage(UIImage(named: "ThumbsDown"), for: .normal)
            surveyValue2Button.tintColor = UIColor.pulseBadSurveyColor() //UIColor.red
            surveyValue2Button.backgroundColor = UIColor.clear
        case 1:
            surveyValue2Button.setImage(UIImage(named: "ThumbsMiddle"), for: .normal)
            surveyValue2Button.tintColor = UIColor.pulseNeutralSurveyColor() //UIColor.yellow
            surveyValue2Button.backgroundColor = UIColor.clear
        case 2:
            surveyValue2Button.setImage(UIImage(named: "ThumbsUp"), for: .normal)
            surveyValue2Button.tintColor = UIColor.pulseGoodSurveyColor() //UIColor.green
            surveyValue2Button.backgroundColor = UIColor.clear
        default:
            surveyValue2Button.setImage(UIImage(named: "ThumbsMiddle"), for: .normal)
            surveyValue2Button.tintColor = UIColor.pulseNoDataSurveyColor() //UIColor.darkGray
        }
    }
    
    // workload
    fileprivate func setUpSurvey3(value: Int) {
        switch value {
        case 0:
            surveyValue3Button.setImage(UIImage(named: "Cross4"), for: .normal)
            surveyValue3Button.tintColor = UIColor.pulseBadSurveyColor() //UIColor.red
            surveyValue3Button.backgroundColor = UIColor.clear
        case 1:
            surveyValue3Button.setImage(UIImage(named: "Circle3"), for: .normal)
            surveyValue3Button.tintColor = UIColor.pulseNeutralSurveyColor() //UIColor.yellow
            surveyValue3Button.backgroundColor = UIColor.clear
        case 2:
            surveyValue3Button.setImage(UIImage(named: "Checkmark5"), for: .normal)
            surveyValue3Button.tintColor = UIColor.pulseGoodSurveyColor() //UIColor.green
            surveyValue3Button.backgroundColor = UIColor.clear
        default:
            surveyValue3Button.setImage(UIImage(named: "Circle3"), for: .normal)
            surveyValue3Button.tintColor = UIColor.pulseNoDataSurveyColor() //UIColor.darkGray
        }
    }
    
    @IBAction func onEmailButton(_ sender: Any) {
        if let emailLabel = emailButton.titleLabel,
            let email = emailLabel.text {
			UIApplication.shared.mailTo(email: email)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        surveyValue1Button.tintColor = UIColor.clear
        surveyValue2Button.tintColor = UIColor.clear
        surveyValue3Button.tintColor = UIColor.clear
        profileImageView.pffile = nil
    }
    
    // MARK: - Actions
    
    @IBAction func onSurveyButtonTap(_ sender: UIButton) {
        if self.survey != nil {
            delegate?.teamTableViewCell?(self, survey: self.survey!)
        }
    }
}
