//
//  MainMenuViewController.swift
//  comeet
//
//  Created by stephen chang on 3/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import WWCalendarTimeSelector

class MainMenuViewController: BaseViewController, WWCalendarTimeSelectorProtocol {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var viewModel: MainMenuViewModel?
    
    var agendaVC: MyAgendaViewController?
    var roomListVC: RoomsListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //add swipe gesture recognizer to container view
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(containerViewSwiped(gesture:)))
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.left
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(containerViewSwiped(gesture:)))
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        containerView.addGestureRecognizer(swipeGestureLeft)
        containerView.addGestureRecognizer(swipeGestureRight)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func containerViewSwiped(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            if agendaVC?.view.isHidden ?? true {
                //animate fade in of agenda VC
                agendaVC?.view.alpha = 0.0
                agendaVC?.view.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.agendaVC?.view.alpha = 1.0
                    self.roomListVC?.view.alpha = 0.0
                }, completion: { (success) in
                    self.roomListVC?.view.isHidden = true
                })
            }
        case UISwipeGestureRecognizerDirection.right:
            if roomListVC?.view.isHidden ?? true {
                
                //animate fade in of agenda VC
                roomListVC?.view.alpha = 0.0
                roomListVC?.view.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.roomListVC?.view.alpha = 1.0
                    self.agendaVC?.view.alpha = 0.0
                }, completion: { (success) in
                    self.agendaVC?.view.isHidden = true
                })
            }
        default:
            break
        }
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
        
        /*let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendarPopUp") as! CalendarViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)*/
        
        let calendarVC = WWCalendarTimeSelector.instantiate()
        calendarVC.optionTopPanelBackgroundColor = UIColor(colorLiteralRed: 129.0/255.0, green: 216.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        calendarVC.optionCalendarBackgroundColorTodayHighlight = UIColor(colorLiteralRed: 129.0/255.0, green: 216.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        calendarVC.optionSelectorPanelBackgroundColor = UIColor(colorLiteralRed: 129.0/255.0, green: 216.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        calendarVC.optionButtonFontColorDone = UIColor(colorLiteralRed: 129.0/255.0, green: 216.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        calendarVC.optionCalendarBackgroundColorFutureDatesHighlight = UIColor(colorLiteralRed: 129.0/255.0, green: 216.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        calendarVC.optionCalendarBackgroundColorPastDatesHighlight = UIColor(colorLiteralRed: 129.0/255.0, green: 216.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        calendarVC.delegate = self
        calendarVC.modalPresentationStyle = .popover
        calendarVC.popoverPresentationController?.sourceView = sender as? UIButton
        self.present(calendarVC, animated: true) { 
            
        }
        
    }
    
    //callback from WWCalendar library when a date is selected and done button is pressed
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        updateDateButton(date: date)
    }
    
    //helper function to convert the date into a string and use that string to update the title of the date button
    func updateDateButton(date: Date) {
        let df = DateFormatter()
        df.dateStyle = .medium
        let title = df.string(from: date)
        
        dateButton.setTitle(title, for: .normal)
    }
}

private extension MainMenuViewController {
    func setup() {
        
        title = viewModel?.title()
        navigationItem.setHidesBackButton(true, animated: false)
        
        dateButton.setTitle(viewModel?.selectedDate.displayStringDate(), for: .normal)
        addRoomsList()
        addAgendaView()
        
//        viewModel?.reloadBinding = { [weak self] in
//
//        }
        //viewModel?.fetchMeetings()
//        showRoomsList()
    }
    
    func addAgendaView() {
        if let agendaVC = getAgendaVC() {
            addChild(viewController: agendaVC, inView: containerView)
            self.agendaVC = agendaVC
            //hide agenda view initially
            agendaVC.view.isHidden = true
        }
    }
    
    func addRoomsList() {
        if let roomsListVC = getRoomsListVC() {
            // have a reference to the rooms list view controller
            self.roomListVC = roomsListVC
            addChild(viewController: roomsListVC, inView: containerView)
        }
    }
    
    func addChild(viewController: UIViewController, inView: UIView) {
        addChildViewController(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        inView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        let views = ["viewControllerView" : viewController.view]
        let vflVertical = "V:|[viewControllerView]|"
        let vflHorizontall = "H:|[viewControllerView]|"
        
        inView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vflVertical, options: [], metrics: nil, views: views))
        inView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vflHorizontall, options: [], metrics: nil, views: views))
    }
    
    func getRoomsListVC() -> RoomsListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RoomsListViewController")
        guard let roomsListVC = viewController as? RoomsListViewController else {
            return nil
        }
        if let roomsListViewModel = getRoomsListViewModel() {
            roomsListVC.viewModel = roomsListViewModel
        }
        
        return roomsListVC
    }
    
    //create a reference of Agenda VC
    func getAgendaVC() -> MyAgendaViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MyAgendaViewController")
        guard let meetingsVC = viewController as? MyAgendaViewController else {
            return nil
        }
        
        return meetingsVC
    }
    
    func getRoomsListViewModel() -> RoomsListViewModel? {
        guard let viewModel = viewModel else {
            return nil
        }
        let roomsListViewModel = RoomsListViewModel(authenticator: viewModel.authenticator, fetcher: viewModel.fetcher, persistor: viewModel.persistor, selectedDate: viewModel.selectedDate, metroarea: nil, roomsList: nil)
        return roomsListViewModel
    }

}
