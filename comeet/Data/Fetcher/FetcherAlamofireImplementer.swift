//
//  FetcherAlamofireImplementer.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import Alamofire

class FetcherAlamofireImplementer : FetcherProtocol {
    
    private let sessionManager = SessionManager()
    private var endpoints = Endpoints(environment: .Mocked)
    
    func set(environment: Environment) {
        endpoints = Endpoints(environment: environment)
    }
    
    func set(accessToken: String, type: AuthType) {
        sessionManager.adapter = AlamofireAccessTokenAdapter(accessToken: accessToken, type: type)
    }
    
    func getSearchCriteria(organization: String, completion:@escaping FetchSearchCriteriaCompletion) {
        sessionManager.request(endpoints.getSeatchCriteria(organization: organization)).responseJSON { (response) in
            var searchCriteria: [SearchCriteria]?
            if let array = FetcherAlamofireImplementer.getArray(response: response) {
                searchCriteria = SearchCriteriaParser.parseSearchCriteria(searchCriteriaArray: array)
            }
            completion(searchCriteria, response.error)
        }
    }
    
    func getRooms(organization: String, roomlist: String, start: String, end: String, completion:@escaping FetchRoomsCompletion) {
        sessionManager.request(endpoints.getRooms(organization: organization, roomlist: roomlist, start: start, end: end)).responseJSON { (response) in
            var rooms: [Room]?
            if let array = FetcherAlamofireImplementer.getArray(response: response) {
                rooms = RoomParser.parseRooms(roomsArray: array)
            }
            completion(rooms, response.error)
        }
    }
    
    func bookRoom(organization: String, roomrecipient: String, params: [String: Any], completion:@escaping BookRoomCompletion) {
        let endpoint = endpoints.bookRoom(organization: organization, roomrecipient: roomrecipient)
        sessionManager.request(endpoint, method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { (response) in
            guard response.response?.statusCode == 200 else {
                completion(false, response.error)
                return;
            }
            completion(true, response.error)
        }
    }
    
    func bookRoomParams(start: String, end: String, subject: String, body: String, requiredAttendees: String, optionalAttendees:String) -> [String: Any] {
        let params: [String: Any] = ["start": start,
                                     "end": end,
                                     "subject": subject,
                                     "body": body,
                                     "required": requiredAttendees,
                                     "optional": optionalAttendees]
        return params
    }
    
    func getMeetings(organization: String, user: String, start: String, end: String, completion:@escaping FetchMeetingsCompletion) {
        let endpoint = endpoints.getMeetings(organization: organization, user: user, start: start, end: end)
        
                
        sessionManager.request(endpoint).responseJSON { (response) in
            
            var meetings: [Meeting]?
            if let array = FetcherAlamofireImplementer.getArray(response: response) {
                meetings = MeetingParser.parseMeetings(meetingsArray: array)
            }
            completion(meetings, response.error)
        }
    }
}

private extension FetcherAlamofireImplementer {
    
    static func getArray(response: DataResponse<Any>) -> [Any]? {
        guard let array = response.result.value as? [Any] else {
                return nil;
        }
        return array
    }
}
