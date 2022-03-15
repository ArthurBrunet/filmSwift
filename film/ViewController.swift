//
//  ViewController.swift
//  film
//
//  Created by Dev Trop-plus on 15/03/2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    var tabMovies : [Movie] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabMovies.append(Movie(name: "Test"))
        self.tabMovies.append(Movie(name: "Test2"))
        self.tabMovies.append(Movie(name: "Test3"))
        self.tabMovies.append(Movie(name: "Test4"))
        self.tabMovies.append(Movie(name: "Test5"))
    }

    // obligatoire à redéfinir
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tabMovies.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // peupler les cellules de tables
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MyTableViewCell
        cell.Name?.text = tabMovies[indexPath.row].name
        return cell
    }
}
