//
//  MainMenuViewController.swift
//  comeet
//
//  Created by stephen chang on 3/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import SSCalendar

class MainMenuViewController: BaseViewController {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let roomsListVC = RoomsListViewController()
    
    var viewModel: MainMenuViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
                print("")
                return
        }
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
    }

    @IBAction func logOut(_ sender: Any) {
        viewModel?.logout()
        _=navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func changeDate(_ sender: Any) {
        
    }
}

private extension MainMenuViewController {
    func setup() {
        
        title = viewModel?.title()
        navigationItem.setHidesBackButton(true, animated: false)
        
        dateButton.setTitle(viewModel?.selectedDate.displayStringDate(), for: .normal)
        
//        viewModel?.reloadBinding = { [weak self] in
//
//        }
        viewModel?.fetchMeetings()
        showRoomsList()
    }
    
    func showRoomsList() {
        
        addChildViewController(roomsListVC)
//        roomsListVC.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        roomsListVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        containerView.addSubview(roomsListVC.view)
        roomsListVC.didMove(toParentViewController: self)
        
        let views = ["containerView" : containerView,
                     "roomsListVCView" : roomsListVC.view
        ]
        
        let vflVertical = "V:|[roomsListVCView]|"
        let vflHorizontall = "H:|[roomsListVCView]|"
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vflVertical, options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vflHorizontall, options: [], metrics: nil, views: views))
        
    }
}
