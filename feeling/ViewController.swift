//
//  ViewController.swift
//  feeling
//
//  Created by vincent on 15/11/14.
//  Copyright © 2015年 xecoder. All rights reserved.
//

import UIKit
import QuartzCore
import MaterialKit

class ViewController: UIViewController,BWWalkthroughViewControllerDelegate {

    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

        
        
        // No border, shadow, floatingPlaceholderEnabled
        username.layer.borderColor = UIColor.clearColor().CGColor
        username.floatingPlaceholderEnabled = true
        username.placeholder = "Email account"
        username.rippleLayerColor = UIColor.MKColor.LightBlue
        username.tintColor = UIColor.MKColor.Blue
        username.backgroundColor = UIColor(hex: 0xE0E0E0)
        
        
        password.layer.borderColor = UIColor.clearColor().CGColor
        password.floatingPlaceholderEnabled = true
        password.placeholder = "Email account"
        password.rippleLayerColor = UIColor.MKColor.LightBlue
        password.tintColor = UIColor.MKColor.Blue
        password.backgroundColor = UIColor(hex: 0xE0E0E0)
    
    }
    
    @IBOutlet var username: MKTextField!
    
    @IBOutlet var password: MKTextField!
    
    @IBAction func closeKey(sender: AnyObject) {
        username.resignFirstResponder();
    }
    @IBAction func closeKeyP(sender: AnyObject) {
        password.resignFirstResponder();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if !userDefaults.boolForKey("walkthroughPresented") {
            
            showWalkthrough()
            
            userDefaults.setBool(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }

    
    @IBAction func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0")
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1")
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_zero)
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}

