//
//  ListViewController.swift
//  NYCSchoolsLister
//
//  Created by Mohamed Ayadi on 2/18/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    /// array of tuple, in table view each section is based on stating alphabat letter.
    /// Means section 0 will be 'A' and section 1 will be 'B'. In this tuple the secont param
    /// is school which belong to rows
    var data: [(title:String , schools:[School])] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SchoolCell.nib, forCellReuseIdentifier: SchoolCell.identifier)
        self.reloadData()
    }
    
    
    // MARK: - Helper Methods
    
    /// Reload the view with respect to current model
    func reloadData() {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.white), nil)
        ApiManager.requestSchools { (schools, error) in
            guard let schools = schools, schools.count > 0, error == nil else {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                self.showError(error?.localizedDescription ?? ApiErrorMessages.generalError)
                return
            }
            
            ApiManager.updateScores(schools: schools, { (schools, error) in
                guard let schools = schools, schools.count > 0, error == nil else {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    self.showError(error?.localizedDescription ?? ApiErrorMessages.generalError)
                    return
                }
                
                // transoforming single school array to split into first letter
                // of school name. Here schools array is already sorted with
                // name so if in the loop school name start with diffrent lettr
                // rather than previous it will app preious letter and schools
                // as tuple in data
                var curTitle: String = ""
                var curSchools: [School] = []
                var data: [(title:String , schools:[School])] = []
                
                for school in schools {
                    let letter = String(school.name.first!)
                    if curTitle == letter {
                        curSchools.append(school)
                    } else {
                        data.append((title: curTitle, schools: curSchools))
                        curTitle = letter
                        curSchools = [school]
                    }
                }
                data.append((title: curTitle, schools: curSchools))
                
                self.data = data
                self.tableView.reloadData()
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            })
        }
    }
    
    /// Show message as error in UIAlertController
    ///
    /// - Parameter message: String which will be display in UIAlert
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Action Handlers
    
    /// refresh the all school information and score from server
    @IBAction func actionRefresh(_ sender: Any) {
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 20, height: 20), animated: true)
        reloadData()
    }
}


// MARK: - UITableView DataSource & Delegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolCell.identifier, for: indexPath) as! SchoolCell
        cell.model = data[indexPath.section].schools[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: DetailViewController.controllerName) as? DetailViewController else { return }
        controller.school = data[indexPath.section].schools[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return data.map { $0.title }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return data.index { $0.title == title } ?? 0
    }
    
}
