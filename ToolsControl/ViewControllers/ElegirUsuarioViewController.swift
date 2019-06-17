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

class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listaUsuarios: UITableView!
    
    var usuarios:[Usuario] = []
    var usuarioselect = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded,
        with: {(snapshot) in
            print(snapshot)
            
            let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
            usuario.perfilURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            usuario.uid = snapshot.key
            if usuario.email != Auth.auth().currentUser?.email{
                self.usuarios.append(usuario)
            }
            self.listaUsuarios.reloadData()
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
        self.performSegue(withIdentifier: "enviarimagen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviarimagen"{
            let sendImageVC = segue.destination as! imagenViewController
            sendImageVC.usuarioID = self.usuarioselect
        }
    }

}
