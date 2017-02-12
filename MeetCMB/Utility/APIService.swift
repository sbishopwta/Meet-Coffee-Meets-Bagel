//
//  APIService.swift
//  MeetCMB
//
//  Created by Steven Bishop on 2/5/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

import Foundation
import os

typealias JSON = Any
typealias JSONArray = [JSON]
typealias JSONObject = [String: JSON]

class APIService {
    
    //TODO: Error handling
    class func parseTeam() -> [TeamMember]  {
        guard let teamUrlPath = Bundle.main.path(forResource: "team", ofType: "json") else {
            os_log("Unable to load team json resource from bundle", type: .error)
            return []
        }
        
        let url = URL(fileURLWithPath: teamUrlPath)
        guard let data = try? Data(contentsOf: url) else {
            os_log("Error while creating data from file path in %@", type: .error, #function)
            return []
        }
        
        let json = try? JSONSerialization.jsonObject(with: data)
        
        var configuredTeamMembers = [TeamMember]()
        
        if let teamMembers = json as? JSONArray {
            for memberJson in teamMembers {
                if let teamMemberDictionary = memberJson as? JSONObject, let teamMember = try? TeamMember(json: teamMemberDictionary) {
                    configuredTeamMembers.append(teamMember)
                }
            }
        }
        
        return configuredTeamMembers
    }
}
