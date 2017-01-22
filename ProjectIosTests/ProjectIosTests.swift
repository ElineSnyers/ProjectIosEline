import XCTest
@testable import ProjectIos
class ProjectIosJSONTests: XCTestCase {
    
    func testValid() {
        let json: [String: Any] = [
            "cityname": "London",
            "cityphoto": "London",
            "attractions":
                [["name": "London Eye",
                    "photo": "Eye",
                    "description": "This is a fairywheel",
                    "latitute": 51.503399,
                    "longitude": -0.119519
                ]]
            
        ]
        guard let city = try? City(json: json) else {
            XCTFail("Unexpected error")
            return
        }
        
        XCTAssertEqual(city.name, "London")
        XCTAssertEqual(city.attractions[0].name, "London Eye")
        XCTAssertEqual(city.photo, "London")
        XCTAssertEqual(city.attractions[0].description, "This is a fairywheel")
        XCTAssertEqual(city.attractions[0].location.latitude, 51.503399)
        XCTAssertEqual(city.attractions[0].location.longitude, -0.119519)
        XCTAssertEqual(city.attractions[0].photo, "Eye")
    }
    
   
    
    func testMissingDescription() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions":
                [ ["name": "London Eye",
                   "photo": "Eye",
                   "latitute": 51.503399,
                   "longitude": -0.119519 ]
            ],
            "cityphoto": "London"
        ]
        
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "description") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    
    func testNonStringDescription() {
                let json: [String: Any] = [
        "cityname": "Londen",
        "attractions":
        [ ["name": "London Eye",
        "photo": "Eye",
        "description": 5,
        "latitute": 51.503399,
        "longitude": -0.119519 ]
        ],
        "cityphoto": "London"
        ]
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "description") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    
    func testMissingLatitude() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions":
                [ ["name": "London Eye",
                   "photo": "Eye",
                   "description": "This is a fairywheel",
                   
                   "longitude": -0.119519 ]
        ],
            "cityphoto": "London"
        ]
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "latitute") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    
    func testNonNumericLatitude() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions":
                [ ["name": "London Eye",
                   "photo": "Eye",
                   "description": "This is a fairywheel",
                   "latitute": "51.503399",
                   "longitude": -0.119519 ]
            ],
            "cityphoto": "London"
        ]
        
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "latitute") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    
    func testMissingLongitude() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions":
                [ ["name": "London Eye",
                   "photo": "Eye",
                   "description": "This is a fairywheel",
                   "latitute": 51.503399
                    ]
            ],
            "cityphoto": "London"
        ]
        
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "longitude") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    
    func testNonNumericLongitude() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions":
                [ ["name": "London Eye",
                   "photo": "Eye",
                   "description": "This is a fairywheel",
                   "latitute": 51.503399,
                   "longitude": "-0.119519" ]
            ],
            "cityphoto": "London"
        ]
        
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "longitude") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    
    func testMissingCityName() {
        let json: [String: Any] = [
            
            "attractions":
                [ ["name": "London Eye",
                   "photo": "Eye",
                   "description": "This is a fairywheel",
                   "latitute": 51.503399,
                   "longitude": -0.119519 ]
            ],
            "cityphoto": "London"
        ]
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "cityname") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    func testNonStringCityName() {
        let json: [String: Any] = [
            "cityname": 3,
            "attractions":
                [ ["name": "London Eye",
                   "photo": "Eye",
                   "description": "This is a fairywheel",
                   "latitute": 51.503399,
                   "longitude": -0.119519 ]
            ],
            "cityphoto": "London"
        ]
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "cityname") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    
    func testNonDictionaryAttractions() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions":
                [ [
                    "London Eye",
                   "Eye",
                    "This is a fairywheel",
                    51.503399,
                   -0.119519 ]
            ],
            "cityphoto": "London"
        ]
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "attractions") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    
    func testMissingCityPhoto() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions":
                [ ["name": "London Eye",
                   "photo": "Eye",
                   "description": "This is a fairywheel",
                   "latitute": 51.503399,
                   "longitude": -0.119519 ]
            ],
            
        ]
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "cityphoto") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    
    func testNonStringCityPhoto() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions" :
                [ ["name": "London Eye",
                   "photo": "Eye",
                   "description": "This is a fairywheel",
                   "latitute": 51.503399,
                   "longitude": -0.119519 ]
            ],
            "cityphoto": 4
        ]
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "cityphoto") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    
    func testMissingName() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions":
                [ [
                   "photo": "Eye",
                   "description": "This is a fairywheel",
                   "latitute": 51.503399,
                   "longitude": -0.119519 ]
            ],
            "cityphoto": "London"
        ]
        
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "name") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    func testNonStringAttractionName() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions":
                [ ["name": 3,
                   "photo": "Eye",
                   "description": "This is a fairywheel",
                   "latitute": 51.503399,
                   "longitude": -0.119519 ]
            ],
            "cityphoto": "London"
        ]
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "name") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    func testMissingPhoto() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions" :
                [ [
                    "name": "London Eye",
                    "description": "This is a fairywheel",
                    "latitute": 51.503399,
                    "longitude": -0.119519 ]
            ],
            "cityphoto": "London"
        ]
        
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "photo") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }
    func testNonStringPhoto() {
        let json: [String: Any] = [
            "cityname": "Londen",
            "attractions" :
                [ ["name": "London Eye",
                   "photo": 3,
                   "description": "This is a fairywheel",
                   "latitute": 51.503399,
                   "longitude": -0.119519 ]
            ],
            "cityphoto": "London"
        ]
        XCTAssertThrowsError(_ = try City(json: json)) {
            error in
            guard case Service.Error.missingJsonProperty(name: "photo") = error else {
                XCTFail("Unexpected error \(error)")
                return
            }
        }
    }

}
