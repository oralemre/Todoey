//
//  ViewController.swift
//  Todoey
//
//  Created by Emre Oral on 7/30/19.
//  Copyright © 2019 Emre Oral. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems() // already got a value for selected category
        }
    }
    //var passedOverCategory : String = ""
    //var dataFilePath
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none // ternary operator
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let text = tableView.cellForRow(at: indexPath)?.textLabel?.text{
            print(text)
            //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
            
            
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            self.saveItems()
            
            //tableView.reloadData()
            
//            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//                tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            } else{
//                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
            if let text = textField.text{
                
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                self.saveItems()
                
            }
           
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
    
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // with external parameter request internal parameter
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){ // default value Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        
        
       
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    
    
}

//MARK: - Searchbar delegate methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // query language
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
        
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Error fetching data from context \(error)")
//        }
        
//        tableView.reloadData()
        //        print(searchBar.text!)
        
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
