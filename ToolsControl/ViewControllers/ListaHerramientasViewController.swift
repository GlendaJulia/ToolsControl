//
//  ElegirUsuarioViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 27/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ListaHerramientasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listaHerramientas: UITableView!
    
    var herramientas:[Herramienta] = []
    var herramientaselect = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaHerramientas.delegate = self
        listaHerramientas.dataSource = self
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
            
            self.herramientas.append(herramienta)
            self.listaHerramientas.reloadData()
        })
        
//        Database.database().reference().child("herramientas").observe(DataEventType.childChanged, with: { (snapshot) in
//            self.listaHerramientas.reloadData()
//        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if herramientas.count == 0{
            return 1
        }else{
            return herramientas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if herramientas.count == 0{
            cell.textLabel?.text = "Historial vacio 😢"
        }else{
            let herr = herramientas[indexPath.row]
            cell.textLabel?.text = herr.nombre
            cell.detailTextLabel?.text = herr.cantidad
            cell.imageView?.sd_setImage(with: URL(string: herr.imagenURL), completed: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recursoSeleccionado = herramientas[indexPath.row]
        self.herramientaselect = recursoSeleccionado.id
        self.performSegue(withIdentifier: "editarherramienta", sender: recursoSeleccionado)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarherramienta"{
            let sendImageVC = segue.destination as! herramientaViewController
            sendImageVC.herramienta = sender as! Herramienta
            sendImageVC.accion = "Actualizar"
        } else if segue.identifier == "crearHerramienta"{
            let sendImageVC = segue.destination as! herramientaViewController
            sendImageVC.accion = "Crear"
        }
    }

}
