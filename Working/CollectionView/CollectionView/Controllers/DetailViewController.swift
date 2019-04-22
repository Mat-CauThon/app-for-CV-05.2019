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
    @IBOutlet weak var navigationItemDetail: UINavigationItem!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet weak var descLabel: UITextField!
    private var backButton: UIBarButtonItem!
    private var backButtonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: Selector(("doneAction")))
    
    
    @IBAction func setEditLabel(_ sender: Any) {
        descLabel.isEnabled = true
        backButton = navigationItemDetail.leftBarButtonItem
        navigationItemDetail.leftBarButtonItem = backButtonDone
        navigationItemDetail.rightBarButtonItem?.isEnabled = false
        
    }
    
    @IBAction func doneAction() {
        navigationItemDetail.leftBarButtonItem = backButton
        navigationItemDetail.rightBarButtonItem?.isEnabled = true
        descLabel.isEnabled = false
    }


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
