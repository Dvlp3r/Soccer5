//
//  GameNavigationController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/19/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class GameNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Do any additional setup after loading the view.

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}
