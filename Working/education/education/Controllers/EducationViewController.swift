//
//  ViewController.swift
//  education
//
//  Created by Roman Mishchenko on 4/25/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import UIKit
import CoreData

class EducationCellClass: UITableViewCell {
    @IBOutlet weak var organizationTitle: UILabel!
    @IBOutlet weak var organization: UILabel!
    @IBOutlet weak var yearsTitle: UILabel!
    @IBOutlet weak var startYear: UILabel!
    @IBOutlet weak var endYear: UILabel!
    @IBOutlet weak var defis: UILabel!
}

class testClass {
    var organizations: String!
    var startYear: String!
    var endYear: String!
    init(organization: String, start: String, end: String) {
        organizations = organization
        startYear = start
        endYear = end
    }
}

class EducationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var educationCollection = [testClass]()
    var menuIsOpen = false
    var newButton: UIButton!
    var cellCount: Int!
    var field: UITextField!
    var startYear: UITextField!
    var endYear: UITextField!
    
    private let context = PersistentService.persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Education>!
    @IBOutlet weak var addMenuButton: UIButton!
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var menuItem: UIView!
    @IBOutlet var menuHeigthConstraint: NSLayoutConstraint!
    @IBOutlet var menuOpenWidth: NSLayoutConstraint!
    
    
    
    @IBAction func addMenu(_ sender: Any) {
        menuIsOpen = !menuIsOpen
        menuHeigthConstraint.constant = menuIsOpen ? 200 : 44
        menuOpenWidth.constant = menuIsOpen ? 30 : 10
        //view.layoutIfNeeded()
        field.resignFirstResponder()
        startYear.resignFirstResponder()
        endYear.resignFirstResponder()
        UIView.animate(
            withDuration: 0.33,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                let angle: CGFloat = self.menuIsOpen ? .pi / 4 : 0.0
                self.addMenuButton.transform = CGAffineTransform(rotationAngle: angle)
                self.view.layoutIfNeeded()
                
            },
            completion: nil)
        
    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }

    
    
   

}

extension EducationViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: Table View methods
    func makeSlider() {
       
        let rect = CGRect(x: 0, y: 0, width: 300, height: 25)
        field = UITextField(frame: rect)
        
        makeField(field: field, name: "Organization name")
        field.returnKeyType = .continue
        //field.return
        addConstraint(item: field!, itemTo: menuItem!, constant: 20, atributeOne: NSLayoutConstraint.Attribute.left, atributeTwo: NSLayoutConstraint.Attribute.left)
        addConstraint(item: field!, itemTo: backButton!, constant: 41, atributeOne: NSLayoutConstraint.Attribute.top, atributeTwo: NSLayoutConstraint.Attribute.top)
        
        
    
        let smallRect = CGRect(x: 0, y: 0, width: 120, height: 25)
        startYear = UITextField(frame: smallRect)
        startYear.keyboardType = UIKeyboardType.numberPad
        makeField(field: startYear, name: "Start Year")
        
        addConstraint(item: startYear!, itemTo: menuItem!, constant: 20, atributeOne: NSLayoutConstraint.Attribute.left, atributeTwo: NSLayoutConstraint.Attribute.left)
        addConstraint(item: startYear!, itemTo: field!, constant: 41, atributeOne: NSLayoutConstraint.Attribute.top, atributeTwo: NSLayoutConstraint.Attribute.top)
        
        
        
        endYear = UITextField(frame: smallRect)
        endYear.keyboardType = UIKeyboardType.numberPad
        makeField(field: endYear, name: "End Year")
        
        addConstraint(item: endYear!, itemTo: startYear!, constant: 100, atributeOne: NSLayoutConstraint.Attribute.left, atributeTwo: NSLayoutConstraint.Attribute.left)
        addConstraint(item: endYear!, itemTo: field!, constant: 41, atributeOne: NSLayoutConstraint.Attribute.top, atributeTwo: NSLayoutConstraint.Attribute.top)
        addConstraint(item: startYear!, itemTo: endYear!, constant: -20, atributeOne: NSLayoutConstraint.Attribute.right, atributeTwo: NSLayoutConstraint.Attribute.left)
        
        
        
        let buttonRect = CGRect(x: menuItem.frame.size.width - 110, y: 130, width: 90, height: 50)
        newButton = UIButton(frame: buttonRect)
        newButton.setTitle("Add New", for: .normal)
        newButton.setTitleColor(UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0), for: .normal)
        newButton.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.19, alpha:1.0)
        newButton.tintColor = UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0)
        newButton.isEnabled = true
        newButton.isHidden = false
        
        newButton.addTarget(self, action: Selector(("addNewCell")), for: UIControl.Event.touchUpInside)
        
        newButton.layer.cornerRadius = 10
        self.menuItem.addSubview(newButton)
        
        
        addConstraint(item: field!, itemTo: newButton!, constant: -112, atributeOne: NSLayoutConstraint.Attribute.right, atributeTwo: NSLayoutConstraint.Attribute.left)
        addConstraint(item: endYear!, itemTo: newButton!, constant: -112, atributeOne: NSLayoutConstraint.Attribute.right, atributeTwo: NSLayoutConstraint.Attribute.left)
        
        
        
    }
    
    
    private func addConstraint(item: Any, itemTo: Any, constant: CGFloat, atributeOne: NSLayoutConstraint.Attribute, atributeTwo: NSLayoutConstraint.Attribute) {
        NSLayoutConstraint(item: item, attribute: atributeOne, relatedBy: NSLayoutConstraint.Relation.equal, toItem: itemTo, attribute: atributeTwo, multiplier: 1, constant: constant).isActive = true
        
    }
    private func makeField(field: UITextField, name: String) {
        
        
        field.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.19, alpha:1.0)
        field.minimumFontSize = 20
        field.layer.cornerRadius = 5
        field.attributedPlaceholder = NSAttributedString(string: name,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 0.6)])
        field.textColor = UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0)
        field.isEnabled = true
        field.translatesAutoresizingMaskIntoConstraints = false
        self.menuItem.addSubview(field)
        
        
    }
    
    
    @IBAction func addNewCell() {
        print("add new")
        self.newButton.pulsate()
        educationCollection.append(testClass.init(organization: field.text!, start: startYear.text!, end: endYear.text!))
        field.text = nil
        startYear.text = nil
        endYear.text = nil
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       makeSlider()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return educationCollection.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            educationCollection.remove(at: indexPath.row)
        }
        tableView.reloadData()
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EducationItem", for: indexPath) as! EducationCellClass
        
        let education = educationCollection[indexPath.row]
        cell.organization.text = education.organizations
        cell.startYear.text = education.startYear
        cell.endYear.text = education.endYear
        
        
        return cell
    }
    
    
}
