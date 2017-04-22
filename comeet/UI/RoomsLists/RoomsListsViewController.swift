//
//  RoomsListsViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class RoomsListsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: RoomsListsViewModel?
    internal struct Constants {
        static let metroareaCellIdentifier = "RoomsListsCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
                return
        }
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
    }
}

private extension RoomsListsViewController {
    func setup() {
        
        self.title = viewModel?.title()
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
}

extension RoomsListsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.roomsListsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.metroareaCellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel?.roomsListName(index: indexPath.row)
        return cell
    }
}

extension RoomsListsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.save(roomlist: viewModel.roomsList(index: indexPath.row))
        Router.selectedRoomsList = viewModel.roomsList(index: indexPath.row)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RoomsListNewLocation"), object: nil)
        dismiss(animated: true, completion: nil)
    }
}
