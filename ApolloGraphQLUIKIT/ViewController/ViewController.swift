//
//  ViewController.swift
//  ApolloGraphQLUIKIT
//
//  Created by Mariano Battaglia on 07/05/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
        
    var personajes = [PersonajesQuery.Data.Character.Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        setupUI()
        api()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 240 / 255.0, green: 255 / 255.0, blue: 250 / 255.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        let personaje = personajes[indexPath.row]
        cell.titleCell.text = personaje.name
        cell.subtitleCell.text = personaje.species
        
        let tipo = personaje.species
        switch tipo {
        case "Alien":
            cell.imageCell.image = UIImage(systemName: "bonjour")
            cell.imageCell.tintColor = UIColor(red: 204 / 255.0, green: 153 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        default:
            cell.imageCell.image = UIImage(systemName: "globe.americas.fill")
            cell.imageCell.tintColor = UIColor(red: 210 / 255.0, green: 255 / 255.0, blue: 240 / 255.0, alpha: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "enviar", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviar" {
            if let id = tabla.indexPathForSelectedRow {
                let fila = personajes[id.row]
                let destino = segue.destination as? DetalleViewController
                destino?.idPersonaje = fila.id
            }
        }
    }
    
    func api() {
        self.showSpinner()
        Network.shared.apollo.fetch(query: PersonajesQuery()) { res in
            switch res {
            case .success(let graphql):
                DispatchQueue.main.async {
                    let personajes = graphql.data?.characters?.results as! [PersonajesQuery.Data.Character.Result]
                    self.personajes.append(contentsOf: personajes)
                    self.tabla.reloadData()
                    self.removeSpinner()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self.removeSpinner()
            }
        }
    }

}

