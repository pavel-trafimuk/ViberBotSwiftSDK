//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation

//extension URLRequest {
//    mutating func applyBasicAuth(_ username: String, password: String) {
//        let loginString = String(format: "%@:%@", username, password)
//        let loginData = loginString.data(using: String.Encoding.utf8)!
//        let base64LoginString = loginData.base64EncodedString()
//        setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
//    }
//    
//    mutating func applyJSONAsBody<T: Codable>(_ model: T, verbose: Int = 0) throws {
//        let modelData = try JSONEncoder().encode(model)
//        if verbose > 0 {
//            if let string = String(data: modelData, encoding: .utf8) {
//                print("jsonBody: \(string)")
//            }
//        }
//        addValue("application/json", forHTTPHeaderField: "Content-Type")
//        addValue("application/json", forHTTPHeaderField: "Accept")
//        httpBody = modelData
//    }
//}
