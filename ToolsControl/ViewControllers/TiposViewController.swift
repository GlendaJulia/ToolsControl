//
//  TiposViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 6/18/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit

class TiposViewController: UIViewController {

    var usuarioenviar = ""
    var tipo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func Button1(_ sender: Any) {
        self.tipo = "btn1"
        self.performSegue(withIdentifier: "prestarHerramienta", sender: nil)
    }
    @IBAction func Button2(_ sender: Any) {
        self.tipo = "btn2"
        self.performSegue(withIdentifier: "prestarHerramienta", sender: nil)
    }
    @IBAction func Button3(_ sender: Any) {
        self.tipo = "btn3"
        self.performSegue(withIdentifier: "prestarHerramienta", sender: nil)
    }
    @IBAction func Button4(_ sender: Any) {
        self.tipo = "btn4"
        self.performSegue(withIdentifier: "prestarHerramienta", sender: nil)
    }
    
    

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "prestarHerramienta"{
        let sendImageVC = segue.destination as! prestarViewController
        sendImageVC.usuarioenviar = self.usuarioenviar
        sendImageVC.tipo = self.tipo
    }
}
}
