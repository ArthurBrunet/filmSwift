//
//  ViewController.swift
//  film
//
//  Created by Dev Trop-plus on 15/03/2022.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var tabMovies : [Movie] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabMovies.append(Movie(name: "Test de test Test de test Test de test"))
        self.tabMovies.append(Movie(name: "Test de test"))
        self.tabMovies.append(Movie(name: "Test de test"))
        self.tabMovies.append(Movie(name: "Test de test"))
        self.tabMovies.append(Movie(name: "Test de test"))
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // obligatoire à redéfinir
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabMovies.count
    }

    // peupler les cellules de tables
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCell", for: indexPath) as! MyCollectionViewCell
        cell.name?.text = tabMovies[indexPath.row].name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewDetail : ViewDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "movieDetail")
        viewDetail.movie = tabMovies[indexPath.row]
        present(viewDetail, animated: true, completion: nil)
    }
}
