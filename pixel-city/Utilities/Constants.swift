//
//  Constants.swift
//  pixel-city
//
//  Created by Kunal Tyagi on 01/01/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import Foundation

let apiKey = "980e6653621a66b6af42a307cb7e5911"

func flickrUrl(forApiKey key: String, withAnnotation annotation: DropabblePin, andNumberOfPhotos number: Int)-> String{
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(key)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)& radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
}

