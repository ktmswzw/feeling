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
import Alamofire
import SwiftyJSON
import ActionButton

class LoginViewController: UIViewController,BWWalkthroughViewControllerDelegate{
    
    
    var actionButton: ActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        let wechatLogin = ActionButtonItem(title: "微信登录", image: UIImage(named: "wechat")!)
        wechatLogin.action = { item in self.showWalkthrough()  }
        
        let qqLogin = ActionButtonItem(title: "QQ登录", image: UIImage(named: "qq")!)
        qqLogin.action = { item in self.showWalkthrough() }
        
        
        let weiboLogin = ActionButtonItem(title: "微博登录", image: UIImage(named: "weibo")!)
        weiboLogin.action = { item in self.showWalkthrough() }
        
        
        let taobaoLogin = ActionButtonItem(title: "淘宝登录", image: UIImage(named: "taobao")!)
        taobaoLogin.action = { item in self.showWalkthrough() }
        
        actionButton = ActionButton(attachedToView: self.view, items: [wechatLogin, qqLogin, weiboLogin, taobaoLogin])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("?", forState: .Normal)
        actionButton.backgroundColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 128.0/255.0, alpha:0.703852370689655)
                
        initText(username,initTitle: "帐号")
        
        initText(password,initTitle: "密码")
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Backgroup.png")!)
        
        initButton(loginButton)

//        NSTimer.scheduledTimerWithTimeInterval(3.5, target: self, selector: "animateImageRipple", userInfo: nil, repeats: false)
        initImage(logoMKImage)
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "animateImageRipple", userInfo: nil, repeats: true)
    }

    func animateImageRipple() {
        logoMKImage.animateRipple()
    }

    
    @IBOutlet var username: MKTextField!
    
    @IBOutlet var password: MKTextField!
    
    @IBOutlet var loginButton: MKButton!
    
    @IBOutlet var logoMKImage: MKImageView!
    
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
    func bytes2String(array:[UInt8]) -> String {
        return (NSString(data: NSData(bytes: array, length: array.count), encoding: NSUTF8StringEncoding) ?? "") as String
    }

    func asciiCArrayToSwiftString(cString:UInt8...) -> String
    {
        var swiftString = String()            // The Swift String to be Returned is Intialized to an Empty String
        var workingCharacter:UnicodeScalar = UnicodeScalar(UInt8(cString[0]))
        let count:Int = cString.count

        for var i:Int = 0; i < count; i++
        {
            workingCharacter = UnicodeScalar(UInt8(cString[i])) // Convert the Int8 Character to a Unicode Scalar
            swiftString.append(workingCharacter)             // Append the Unicode Scalar

        }
        return swiftString                     // Return the Swift String
    }
    
    
    @IBAction func login(sender: AnyObject) {
        
        if username.text != "" || password.text != ""
        {
//            
//            Swift
//            
//            let plainString = "foo"
//            Encoding
//            
//            let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
//            let base64String = plainData?.base64EncodedStringWithOptions(.allZeros)
//            println(base64String!) // Zm9v
//            Decoding
//            
//            let decodedData = NSData(base64EncodedString: base64String!, options: .allZeros)
//            let decodedString = NSString(data: decodedData, encoding: NSUTF8StringEncoding)
//            println(decodedString) // foo
            self.performSegueWithIdentifier("login", sender: self)
//
//            let userNameText = NSData.AES256EncryptWithPlainText(username.text)
//            let passwordText = NSData.AES256EncryptWithPlainText(password.text)
//            Alamofire.request(.GET, "http://192.168.137.1:8080/login/autoLoad", parameters: ["username": userNameText,"password":passwordText]).responseJSON { response in
//                if let json = response.result.value {
//                    let myJosn = JSON(json)
//                    print("JSON: \(json)")
//                    if let successful = myJosn.dictionary!["successful"]!.bool {
//                        if successful {
//                            self.performSegueWithIdentifier("login", sender: self)
//                        }
//                    }
//                    else
//                    {
//                        let refreshAlert = UIAlertController(title: "错误", message: myJosn.dictionary!["msg"]!.string, preferredStyle: UIAlertControllerStyle.ActionSheet)
//                        refreshAlert.addAction(UIAlertAction(title: "确认", style: .Cancel, handler: { (action: UIAlertAction!) in }))
//                        self.presentViewController(refreshAlert, animated: true, completion: nil)
//                    }
//                }
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

