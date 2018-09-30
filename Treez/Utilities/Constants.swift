//
//  Constants.swift
//  Treez
//
//  Created by Weston Gibler on 9/30/18.
//  Copyright © 2018 Weston Gibler. All rights reserved.
//

import Foundation

let apiKey = "86cf74dfe7ade768079ef14a64ef5798"
let secret = "b9487b1883c67c2c"

func flickrURL(forApiKey key: String, withAnnotation annotation: DroppablePin, andNumberOfPhotos number: Int) -> String  {
    let url =  "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
    return url
}
