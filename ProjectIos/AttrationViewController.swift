import UIKit
import MapKit

class AttractionViewController: UITableViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var directions: UITextView!
    
    
    var attraction: Attraction!
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        title = attraction.name
        descriptionView.text! = attraction.description
        descriptionView.isScrollEnabled = false
       
        image.image = UIImage(named:attraction.photo)!
        mapView.delegate = self
        
       mapView.region = MKCoordinateRegion(center: attraction.location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
       
        let pin = MKPointAnnotation()
        pin.title = attraction.name
        pin.coordinate = attraction.location
        mapView.addAnnotation(pin)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
          locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
           locationManager.requestLocation()
           
        }
        
       
    
       
    }
  
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        _ = locations[0]
       
        
        
        
    }
    
    @IBAction func showDirections(sender: AnyObject) {
        
       
        let request = MKDirectionsRequest()
       
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: attraction.location,addressDictionary: nil))
        let sourceAnnotation = MKPointAnnotation()
                sourceAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceAnnotation.coordinate, addressDictionary: nil)
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        let pin = MKPointAnnotation()
        pin.title = attraction.name
        pin.coordinate = attraction.location
    
        
        let pinPlacemark = MKPlacemark(coordinate: pin.coordinate, addressDictionary: nil)
        if let location = pinPlacemark.location {
            pin.coordinate = location.coordinate
        }
       self.mapView.showAnnotations([sourceAnnotation,pin], animated: true)
                request.requestsAlternateRoutes = false
        
        let direction = MKDirections(request: request)
        request.transportType = .any
           direction.calculate { [unowned self] response,error in
             guard let unwappedResponse = response else {
                 return
             }
             if (unwappedResponse.routes.count > 0) {
               self.mapView.add(unwappedResponse.routes[0].polyline)
             self.mapView.setVisibleMapRect(unwappedResponse.routes[0].polyline.boundingMapRect, animated: true)
            self.showRoute(unwappedResponse)
              }

                       }

    }

func showRoute(_ response: MKDirectionsResponse) {
    
    for route in response.routes {
        mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
        let rect = route.polyline.boundingMapRect
        self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        var text: String = ""
        for step in route.steps {
            
            text += step.instructions + "\n"
           directions.text = text
            print(step.instructions)
        }
    }

    
}
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

func mapView(_ mapView: MKMapView, rendererFor
    overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    
    renderer.strokeColor = UIColor.blue
    renderer.lineWidth = 5.0
    return renderer
}
    
  
        
    }
    


