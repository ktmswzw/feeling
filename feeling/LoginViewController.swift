//
//  LoginViewController.swift
//  feeling
//
//  Created by vincent on 15/11/17.
//  Copyright © 2015年 xecoder. All rights reserved.
//


import UIKit
import QuartzCore
import MaterialKit
import CryptoSwift
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController,BWWalkthroughViewControllerDelegate {
    
//    let key: [UInt8] = [56, 118, 37, 51, 125, 78, 103, 107, 119, 40, 74, 88, 117, 112, 123, 75]
//    
//    let iv: [UInt8] = [69, 122, 99, 87, 83, 112, 110, 65, 54, 109, 107, 89, 73, 122, 74, 49]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        // No border, shadow, floatingPlaceholderEnabled
        username.layer.borderColor = UIColor.clearColor().CGColor
        username.floatingPlaceholderEnabled = true
        username.placeholder = "帐号"
        username.rippleLayerColor = UIColor.MKColor.LightBlue
        username.tintColor = UIColor.MKColor.Blue
        username.backgroundColor = UIColor(hex: 0xE0E0E0)
        
        
        password.layer.borderColor = UIColor.clearColor().CGColor
        password.floatingPlaceholderEnabled = true
        password.placeholder = "密码"
        password.rippleLayerColor = UIColor.MKColor.LightBlue
        password.tintColor = UIColor.MKColor.Blue
        password.backgroundColor = UIColor(hex: 0xE0E0E0)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Backgroup.png")!)
        
        loginButton.cornerRadius = 30.0
        loginButton.backgroundLayerCornerRadius = 30.0
        loginButton.maskEnabled = false
        loginButton.ripplePercent = 1.75
        loginButton.rippleLocation = .Center
        
        loginButton.layer.shadowOpacity = 0.75
        loginButton.layer.shadowRadius = 3.5
        loginButton.layer.shadowColor = UIColor.blackColor().CGColor
        loginButton.layer.shadowOffset = CGSize(width: 1.0, height: 2.5)
        
    }
    
    @IBOutlet var username: MKTextField!
    
    @IBOutlet var password: MKTextField!
    
    @IBOutlet var loginButton: MKButton!
    
    
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
    
    
    @IBAction func login(sender: AnyObject) {
        
        if username.text != "" || password.text != ""
        {
            
//            let plaintext: [UInt8] = [123, 10, 32, 32]
//
//            let encryptedU = try! AES(key: key, iv: iv, blockMode: .CFB).encrypt(Array(username.text!.utf8))
//            let encryptedP = try! AES(key: key, iv: iv, blockMode: .CFB).encrypt(Array(password.text!.utf8))
            
//            print(Array(password.text!.utf8))
//            
//            let encryptedU = try! AES(key: key, iv: iv, blockMode: .CFB).encrypt(plaintext)
//            let encryptedP = try! AES(key: key, iv: iv, blockMode: .CFB).encrypt(plaintext)
//            
//            
//            print(NSString(bytes: encryptedU, length: encryptedU.count, encoding: NSUTF8StringEncoding))
//            
//            print(NSString(bytes: encryptedP, length: encryptedP.count, encoding: NSUTF8StringEncoding))
//            
//            let usernameEncrypted = NSString(bytes: encryptedU, length: encryptedU.count, encoding: NSUTF8StringEncoding)
//            let passwordEncrypted = NSString(bytes: encryptedP, length: encryptedP.count, encoding: NSUTF8StringEncoding)
//            let decrypted = try! aes.decrypt(passwordEncrypted, padding: nil)
//            self.performSegueWithIdentifier("login", sender: self)
//            Alamofire.request(.GET, "http://192.168.137.1:8080/login/autoLoad", parameters: ["username": usernameEncrypted!,"password":passwordEncrypted!]).responseJSON { response in
//                    print(response.request)  // original URL request
//                    print(response.response) // URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
//
//                    if let json = response.result.value {
//                        let myJosn = JSON(json)
//                        print("JSON: \(json)")
//                        if let successful = myJosn.dictionary!["successful"]!.bool {
//                            if successful {
//                                self.performSegueWithIdentifier("login", sender: self)
//                            }
//                        }
//
//                    }
//            }
            
        }
        else
        {
            let refreshAlert = UIAlertController(title: "错误", message: "帐号密码错误", preferredStyle: UIAlertControllerStyle.ActionSheet)
            //refreshAlert.addAction(UIAlertAction(title: "Clear message history", style: .Destructive, handler: { (action: UIAlertAction!) in }))
            refreshAlert.addAction(UIAlertAction(title: "确认", style: .Cancel, handler: { (action: UIAlertAction!) in }))
            presentViewController(refreshAlert, animated: true, completion: nil)
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

