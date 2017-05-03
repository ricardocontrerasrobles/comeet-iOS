//
//  MyAgendaViewModel.swift
//  comeet
//
//  Created by stephen chang on 3/28/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class MyAgendaViewModel : BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    let persistor: PersistorProtocol
    internal let loader = DataSimpleBridge.getLoader()
    var reloadBinding: ReloadBinding?
    internal var selectedDate: Date
    internal var testing = false
    internal var meetingsByDate: [Date:[Meeting]] = [:]
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, persistor: PersistorProtocol, selectedDate: Date) {
        self.persistor = persistor
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.selectedDate = selectedDate
    }
    
    struct Constants {
        static let loadingText = "Loading Meetings"
    }
    
    func change(date: Date) {
        selectedDate = date
    }
    
    func fetchMeetings() {
        let start = selectedDate.startOfDay().stringISO8601()
        let end = selectedDate.nextWeek()?.stringISO8601() ?? selectedDate.stringISO8601()
        
        fetcher.getMeetings(organization: authenticator.getOrganization(), user: "", start: start, end: end) { [weak self] (meetings: [Meeting]?, error: Error?) in
            
            guard error == nil else {
                // TODO: surface error in UI?
                print(error!)
                return
            }
            if let meetings = meetings {
                DispatchQueue.main.async {
                    self?.meetingsByDate = MyAgendaViewModel.createMeetingsByDate(meetings: meetings)
                    self?.reloadBinding?()
                }
            } else {
                print("fetcher.getRooms returned nil")
            }
        }
    }
    
    /// Whethere to show the guide graphic.
    var showGuide : Bool {
        get {
            let userDefault = UserDefaults.standard
            let isGuideShown = userDefault.bool(forKey: "isAgendaGuideShown")
            return !isGuideShown
        }
        set {
            let userDefault = UserDefaults.standard
            userDefault.set(newValue, forKey: "isAgendaGuideShown")
        }
    }
    
    func sectionsCount() -> Int {
        return meetingsByDate.keys.count
    }
    
    func selectedSection() -> Int? {
        let sortedDays = getSortedDays()
        return sortedDays.index(of: selectedDate.startOfDay())
    }
    
    func sectionTitle(section: Int) -> String? {
        if let sectionDate = dateFrom(section: section) {
            return sectionDate.displayStringDate()
        } else {
            return nil
        }
    }
    
    func meetingsCount(section: Int) -> Int {
        return getMeetings(section: section).count
    }
    
    func meetingSubject(section: Int, index: Int) -> String {
        let meetings = getMeetings(section: section)
        guard meetings.count > index else {
            return ""
        }
        let meeting = meetings[index]
        return meeting.subject
    }
    
    func meetingTime(section: Int, index: Int) -> String {
        let meetings = getMeetings(section: section)
        guard meetings.count > index else {
            return ""
        }
        let meeting = meetings[index]
        return "\(meeting.start.displayStringHourMinute()) - \(meeting.end.displayStringHourMinute())"
    }
    
    func meeting(section: Int, index: Int) -> Meeting? {
        let meetings = getMeetings(section: section)
        guard meetings.count > index else {
            return nil
        }
        let meeting = meetings[index]
        return meeting
    }
}

private extension MyAgendaViewModel {

    static func createMeetingsByDate(meetings: [Meeting]) -> [Date:[Meeting]] {
        var meetingsByDate: [Date:[Meeting]] = [:]
        
        for meeting in meetings {
            
            let startWithoutTime = meeting.start.startOfDay()
            
            if var dayArray = meetingsByDate[startWithoutTime] {
                dayArray.append(meeting)
                meetingsByDate[startWithoutTime] = dayArray
            } else {
                meetingsByDate[startWithoutTime] = [meeting]
            }
        }
        return meetingsByDate
    }
    
    func getMeetings(section: Int) -> [Meeting] {
        if let sectionDate = dateFrom(section: section),
            let meetings = meetingsByDate[sectionDate] {
            return meetings
        } else {
            return []
        }
    }
    
    func dateFrom(section: Int) -> Date? {
        let sortedDays = getSortedDays()
        
        guard sortedDays.count > section else {
            return nil
        }
        return sortedDays[section]
    }
    
    func getSortedDays() -> [Date] {
        return Array(meetingsByDate.keys).sorted { $0 < $1 }
    }
}
