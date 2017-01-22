

import Foundation
class City{
    
    let name: String
    let attractions: [Attraction]
    let photo: String
    
    
    
    init(name: String, attractions: [Attraction],photo: String) {
        self.name = name
        self.attractions = attractions
        self.photo = photo
        
    }
    
  

}
extension City {
    
    convenience init(json: [String: Any]) throws {
        guard let cityname = json["cityname"] as? String else {
            throw Service.Error.missingJsonProperty(name: "cityname")
        }
        guard let cityphoto = json["cityphoto"] as? String else {
            throw Service.Error.missingJsonProperty(name: "cityphoto")
        }
        
        guard let attractions = json["attractions"] as? [[String: Any]] else {
            throw Service.Error.missingJsonProperty(name: "attractions")
        }
        
        var attraction: [Attraction] = []
        for attr in attractions {
            guard (attr["name"] as? String) != nil else {
                throw Service.Error.missingJsonProperty(name: "name")
            }
            guard (attr["description"] as? String) != nil else {
                throw Service.Error.missingJsonProperty(name: "description")
            }
            guard (attr["photo"] as? String) != nil else {
                throw Service.Error.missingJsonProperty(name: "photo")
            }
            guard (attr["latitute"] as? Double) != nil else {
                throw Service.Error.missingJsonProperty(name: "latitute")
            }
            guard (attr["longitude"] as? Double) != nil else {
                throw Service.Error.missingJsonProperty(name: "longitude")
            }
            
        attraction.append(Attraction(name: attr["name"] as! String, photo: attr["photo"] as! String, description: attr["description"] as! String, latitute: attr["latitute"] as! Double, longitude:attr["longitude"] as! Double ))
        }
      self.init(name: cityname, attractions: attraction,photo: cityphoto)
      
    

        
        
        
        
    }


}
