//
//  ReportVC.swift
//  Scoops
//
//  Created by Vicente de Miguel on 24/2/16.
//  Copyright © 2016 Vicente de Miguel. All rights reserved.
//

import UIKit

class ReportVC: UIViewController {
    
    //modelo de noticia que se ha seleccionado
    var model : AnyObject = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("seleccionado el \(model)")
    }

}
