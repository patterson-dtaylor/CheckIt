//
//  ViewController.swift
//  CheckIt
//
//  Created by Taylor Patterson on 5/7/20.
//  Copyright © 2020 Taylor Patterson. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            // the default value is the paramter called here.
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //decalres the default user save file.
//    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hard Coded items for testing
//        let newItem = Item()
//        newItem.title = "Finish iOS Bootcamp"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Apply for Jobs"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Apply for Jobs"
//        itemArray.append(newItem3)
        
        // defines and attachs the plist file array to the itemsArray to render on user screen.
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
    }
    
//MARK: - Tabelview Datasource Methods
    
    //Basic Setup of a TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        // added .title to render the text of the model
        cell.textLabel?.text = item.title
        
        // Check or uncheck a cell animation
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

//MARK: - Tabelview Delegate Methods
    
    // Selecting a row function
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // checks to if the cell is done or not points up to the check mark.
        // ! means not
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        // Turns off animation highlight of cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: - Add New Items
    
    @IBAction func addButonPressed(_ sender: UIBarButtonItem) {
        // sets the textField to access the text of the alert
        var textField = UITextField()
        // sets the alert
        let alert = UIAlertController(title: "Add New CheckIt Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user adds the item.
            
            // added the two next lines to connect to title from the model to the textfield.
//            let newItem = Item()
//            newItem.title = textField.text!
            
            //After creating the DataModel, these next lines will come from the DataModel file
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            // prior to building the model, itemArray appened textField.text!
            self.itemArray.append(newItem)
            
            // sets the plist data file as the key.
            // look at saveItems functionality.
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.saveItems()
            
            // reloads the data on the tableView to relfect the new items added. 
//            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveItems() {
        // encodes data from the Item model
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!)
//        } catch {
//            print("Error encoding item array, \(error)")
//        }
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // with == external perameter
    // request == internal parameter
    // = Item.fetchRequest() == the default parameter
    // predicate: is the predicate from searchBarButton
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        //predicate to make sure the loaded items are for the correct category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // combines the two predicates so they do not cancel each other out. 
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [additionalPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error while fetching data from context: \(error)")
        }
        
        tableView.reloadData()
        
        // Use if working with a model class and plist file
//        if let data  = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding: \(error)")
//            }
//        }
    }
}

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //use if working with Core Data and SQLite
        //must specifiy what datatype this variable is...
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //This queries hits within the "title" attribute
        let itemPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sorts the data in our choice
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: itemPredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
