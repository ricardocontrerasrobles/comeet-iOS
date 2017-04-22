//
//  MetroareaViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class MetroareaViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: MetroareaViewModel?
    internal struct Constants {
        static let metroareaCellIdentifier = "MetroareaCell"
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

private extension MetroareaViewController {
    func setup() {
        
        self.title = "Metro Area"
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        viewModel?.reloadBinding = { [weak self] (rooms) in
            self?.tableView.reloadData()
        }
        viewModel?.fetchSearchCriteria()
    }
}

extension MetroareaViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.metroareaCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.metroareaCellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel?.metroareaName(index: indexPath.row)
        return cell
    }
}

extension MetroareaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel?.save(metroarea: viewModel?.metroareaName(index: indexPath.row))
        Router.selectedMetroarea = viewModel?.metroareaName(index: indexPath.row)
        Router.selectedRoomsLists = viewModel?.roomsLists(index: indexPath.row)
        performSegue(withIdentifier: Router.Constants.roomsListsSegue, sender: self)
    }
}
