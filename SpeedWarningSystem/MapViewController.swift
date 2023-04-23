//
//  MapViewController.swift
//  SpeedWarningSystem
//
//  Created by Yavuz Ulgar on 21.04.2023.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var warningImageview: UIImageView!
    @IBOutlet weak var choosenSpeedLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var choosenView: UIView!
    
    var player : AVAudioPlayer!
    var locationManager = CLLocationManager()
    var lastSpeed = Int()
    var choosenSpeed: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        warningImageview.isHidden = true
        choosenSpeedLabel.text = choosenSpeed
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        warningVoice()
        
    }
    
    private func setViews() {
        footerView.layer.cornerRadius = 25
        footerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        speedView.layer.cornerRadius = 25
        warningView.layer.cornerRadius = 25
        choosenView.layer.cornerRadius = 25
        warningImageview.layer.cornerRadius = 25
    }
    
    private func warningVoice() {
        guard let url = Bundle.main.url(forResource: "funnyVoiceAlert", withExtension: "m4a") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation: CLLocation = locations[locations.count - 1]
        let location = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        lastSpeed = Int(lastLocation.speed)
        speedLabel.text = String(lastSpeed)
        
        if let choosenSpeed = choosenSpeed {
            if lastSpeed > Int(choosenSpeed) ?? 30 {
                player?.play()
                if (player?.isPlaying ?? true) {
                    warningImageview.isHidden = false
                    warningView.backgroundColor = .white
                    player?.play()
                    self.speedView.backgroundColor = UIColor.red
                }
            } else {
                warningImageview.isHidden = true
                warningView.backgroundColor = .clear
                player?.stop()
                self.speedView.backgroundColor = UIColor.green
            }
        }
    }
}
