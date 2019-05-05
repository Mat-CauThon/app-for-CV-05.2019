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


struct educationStruct {
    var startYear: String!
    var endYear: String!
    var organization: String!
}

class EducationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let customEducation: [educationStruct] = [educationStruct.init(startYear: "2006", endYear: "2014", organization: "Nikopol secordary school №13"), educationStruct.init(startYear: "2015", endYear: "2017", organization: "Nikopol specialized school №5"), educationStruct.init(startYear: "2010", endYear: "2017", organization: #"Theater studio "Big change""#), educationStruct.init(startYear: "2017", endYear: "2021", organization: "Kiev Polytechnic University, FICT")]
    
    private var menuIsOpen = false
    private var newButton: UIButton!
    private var field: UITextField!
    private var startYear: UITextField!
    private var endYear: UITextField!
    private var isFiltered = false
    private var query = ""
    private var filtered = [Education]()
    
    
    private let context = PersistentService.persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Education>!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var addMenuButton: UIButton!
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var menuItem: UIView!
    @IBOutlet var menuHeigthConstraint: NSLayoutConstraint!
    @IBOutlet var menuOpenWidth: NSLayoutConstraint!
    
    
    @IBAction func backAction(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addMenu(_ sender: Any) {
        menuIsOpen = !menuIsOpen
        menuHeigthConstraint.constant = menuIsOpen ? 200 : 44
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
    
    
    
}

extension EducationViewController: UITableViewDelegate, UITableViewDataSource {
    func makeSlider() {
        
        let rect = CGRect(x: 0, y: 0, width: 300, height: 25)
        field = UITextField(frame: rect)
        
        makeField(field: field, name: "Organization name")
        field.returnKeyType = .continue
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
        
        field.delegate = self
        startYear.delegate = self
        endYear.delegate = self
        
        let buttonRect = CGRect(x: view.frame.size.width - 110, y: 130, width: 90, height: 50)
        newButton = UIButton(frame: buttonRect)
        newButton.setTitle("Add New", for: .normal)
        newButton.setTitleColor(UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0), for: .normal)
        newButton.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.15, alpha:1.0)
        newButton.tintColor = UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0)
        newButton.isEnabled = true
        newButton.isHidden = false
        
        newButton.addTarget(self, action: Selector(("addNewED")), for: UIControl.Event.touchUpInside)
        
        newButton.layer.cornerRadius = 10
        self.menuItem.addSubview(newButton)
        
        
        addConstraint(item: field!, itemTo: newButton!, constant: -20, atributeOne: NSLayoutConstraint.Attribute.right, atributeTwo: NSLayoutConstraint.Attribute.left)
        addConstraint(item: endYear!, itemTo: newButton!, constant: -20, atributeOne: NSLayoutConstraint.Attribute.right, atributeTwo: NSLayoutConstraint.Attribute.left)
        
        
        
    }
    
    
    private func addConstraint(item: Any, itemTo: Any, constant: CGFloat, atributeOne: NSLayoutConstraint.Attribute, atributeTwo: NSLayoutConstraint.Attribute) {
        NSLayoutConstraint(item: item, attribute: atributeOne, relatedBy: NSLayoutConstraint.Relation.equal, toItem: itemTo, attribute: atributeTwo, multiplier: 1, constant: constant).isActive = true
        
    }
    private func makeField(field: UITextField, name: String) {
        
        
        field.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.15, alpha:1.0)
        field.minimumFontSize = 20
        field.layer.cornerRadius = 5
        field.attributedPlaceholder = NSAttributedString(string: name,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 0.6)])
        field.textColor = UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0)
        field.isEnabled = true
        field.translatesAutoresizingMaskIntoConstraints = false
        self.menuItem.addSubview(field)
        
        
    }
    
    
    @IBAction func addNewED() {
       
        self.newButton.pulsate()
       
        let data = Education(entity: Education.entity(), insertInto: self.context)
        data.organization = field.text!
        
        var nsYear = startYear.text! as NSString
        if nsYear.length > 4 {
            startYear.text = nsYear.substring(with: NSRange(location: 0, length: nsYear.length > 4 ? 4 : nsYear.length))
        }
        nsYear = endYear.text! as NSString
        if nsYear.length > 4 {
            endYear.text = nsYear.substring(with: NSRange(location: 0, length: nsYear.length > 4 ? 4 : nsYear.length))
        }
        
        data.startYear = startYear.text!
        data.endYear = endYear.text!
        PersistentService.saveContext()
        refresh()
        tableView.reloadData()
        
        
        field.text = nil
        startYear.text = nil
        endYear.text = nil
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSlider()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
        if fetchedRC.fetchedObjects?.count == 0 {
            for item in customEducation {
                let data = Education(entity: Education.entity(), insertInto: self.context)
                data.organization = item.organization
                data.startYear = item.startYear
                data.endYear = item.endYear
                PersistentService.saveContext()
                
            }
            refresh()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedRC.fetchedObjects?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        view.layoutIfNeeded()
        if editingStyle == .delete {
            
            let cell = tableView.cellForRow(at: indexPath)
            
            UIView.transition(
                with: tableView,
                duration: 1.0,
                options: .transitionCrossDissolve,
                animations: {
                    cell!.removeFromSuperview()
                    
                    self.context.delete(self.fetchedRC.object(at: indexPath))
                    do {
                        try self.context.save()
                        print("saved!")
                    } catch let error as NSError {
                        print("Could not save \(error), \(error.userInfo)")
                    } catch {}
                    
                    self.refresh()
            },
                completion: { _ in
            })
        }
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EducationItem", for: indexPath) as! EducationCellClass
        
        let education = fetchedRC.object(at: indexPath)
        cell.organization.text = education.organization
        cell.startYear.text = education.startYear
        cell.endYear.text = education.endYear
        
        
        return cell
    }
    
    private func refresh() {
        
        let request = Education.fetchRequest() as NSFetchRequest<Education>
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "organization CONTAINS[cd] %@", query)
        }
        let sort = NSSortDescriptor(key: #keyPath(Education.endYear), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension EducationViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let txt = searchBar.text else {
            return
        }
        query = txt
        refresh()
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        query = ""
        
        searchBar.text = nil
        searchBar.resignFirstResponder()
        refresh()
        tableView.reloadData()
    }
}


