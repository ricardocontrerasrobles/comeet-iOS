//
//  PersistorUserDefaultsImplementer.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/4/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class PersistorUserDefaultsImplementer : PersistorProtocol {
    
    private struct Constants {
        static let metroAreaKey = "metroAreaKey"
        static let roomlistNameKey = "roomlistNameKey"
        static let roomlistEmailKey = "roomlistEmailKey"
    }
    
    func save(metroArea: String?) {
        UserDefaults.standard.set(metroArea, forKey: Constants.metroAreaKey)
        UserDefaults.standard.synchronize()
    }
    
    func getMetroArea() -> String? {
        return UserDefaults.standard.string(forKey: Constants.metroAreaKey)
    }
    
    func save(roomlist: User?) {
        guard let roomlist = roomlist else {
            return
        }
        
        UserDefaults.standard.set(roomlist.name, forKey: Constants.roomlistNameKey)
        UserDefaults.standard.set(roomlist.email, forKey: Constants.roomlistEmailKey)
        UserDefaults.standard.synchronize()
    }
    
    func getRoomlist() -> User? {
        
        guard let name = UserDefaults.standard.object(forKey: Constants.roomlistNameKey) as? String,
            let email = UserDefaults.standard.object(forKey: Constants.roomlistEmailKey) as? String else {
                return nil
        }
        
        let user = User(name: name, email: email)
        return user
    }
}
