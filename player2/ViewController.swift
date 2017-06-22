//
//  ViewController.swift
//  player2
//
//  Created by Leif Weitzel on 21.06.17.
//  Copyright © 2017 Leif Weitzel. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let avPlayerViewController = AVPlayerViewController()
    var avPlayer:AVPlayer?
    
    @IBOutlet weak var sprachSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //background audio
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        //done

        
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.0215077, longitude: 11.2492387)
        
        mapView.addAnnotation(annotation)
        mapView.showsUserLocation = true

        
        
        
        
        func zoomIn(_ sender: AnyObject) {
            let userLocation = mapView.userLocation
            
            let region = MKCoordinateRegionMakeWithDistance(
                userLocation.location!.coordinate, 2000, 2000)
            
            mapView.setRegion(region, animated: true)
        }

    }


 /*
    @IBAction func languageSwitched(_ sender: Any) {
        
        switch(sprachSwitch.selectedSegmentIndex) {
        case 0:
            print("fisrt")
        case 1:
            print("second")
        default:
            break
        }
    }
        
*/
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        print("Song+\(sprachSwitch.selectedSegmentIndex)")
        let urlPathString:String? = Bundle.main.path(forResource: "Song\(sprachSwitch.selectedSegmentIndex)", ofType: "mp3")

        if let urlPath = urlPathString
        {
            let movieUrl = NSURL(fileURLWithPath: urlPath)
            
            self.avPlayer = AVPlayer(url: movieUrl as URL)
            self.avPlayerViewController.player = self.avPlayer
            
            
        }
        
        self.present(avPlayerViewController, animated: true) {
            self.avPlayerViewController.player!.play()
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate
        userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }
    
    @IBAction func zoomIn(_ sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 2000, 2000)
        
        mapView.setRegion(region, animated: true)
    }
    
}

