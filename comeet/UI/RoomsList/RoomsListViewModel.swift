//
//  RoomsListViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class RoomsListViewModel : BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    let persistor: PersistorProtocol
    var reloadBinding: ReloadBinding?
    internal let selectedDate: Date
    private var metroarea: String?
    private(set) var roomsList: User?
    internal var rooms: [Room] = []
    internal var startDate : Date
    internal var endDate : Date
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, persistor: PersistorProtocol, selectedDate: Date, metroarea: String?, roomsList: User?) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        self.persistor = persistor
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.selectedDate = selectedDate
        self.startDate = selectedDate
        self.endDate = selectedDate
    }
    
    struct Constants {
        static let startDateText = "Select Start"
        static let endDateText = "Select End"
    }
    
    func newLocation(metroarea: String?, roomsList: User?) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        fetchRooms()
    }
    
    func title() -> String {
        guard let name = roomsList?.name else {
            return "Select a Room"
        }
        return "Rooms in " + name
    }
    
    func startDateString() -> String {
        return startDate.displayString()
    }
    
    func endDateString() -> String {
        return endDate.displayString()
    }
    
    func fetchRooms() {
        guard let email = roomsList?.email else {
            return
        }
        fetcher.getRooms(organization: authenticator.getOrganization(), roomlist: email, start: startDateForRequest(), end: endDateForRequest()) { [weak self] (rooms, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let rooms = rooms {
                DispatchQueue.main.async {
                    self?.rooms = rooms
                    self?.reloadBinding?()
                }
            } else {
                print("fetcher.getRooms returned nil")
            }
        }
    }
    
    func roomsCount() -> Int {
        return availableRooms().count
    }
    
    func roomName(index: Int) -> String {
        guard availableRooms().count > index else {
            return ""
        }
        let room = availableRooms()[index]
        return room.name
    }
    
    func roomDescription(index: Int) -> String {
        guard availableRooms().count > index else {
            return ""
        }
        let room = availableRooms()[index]
        if let capacity = room.capacity {
            return "Capacity: \(capacity)"
        }
        return room.email
    }
    
    func roomPicture(index: Int) -> URL? {
        guard availableRooms().count > index else {
            return nil
        }
        guard let picture = availableRooms()[index].picture else {
            return nil
        }
        return URL(string: picture)
    }
    
    func room(index: Int) -> Room? {
        guard availableRooms().count > index else {
            return nil
        }
        return availableRooms()[index]
    }
    
    func start(hours: Int, minutes: Int) {
        startDate = dateFrom(hours: hours, minutes: minutes)
        reloadBinding?()
    }
    
    func end(hours: Int, minutes: Int) {
        endDate = dateFrom(hours: hours, minutes: minutes)
        reloadBinding?()
    }
    
    func locationPersisted() -> Bool {
        if let metroarea = persistor.getMetroArea(),
            let roomlist = persistor.getRoomlist() {
            Router.selectedMetroarea = metroarea
            Router.selectedRoomsList = roomlist
            newLocation(metroarea: metroarea, roomsList: roomlist)
            return true
        } else {
            return false
        }
    }
}

private extension RoomsListViewModel {
    
    func startDateForRequest() -> String {
        let start = selectedDate.startOfDay()
        return start.stringForAPI()
    }
    
    func endDateForRequest() -> String {
        guard let end = selectedDate.endOfDay() else {
            return selectedDate.stringForAPI()
        }
        return end.stringForAPI()
    }
    
    func dateFrom(hours: Int, minutes: Int) -> Date {
        var components = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        components.hour = hours
        components.minute = minutes
        return NSCalendar.current.date(from: components) ?? selectedDate
    }
    
    func availableRooms() -> [Room] {
              return rooms
        // TODO: Correct filter criteria
//        return rooms.filter({ (room) -> Bool in
//            guard let freebusy = room.freebusy, freebusy.count > 0 else {
//                return true
//            }
//            return freebusy.containsFree(start: startDate, end: endDate)
//        })
    }
}
