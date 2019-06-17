//
//  VerMensajeViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 30/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase

class VerMensajeViewController: UIViewController {

    @IBOutlet weak var mensajeText: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    
    var snap2 = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mensajeText.text = "Mensaje: " + snap2.mensaje
        fechaLabel.text = "Fecha: " + snap2.fecha
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(self.snap2.id).child("estado").setValue("T")
    }
    
    @IBAction func volverActionjeje(_ sender: Any) {
        let alerta = UIAlertController(title: "Eliminar", message: "¿Desea eliminar este mensaje?", preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "Eliminar", style: .default, handler: { (UIAlertAction) in
            
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(self.snap2.id).removeValue()
            
            self.navigationController?.popViewController(animated: true)
        })
        let btnCancel = UIAlertAction(title: "Conservar", style: .default, handler: {(UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        })
        
        alerta.addAction(btnOK)
        alerta.addAction(btnCancel)
        self.present(alerta, animated: true, completion: nil)
    }

}
