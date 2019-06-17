//
//  VerImagenViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 30/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class VerImagenViewController: UIViewController {
    @IBOutlet weak var mensajeLabel: UILabel!
    @IBOutlet weak var fotoRecibida: UIImageView!
    @IBOutlet weak var fechaLabel: UILabel!
    
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mensajeLabel.text = "Mensaje: " + snap.mensaje
        fechaLabel.text = "Fecha: " + snap.fecha
        fotoRecibida.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(self.snap.id).child("estado").setValue("T")
    }
    
    @IBAction func volverTapped(_ sender: Any) {
        let alerta = UIAlertController(title: "Eliminar", message: "¿Desea eliminar esta imagen?", preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "Eliminar", style: .default, handler: { (UIAlertAction) in
            
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(self.snap.id).removeValue()
            
            Storage.storage().reference().child("imagenes").child("\(self.snap.imagenID).jpg").delete{
                (error) in
                print("Se elimino la imagen correctamente.")
            }
            
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
