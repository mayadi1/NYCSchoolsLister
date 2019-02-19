//
//  ApiManager.swift
//  NYCSchoolsLister
//
//  Created by Mohamed Ayadi on 2/18/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//

import UIKit
import Alamofire

/// Manage the api request and return the result or error in callback
class ApiManager {
    
    /// Base url of Api
    static let baseUrl = "https://data.cityofnewyork.us/resource/"
    
    /// Relative url of school api to fetch all the schools
    static let schoolUrl = baseUrl + "97mf-9njv.json"
    
    /// Relative url of scroes api to fetch all the schools' scores
    static let scoreUrl =  baseUrl + "734v-jeq5.json"
    
    /// AccessToken is not using in this application. But for larger app it set and use in headers
    static var accessToken: String = ""
    
    /// Requests the all school information from school api. On the sucess it try to parse json
    /// into proper School model (sorted by name) and finally callback to either array of school or error
    ///
    /// - Parameter callback: Its contain either array of school model means everything is
    ///                       sucess or error means its fails either in requesting or parsing
    static func requestSchools(_ callback: @escaping ([School]?, Error?) -> Void) {
        Alamofire.request(ApiManager.schoolUrl, method: .get).responseData(completionHandler: { (response) in
            switch response.result {
            case .failure(let error): callback(nil, error)
            case .success(let data):
                if var schools = try? JSONDecoder().decode([School].self, from: data) {
                    schools.sort(by: { $0.name < $1.name })
                    callback(schools, nil)
                } else {
                    callback(nil, NSError(domain: "Parsing", code: -1, userInfo: [NSLocalizedDescriptionKey : "Unable to Parse"]))
                }
            }
        })
    }
    
    /// Update the all schools' score from score api. On the sucess it try to parse json
    /// into proper Scorem model and map into given school array. Finally it callback to
    /// either array of school which have score or error
    ///
    /// - Parameter callback: Its contain either array of school model with updated score
    ///                       or error means its fails either in requesting or parsing
    static func updateScores(schools: [School], _ callback: @escaping ([School]?, Error?) -> Void) {
        Alamofire.request(ApiManager.scoreUrl, method: .get).responseData(completionHandler: { (response) in
            switch response.result {
            case .failure(let error): callback(nil, error)
            case .success(let data):
                if let scores = try? JSONDecoder().decode([Score].self, from: data) {
                    for school in schools {
                        if let score = scores.first(where: { $0.schoolId == school.schoolId }) {
                            school.score = score
                        }
                    }
                    
                    callback(schools, nil)
                } else {
                    callback(nil, NSError(domain: "Parsing", code: -1, userInfo: [NSLocalizedDescriptionKey : "Unable to Parse"]))
                }
            }
        })
    }
    
}
