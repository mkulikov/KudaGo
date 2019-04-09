//
//  CitiesViewController.swift
//  KudaGo
//
//  Created by mikhail.kulikov on 01/04/2019.
//  Copyright © 2019 mikhail.kulikov. All rights reserved.
//

import UIKit

protocol CitiesViewControllerDelegate: AnyObject {
    func citiesList(didSelectAt index: Int)
}

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var cities = [City]()
    
    weak var delegate: CitiesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "CityCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        cell.label.text = cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.citiesList(didSelectAt: indexPath.row)
    }

}
