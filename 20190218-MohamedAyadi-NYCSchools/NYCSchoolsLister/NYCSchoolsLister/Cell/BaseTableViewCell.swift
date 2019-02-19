//
//  BaseTableViewCell.swift
//  NYCSchoolsLister
//
//  Created by Mohamed Ayadi on 2/18/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

}
