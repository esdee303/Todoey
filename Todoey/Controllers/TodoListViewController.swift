//
//  ViewController.swift
//  Todoey
//
//  Created by Steven Deferme on 17/04/2019.
//  Copyright © 2019 Steven Deferme. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    // CRUD (Create Read Update Destroy)
    // CREATE : Create cosntant variable and grab the container and grab a reference to the context of the containeer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        
        let item = itemArray[indexPath.row]
        cell?.textLabel?.text = item.title
        
        // ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        cell?.accessoryType = item.done ? .checkmark : .none
     
        return cell!
    }
    
    //MARK: TableView Delegate Methods (selecting - deselecting items)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // delete item when selected
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        // check item when selected
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    //MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            // what will happen once the user clicks the Add item button on our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            print("--add Item success: \(String(describing: newItem.title))")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Model Manipulation Methods
    func saveItems() {
      
        do {
           try context.save()
        } catch {
            print("--error saving item context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
               
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("---error fetching items from context: \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    // go back to the original list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            // close the keyboard and remove the cursor from the search bar
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
