//
//  imagenViewController.swift
//  ToolsControl
//
//  Created by Tecsup on 27/05/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit
import Firebase

class herramientaViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString

    var herramienta = Herramienta()
    var urlimage = ""
    var accion = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var elegirBoton: UIButton!
    @IBOutlet weak var tipoTextField: UITextField!
    @IBOutlet weak var cantidadTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirBoton.isEnabled = false
        elegirBoton.setTitle(self.accion, for: .normal)
        if elegirBoton.titleLabel?.text == "Actualizar"{
            self.nombreTextField.text = herramienta.nombre
            self.tipoTextField.text = herramienta.tipo
            imageView.sd_setImage(with: URL(string: herramienta.imagenURL), completed: nil)
            self.elegirBoton.isEnabled = true
            self.cantidadTextField.text = herramienta.cantidad
        }
    }
    
    func getDate ()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    @IBAction func elegirTapped(_ sender: Any) {
        if elegirBoton.titleLabel?.text == "Crear"{
            let imagenesFolder = Storage.storage().reference().child("imagenes")
            let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
            let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
            cargarImagen.putData(imagenData!, metadata: nil) { (metadata, error) in
                if error != nil{
                    self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo.", accion: "Aceptar")
                    self.elegirBoton.isEnabled = true
                    print("Ocurrio un error al subir la imagen: \(error)")
                    return
                }else{
                    cargarImagen.downloadURL(completion: {(url, error) in
                        guard let enlaceURL = url else{
                            self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen.", accion: "Cancelar")
                            self.elegirBoton.isEnabled = true
                            print("Ocurrio un error al obtener la informacion de imagen \(error)")
                            return
                        }
                        
                        self.urlimage = (url?.absoluteString)!
                        
                        let herr = ["imagenURL": self.urlimage, "imagenID":self.imagenID, "tipo": self.tipoTextField.text!, "nombre": self.nombreTextField.text!, "cantidad": self.cantidadTextField.text!]
                        
                        Database.database().reference().child("herramientas").childByAutoId().setValue(herr)
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        } else{
            Database.database().reference().child("herramientas").child(self.herramienta.id).child("nombre").setValue(self.nombreTextField.text)
            Database.database().reference().child("herramientas").child(self.herramienta.id).child("tipo").setValue(self.tipoTextField.text)
            Database.database().reference().child("herramientas").child(self.herramienta.id).child("imagenID").setValue(self.imagenID)
            Database.database().reference().child("herramientas").child(self.herramienta.id).child("cantidad").setValue(self.cantidadTextField.text)
            
            let imagenesFolder = Storage.storage().reference().child("imagenes")
            let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
            let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
            Storage.storage().reference().child("imagenes").child("\(herramienta.imagenID).jpg").delete{
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
                            self.elegirBoton.isEnabled = true
                            print("Ocurrio un error al obtener la informacion de imagen \(error)")
                            return
                        }
                        
                        self.urlimage = (url?.absoluteString)!
                        
                        Database.database().reference().child("herramientas").child(self.herramienta.id).child("imagenURL").setValue(self.urlimage)
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }

}
