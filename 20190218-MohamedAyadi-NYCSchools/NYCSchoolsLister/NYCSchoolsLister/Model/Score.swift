//
//  Score.swift
//  NYCSchoolsLister
//
//  Created by Mohamed Ayadi on 2/18/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//

import UIKit

@objcMembers
class Score: NSObject, Codable {
    var schoolId: String = ""
    var math: String = ""
    var reading: String = ""
    var writing: String = ""
    var numberOfTestTakers: String = ""
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // try to decode school id. If its not valid then throw exception
        schoolId = try values.decode(String.self, forKey: .schoolId)
        
        // try to decode other values. If its not valid then set with default values
        math = (try? values.decode(String.self, forKey: .math)) ?? ""
        reading = (try? values.decode(String.self, forKey: .reading)) ?? ""
        writing = (try? values.decode(String.self, forKey: .writing)) ?? ""
        numberOfTestTakers = (try? values.decode(String.self, forKey: .numberOfTestTakers)) ?? ""
    }

    /// Coding keys with respect to define in APIs
    private enum CodingKeys: String, CodingKey {
        case schoolId = "dbn"
        case math = "sat_math_avg_score"
        case reading = "sat_critical_reading_avg_score"
        case writing = "sat_writing_avg_score"
        case numberOfTestTakers = "num_of_sat_test_takers"
    }

}
