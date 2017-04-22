//
//  RoomsListViewModelTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/19/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class RoomsListViewModelTests: XCTestCase {
    
    var viewModel: RoomsListViewModel?
    var authenticator: FakeAuthenticator?
    var persistor = PersistorUserDefaultsImplementer()
    var fetcher: FakeFetcher?
    
    override func setUp() {
        super.setUp()
        authenticator = FakeAuthenticator()
        fetcher = FakeFetcher()
        let roomlist = User(name: "A Building", email: "test@test.com")
        viewModel = RoomsListViewModel(authenticator: authenticator!, fetcher: fetcher!, persistor: persistor,selectedDate: Date(), metroarea: "A City", roomsList: roomlist)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchRoomsError() {
        self.fetcher?.error = Stubs.unauthorizedError()
        self.fetcher?.rooms = [Stubs.room()]
        
        viewModel?.reloadBinding = {[weak self] in
            XCTAssertTrue(self!.viewModel!.roomsCount() == 0)
        }
        self.viewModel?.fetchRooms()
    }
    
    func testFetchRooms() {
        self.fetcher?.rooms = [Stubs.room()]
        
        viewModel?.reloadBinding = {[weak self] in
            XCTAssertTrue(self!.viewModel!.roomsCount() == 1)
        }
        self.viewModel?.fetchRooms()
    }
    
    func testRoomName() {
        self.fetcher?.rooms = [Stubs.room()]
        
        viewModel?.reloadBinding = {[weak self] in
            XCTAssertTrue(self!.viewModel!.roomName(index: 0) == Stubs.room().name)
        }
        self.viewModel?.fetchRooms()
    }
    
    func testRoomDescription() {
        self.fetcher?.rooms = [Stubs.room()]
        
        viewModel?.reloadBinding = {[weak self] in
            XCTAssertTrue(self!.viewModel!.roomDescription(index: 0) == Stubs.room().email)
        }
        self.viewModel?.fetchRooms()
    }
}
