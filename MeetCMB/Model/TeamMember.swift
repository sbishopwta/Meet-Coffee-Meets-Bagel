//
//  TeamMember.swift
//  MeetCMB
//
//  Created by Steven Bishop on 2/5/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

fileprivate enum Constants {
    static let avatar = "avatar"
    static let bio = "bio"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let jobTitle = "title"
    static let id = "id"
}

struct TeamMember {
    let avatarUrl: URL
    let bio: String
    let firstName: String
    let lastName: String
    let jobTitle: String
    let id: Int
    
    init(json: JSONObject) throws {
        guard let avatarUrlString = json[Constants.avatar] as? String else {
            throw SerializationError.missing(Constants.avatar)
        }
        
        guard let avatarUrl = URL(string: avatarUrlString) else {
            throw SerializationError.invalid("string could not be converted to a URL", avatarUrlString)
        }
        
        guard let bio = json[Constants.bio] as? String else {
            throw SerializationError.missing(Constants.bio)
        }
        
        guard let firstName = json[Constants.firstName] as? String else {
            throw SerializationError.missing(Constants.firstName)
        }
        
        guard let lastName = json[Constants.lastName] as? String else {
            throw SerializationError.missing(Constants.lastName)
        }
        
        guard let jobTitle = json[Constants.jobTitle] as? String else {
            throw SerializationError.missing(Constants.jobTitle)
        }
        
        guard let idString = json[Constants.id] as? String else {
            throw SerializationError.missing(Constants.id)
        }
        
        guard let id = Int(idString) else {
            throw SerializationError.invalid("could not convert id string to int", idString)
        }
        
        self.avatarUrl = avatarUrl
        self.bio = bio
        self.firstName = firstName
        self.lastName = lastName
        self.jobTitle = jobTitle
        self.id = id
    }
}
