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

import ImagePickerSheetController

class SendViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    let locationManager = CLLocationManager()
    
    var picker = UIImagePickerController()
    var imageData = [UIImage]()
    
    
    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named: "Backgroup.png")?.CGImage
        //地图初始化
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = 10;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    
    func pickerImage() {
        let alertController = UIAlertController(title: "选择照片", message: "从相机或者照片中选择", preferredStyle:UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "相机", style: .Default) { (action:UIAlertAction!) in
            
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            //to select only camera controls, not video controls
            self.picker.mediaTypes = [kUTTypeImage as String]
            self.picker.showsCameraControls = true
            self.picker.allowsEditing = true
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        
        
        let albumAction = UIAlertAction(title: "相册", style: .Default) { (action:UIAlertAction!) in
            
            self.picker.delegate = self
            self.presentViewController(self.picker, animated: true, completion: nil)
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
//
//    
//    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>){
//        if(error != nil){
//            print("ERROR IMAGE \(error.debugDescription)")
//        }
//    }
//    
    
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
    
    
    
    func presentImagePickerSheet() {
        let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
            let controller = UIImagePickerController()
            controller.delegate = self
            var sourceType = source
            if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                sourceType = .PhotoLibrary
                print("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
            }
            controller.sourceType = sourceType
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
        let controller = ImagePickerSheetController(mediaType: .ImageAndVideo)
        controller.addAction(ImagePickerAction(title: NSLocalizedString("Take Photo Or Video", comment: "Action Title"), secondaryTitle: NSLocalizedString("Add comment", comment: "Action Title"), handler: { _ in
            presentImagePickerController(.Camera)
            }, secondaryHandler: { _, numberOfPhotos in
                print("Comment \(numberOfPhotos) photos")
        }))
        controller.addAction(ImagePickerAction(title: NSLocalizedString("Photo Library", comment: "Action Title"), secondaryTitle: { NSString.localizedStringWithFormat(NSLocalizedString("ImagePickerSheet.button1.Send %lu Photo", comment: "Action Title"), $0) as String}, handler: { _ in
            presentImagePickerController(.PhotoLibrary)
            }, secondaryHandler: { _, numberOfPhotos in
                //print("Send \(controller.selectedImageAssets)")
                for ass in controller.selectedImageAssets
                {
                    let image = getAssetThumbnail(ass)
                    self.imageData.append(image)
                }
                self.photoCollectionView.reloadData()
                
        }))
        controller.addAction(ImagePickerAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: { _ in
            //print("Cancelled")
        }))
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            controller.modalPresentationStyle = .Popover
            controller.popoverPresentationController?.sourceView = view
            controller.popoverPresentationController?.sourceRect = CGRect(origin: view.center, size: CGSize())
        }
        
        presentViewController(controller, animated: true, completion: nil)
    }
}


extension SendViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //pickerImage()
        presentImagePickerSheet()
        //self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        switch indexPath.row {
            
        case imageData.count:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("newCell", forIndexPath: indexPath)
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo", forIndexPath: indexPath)
            let imgV = UIImageView(image: imageData[indexPath.row])
            imgV.frame = cell.frame
            cell.backgroundView = imgV
        }
        
        return cell
    }
}

extension SendViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageData.append(image)
        photoCollectionView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
