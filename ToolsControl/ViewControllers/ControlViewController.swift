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
    var user = Usuario()
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRecibidos.delegate = self
        tableViewRecibidos.dataSource = self
        
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded,
        with: {(snapshot) in                                 
        let usuario = Usuario()
        usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
        usuario.perfilURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
        usuario.nombre = (snapshot.value as! NSDictionary)["nombres"] as! String
        usuario.apellido = (snapshot.value as! NSDictionary)["apellidos"] as! String
        usuario.uid = snapshot.key
        if usuario.email != Auth.auth().currentUser?.email{
                self.usuarios.append(usuario)
        }
        self.tableViewRecibidos.reloadData()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let usuariou = usuarios[indexPath.row]
        cell.textLabel?.text = "\(usuariou.nombre) \(usuariou.apellido)"
        cell.imageView?.sd_setImage(with: URL(string: usuariou.perfilURL), completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recursoSeleccionado = usuarios[indexPath.row]
        performSegue(withIdentifier: "verpersonal", sender: recursoSeleccionado)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verpersonal"{
            let siguienteVC = segue.destination as! SubViewController
            siguienteVC.userS = sender as! Usuario
        }else if segue.identifier == "editarUsuario"{
            let siguienteVC = segue.destination as! EditarUserViewController
            siguienteVC.user = user as! Usuario
        }
    }

    @IBAction func editarUser(_ sender: Any) {
        performSegue(withIdentifier: "editarUsuario2", sender: nil)
    }
}
