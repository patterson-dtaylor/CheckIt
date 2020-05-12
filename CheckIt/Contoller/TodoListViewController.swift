//
//  ViewController.swift
//  CheckIt
//
//  Created by Taylor Patterson on 5/7/20.
//  Copyright © 2020 Taylor Patterson. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
//    initalizing CoreData entity
//    var itemArray = [Item]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            // the default value is the paramter called here.
            loadItems()
        }
    }
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.cellColor {
            
            title = selectedCategory!.name
//            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: HexColor(category.cellColor)!, isFlat: true)
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist")
            }
            
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.backgroundColor = navBarColor
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn: (HexColor(colorHex)!), isFlat: true)]
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                searchBar.barTintColor = navBarColor
            }
            searchBar.searchTextField.backgroundColor = .white
        }
    }
    
//MARK: - Tabelview Datasource Methods
    
    //Basic Setup of a TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            // added .title to render the text of the model
            cell.textLabel?.text = item.title
            
            if let color = HexColor(selectedCategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
            
            // Check or uncheck a cell animation
            // Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }

//MARK: - Tabelview Delegate Methods
    
    // Selecting a row function
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //using Realm
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    //How to delete
//                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving data:\(error)")
            }
            
        }
        
        self.tableView.reloadData()
        
        // checks to if the cell is done or not points up to the check mark.
        // ! means not
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        
////        context.delete(itemArray[indexPath.row])
////        itemArray.remove(at: indexPath.row)
//        
//        saveItems()
        
        // Turns off animation highlight of cell
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: - Add New Items
    
    @IBAction func addButonPressed(_ sender: UIBarButtonItem) {
        // sets the textField to access the text of the alert
        var textField = UITextField()
        // sets the alert
        let alert = UIAlertController(title: "Add New CheckIt Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user adds the item.
            
            //Realm initalization
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.timeStamp = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving context: \(error)")
                }
                
            }
            
            self.tableView.reloadData()
            
            
            // added the two next lines to connect to title from the model to the textfield.
//            let newItem = Item()
//            newItem.title = textField.text!
            
            //After creating the DataModel, these next lines will come from the DataModel file
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
            
            // prior to building the model, itemArray appened textField.text!
//            self.itemArray.append(newItem)
            
            // sets the plist data file as the key.
            // look at saveItems functionality.
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
//            self.saveItems()
            
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
    
//    func saveItems() {
//        // encodes data from the Item model
////        let encoder = PropertyListEncoder()
////
////        do {
////            let data = try encoder.encode(self.itemArray)
////            try data.write(to: self.dataFilePath!)
////        } catch {
////            print("Error encoding item array, \(error)")
////        }
//
//        do {
//            try realm.write{
//                realm.add(todoItems!)
//            }
//        } catch {
//
//        }
//
//        self.tableView.reloadData()
//    }
    
    // with == external perameter
    // request == internal parameter
    // = Item.fetchRequest() == the default parameter
    // predicate: is the predicate from searchBarButton
    func loadItems(/*with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil*/) {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "timeStamp", ascending: true)
        tableView.reloadData()
//        //predicate to make sure the loaded items are for the correct category
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        // combines the two predicates so they do not cancel each other out.
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [additionalPredicate, categoryPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error while fetching data from context: \(error)")
//        }
//
//
//        // Use if working with a model class and plist file
////        if let data  = try? Data(contentsOf: dataFilePath!) {
////            let decoder = PropertyListDecoder()
////            do {
////                itemArray = try decoder.decode([Item].self, from: data)
////            } catch {
////                print("Error decoding: \(error)")
////            }
////        }
    }
    
    override func updateModelWithCellDeletion(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write{
                    //How to delete
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting data:\(error)")
            }
        }
    }
}

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "timeStamp", ascending: true)
        tableView.reloadData()
//        //use if working with Core Data and SQLite
//        //must specifiy what datatype this variable is...
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //This queries hits within the "title" attribute
//        let itemPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //sorts the data in our choice
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: itemPredicate)
    }
//
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
