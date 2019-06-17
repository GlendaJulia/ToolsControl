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
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueregister"{
            let registerVC = segue.destination as! RegisterViewController
            registerVC.email = self.emailTextField.text!
            registerVC.password = self.passwordTextField.text!
        }
    }
}

// LAB 11 PAG.18
