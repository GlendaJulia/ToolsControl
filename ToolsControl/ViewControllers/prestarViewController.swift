//
//  mensajeViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 29/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase

class prestarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var usuarioenviar = ""
    var tipo = ""
    var herramientas:[Herramienta] = []

    @IBOutlet weak var tableViewherramientas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewherramientas.dataSource = self
        tableViewherramientas.delegate = self
        
        Database.database().reference().child("herramientas").observe(DataEventType.childAdded,
        with: {(snapshot) in
        print(snapshot)
        let herramienta = Herramienta()
        herramienta.nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
        herramienta.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
        herramienta.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
        herramienta.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
        herramienta.cantidad = (snapshot.value as! NSDictionary)["cantidad"] as! String
        herramienta.id = snapshot.key
            if self.tipo == "btn1"{
                if herramienta.tipo == "Seguridad"{
                    self.herramientas.append(herramienta)
                }
            }else if self.tipo == "btn2"{
                if herramienta.tipo == "Herramienta"{
                    self.herramientas.append(herramienta)
                }
            }
            else if self.tipo == "btn3"{
                if herramienta.tipo == "Maquina"{
                    self.herramientas.append(herramienta)
                }
            }else{
                self.herramientas.append(herramienta)
            }
        self.tableViewherramientas.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if herramientas.count == 0 {
            return 1
        }else{
            return herramientas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if herramientas.count == 0{
            cell.textLabel?.text = "No existe ninguna herramienta de este tipo 😢"
        }else{
            let herr = herramientas[indexPath.row]
            cell.textLabel?.text = herr.nombre
            cell.imageView?.sd_setImage(with: URL(string: herr.imagenURL), completed: nil)
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .insert{
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let botonInsertar = UITableViewRowAction(style: .normal, title: "Insertar")
        { (accionesFila, indiceFila) in
            let herr = self.herramientas[indexPath.row]
            var cant = Int(herr.cantidad)!
            if cant > 0{
                let mensaje = ["responsable" : Auth.auth().currentUser?.email, "herramientaID" : herr.id, "nombre" : herr.nombre, "fecha":self.getDate(), "estado": "F","condicion": "", "imagenURL":herr.imagenURL]
                
                Database.database().reference().child("usuarios").child(self.usuarioenviar).child("prestados").childByAutoId().setValue(mensaje)
                cant = cant - 1
                Database.database().reference().child("herramientas").child(herr.id).child("cantidad").setValue(String(cant))
            }else{
                let alerta = UIAlertController(title: "Oh no!", message: "Ya no hay la herramienta en el inventario. Lo sentimos, no puedes realizar el prestamo.", preferredStyle: .alert)
                
                let btnOk = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                
                alerta.addAction(btnOk)
                self.present(alerta, animated: true, completion: nil)
            }
        }
        botonInsertar.backgroundColor = UIColor.green
        return[botonInsertar]
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
}
