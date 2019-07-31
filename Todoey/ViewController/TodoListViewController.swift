//
//  ViewController.swift
//  Todoey
//
//  Created by Emre Oral on 7/30/19.
//  Copyright © 2019 Emre Oral. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{

    var todoItems: Results<Item>?
    let realm  = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            loadItems() // already got a value for selected category
        }
    }
    //var passedOverCategory : String = ""
    //var dataFilePath
    
   
    //let defaults = UserDefaults.standard
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
//        searchBar.delegate = self
        
        
        //loadItems(with: Item.fetchRequest())
//        print("Category Name: \(passedOverCategory)")
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
//            itemArray = items
//        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
    //MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none // ternary operator
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if let text = tableView.cellForRow(at: indexPath)?.textLabel?.text{
            
            if let item = todoItems?[indexPath.row]{
                do{
                    try realm.write {
                        item.done = !item.done
                    }
                }catch{
                    print("Error saving done status, \(error)")
                }
            }
            
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        //}
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//
//    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success!")
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
//                        let date = Date()
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "dd.MM.yyyy"
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new items, \(error)")
                }
                
            }
            
            self.tableView.reloadData()
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            //print(alertTextField.text)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manupilation Methods
    
//    func saveItems(){
//
//        do{
//            try context.save()
//        }catch{
//            print("Error saving context \(error)")
//        }
//
//        tableView.reloadData()
//    }
//
    // with external parameter request internal parameter
    
    func loadItems(){ // default value Item.fetchRequest()
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
//
    
    
    
    
}

//MARK: - Searchbar delegate methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
    
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//
//    }
}
