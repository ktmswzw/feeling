//
//  HomwViewController.swift
//  feeling
//
//  Created by vincent on 15/11/22.
//  Copyright © 2015年 xecoder. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    
    @IBOutlet var myImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let myImages:UIImage = UIImage(named: "home-man.jpg")!
        
//        let colors = myImages.getColors()
//
//        self.view.backgroundColor = colors.backgroundColor
//        mainLabel.textColor = colors.primaryColor
//        secondaryLabel.textColor = colors.secondaryColor
//        detailLabel.textColor = colors.detailColor
//        
//        Toucan.Mask.maskImageWithEllipse(myImages)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

}
