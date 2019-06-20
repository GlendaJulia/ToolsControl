//
//  EmpleadoViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 6/17/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase

class EmpleadoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate   {
    
    @IBOutlet weak var tablePrestados: UITableView!
    
    var snaps2: [Snap] = []
    var userS = Usuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePrestados.delegate = self
        tablePrestados.dataSource = self
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("prestados").observe(DataEventType.childAdded, with: { (snapshot) in
            let snap = Snap()
            snap.nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            snap.fecha = (snapshot.value as! NSDictionary)["fecha"] as! String
            snap.id = snapshot.key
            snap.estado = (snapshot.value as! NSDictionary)["estado"] as! String
            snap.responsable = (snapshot.value as! NSDictionary)["responsable"] as! String
            snap.condiciones = (snapshot.value as! NSDictionary)["condiciones"] as! String
            snap.herramientaID = (snapshot.value as! NSDictionary)["herramientaID"] as! String
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            self.snaps2.append(snap)
            self.tablePrestados.reloadData()
            
        })
    }

    @IBAction func cerrarSesion(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps2.count == 0{
            return 1
        }else{
            return snaps2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps2.count == 0{
            cell.textLabel?.text = "No debe herramientas"
        }else{
            let snap = snaps2[indexPath.row]
            cell.textLabel?.text = snap.nombre
            if snap.estado == "F"{
                cell.backgroundColor = UIColor.cyan
            }else{
                cell.backgroundColor = UIColor.white
            }
        }
        return cell
    }
}
