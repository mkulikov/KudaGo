//
//  EventsViewController.swift
//  KudaGo
//
//  Created by mikhail.kulikov on 01/04/2019.
//  Copyright © 2019 mikhail.kulikov. All rights reserved.
//

import UIKit

protocol EventsViewControllerDelegate: AnyObject {
    func eventsListWillUpdate()
}

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: EventsViewControllerDelegate?
    
    var events = [Event]()
    var pageSize = 20
    var nextPage = 1
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.label.text = events[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == events.count - 1 && nextPage <= pageCount() {
            delegate?.eventsListWillUpdate()
        }
    }

    private func pageCount() -> Int {
        return Int(ceil(Double(count) / Double(pageSize)))
    }

}
