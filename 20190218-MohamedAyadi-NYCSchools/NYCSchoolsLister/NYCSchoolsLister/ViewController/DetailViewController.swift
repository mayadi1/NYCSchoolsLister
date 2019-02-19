//
//  DetailViewController.swift
//  NYCSchoolsLister
//
//  Created by Mohamed Ayadi on 2/18/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    static let controllerName: String = "DetailViewController"
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var scoreMathLabel: UILabel!
    @IBOutlet var scoreWritingLabel: UILabel!
    @IBOutlet var scoreReadingLabel: UILabel!
    
    var school: School! = nil

    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadData()
    }
    
    
    // MARK: - Helper Methods
    
    /// Reload the view with respect to current model
    func reloadData() {
        nameLabel.text = school.name
        overviewLabel.text = school.overview
        scoreMathLabel.text = school.score?.math ?? "-"
        scoreWritingLabel.text = school.score?.writing ?? "-"
        scoreReadingLabel.text = school.score?.reading ?? "-"

        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(school.latitude, school.longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(regionSpan, animated: true)
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
    
    /// try to open school location in map application using iOS MapKit
    @IBAction func actionMap(_ sender: Any) {
        let regionDistance:CLLocationDistance = 300
        let coordinates = CLLocationCoordinate2DMake(school.latitude, school.longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]

        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = school.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    /// try to call school if current deveice support it and have sim
    @IBAction func actionCall(_ sender: Any) {
        if let url = URL(string: "tel://\(school.phone)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                self.showError("Can not call")
            }
        }
    }
    
    /// try to open email school if email properly configured to device
    @IBAction func actionEmail(_ sender: Any) {
        if let url = URL(string: "mailto://\(school.email)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                self.showError("Can not open email")
            }
        }
    }
    
    /// try to open the webstie on safari
    @IBAction func actionWebsite(_ sender: Any) {
        let website = (school.website.contains("://") ? "" : "http://") + school.website
        if let url = URL(string: website) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                self.showError("Can not open website")
            }
        }
    }
    
}
