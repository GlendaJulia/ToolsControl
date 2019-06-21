//
//  EditarUserViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 6/20/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class EditarUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var fotoUser: UIImageView!
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var lastnameUser: UITextField!
    @IBOutlet weak var ageUser: UITextField!
    @IBOutlet weak var ocupationUser: UITextField!
    @IBOutlet weak var dniUser: UITextField!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    var user = Usuario()
    var urlimage = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("nombres").observeSingleEvent(of: .value, with:{(snapshot) in
            self.nameUser.text = snapshot.value as! String
        })
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("apellidos").observeSingleEvent(of: .value, with:{(snapshot) in
            self.lastnameUser.text = snapshot.value as! String
        })
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("ocupacion").observeSingleEvent(of: .value, with:{(snapshot) in
            self.ocupationUser.text = snapshot.value as! String
        })
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("edad").observeSingleEvent(of: .value, with:{(snapshot) in
            self.ageUser.text = snapshot.value as! String
        })
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("DNI").observeSingleEvent(of: .value, with:{(snapshot) in
            self.dniUser.text = snapshot.value as! String
        })
        
        self.nameUser.text = user.nombre
        self.lastnameUser.text = user.apellido
        self.ageUser.text = user.edad
        self.ocupationUser.text = user.ocupacion
        self.dniUser.text = user.dni
        fotoUser.sd_setImage(with: URL(string: user.perfilURL), completed: nil)
        
    }
    
    @IBAction func ActualizarUsuario(_ sender: Any) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("nombres").setValue(self.nameUser.text)
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("apellidos").setValue(self.lastnameUser.text)
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("imagenID").setValue(self.imagenID)
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("edad").setValue(self.ageUser.text)
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("ocupacion").setValue(self.ocupationUser.text)
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("DNI").setValue(self.dniUser.text)
        
        let imagenesFolder = Storage.storage().reference().child("perfiles")
        let imagenData = fotoUser.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        Storage.storage().reference().child("perfiles").child("\(user.perfilID).jpg").delete{
            (error) in
            print("Se elimino la imagen correctamente.")
        }
        cargarImagen.putData(imagenData!, metadata: nil) { (metadata, error) in
            if error != nil{
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo.", accion: "Aceptar")
                
                print("Ocurrio un error al subir la imagen: \(error)")
                return
            }else{
                cargarImagen.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen.", accion: "Cancelar")
                        print("Ocurrio un error al obtener la informacion de imagen \(error)")
                        return
                    }
                    
                    self.urlimage = (url?.absoluteString)!
                    
                    Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("imagenURL").setValue(self.urlimage)
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    @IBAction func cancelar(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraT(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        fotoUser.image = image
        fotoUser.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
}
