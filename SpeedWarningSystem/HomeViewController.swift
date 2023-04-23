//
//  ViewController.swift
//  SpeedWarningSystem
//
//  Created by Yavuz Ulgar on 21.04.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    let speedLimits = ["30","40","50","60","70","80","90","100","110","120","130","140","150","160","170","180","190","200"]
    var selectedSpeed: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Large Navigation Title
        navigationController?.navigationBar.prefersLargeTitles = true
    }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speedLimits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var context = cell.defaultContentConfiguration()
        context.text = speedLimits[indexPath.row]
        cell.contentConfiguration = context
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSpeed = speedLimits[indexPath.row]
        performSegue(withIdentifier: "goMapVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goMapVC" {
            let goMapVC = segue.destination as! MapViewController
            goMapVC.choosenSpeed = selectedSpeed
        }
    }
    
    
}

