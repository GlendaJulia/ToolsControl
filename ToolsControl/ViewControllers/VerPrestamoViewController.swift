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

class VerPrestamoViewController: UIViewController {
    @IBOutlet weak var mensajeLabel: UILabel!
    @IBOutlet weak var fotoRecibida: UIImageView!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var condicionText: UITextField!
    @IBOutlet weak var responsableLabel: UILabel!
    
    var snap = Snap()
    var user = Usuario()
    let alert2 = UIAlertController(title: "Ups!", message: "Tiene que ingresar la condicion de la herramienta devuelta", preferredStyle: .alert)
    
    let btnCancel2 = UIAlertAction(title: "Volver", style: .default, handler: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fechaLabel.text = "Fecha: " + snap.fecha
        fotoRecibida.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
        mensajeLabel.text = "Nombre: " + snap.nombre
        responsableLabel.text = "Responsable: " + snap.responsable
        condicionText.text = snap.condiciones
    }
    
    @IBAction func volverTapped(_ sender: Any) {
        let alerta = UIAlertController(title: "Devolver", message: "¿La herramienta ha sido devuelta?", preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "De vuelta", style: .default, handler: { (UIAlertAction) in
       
            if self.condicionText.text != ""{
                Database.database().reference().child("usuarios").child(self.user.uid).child("prestados").child(self.snap.id).child("estado").setValue("T")
               
                Database.database().reference().child("herramientas").child(self.snap.herramientaID).child("cantidad").observeSingleEvent(of: .value, with:{(snapshot) in
                    let dato = snapshot.value as! String
                    let cant = Int(dato)! + 1
                    Database.database().reference().child("herramientas").child(self.snap.herramientaID).child("cantidad").setValue(String(cant))
                })
                
                Database.database().reference().child("usuarios").child(self.user.uid).child("prestados").child(self.snap.id).child("condicion").setValue(self.condicionText.text)
                
                self.navigationController?.popViewController(animated: true)
            }else{
                self.alert2.addAction(self.btnCancel2)
                self.present(self.alert2, animated: true, completion: nil)
            }
            
        })
        let btnCancel = UIAlertAction(title: "Volver", style: .default, handler: {(UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        })
        
        alerta.addAction(btnOK)
        alerta.addAction(btnCancel)
        self.present(alerta, animated: true, completion: nil)
    }
    

}
