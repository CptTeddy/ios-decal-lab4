//
//  CategoryViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemonArray: [Pokemon]?
    var cachedImages: [Int:UIImage] = [:]
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInCategory.delegate = self
        tableViewInCategory.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (pokemonArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        let pokemon = pokemonArray![indexPath.item]
        if let image = cachedImages[indexPath.row] {
            cell.pokemonImage.image = image
            
        } else {
            let url = URL(string: (pokemon.imageUrl)!)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.cachedImages[indexPath.row] = image
                            cell.pokemonImage.image = UIImage(data: imageData)
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code")
                    }
                }
            }
            downloadPicTask.resume()
        }
        cell.pokemonName.text = pokemon.name
        cell.pokemonNumber.text = "#" + String(describing: pokemon.number!)
        cell.pokemonStats.text = String(describing: pokemon.attack!) + "/" + String(describing: pokemon.defense!) + "/" + String(describing: pokemon.health!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "CategoryToInfo", sender: selectedIndexPath?.item)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryToInfo" {
            if let destination = segue.destination as? PokemonInfoViewController {
                destination.pokemon = pokemonArray?[(selectedIndexPath?.item)!]
                destination.image = cachedImages[(selectedIndexPath?.item)!]
            }
        }
    }
    
    @IBOutlet weak var tableViewInCategory: UITableView!


}
