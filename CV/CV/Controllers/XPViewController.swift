//
//  ViewController.swift
//  xp
//
//  Created by Roman Mishchenko on 4/30/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import UIKit
import CoreData

class XPCellClass: UITableViewCell {
    @IBOutlet weak var xpTitle: UILabel!
}


class XPViewController: UIViewController, UITextFieldDelegate {
    var testArray: [String] = ["LOL", "KEK"]

    
     let customXP = ["Work with Mathematica", "Algorithms knowledge","Program patterns knowledge", "Work with Mathcad", "Work with AutoCAD", "Work with OmniGraffle", "Robots designing", "Consert organization", "Game design", "Game development", "Creating web-pages", "Math knowledge"]
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var menuHeigthConstraint: NSLayoutConstraint!
    @IBOutlet var menuOpenWidth: NSLayoutConstraint!
    @IBOutlet weak var addMenuButton: UIButton!
    @IBOutlet weak var barHeigthBig: NSLayoutConstraint!
    
    
    
    private var field: UITextField!
    private var newButtonXP: UIButton!
    private var menuIsOpen = false
    
    private var query = ""
    private var filtered = [Experience]()
    
    
    private let context = PersistentService.persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Experience>!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    let progressBar: UIProgressView = {
        let prgressView = UIProgressView()
        prgressView.progress = 0.0
        prgressView.progressTintColor = UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0)
        prgressView.trackTintColor = UIColor(red:0.16, green:0.16, blue:0.15, alpha:1.0)
        prgressView.layer.cornerRadius = 7
        prgressView.clipsToBounds = true
        prgressView.transform = CGAffineTransform(rotationAngle: .pi / -2)
        prgressView.translatesAutoresizingMaskIntoConstraints = false
        return prgressView
    }()
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addMenu(_ sender: Any) {
        menuIsOpen = !menuIsOpen
        menuHeigthConstraint.constant = menuIsOpen ? 200 : 44
        barHeigthBig.constant = !menuIsOpen ? view.frame.size.height - 185 : view.frame.size.height - 335
        field.resignFirstResponder()
        
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


extension XPViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedRC.fetchedObjects?.count ?? 0
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "XP item", for: indexPath) as! XPCellClass
        let object = fetchedRC.object(at: indexPath)
        cell.xpTitle.text = object.xpDesc
        return cell
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
                    self.progressBar.progress -= 0.01
                    self.refresh()
            },
                completion: { _ in
                    
                  
            })
        }
        
        tableView.reloadData()
    }
    

    func makeSlider() {
        
        let rect = CGRect(x: 0, y: 0, width: 600, height: 40)
        field = UITextField(frame: rect)
        makeField(field: field, name: "Your Experience")
        field.delegate = self
        field.returnKeyType = .continue
        addConstraint(item: field!, itemTo: menu!, constant: 20, atributeOne: NSLayoutConstraint.Attribute.left, atributeTwo: NSLayoutConstraint.Attribute.left)
        addConstraint(item: field!, itemTo: backButton!, constant: 51, atributeOne: NSLayoutConstraint.Attribute.top, atributeTwo: NSLayoutConstraint.Attribute.top)
        
        
        
        let buttonRect = CGRect(x: view.frame.size.width - 110, y: 130, width: 90, height: 50)
        newButtonXP = UIButton(frame: buttonRect)
        newButtonXP.setTitle("Add New", for: .normal)
        newButtonXP.setTitleColor(UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0), for: .normal)
        newButtonXP.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.15, alpha:1.0)
        newButtonXP.tintColor = UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0)
        newButtonXP.isEnabled = true
        newButtonXP.isHidden = false
        
        newButtonXP.addTarget(self, action: Selector(("addNewXP")), for: UIControl.Event.touchUpInside)
        
        newButtonXP.layer.cornerRadius = 10
        self.menu.addSubview(newButtonXP)
        
        
        addConstraint(item: field!, itemTo: newButtonXP!, constant: -20, atributeOne: NSLayoutConstraint.Attribute.right, atributeTwo: NSLayoutConstraint.Attribute.left)
        
        
        
        
    }
    
    
    @IBAction func addNewXP() {
        self.newButtonXP.pulsate()
        progressBar.progress += 0.01
        
        
        let data = Experience(entity: Experience.entity(), insertInto: self.context)
        data.xpDesc = field.text!
        PersistentService.saveContext()
        refresh()
        
        field.text = nil
        
        tableView.reloadData()
        
        
        
    }
    
    private func addConstraint(item: Any, itemTo: Any, constant: CGFloat, atributeOne: NSLayoutConstraint.Attribute, atributeTwo: NSLayoutConstraint.Attribute) {
        NSLayoutConstraint(item: item, attribute: atributeOne, relatedBy: NSLayoutConstraint.Relation.equal, toItem: itemTo, attribute: atributeTwo, multiplier: 1, constant: constant).isActive = true
        
    }
    private func makeField(field: UITextField, name: String) {
        
       
        field.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.15, alpha:1.0)
        field.minimumFontSize = 30
        field.layer.cornerRadius = 5
       
        field.attributedPlaceholder = NSAttributedString(string: name,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 0.6)])
        field.textColor = UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0)
        field.isEnabled = true
        field.translatesAutoresizingMaskIntoConstraints = false
        self.menu.addSubview(field)
        
        
    }
    
    
    private func refresh() {
        
        let request = Experience.fetchRequest() as NSFetchRequest<Experience>
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "xpDesc CONTAINS[cd] %@", query)
        }
        let sort = NSSortDescriptor(key: #keyPath(Experience.xpDesc), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.addSubview(progressBar)
        progressBar.centerXAnchor.constraint(equalTo: progressView.centerXAnchor).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        barHeigthBig = progressBar.widthAnchor.constraint(equalToConstant: view.frame.size.height - 185)
        barHeigthBig.isActive = true
        makeSlider()
    
       
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         refresh()
        if fetchedRC.fetchedObjects?.count == 0 {
            for item in customXP {
                let data = Experience(entity: Experience.entity(), insertInto: self.context)
                data.xpDesc = item
                PersistentService.saveContext()
                
            }
             refresh()
        }
        
         progressBar.progress = Float(fetchedRC.fetchedObjects?.count ?? 0) * 0.01
    }
    
}
extension XPViewController: UISearchBarDelegate {
    
    
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
