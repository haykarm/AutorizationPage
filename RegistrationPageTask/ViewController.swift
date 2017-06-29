//
//  ViewController.swift
//  Task
//
//  Created by MacBook on 6/27/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func registrationButtonAction(_ sender: UIButton) {
        let registrationController = self.storyboard?.instantiateViewController(withIdentifier: "ResgistrationPageViewController") as! ResgistrationPageViewController
        self.navigationController?.pushViewController(registrationController, animated: true)
        
    }
}

