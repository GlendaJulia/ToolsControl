//
//  ElegirUsuarioMensajeViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 29/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ElegirUsuarioMensajeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView2: UITableView!
    
    var usuarios:[Usuario] = []
    
    var usuarioselect = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView2.delegate = self
        tableView2.dataSource = self
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded,
        with: {(snapshot) in
        print(snapshot)
                                                                    
        let usuario = Usuario()
        usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
        usuario.uid = snapshot.key
            if usuario.email != Auth.auth().currentUser?.email{
                self.usuarios.append(usuario)
            }
        self.tableView2.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        cell.imageView?.sd_setImage(with: URL(string: usuario.perfilURL), completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recursoSeleccionado = usuarios[indexPath.row]
        self.usuarioselect = recursoSeleccionado.uid
        self.performSegue(withIdentifier: "enviarmensaje", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviarmensaje"{
            let sendImageVC = segue.destination as! mensajeViewController
            sendImageVC.usuarioenviar = self.usuarioselect
        }
    }

}
