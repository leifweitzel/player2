//
//  ViewController.swift
//  player2
//
//  Created by Leif Weitzel on 21.05.17.
//  Copyright © 2017 Leif Weitzel. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    override var prefersStatusBarHidden: Bool { return true }

    
    @IBOutlet weak var bgNoLogo: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    let avPlayerViewController = AVPlayerViewController()
    var avPlayer:AVPlayer?
    
    @IBOutlet weak var sprachSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background audio
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        //done

        
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.032002723592484, longitude: 11.273583825677633)
        annotation.title = "Start DTour"
        
        mapView.addAnnotation(annotation)
        mapView.showsUserLocation = true

       // print (userDistance(from: annotation) ?? 1)
        
        /*
        /// Returns the distance (in meters) from the
        /// user's location to the specified point.
        
        func userDistance(from point: MKPointAnnotation) -> Double? {
            guard case location.coordinate = location.coordinate else {
                return nil // User location unknown!
            }
            let pointLocation = CLLocation(
                latitude:  51.0215077,
                longitude: 11.2492387
            )
            return userLocation.distance(from: pointLocation)
            print(userLocation.distance(from: pointLocation))
        }
        */
        
        
        
        userDistance(from: annotation)
        
        print (userDistance)

        
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
                
        let place = MKPlacemark(coordinate: annotation.coordinate)
        
        let destination = MKMapItem(placemark: place)
        
        
        request.destination = destination
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error getting directions")
            } else {
                self.showRoute(response!)
            }
        })
        
        
        
        
    }
    
    /////////////////////////////////////////////
    
    
    // draw route

    func showRoute(_ response: MKDirectionsResponse) {
        
        for route in response.routes {
            
            mapView.add(route.polyline,
                         level: MKOverlayLevel.aboveRoads)
            for step in route.steps {
                print(step.instructions)
                
            let rect = route.polyline.boundingMapRect
                
            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsetsMake(50, 50, 50, 50), animated: true)
                
            }
        }
    }
 
    
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 61/255, green: 104/255, blue: 114/255, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
   
    // done
    
    
    func userDistance(from point: MKPointAnnotation) -> Double? {
        guard let userLocation = mapView.userLocation.location else {
            print("Error getting distance")
            return nil // User location unknown!
        }
        let pointLocation = CLLocation(
            latitude:  point.coordinate.latitude,
            longitude: point.coordinate.longitude
        )
        print(userLocation.distance(from: pointLocation))

        return userLocation.distance(from: pointLocation)
        
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        
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
        
        avPlayerViewController.contentOverlayView?.backgroundColor = UIColor(red: 61/255, green: 104/255, blue: 114/255, alpha: 1)

//        avPlayerViewController.contentOverlayView?.addSubview(UIImageView)

    }
    
}

