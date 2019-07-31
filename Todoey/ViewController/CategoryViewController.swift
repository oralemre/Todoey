//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Emre Oral on 7/30/19.
//  Copyright © 2019 Emre Oral. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    var selectedRowCategoryName : String = ""
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowCategoryName = categoryArray[indexPath.row].name!
        performSegue(withIdentifier: "goToItemList", sender: self)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("Success!")
            if let text = textField.text{
                let newCategory = Category(context: self.context)
                newCategory.name = text
                self.categoryArray.append(newCategory)
                self.saveCategories()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
    
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // we have a segue
        
        if segue.identifier == "goToItemList" {
            let destinationVC = segue.destination as! TodoListViewController // as! down cast
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
            //destinationVC.passedOverCategory = selectedRowCategoryName
        }
    }
    
    //MARK: - TableView Datasource Methods
    
    
    //MARK: - TableView Delegate Methods
    
    //MARK: - Data Manipulation Methods
    
}
