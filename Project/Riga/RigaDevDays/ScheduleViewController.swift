//
//  ScheduleViewController.swift
//  RigaDevDays
//
//  Created by Dmitry Beloborodov on 27/01/2017.
//  Copyright © 2017 RigaDevDay. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ScheduleViewController: UIViewController {

    @IBOutlet weak var selectedDayFilter: UISegmentedControl!
    @IBOutlet weak var filterPlaceholderView: UIView!

    var selectedDayIndex: Int = 0
    var embeddedDayViewController: DayViewController?
    var embeddedFavouritesViewController: FavouritesViewController?

    @IBOutlet weak var dayControllerContainer: UIView!
    @IBOutlet weak var favouritesControllerContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateWithNewData), name: .AllDataReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged), name: .FavouritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged), name: .UserDidSignIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged), name: .UserDidSignOut, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged), name: .SpeakersUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged), name: .SessionsUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateWithNewData), name: .ScheduleUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged), name: .FavouritesUpdated, object: nil)

        favouritesControllerContainer.isHidden = true
        dayControllerContainer.isHidden = false
        
        if !ConnectionManager.shared.isConnection() {
            let alertController = UIAlertController(title: locs("user.alert.no-connection.title"), message: locs("user.alert.no-connection.message"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectedDayChanged(_ sender: UISegmentedControl) {
        if selectedDayFilter.selectedSegmentIndex > DataManager.sharedInstance.days.count-1 {
            favouritesControllerContainer.isHidden = false
            dayControllerContainer.isHidden = true
            displaySessionButton(true)
        } else {
            favouritesControllerContainer.isHidden = true
            dayControllerContainer.isHidden = false
            selectedDayIndex = selectedDayFilter.selectedSegmentIndex
            diplaySelectedSchedule()
            displaySessionButton(false)
        }
    }

    func updateWithNewData() {
        selectedDayFilter.removeAllSegments()
        for index in 0..<DataManager.sharedInstance.days.count {
            let day = DataManager.sharedInstance.days[index]
            let title = day.localizedDate
            selectedDayFilter.insertSegment(withTitle: title, at: index, animated: false)
        }
        selectedDayFilter.insertSegment(withTitle: "Favourites", at: DataManager.sharedInstance.days.count, animated: false)

        if selectedDayIndex > DataManager.sharedInstance.days.count {
            selectedDayIndex = 0
        }

        if DataManager.sharedInstance.days.count > 0 {
            selectedDayFilter.selectedSegmentIndex = selectedDayIndex
        }

        diplaySelectedSchedule()

    }

    func diplaySelectedSchedule() {
        if DataManager.sharedInstance.days.indices.contains(selectedDayIndex)  {
            self.embeddedDayViewController?.selectedDay = DataManager.sharedInstance.days[selectedDayIndex]
            self.embeddedDayViewController?.tableView.reloadData()
        }
    }

    func dataChanged() {
        diplaySelectedSchedule()

        if DataManager.sharedInstance.days.count > 0
            && selectedDayFilter.selectedSegmentIndex == DataManager.sharedInstance.days.count {
            displaySessionButton(true)
        } else {
            displaySessionButton(false)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "embeddedDay" {
            self.embeddedDayViewController = segue.destination as? DayViewController
            let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(self.filterPlaceholderView.frame.height, 0, 0, 0);
            //Where tableview is the IBOutlet for your storyboard tableview.
            self.embeddedDayViewController?.tableView.contentInset = adjustForTabbarInsets;
            self.embeddedDayViewController?.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
        }

        if segue.identifier == "embeddedFavourites" {
            self.embeddedFavouritesViewController = segue.destination as? FavouritesViewController

            var topOffset = UIApplication.shared.statusBarFrame.height
            if let navBar = self.navigationController?.navigationBar {
                topOffset += navBar.frame.height
            }
            topOffset += self.filterPlaceholderView.frame.height
            var bottomOffset: CGFloat = 0.0
            if let tabBar = self.tabBarController?.tabBar {
                bottomOffset += tabBar.frame.height
            }
            let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(topOffset, 0, bottomOffset, 0);
            //Where tableview is the IBOutlet for your storyboard tableview.
            self.embeddedFavouritesViewController?.tableView.contentInset = adjustForTabbarInsets;
            self.embeddedFavouritesViewController?.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
        }
    }
}
