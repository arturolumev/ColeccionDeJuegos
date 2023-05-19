//
//  ViewController.swift
//  LumeColeccionDeJuegos
//
//  Created by Arturo Lume on 17/05/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var juegos : [Juego] = []
    var categorias : [Categoria] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try categorias = context.fetch(Categoria.fetchRequest())
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        } catch {
            print("Error al obtener los juegos y categorias: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let juego = juegos[indexPath.row]
        
        var textoCelda = juego.titulo ?? "" // Asegúrate de que juego.titulo sea desempaquetado correctamente
        
        if let categoria = juego.categoria {
            textoCelda += " - \(categoria)"
        }
        
        cell.textLabel?.text = textoCelda
        cell.imageView?.image = UIImage(data: juego.imagen!)
        
        print(cell)
        
//        cell.textLabel?.text = juego.titulo
//        cell.textLabel?.text = juego.categoria
//        cell.imageView?.image = UIImage(data: (juego.imagen!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.setEditing(true, animated: true)
        
        if tableView.isEditing {
            // Realiza las acciones de edición, como editar la celda
            // según tus necesidades
            let juego = juegos[indexPath.row]
            performSegue(withIdentifier: "juegoSegue", sender: juego)
            print("Editar celda en el índice: \(indexPath.row)")
        }
        
//        let juego = juegos[indexPath.row]
//        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "juegoSegue" {
//            let siguienteVC = segue.destination as! JuegosViewController
////            siguienteVC.juego = sender as? Juego
////            siguienteVC.categoriaSeleccionada = (sender as? Juego)?.categoria
//        }
//        let siguienteVC = segue.destination as! JuegosViewController
//        siguienteVC.juego = sender as? Juego
        
        if segue.identifier == "juegoSegue" {
            let siguienteVC = segue.destination as! JuegosViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let juego = juegos[indexPath.row]
                siguienteVC.juego = juego
                siguienteVC.tableView = tableView
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let juego = juegos[sourceIndexPath.row]
        juegos.remove(at: sourceIndexPath.row)
        juegos.insert(juego, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let juego = juegos[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(juego)
            juegos.remove(at: indexPath.row)
            do {
                try context.save()
            } catch {
                print("Error al guardar el contexto: \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isEditing = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelectionDuringEditing = true
        tableView.setEditing(true, animated: false)
    }
}

