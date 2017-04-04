//
//  LoginViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias TokenBinding = (String)-> Void
typealias TokenErrorBinding = (Error)-> Void

class LoginViewModel : BaseViewModel {
    
    var tokenBinding: TokenBinding?
    var tokenErrorBinding: TokenErrorBinding?
    var authenticator = DataSimpleBridge.getAuthenticator()
    var fetcher = DataSimpleBridge.getFetcher()
    
    // Set API environment
    private let environment: Environment = .Mocked
    
    func getToken() {
        authenticator.getToken { [weak self] (token: String?, error: Error?, type: AuthType) in
            guard error == nil else {
                DispatchQueue.main.async {
                    self?.tokenErrorBinding?(error!)
                }
                return
            }
            
            if let token = token {
                DispatchQueue.main.async {
                    self?.prepareFetcher(accessToken: token, type: type)
                    self?.tokenBinding?(token)
                }
            }
        }
    }
    
    func isLoggedIn() -> Bool {
        return authenticator.isLoggedIn()
    }
    
    private func prepareFetcher(accessToken: String, type: AuthType) {
        fetcher.set(environment: environment)
        fetcher.set(accessToken: accessToken, type: type)
    }
}
