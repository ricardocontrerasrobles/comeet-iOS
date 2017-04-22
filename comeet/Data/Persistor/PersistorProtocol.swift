//
//  PersistorProtocol.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/4/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

protocol PersistorProtocol {

    func save(metroArea: String?)
    func getMetroArea() -> String?
    func save(roomlist: User?)
    func getRoomlist() -> User?
}
