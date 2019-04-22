//
//  DetailViewController.swift
//  CollectionView
//
//  Created by Roman Mishchenko on 4/7/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import UIKit
import CoreData
class DetailViewController: UIViewController {

    
    var selection: Skill!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
   


    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsLabel.text = selection.skillName
        categoryLabel.text = selection.category
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
