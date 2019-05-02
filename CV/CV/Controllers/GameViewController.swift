//
//  GameViewController.swift
//  CV
//
//  Created by Roman Mishchenko on 5/1/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

   
    
    @IBOutlet weak var attackButton: UIButton!
    @IBOutlet weak var hpView: UIView!
    @IBOutlet weak var progressView: UIView!
    let progressBar: UIProgressView = {
        let prgressView = UIProgressView()
        prgressView.progress = 1
        prgressView.progressTintColor = UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0)
        prgressView.trackTintColor = UIColor(red:0.20, green:0.18, blue:0.15, alpha:1.0)
        prgressView.layer.cornerRadius = 7
        prgressView.clipsToBounds = true
        prgressView.translatesAutoresizingMaskIntoConstraints = false
        return prgressView
    }()
    
    let enemyHpBar: UIProgressView = {
        let prgressView = UIProgressView()
        prgressView.progress = 1
        prgressView.progressTintColor = UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.0)
        prgressView.trackTintColor = UIColor(red:0.16, green:0.16, blue:0.15, alpha:1.0)
        prgressView.layer.cornerRadius = 7
        prgressView.clipsToBounds = true
        prgressView.translatesAutoresizingMaskIntoConstraints = false
        return prgressView
    }()
    
    var timer = Timer()
    var opened = true
    func createTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateBar),
            userInfo: nil,
            repeats: true)
    }
    @objc func updateBar() {
        
        if progressBar.progress != 0 {
            progressBar.progress -= 0.04
        } else if opened {
             dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func attackAction(_ sender: Any) {
            if enemyHpBar.progress != 0 {
                enemyHpBar.progress -= 0.01
            } else {
                
                progressBar.progress = 1.0
                performSegue(withIdentifier: "Show Easter Egg", sender: self)
                
            }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.addSubview(progressBar)
        hpView.addSubview(enemyHpBar)
        createTimer()
        
        
        progressBar.centerXAnchor.constraint(equalTo: progressView.centerXAnchor).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        progressBar.widthAnchor.constraint(equalToConstant: 48*5).isActive = true
        
        enemyHpBar.centerXAnchor.constraint(equalTo: hpView.centerXAnchor).isActive = true
        enemyHpBar.centerYAnchor.constraint(equalTo: hpView.centerYAnchor).isActive = true
        enemyHpBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        enemyHpBar.widthAnchor.constraint(equalToConstant: 48*5).isActive = true

    }
    

   

}
