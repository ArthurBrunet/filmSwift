//
//  ViewDetailController.swift
//  film
//
//  Created by Dev Trop-plus on 15/03/2022.
//

import SwiftUI

class ViewDetailController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    var movie : Movie?
    // quand la vue apparaît, après sa création
    override func viewDidLoad() {
        super.viewDidLoad();
        name.text = "test"
    }
}
