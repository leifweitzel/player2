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

var languageSelected = 2

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
//    override var prefersStatusBarHidden: Bool { return true }

    
    
    @IBOutlet weak var startTextField: UILabel!
    @IBOutlet weak var welcomeTextField: UILabel!
    @IBOutlet weak var bgNoLogo: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButton: UIButton!
    
    var popupNaviTitel = ""
    var popupNaviUntertitel = ""
    var popupWarnungTitel = ""
    var popUpWarnungUntertitel = ""
    var locationWarnungTitel = ""
    var locationWarnungUntertitel = ""
    
    let entfernungsLimit = 50
    
    let leichtBlau : UIColor = UIColor(hue: 197, saturation: 94, brightness: 80, alpha: 1)
    let dunkelGrau : UIColor = UIColor(hue: 240, saturation: 2, brightness: 23, alpha: 1)

    
    let avPlayerViewController = AVPlayerViewController()
    var avPlayer:AVPlayer?

    
    @IBOutlet weak var sprachSwitch: UISegmentedControl!
    
    let coords = CLLocationCoordinate2DMake(51.032002723592484, 11.273583825677633)
    
    var startButtonAllowed : Bool = false
    let annotation = MKPointAnnotation()

    let locationManager = CLLocationManager()

    ////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Use users current location if no starting point set
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse
                || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
                locationManager.startUpdatingLocation()
            }
            else{
                locationManager.requestWhenInUseAuthorization()
            }
        }
        else{
            let locAlert = UIAlertController(title: locationWarnungTitel, message: locationWarnungUntertitel, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.present(locAlert, animated: true, completion: nil)
                
            })
            
            locAlert.addAction(restartAction)
            
            present(locAlert, animated: true, completion: nil)        }
//        end
        
        toGerman()
        
        startButton.setTitleColor(UIColor .gray, for: .disabled)
        
        mapView.delegate = self
        
        
        annotation.coordinate = coords
        annotation.title = "Start DTour"
        
        mapView.addAnnotation(annotation)
        mapView.showsUserLocation = true
        
        
        
    }
    
    /////////////////////////////////////////////

   

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            
            if (annotationTitle! == "Start DTour") {
                
               let navAlert = UIAlertController(title: popupNaviTitel, message: popupNaviUntertitel, preferredStyle: .alert)
                
                let aMapsNav = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    
                    /////////////// open Maps
//
                    let place = MKPlacemark(coordinate: self.coords)

                    let mapItem = MKMapItem(placemark: place)

                    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: launchOptions)
                    
                    /////////////// Endeopen Maps

                    
                })
                let abbrechenButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                    
                })
                
                navAlert.addAction(abbrechenButton)
                navAlert.addAction(aMapsNav)

                
                present(navAlert, animated: true, completion: nil)
            }
            
        }
    }
    
    /////////////////////////////////////////////
    
    func calculateDistance() {

        var distanceNew = mapView.userLocation.location? .distance(from: CLLocation(latitude:  51.032002723592484, longitude: 11.273583825677633))
        
        print ("Entfernung: \(distanceNew ?? 1)")
        
        //     Startbutton tippbar
        
        if(Int(distanceNew!)) <= entfernungsLimit{
            startButton.isEnabled = true

            startButton.setTitleColor(UIColor .red, for: .normal)
            startButtonAllowed = true
                   }
        else {
            startButton.isEnabled = true

            startButton.setTitleColor(UIColor .gray, for: .normal)

        }
        
//         done
        
    }
    
    // draw route

    func showRoute(_ response: MKDirectionsResponse) {
        
        for route in response.routes {
            
            mapView.add(route.polyline,
                         level: MKOverlayLevel.aboveRoads)
//            for step in route.steps {
//                print(step.instructions)
                
            let rect = route.polyline.boundingMapRect
                
            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsetsMake(50, 50, 50, 50), animated: true)
                
//            }
//            Distanz errechnen
            calculateDistance()
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
    
    func toEnglish() {
        languageSelected = 1
        
        welcomeTextField.text = "WELCOME"
        startTextField.text = "Start the tour at the red pin"
        
        popupNaviTitel = "Open Maps"
        popupNaviUntertitel = "Navigate to Pin"
        popupWarnungTitel = "Please get closer to the starting point"
        popUpWarnungUntertitel = "You can start the walk there"
        locationWarnungTitel = "In order to use the app you have to enable Location Services"
        locationWarnungUntertitel = "Go to your phone's settings to enable Location Services"
    }
    
    func toGerman() {
        
        languageSelected = 2
        
        welcomeTextField.text = "WILLKOMMEN"
        startTextField.text = "Beginnen Sie an der roten Nadel"
        
        popupNaviTitel = "Maps öffnen"
        popupNaviUntertitel = "Zur Nadel Navigieren"
        popupWarnungTitel = "Bitte nähern Sie sich dem Startpunkt"
        popUpWarnungUntertitel = "Dort können Sie den walk beginnen"
        locationWarnungTitel = "Um die App zu nutzen müssen Sie die Ortung aktivieren"
        locationWarnungUntertitel = "Öffnen Sie die Einstellungen Ihres iPhones, um Location Services zu aktivieren"
        
        
    }
    

    @IBAction func sprachSwitchPressed(_ sender: UISegmentedControl) {
        
        if(sprachSwitch.selectedSegmentIndex == 1){
            
            toEnglish()
            
        }
        
        else {
            
            toGerman()
            
        }
        
        
    }
    

    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        if (startButtonAllowed == false) {
            
            
            let alert = UIAlertController(title: popupWarnungTitel, message: popUpWarnungUntertitel, preferredStyle: .alert)
                
                let restartAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    //                present(navAlert, animated: true, completion: nil)
                    
                })
                
                alert.addAction(restartAction)
                
                present(alert, animated: true, completion: nil)
            
            
            }
            
        
        else {
        
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

        
        let urlPathString:String? = Bundle.main.path(forResource: "Song\(sprachSwitch.selectedSegmentIndex)", ofType: "mp3")


        
        if let urlPath = urlPathString
        {
            let movieUrl = NSURL(fileURLWithPath: urlPath) //lokale datei
//            let movieUrl = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4") --- stream
            
            
           self.avPlayer = AVPlayer(url: movieUrl as URL) //lokale datei
//            self.avPlayer = AVPlayer(url: movieUrl!) --- stream

            self.avPlayerViewController.player = self.avPlayer
//            avPlayerViewController.contentOverlayView!.addSubview(bgNoLogo)

            
            //    NEU
//            NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avPlayer?.currentItem)
//            if #available(iOS 11.0, *) {
//                NotificationCenter.defaultCenter.addObserver(self, selector: "donePlaying:", name: AVPlayeritemdidplaytoendtime, object: nil)
//            } else {
//                // Fallback on earlier versions
//            }

            
        }
        
        self.present(avPlayerViewController, animated: true) {
           
            self.avPlayerViewController.player!.play()
        }
            

            
      avPlayerViewController.contentOverlayView?.backgroundColor = UIColor.black
            
            


    }
    }
    
//    func playerDidFinishPlaying(note: NSNotification) {
//        print("DONE PLAYING")
//    }
//
    func donePlaying(notification:NSNotification) {
        //Dismiss AVPlayerViewController
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        

        
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        
        let place = MKPlacemark(coordinate: coords)
        
        
        let destination = MKMapItem(placemark: place)
        
        
        request.destination = destination
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error getting directions")
            } else {
                self.mapView.removeOverlays(self.mapView.overlays)

                self.showRoute(response!)
            }
        })
    }
    
    
}

