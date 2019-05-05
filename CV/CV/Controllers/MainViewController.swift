//
//  ViewController.swift
//  CV
//
//  Created by Roman Mishchenko on 5/1/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import UIKit
import CoreData


class MainViewController: UIViewController {
    
    
    @IBOutlet weak var photoW: NSLayoutConstraint!
    @IBOutlet weak var photoH: NSLayoutConstraint!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    
    @IBOutlet weak var photoHCon: UIView!
    @IBOutlet weak var photoHMargin: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dob: UIDatePicker!
    @IBOutlet weak var menu: UIView!
    @IBOutlet var menuHeigthConstraint: NSLayoutConstraint!
    @IBOutlet var menuOpenWidth: NSLayoutConstraint!
    @IBOutlet weak var addMenuButton: UIButton!
    var imagePicker: ImagePicker!
    
    @IBOutlet weak var image: UIButton!
    @IBAction func pickImage(_ sender: Any) {
        image.pulsate()
        self.imagePicker.present(from: sender as! UIView)
    }

    private var educationButton: UIButton!
    private var skillButton: UIButton!
    private var xpButton: UIButton!
    private var easterEggButton: UIButton!
    private var saveButon: UIButton!
    private var menuIsOpen = false
    private var easterEgg: Int = 0
    
    private let context = PersistentService.persistentContainer.viewContext
    private var mainInfo = [MainInfo]()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func addMenu(_ sender: Any) {
        menuIsOpen = !menuIsOpen
        menuHeigthConstraint.constant = menuIsOpen ? 200 : 44
        easterEgg += 1
        if easterEgg == 11 {
            easterEggButton = makeButton(x: 20, y: 65, title: "Secret", target: "showSecret")
            menu.addSubview(easterEggButton)
        }
        UIView.animate(
            withDuration: 0.33,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                let angle: CGFloat = self.menuIsOpen ? .pi : 0.0
                self.addMenuButton.transform = CGAffineTransform(rotationAngle: angle)
                self.view.layoutIfNeeded()
                
        },
            completion: nil)
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dob.setValue(UIColor.orange, forKeyPath: "textColor")
        dob.setValue(false, forKey: "highlightsToday")

    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoH.constant = (view.frame.size.height / 3)
        self.photoW.constant = (view.frame.size.width / 2.5)
       // self.photoHCon.consta
//        self.photoHMargin.constant = (view.frame.size.height / 10)
        let animationArray = [nameField,surnameField,numberField,mailField]
        let animationArrayL = [nameLabel,surnameLabel,phoneLabel,mailLabel]
        var k: Double = 0
        nameField.alpha = 0
        surnameField.alpha = 0
        numberField.alpha = 0
        mailField.alpha = 0
        nameLabel.alpha = 0
        surnameLabel.alpha = 0
        phoneLabel.alpha = 0
        mailLabel.alpha = 0
        dobLabel.alpha = 0
        dob.alpha = 0
        image.alpha = 0
        for i in 0...(animationArray.count - 1) {
            UIView.transition(
                with: view,
                duration: 2.0 + k,
                options: .transitionCrossDissolve,
                animations: {
                    animationArray[i]!.alpha = 1
                    animationArrayL[i]!.alpha = 1
                    if i == (animationArray.count - 1) {
                        self.dobLabel.alpha = 1
                        self.dob.alpha = 1
                        self.image.alpha = 1
                    }
            },
                completion: { _ in
            })
            k += 0.4
        }
        
        
        
        
        makeSlider()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        do {
            mainInfo = try context.fetch(MainInfo.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
       
        if mainInfo.count == 0 {
            
            nameField.text! = "Roman"
            surnameField.text! = "Mishchenko"
            numberField.text! = "+380954106945"
            mailField.text! = "romanmishchenko34@icloud.com"
            var myDob = DateComponents()
            myDob.year = 2000
            myDob.month = 8
            myDob.day = 12
            dob.date = Calendar.current.date(from: myDob)!
            image.setImage(UIImage(named: "customPhoto.jpg"), for: .normal)
            
        } else {
        
            nameField.text! = mainInfo[0].name!
            surnameField.text! = mainInfo[0].surname!
            numberField.text! = mainInfo[0].number!
       
            mailField.text! = mainInfo[0].eMail!
       
            dob.date = mainInfo[0].dob! as Date
      
            image.setImage(UIImage(data: mainInfo[0].photo! as Data), for: .normal)
        }
    }
    
    func makeButton(x: CGFloat, y: CGFloat, title: String, target: String) -> UIButton {
        let buttonRect = CGRect(x: x, y: y, width: 90, height: 50)
        let button = UIButton(frame: buttonRect)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0), for: .normal)
        button.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.15, alpha:1.0)
        button.tintColor = UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0)
        button.isEnabled = true
        button.isHidden = false
        
        button.addTarget(self, action: Selector((target)), for: UIControl.Event.touchUpInside)
        
        button.layer.cornerRadius = 10
        return button
    }
    
    func makeSlider() {

        educationButton = makeButton(x: view.frame.size.width - 110, y: 130, title: "Education", target: "showEducation")
        xpButton = makeButton(x: (view.frame.size.width-90)/2, y: 130, title: "Expirience", target: "showXP")
        skillButton = makeButton(x: 20, y: 130, title: "Skills", target: "showSkills")
        saveButon = makeButton(x: (view.frame.size.width-90)/2, y: 65, title: "Save Info", target: "saveInfo")
        self.menu.addSubview(educationButton)
        self.menu.addSubview(xpButton)
        self.menu.addSubview(skillButton)
        self.menu.addSubview(saveButon)
        
    }
    
    @IBAction func saveInfo() {
        saveButon.pulsate()
        let moc = PersistentService.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MainInfo")
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [MainInfo]
        for object in resultData
        {
                moc.delete(object)
        }
        
        do {
            try self.context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {}
        
        let info = MainInfo(entity: MainInfo.entity(), insertInto: context)
        info.name = nameField.text!
        info.surname = surnameField.text!
        info.number = numberField.text!
        info.eMail = mailField.text!
        info.dob = dob.date as NSDate
        info.photo = image.imageView?.image?.pngData() as NSData?
        PersistentService.saveContext()
    }
    
    @IBAction func showEducation() {
        educationButton.pulsate()
       
        performSegue(withIdentifier: "Show Education", sender: self)
      
        
    }
    @IBAction func showXP() {
        xpButton.pulsate()
        performSegue(withIdentifier: "Show XP", sender: self)
        
        
    }
    @IBAction func showSkills() {
        skillButton.pulsate()
        
        performSegue(withIdentifier: "Show Skills", sender: self)
        
        
    }
    @IBAction func showSecret() {
        easterEggButton.pulsate()
       
        performSegue(withIdentifier: "Show Secret", sender: self)
        
        
    }
    
    
    
    private func addConstraint(item: Any, itemTo: Any, constant: CGFloat, atributeOne: NSLayoutConstraint.Attribute, atributeTwo: NSLayoutConstraint.Attribute) {
        NSLayoutConstraint(item: item, attribute: atributeOne, relatedBy: NSLayoutConstraint.Relation.equal, toItem: itemTo, attribute: atributeTwo, multiplier: 1, constant: constant).isActive = true
        
    }
    
}

extension UIDatePicker {
    
    var textColor: UIColor? {
        set {
            setValue(newValue, forKeyPath: "textColor")
        }
        get {
            return value(forKeyPath: "textColor") as? UIColor
        }
    }
    
}

extension MainViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil {
            self.image.setImage(image, for: .normal)
        }
    }
}
