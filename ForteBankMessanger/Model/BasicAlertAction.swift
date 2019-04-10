//
//  File.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 4/2/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import UIKit

struct BasicAlertAction {
    
    let title: String
    let style: UIAlertAction.Style
    let icon: String
    let switchViewController: UIViewController
    
    func handler(presentationViewController: UIViewController) {
        presentationViewController.navigationController?.pushViewController(switchViewController, animated: true)
    }
}
