//
//  LoginViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var tokenLabel: UILabel!
    internal let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func getToken(_ sender: Any) {
        viewModel.getToken()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
    }
}

private extension LoginViewController {
    func setup() {
        viewModel.tokenBinding = { [weak self] (token: String) in
            self?.tokenLabel.text = "Token: " + token
            self?.performSegue(withIdentifier: Router.Constants.roomsListIdentifier, sender: nil)
        }
        viewModel.tokenErrorBinding = { [weak self] (error: Error) in
            self?.tokenLabel.text = "Error: " + error.localizedDescription
        }
    }
}
