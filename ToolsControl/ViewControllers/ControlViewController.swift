//
//  ControlViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 27/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ControlViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var tableViewRecibidos: UITableView!
    var usuarios:[Usuario] = []
    
    var glenda = ""
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRecibidos.delegate = self
        tableViewRecibidos.dataSource = self
        
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded,
        with: {(snapshot) in
            print(snapshot)
                                                                    
        let usuario = Usuario()
        usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
        usuario.perfilURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
        usuario.uid = snapshot.key
        
        self.usuarios.append(usuario)
        self.tableViewRecibidos.reloadData()
        })
        
        print((Auth.auth().currentUser?.uid)!)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        
        var cont = devolver(correo: usuario.email)
        cell.textLabel?.text = "\(usuario.email) ( \(cont) mensajes recibidos)"
        cell.imageView?.sd_setImage(with: URL(string: usuario.perfilURL), completed: nil)
        return cell
    }
    
    func devolver(correo: String)->Int{
       var snaps: [Snap] = []
        var cont = 0
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            let snap = Snap()
            
            snap.from = (snapshot.value as! NSDictionary) ["from"] as! String
            print("///")
            print(snap.from)
            print(correo)
            print("///")
            if correo == snap.from{
                snaps.append(snap)
                print("entro")
                cont = cont + 1
                print(cont)
            }
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
                var iterator = 0
                for snap in snaps{
                    if snap.id == snapshot.key{
                        snaps.remove(at: iterator)
                    }
                    iterator += 1
                }
            })
        })
        
        return cont
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recursoSeleccionado = usuarios[indexPath.row]
        self.glenda = recursoSeleccionado.email
        performSegue(withIdentifier: "verpersonal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verpersonal"{
            let siguienteVC = segue.destination as! SubViewController
            siguienteVC.fromm = self.glenda
        }
    }

}
