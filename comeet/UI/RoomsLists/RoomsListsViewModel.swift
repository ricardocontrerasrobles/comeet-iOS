//
//  RoomsListsViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class RoomsListsViewModel : BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    let persistor: PersistorProtocol
    private let metroarea: String
    private let roomsLists: [User]
    let selectedDate: Date
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, selectedDate: Date, metroarea: String, roomsLists: [User], persistor: PersistorProtocol) {
        self.metroarea = metroarea
        self.roomsLists = roomsLists
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.selectedDate = selectedDate
        self.persistor = persistor
    }
    
    func title() -> String {
        return "Locations in " + metroarea
    }
    
    func roomsListsCount() -> Int {
        return roomsLists.count
    }
    
    func roomsListName(index: Int) -> String {
        guard roomsLists.count > index else {
            return ""
        }
        return roomsLists[index].name
    }
    
    func roomsList(index: Int) -> User {
        return roomsLists[index]
    }
    
    func getMetroarea() -> String {
        return metroarea
    }
    
    func save(roomlist: User) {
        persistor.save(roomlist: roomlist)
    }
}
