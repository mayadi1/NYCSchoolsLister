//
//  SchoolCell.swift
//  NYCSchoolsLister
//
//  Created by Mohamed Ayadi on 2/18/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//
import UIKit

class SchoolCell: BaseTableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var scoreColor: UILabel!
    
    var model: School! {
        didSet {
            nameLabel.text = model.name
            overviewLabel.text = model.overview
            scoreColor.backgroundColor = ((Int(model.score?.math ?? "0") ?? 0) > 600 ? UIColor.green : UIColor.red)
        }
    }

}
