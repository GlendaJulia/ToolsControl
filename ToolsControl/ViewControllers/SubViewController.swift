//
//  SubViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 30/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase

class SubViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableViewSub: UITableView!
    var snaps2: [Snap] = []
    var userS = Usuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSub.delegate = self
        tableViewSub.dataSource = self
        
        Database.database().reference().child("usuarios").child(self.userS.uid).child("prestados").observe(DataEventType.childAdded, with: { (snapshot) in
            let snap = Snap()
            snap.nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            snap.fecha = (snapshot.value as! NSDictionary)["fecha"] as! String
            snap.id = snapshot.key
            snap.estado = (snapshot.value as! NSDictionary)["estado"] as! String
            snap.responsable = (snapshot.value as! NSDictionary)["responsable"] as! String
            snap.condiciones = (snapshot.value as! NSDictionary)["condicion"] as! String
            snap.herramientaID = (snapshot.value as! NSDictionary)["herramientaID"] as! String
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            self.snaps2.append(snap)
            self.tableViewSub.reloadData()
            
        })
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
            cell.detailTextLabel?.text = snap.fecha
            if snap.estado == "F"{
                cell.backgroundColor = UIColor.cyan
            }else{
                cell.backgroundColor = UIColor.white
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps2[indexPath.row]
        performSegue(withIdentifier: "verprestamo", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verprestamo"{
            let siguienteVC = segue.destination as! VerPrestamoViewController
            siguienteVC.snap = sender as! Snap
            siguienteVC.user = userS as! Usuario
        }
    }

    
}
