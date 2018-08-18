//
//  ViewController.swift
//  ovenBits
//
//  Created by Victoria George on 12/1/17.
//  Copyright © 2017 Victoria George. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie


class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var picOfTheDay: UIImageView!
    @IBOutlet weak var glitchText: UILabel!
    @IBOutlet weak var spaceHolder: UIView!
    @IBOutlet weak var monsterTruck: UIImageView!
    @IBOutlet weak var webView: UIWebView! 
    @IBOutlet weak var explainItNasa: UITextView!
    
    var player: AVAudioPlayer!
    var timer: Timer!
    
    var milkView: LOTAnimationView?
    var ToriToriToriView: LOTAnimationView?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.isHidden = true
        
        //sound set up
        let path = Bundle.main.path(forResource: "bloopSound", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }        
        
        //setup animation milk
        let milkView = LOTAnimationView(name: "milk")
        milkView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        milkView.center = self.view.center
        milkView.contentMode = .scaleAspectFill
        view.addSubview(milkView)
        
        milkView.play(completion: { (_) in
            
            //setup NASA
            
            NASAAPIClient.getDataFromAPI { (data) in
                
                let mediaCheck = NASAAPIClient().mediaCheck()
                let youTubeURL = "\(data["url"]!)"
                
                if mediaCheck == "video" {
                    
                    DispatchQueue.main.async {
                        self.webView.isHidden = false
                    }
                    
                    let url = URL(string: "\(youTubeURL)")
                    if let unwrappedURL = url {
                        
                        let request = URLRequest(url: unwrappedURL)
                        let session = URLSession.shared
                        let task = session.dataTask(with: request) { (data, response, error) in
                            
                            if error == nil {
                                DispatchQueue.main.async {
                                    self.webView.loadRequest(request)
                                }
                                
                            } else {
                                
                                print("ERROR: \(String(describing: error))")
                            }
                        }
                        task.resume()
                    }
                    
                } else {
                    
                    NASAAPIClient.downloadImage(at: data["url"]!, completion: { (success, image) in
                        
                        if success == true {
                            
                            print("got image data from URL")
                            DispatchQueue.main.async {
                                self.webView.isHidden = true
                                self.picOfTheDay.image = image
                            }
                            
                        } else {
                            print ("Error getting image")
                        }
                    })
                }
                DispatchQueue.main.async {
                    self.dateLabel.text = "\(data["date"]!)"
                    self.imageTitle.text = "\(data["title"]!)"
                    self.explainItNasa.text = "\(data["explanation"]!)"
                    print("inside dispatchqueue 2")
                }
            }
            
            self.nasaButtonAction()
            for _ in self.view.subviews {
                milkView.removeFromSuperview()
                print("after discmiss subviews")
            }
        })

    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func nasaButtonAction() {
        let rainbowView = LOTAnimationView(name: "rainbowTransition")
        rainbowView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        rainbowView.center = self.view.center
        rainbowView.contentMode = .scaleAspectFill
        view.addSubview(rainbowView)
        
        
        rainbowView.play(completion: { (_) in
           
            for _ in self.view.subviews {
                rainbowView.removeFromSuperview()
                self.spaceHolder.isHidden = false
                self.player.play()
                self.monsterTruck.isUserInteractionEnabled = true
                
                UIView.animate(withDuration: 2.0, animations: {
                    self.monsterTruck.frame = CGRect(x: -300, y: 120, width: 250, height: 250)
                }) { (finished) in
                    print("Inside finished animation")
                    //stuff happens
                }
            }
        })

    }
    
}
        



