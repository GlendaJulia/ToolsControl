//
//  RegisterViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 29/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!

    var perfilPicker = UIImagePickerController()
    var perfilID = NSUUID().uuidString
    var urlperfil = ""
    
    var email = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perfilPicker.delegate = self
        emailTextField.text = email
        passwordTextField.text = password
    }

    @IBAction func RegisterHandler(_ sender: Any) {
        let perfilesFolder = Storage.storage().reference().child("perfiles")
        let perfilData = fotoPerfil.image?.jpegData(compressionQuality: 0.50)
        let cargarPerfil = perfilesFolder.child("\(perfilID).jpg")
        
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
            print("Intentando crear usuario")
            if error != nil{
                print("Se presento el siguiente error al intentar crear un usuario: \(error)")
                let alerta = UIAlertController(title: "Error", message: "Se presento el siguiente error al intentar crear un usuario: \(error)", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
            }else{
                print("El usuario fue creado Exitosamente")
                cargarPerfil.putData(perfilData!, metadata: nil) { (metadata, error) in
                    if error != nil{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo.", accion: "Aceptar")
                        print("Ocurrio un error al subir la imagen: \(error)")
                        return
                    }else{
                        cargarPerfil.downloadURL(completion: {(url, error) in
                            guard let enlaceURL = url else{
                                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen.", accion: "Cancelar")
                                print("Ocurrio un error al obtener la informacion de imagen \(error)")
                                return
                            }
                            self.urlperfil = (url?.absoluteString)!
                            let userr = ["email" : user?.user.email, "contraseña" : self.passwordTextField.text!, "imagenURL": (url?.absoluteString)!, "imagenID":self.perfilID, "user": self.correoTextField.text!]
                            Database.database().reference().child("usuarios").child(user!.user.uid).setValue(userr)
                        })
                    }
                }
                
                
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.emailTextField.text!) se creo correctamente!", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Iniciar Sesion", style: .default, handler: { (UIAlertAction) in
                    
                    self.performSegue(withIdentifier: "seguelogin", sender: nil)
                })
                
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
            }
        })
        
    }
    
    @IBAction func CancelarHandler(_ sender: Any) {
        let alerta = UIAlertController(title: "Volver", message: "Esta seguro de que desea volver a Login?", preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            self.performSegue(withIdentifier: "seguelogin", sender: nil)
        })
        let btnCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alerta.addAction(btnOK)
        alerta.addAction(btnCancel)
        self.present(alerta, animated: true, completion: nil)
    }
    
    
    @IBAction func mediaTapped(_ sender: Any) {
        perfilPicker.sourceType = .savedPhotosAlbum
        perfilPicker.allowsEditing = false
        present(perfilPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        fotoPerfil.image = image
        fotoPerfil.backgroundColor = UIColor.clear
        perfilPicker.dismiss(animated: true, completion: nil)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let loginVC = segue.destination as! iniciarSesionViewController
        loginVC.mail = emailTextField.text!
        loginVC.pass = passwordTextField.text!
    }
}
