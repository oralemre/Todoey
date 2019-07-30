//
//  ViewController.swift
//  Todoey
//
//  Created by Emre Oral on 7/30/19.
//  Copyright © 2019 Emre Oral. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    //MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let text = tableView.cellForRow(at: indexPath)?.textLabel?.text{
            print(text)
            //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            } else{
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//
//    }
    

}

