//
//  ViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 27/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var mail = ""
    var pass = ""
    var tipo = ""
    var user = Usuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.text = mail
        self.passwordTextField.text = pass
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Intentando iniciar sesion")
            if error != nil {
                print("Error: \(error)")
                let alerta = UIAlertController(title: "Usuario no existe", message: "El Usuario: \(self.emailTextField.text!) no existe :( , CREALO!", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Registrar", style: .default, handler: { (UIAlertAction) in
                    
                    self.performSegue(withIdentifier: "segueregister", sender: nil)
                })
                let btnCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
                
                alerta.addAction(btnOK)
                alerta.addAction(btnCancel)
                self.present(alerta, animated: true, completion: nil)
            }else{
                print("Inicio de sesion exitoso")
                
                Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tipo").observeSingleEvent(of: .value, with:{(snapshot) in
                    self.tipo = snapshot.value as! String
                    if self.tipo == "administrador"{
                        self.performSegue(withIdentifier: "iniciarsesionadminsegue", sender: nil)
                    }else if self.tipo == "empleado"{
                        self.performSegue(withIdentifier: "iniciarsesionempleadosegue", sender: nil)
                    }
                })
                Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("nombres").observeSingleEvent(of: .value, with:{(snapshot) in
                    self.user.nombre = snapshot.value as! String
                })
                Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("apellidos").observeSingleEvent(of: .value, with:{(snapshot) in
                    self.user.apellido = snapshot.value as! String
                })
                Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("ocupacion").observeSingleEvent(of: .value, with:{(snapshot) in
                    self.user.ocupacion = snapshot.value as! String
                })
                Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("edad").observeSingleEvent(of: .value, with:{(snapshot) in
                    self.user.edad = snapshot.value as! String
                })
                Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("DNI").observeSingleEvent(of: .value, with:{(snapshot) in
                    self.user.dni = snapshot.value as! String
                })
                Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("imagenURL").observeSingleEvent(of: .value, with:{(snapshot) in
                    self.user.perfilURL = snapshot.value as! String
                })
                Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("imagenID").observeSingleEvent(of: .value, with:{(snapshot) in
                    self.user.perfilID = snapshot.value as! String
                })
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueregister"{
            let registerVC = segue.destination as! RegisterViewController
            registerVC.email = self.emailTextField.text!
            registerVC.password = self.passwordTextField.text!
        }else if segue.identifier == "iniciarsesionadminsegue"{
            if let navigationController = segue.destination as? UINavigationController {
                let childViewController = navigationController.topViewController as? ControlViewController
                childViewController?.user = user as! Usuario
            }
        }else if segue.identifier == "iniciarsesionempleadosegue"{
            if let navigationController = segue.destination as? UINavigationController {
                let childViewController = navigationController.topViewController as? EmpleadoViewController
                childViewController?.user = user as! Usuario
            }
        }
    }
    
}

