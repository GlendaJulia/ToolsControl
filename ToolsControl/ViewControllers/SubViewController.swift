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
    var fromm = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSub.delegate = self
        tableViewSub.dataSource = self
        print(self.fromm)
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            let snap = Snap()
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            snap.from = (snapshot.value as! NSDictionary) ["from"] as! String
            snap.mensaje = (snapshot.value as! NSDictionary)["mensaje"] as! String
            snap.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
            snap.fecha = (snapshot.value as! NSDictionary)["fecha"] as! String
            snap.id = snapshot.key
            snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            snap.estado = (snapshot.value as! NSDictionary)["estado"] as! String
            if snap.from == self.fromm{
                self.snaps2.append(snap)
            }
            self.tableViewSub.reloadData()
            
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
                var iterator = 0
                for snap in self.snaps2{
                    if snap.id == snapshot.key{
                        self.snaps2.remove(at: iterator)
                    }
                    iterator += 1
                }
                self.tableViewSub.reloadData()
            })
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
            cell.textLabel?.text = "Chat vacio 😢"
        }else{
            let snap = snaps2[indexPath.row]
            cell.textLabel?.text = snap.mensaje
            if snap.estado == "F"{
                if snap.tipo == "mensaje"{
                    cell.backgroundColor = UIColor.yellow
                }else{
                    cell.backgroundColor = UIColor.cyan
                }
            }else{
                cell.backgroundColor = UIColor.white
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps2[indexPath.row]
        if snap.tipo == "imagen"{
            performSegue(withIdentifier: "verimagen", sender: snap)
        }else{
            performSegue(withIdentifier: "vermensaje", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verimagen"{
            let siguienteVC = segue.destination as! VerImagenViewController
            siguienteVC.snap = sender as! Snap
        }else if segue.identifier == "vermensaje"{
            let nextVC = segue.destination as! VerMensajeViewController
            nextVC.snap2 = sender as! Snap
        }
    }

    
}
