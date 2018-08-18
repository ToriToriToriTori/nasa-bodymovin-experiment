//
//  NASAApiClient.swift
//  ovenBits
//
//  Created by App Developer on 7/28/18.
//  Copyright © 2018 Victoria George. All rights reserved.
//

import Foundation
import UIKit

   let urlString = "https://api.nasa.gov/planetary/apod?api_key=SecretKey"
   var mediaType = "picture"


class NASAAPIClient {
    
    typealias JSON = [String :  String]
    
    static func getDataFromAPI(with completion: @escaping (JSON) -> ()) {
        
        
        //let urlString = "https://api.nasa.gov/planetary/apod?api_key=8NpEjnxfpcUT9wHHyK9V4upcqeESJ2psWSBd0J8f"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else {return}
        
        let session = URLSession.shared
        let task = session.dataTask(with: unwrappedURL) { (data, response, error) in
            
            print("Start")
            guard let unwrappedData = data else {return}
            
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! JSON
                print(responseJSON["explanation"]!)
            
                mediaType = "\(String(describing: responseJSON["media_type"]!))"
                
                print(responseJSON["media_type"]!)
                print(mediaType)
                completion(responseJSON)
                print("got data")
                
            } catch {
                
                print(error)
                
            }
            
        }
        task.resume()
        
    }
    
    
    static func downloadImage(at urlString: String, completion: @escaping (Bool, UIImage?) -> ()) {
        
        let url = URL(string: urlString)
        guard let unwrappedURL = url else {return}
        
        let request = URLRequest(url: unwrappedURL)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data, let image = UIImage(data: data) else { completion(false, nil); return }
            
            completion(true, image)
            
        }
        task.resume()
    }
    

    
    
    func mediaCheck() -> String {
        
        print("inside check media")
        print(mediaType)
        return mediaType
    }
}




