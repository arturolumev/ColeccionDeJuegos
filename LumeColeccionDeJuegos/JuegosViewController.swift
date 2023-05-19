//
//  JuegosViewController.swift
//  LumeColeccionDeJuegos
//
//  Created by Arturo Lume on 17/05/23.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var array = ["Categoría 1", "Categoría 2", "Categoría 3"]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var eliminarBoton: UIButton!
    @IBOutlet weak var categoriaPickerView: UIPickerView!
    
    var imagePicker = UIImagePickerController()
    
    var juego:Juego?
    var juegos: [Juego] = []
    
    var tituloActualizar:String?
    
    var tableView: UITableView?
    
    var categoriaSeleccionada: Categoria? = nil
    
    var categorias: [Categoria] = []
    
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let juego = juego {
//            print(juego)
//            print(juego.titulo)
//            tituloTextField.text = juego.titulo
//
//            // Configura los demás campos con los datos del juego
//        } else {
//            print("No entro al if")
//        }
//        cargarCategorias()
        imagePicker.delegate = self
        
        if juego != nil {
            imageView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextField.text = juego!.titulo
            agregarActualizarBoton.setTitle("Actualizar", for: .normal) // Corrección aquí
        } else {
            eliminarBoton.isHidden = true
        }
        
        categoriaPickerView.dataSource = self
        categoriaPickerView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "juegoSegue" {
            let siguienteVC = segue.destination as! JuegosViewController
            if let indexPath = tableView?.indexPathForSelectedRow {
                let juego = juegos[indexPath.row]
                siguienteVC.juego = juego
            }
        }
    }

    
    @IBAction func seleccionarCategoriaTapped(_ sender: Any) {
        let selectedRow = categoriaPickerView.selectedRow(inComponent: 0)
        categoriaSeleccionada = categorias[selectedRow]
    }
    
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
    }

    @IBAction func agregarTapped(_ sender: Any) {
        
        if juego != nil {
            juego?.titulo = tituloTextField.text!
            juego?.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let nuevoJuego = Juego(context: context)
            nuevoJuego.titulo = tituloTextField.text
            nuevoJuego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            nuevoJuego.categoria = selectedCategory
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    
    }
    
    // Número de componentes en el picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Número de filas en el picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }

    // Título para cada fila en el picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = array[row]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        imageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
