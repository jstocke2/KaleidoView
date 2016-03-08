//
//  ViewController.swift
//  KaleidoView
//
//  Created by Jake Stocker on 3/3/16.
//  Copyright © 2016 Jake Stocker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        let topView = self.view as! KaleidoView
        topView.startDrawing()
        
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        let topView = self.view as! KaleidoView
        topView.stopDrawing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

