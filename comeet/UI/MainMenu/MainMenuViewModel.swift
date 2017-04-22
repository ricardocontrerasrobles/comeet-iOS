//
//  MainMenuViewModel.swift
//  comeet
//
//  Created by stephen chang on 3/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//


import Foundation

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
    
  
}
