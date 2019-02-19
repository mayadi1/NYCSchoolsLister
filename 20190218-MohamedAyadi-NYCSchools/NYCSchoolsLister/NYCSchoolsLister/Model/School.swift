//
//  School.swift
//  NYCSchoolsLister
//
//  Created by Mohamed Ayadi on 2/18/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//

import UIKit

/// School model which contains all the related information about school
@objcMembers
class School: NSObject, Codable {
    
    var schoolId: String = ""
    var name: String = ""
    var overview: String = ""
    var email: String = ""
    var phone: String = ""
    var website: String = ""
    var address: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var score: Score? = nil
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // try to decode school id. If its not valid then throw exception
        schoolId = try values.decode(String.self, forKey: .schoolId)
        
        // try to decode other values. If its not valid then set with default values
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        overview = (try? values.decode(String.self, forKey: .overview)) ?? ""
        email = (try? values.decode(String.self, forKey: .email)) ?? ""
        phone = (try? values.decode(String.self, forKey: .phone)) ?? ""
        website = (try? values.decode(String.self, forKey: .website)) ?? ""
        address = (try? values.decode(String.self, forKey: .address)) ?? ""
        latitude = Double((try? values.decode(String.self, forKey: .latitude)) ?? "") ?? 0.0
        longitude = Double((try? values.decode(String.self, forKey: .longitude)) ?? "") ?? 0.0
    }

    /// Coding keys with respect to define in APIs
    private enum CodingKeys: String, CodingKey {
        case schoolId = "dbn"
        case name = "school_name"
        case overview = "overview_paragraph"
        case email = "school_email"
        case phone = "phone_number"
        case website = "website"
        case address = "location"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
