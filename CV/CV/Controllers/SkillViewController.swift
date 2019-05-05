//
//  AppDelegate.swift
//  CollectionView
//
//  Created by Roman Mishchenko on 4/7/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import UIKit
import CoreData

struct customSkill {
    var skill: String!
    var category: String!
}


class SkillViewController: UIViewController {
    
     let customSkills: [customSkill] = [customSkill.init(skill: "C++ programming", category: "Hard skills"), customSkill.init(skill: "Swift programming", category: "Hard skills"), customSkill.init(skill: "CoreData skills", category: "Hard skills"), customSkill.init(skill: "SpriteKit skills", category: "Hard skills"), customSkill.init(skill: "iOS programming", category: "Hard skills"), customSkill.init(skill: "Analytical thinking", category: "Soft skills"), customSkill.init(skill: "Punctuality", category: "Soft skills"), customSkill.init(skill: "Creativity", category: "Soft skills"),customSkill.init(skill: "Honesty", category: "Soft skills"), customSkill.init(skill: "Studious", category: "Soft skills"), customSkill.init(skill: "Desire to learn", category: "Soft skills"), customSkill.init(skill: "TeamWork skills", category: "Soft skills"), customSkill.init(skill: "English", category: "Languages"), customSkill.init(skill: "Ukrainian", category: "Languages"), customSkill.init(skill: "Russian", category: "Languages"),customSkill.init(skill: "Assembly skills", category: "Hard skills"),customSkill.init(skill: "SwiftJSON", category: "Hard skills")]
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    private var query = ""
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = PersistentService.persistentContainer.viewContext
    private var isFiltered = false
    private var fetchedRC: NSFetchedResultsController<Skill>!
    private var filtered = [Skill]()
    
    
    @IBAction func backAction(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addItem() {
        
        let alert = UIAlertController(title: "Add New Skill", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Your new Skill"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Your skill Category"
        }
        
        let action = UIAlertAction(title: "Add new", style: .default) { (_) in
            
            var newText = alert.textFields!.first!.text!
            let nsField = alert.textFields!.first!.text! as NSString
            if nsField.length > 18 {
                newText = nsField.substring(with: NSRange(location: 0, length: nsField.length > 18 ? 18 : nsField.length))
            }
            
            var newCat = alert.textFields!.last!.text!
            let nsCat = alert.textFields!.last!.text! as NSString
            if nsCat.length > 18 {
                newCat = nsCat.substring(with: NSRange(location: 0, length: nsCat.length > 18 ? 18 : nsCat.length))
            }
        
            
            if newCat == "" {
                newCat = "Unknown category"
            }
            let data = Skill(entity: Skill.entity(), insertInto: self.context)
            data.skillName = newText
            data.category = newCat
            PersistentService.saveContext()
            self.refresh()
            
            
            
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default)
        { (_) in
            print("Canceled!")
        }
        alert.addAction(actionCancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
       
        PersistentService.saveContext()
        refresh()
        
    }
    @IBAction func deleteSelected(){
        if let selected = collectionView.indexPathsForSelectedItems {
            
            
            let moc = context
            for item in selected {
                moc.delete(fetchedRC.object(at: item))
            }
            do {
                try moc.save()
                print("saved!")
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            } catch {}
            
            refresh()
            
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 10) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        navigationController?.isToolbarHidden = true
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red:1.00, green:0.58, blue:0.00, alpha:1.0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
        
        if fetchedRC.fetchedObjects?.count == 0 {
            for item in customSkills {
                let data = Skill(entity: Skill.entity(), insertInto: self.context)
                data.skillName = item.skill
                data.category = item.category
                PersistentService.saveContext()
               
            }
            refresh()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        
        super.setEditing(editing, animated: animated)
       
        
        searchBar.isHidden = editing
        query = ""
        searchBar.text = nil
        searchBar.resignFirstResponder()
        refresh()
        
        navigationItem.leftBarButtonItem?.isEnabled = !editing
        
        collectionView.allowsMultipleSelection = editing
        collectionView.indexPathsForSelectedItems?.forEach {
            collectionView.deselectItem(at: $0, animated: false)
        }
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths
        {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.isEditing = editing
        }
        
        
        
        navigationController?.setToolbarHidden(!editing, animated: animated)
        
    }
    
    
    
    
    private func refresh() {
        let request = Skill.fetchRequest() as NSFetchRequest<Skill>
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "skillName CONTAINS[cd] %@", query)
        }
        let sort = NSSortDescriptor(key: #keyPath(Skill.skillName), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let category = NSSortDescriptor(key: #keyPath(Skill.category), ascending: true)
        request.sortDescriptors = [category, sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(Skill.category), cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        collectionView.reloadData()
    }
    
}

extension SkillViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedRC.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let sections = fetchedRC.sections, let objs = sections[section].objects else {
            return 0
        }
        return objs.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderRow", for: indexPath)
        if let label = view.viewWithTag(1000) as? UILabel {
            if let skills = fetchedRC.sections?[indexPath.section].objects as? [Skill], let skill = skills.first {
                label.text = "Category name: " + (skill.category ?? "Nan")
            }
        }
        return view
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let skill = fetchedRC.object(at: indexPath)
        cell.titleLabel.text = skill.skillName
        cell.isEditing = isEditing
        
        
        
        return cell
    }
    
    
    
}

extension SkillViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let txt = searchBar.text else {
            return
        }
        query = txt
        refresh()
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        query = ""
        searchBar.text = nil
        searchBar.resignFirstResponder()
        refresh()
        collectionView.reloadData()
    }
}


