

import CoreLocation
class Attraction {
    let name: String
    let photo: String
    let description: String
    let location: CLLocationCoordinate2D
    
    init(name: String, photo:String, description: String, latitute: Double, longitude: Double ) {
    
        self.name = name
        self.photo = photo
       self.description = description
        self.location = CLLocationCoordinate2DMake(CLLocationDegrees(latitute), CLLocationDegrees(longitude))
        
    }

    
    
}
