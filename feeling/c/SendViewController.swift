//
//  SendViewController.swift
//  feeling
//
//  Created by vincent on 15/11/24.
//  Copyright © 2015年 xecoder. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation

import MediaPlayer
import MobileCoreServices

class SendViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    let locationManager = CLLocationManager()

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Backgroup.png")!)
        //地图初始化
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = 10;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        searchBar.showsCancelButton = true

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pickerImage(sender: UIButton) {

    
    
    let alertController = UIAlertController(title: "选择照片", message: "从相机或者照片中选择", preferredStyle:UIAlertControllerStyle.ActionSheet)
    
    
    let cameraAction = UIAlertAction(title: "相机", style: .Default) { (action:UIAlertAction!) in
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        //to select only camera controls, not video controls
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.showsCameraControls = true
        //imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    alertController.addAction(cameraAction)
    
    
    let albumAction = UIAlertAction(title: "相册", style: .Default) { (action:UIAlertAction!) in
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.presentViewController(pickerC, animated: true, completion: nil)
    }
    alertController.addAction(albumAction)
    
    let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (action:UIAlertAction!) in
        print("you have pressed the Cancel button");
    }
    alertController.addAction(cancelAction)
    
    
    self.presentViewController(alertController, animated: true, completion:{ () -> Void in
    print("y11111");
    })

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        let imagePickerc = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imagePreview.image = imagePickerc
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>){
        if(error != nil){
            print("ERROR IMAGE \(error.debugDescription)")
        }
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        latitudeLabel.text =  NSString(format: "%f" , location!.coordinate.latitude) as String
        longitudeLabel.text = NSString(format: "%f" , location!.coordinate.longitude) as String
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.mapView.setRegion(region, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {
            (placemarks, error) -> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    

    
    func displayLocationInfo(placemark: CLPlacemark) {
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
//        print(placemark.locality)
//        print(placemark.administrativeArea)
//        print(placemark.country)
        if let locationName = placemark.addressDictionary!["Name"] as? NSString {
            address.text = locationName as String
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }
    
    
    // 输入框内容改变触发事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("过滤：\(searchText)")
    }
    
    // 书签按钮触发事件
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        print("搜索历史")
    }
    
    // 取消按钮触发事件
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("取消搜索")
    }
    
    // 搜索触发事件
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("开始搜索")
    }

}
