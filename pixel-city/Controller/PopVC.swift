//
//  PopVC.swift
//  pixel-city
//
//  Created by Kunal Tyagi on 04/01/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit
import Alamofire

class PopVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var takenOnLbl: UILabel!
    @IBOutlet weak var postedByLbl: UILabel!
    @IBOutlet weak var dismissLbl: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var popImageView: UIImageView!
    
    var passedImage: UIImage!
    var photoId: String?
    var secret: String?
    
    var photoTitle: String = ""
    var photoDescription: String = ""
    var ownerName: String = ""
    var date: String = ""
    
    
    func initData(forImage image: UIImage){
        self.passedImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.text = photoTitle
        self.descriptionLbl.text = photoDescription
        self.userLbl.text = ownerName
        self.dateLbl.text = date
        popImageView.image = passedImage
        if ownerName == ""
        {
            postedByLbl.isHidden = true
            takenOnLbl.isHidden = true
            dismissLbl.isHidden = true
        }
        addDoubleTap()
    }
    
    func addDoubleTap(){
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    }
    
    @objc func screenWasDoubleTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    func getDetails(photoId: String, secret: String, handler: @escaping (_ status: Bool)-> () ){
        self.photoId = photoId
        self.secret = secret
        handler(true)
    }
    
    func retrievePictureDetails(handler: @escaping (_ status: Bool)-> () ){
        Alamofire.request("https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(apiKey)&photo_id=\(self.photoId!)&secret=\(self.secret!)&format=json&nojsoncallback=1").responseJSON { (response) in
            if response.result.error == nil{
                print("https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(apiKey)&photo_id=\(self.photoId!)&secret=\(self.secret!)&format=json&nojsoncallback=1")
                guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
                let photoDetails = json["photo"] as? Dictionary<String, AnyObject>
                let ownerDetails = photoDetails!["owner"] as? Dictionary<String, AnyObject>
                let title = photoDetails!["title"] as! Dictionary<String, String>
                self.photoTitle = title["_content"]!
                let description = photoDetails!["description"] as! Dictionary<String, String>
                self.photoDescription = description["_content"]!
                let dates = photoDetails!["dates"] as? Dictionary<String, AnyObject>
                let views = photoDetails!["views"]
                self.ownerName = ownerDetails!["username"] as! String
                let dateTaken = dates!["taken"] as! String
                self.date = self.getConvertedDate(dateTaken: dateTaken)
                
                handler(true)
            }
            else
            {
                print(response.result.error!)
                handler(false)
            }
        }
    }
    
    func getFavourites(handler: @escaping (_ status: Bool)-> () ){
        Alamofire.request("https://api.flickr.com/services/rest/?method=flickr.photos.getFavorites&api_key=\(apiKey)&photo_id=\(photoId!)&format=json&nojsoncallback=1").responseJSON { (response) in
            if response.result.error == nil{
                guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
                let photoDetails = json["photo"] as? Dictionary<String, AnyObject>
                let fave = photoDetails!["total"]
                print(fave!)
                handler(true)
            }
            else
            {
                print(response.result.error!)
                handler(false)
            }
        }
    }
    
    func getConvertedDate(dateTaken: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = dateFormatter.date(from: dateTaken)
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date = dateFormatter.string(from: convertedDate!)
        return date
    }
}
