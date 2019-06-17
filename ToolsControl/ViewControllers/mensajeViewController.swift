//
//  mensajeViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 29/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase

class mensajeViewController: UIViewController {
    var usuarioID = ""
    
    var usuarioenviar = ""
    var urlimage = ""

    
    @IBOutlet weak var mensajeText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getDate ()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    @IBAction func enviarMensajeTaped(_ sender: Any) {
        let mensaje = ["from" : Auth.auth().currentUser?.email, "tipo" : "mensaje", "mensaje" : self.mensajeText.text!, "fecha":self.getDate(), "estado": "F","imagenURL": "", "imagenID": ""]
        
        Database.database().reference().child("usuarios").child(self.usuarioenviar).child("snaps").childByAutoId().setValue(mensaje)
        self.navigationController?.popViewController(animated: true)
    }
}
