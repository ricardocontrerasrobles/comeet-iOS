//
//  RoomDetailViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias BookRoomBinding = (Bool)-> Void

class RoomDetailViewModel :  BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    var bookRoomBinding: BookRoomBinding?
    let startDate: Date
    let endDate: Date
    private let metroarea: String
    private let roomsList: User
    private let room: Room
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, startDate: Date, endDate: Date, metroarea: String, roomsList: User, room: Room) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        self.room = room
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func bookRoom(subject: String?, body: String?) {
        let finalSubject = subject ?? ""
        let finalBody = body ?? ""
        let requiredAtendees = room.email
        let optionalAttendees = ""
        let params = fetcher.bookRoomParams(start: startDate.stringForAPI(), end: endDate.stringForAPI(), subject: finalSubject, body: finalBody, requiredAttendees: requiredAtendees, optionalAttendees: optionalAttendees)
        
        fetcher.bookRoom(organization: authenticator.getOrganization(), roomrecipient: room.email, params: params) { [weak self] (succes: Bool, error: Error?) in
            self?.bookRoomBinding?(succes)
        }
    }
    
    func title() -> String {
        return "Selected Room"
    }
    
    func roomname() -> String {
        return room.name
    }
    
    func roomPicture() -> URL? {
        guard let picture = room.picture else {
            return nil
        }
        return URL(string: picture)
    }
    
    func roomAddress() -> String {
        let address = room.address ?? ""
        return metroarea + "\n" + address
    }
    
    func roomAmenities() -> String {
        
        var amenitiesString = ""
        
        if let capacity = room.capacity {
            amenitiesString = "Capacity: \(capacity)"
        }
        
        if let amenities = room.amenities {
            for amenity in amenities {
                amenitiesString = amenitiesString + "\n\n" + "\(amenity.name): \(amenity.description)"
            }
        }

        return amenitiesString
    }
    
    func roomBookText() -> String {
        return "Book \(startDate.displayStringDate()) \(startDate.displayStringHourMinute())-\(endDate.displayStringHourMinute())"
    }
}
