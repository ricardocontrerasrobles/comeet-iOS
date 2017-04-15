//
//  MainMenuViewModel.swift
//  comeet
//
//  Created by stephen chang on 3/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//


import Foundation
import SSCalendar

class MainMenuViewModel : BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    let persistor: PersistorProtocol
    var selectedDate = Date()
    var reloadBinding: ReloadBinding?
    private var meetings: [Meeting] = []
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, persistor: PersistorProtocol) {
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.persistor = persistor
    }
    
    func fetchMeetings() {
        let start = ""
        print(start)
        let end = ""
        
        
        
        fetcher.getMeetings(organization: authenticator.getOrganization(), user: "", start: start, end: end) { [weak self] (meetings: [Meeting]?, error: Error?) in
            if let meetings = meetings {
                
                /*
                for me in meetings{
                    print(me.subject)
                    print(me.body)
                    print(me.location)
                    print(me.start?.displayString())
                    print(me.end?.displayString())
                }*/
                
                self?.meetings = meetings
                self?.reloadBinding?()
            }
        }
    }
    
    func title() -> String {
        return ""
    }
    
    func logout() {
        authenticator.logout()
        persistor.save(metroArea: nil)
    }
    
    func events() -> [SSEvent] {
        return meetings.map { MainMenuViewModel.eventFrom(meeting: $0) }
    }
}

private extension MainMenuViewModel {
    static func eventFrom(meeting: Meeting) -> SSEvent {
        let event = SSEvent()
        
        event.startDate = meeting.start
        event.startTime = meeting.start?.displayStringHourMinute()
        event.endTime = meeting.end?.displayStringHourMinute()
        event.name = meeting.subject
        return event
    }
}
