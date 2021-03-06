//
//  ContainerViewController.swift
//  KudaGo
//
//  Created by mikhail.kulikov on 01/04/2019.
//  Copyright © 2019 mikhail.kulikov. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, CitiesViewControllerDelegate, EventsViewControllerDelegate {
    
    var location: String?
    var needReloadEventsList = true

    enum View {
        case cities
        case events
    }
    
    var currentView = View.cities
    
    let citiesViewController = CitiesViewController()
    let eventsViewController = EventsViewController()

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            remove(childViewController: eventsViewController)
            addView(fromViewController: citiesViewController)
            currentView = .cities
        case 1:
            remove(childViewController: citiesViewController)
            addView(fromViewController: eventsViewController)
            if needReloadEventsList {
                eventsViewController.tableView.reloadData()
                eventsViewController.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
                needReloadEventsList = false
            }
            currentView = .events
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesViewController.delegate = self
        eventsViewController.delegate = self
        addChild(citiesViewController)
        addChild(eventsViewController)
        addView(fromViewController: citiesViewController)
        segmentedControl.setEnabled(false, forSegmentAt: 1)
        fetchCities()
    }
    
    func addView(fromViewController viewController: UIViewController) {
        containerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        setConstraints(forChildViewController: viewController)
    }
    
    func remove(childViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func setConstraints(forChildViewController viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.firstBaselineAnchor.constraint(equalTo: containerView.firstBaselineAnchor).isActive = true
        viewController.view.self.lastBaselineAnchor.constraint(equalTo: containerView.lastBaselineAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    func fetchCities() {
        let networkRequest = NetworkRequest()
        networkRequest.getCities { [weak self] (result) in
            switch result {
            case .success(let cities):
                debugPrint(cities)
                self?.citiesViewController.cities = cities
                self?.citiesViewController.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchEvents(location: String) {
        let networkRequest = NetworkRequest()
        networkRequest.cancelEventsRequest()
        networkRequest.getEvents(location: location, page: eventsViewController.nextPage, pageSize: eventsViewController.pageSize) { [weak self] (result) in
            switch result {
            case .success(let events):
                debugPrint(events.results)
                self?.eventsViewController.count = events.count ?? 0
                self?.eventsViewController.events.append(contentsOf: events.results)
                self?.eventsViewController.nextPage += 1
                self?.eventsViewController.isFetchEventsInProgress = false
                if self?.currentView == .cities {
                    self?.segmentedControl.setEnabled(true, forSegmentAt: 1)
                } else {
                    self?.eventsViewController.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                self?.eventsViewController.isFetchEventsInProgress = false
                if self?.currentView == .events {
                    self?.eventsViewController.tableView.reloadData()
                }
            }
        }
    }
    
    func citiesList(didSelectAt index: Int) {
        guard let location = citiesViewController.cities[index].slug else { return }
        if location != self.location {
            self.location = location
            needReloadEventsList = true
            eventsViewController.events = []
            eventsViewController.nextPage = 1
            segmentedControl.setEnabled(false, forSegmentAt: 1)
            fetchEvents(location: location)
        }
    }
    
    func eventsListWillUpdate() {
        guard let location = self.location else { return }
        eventsViewController.isFetchEventsInProgress = true
        eventsViewController.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        fetchEvents(location: location)
    }

}
