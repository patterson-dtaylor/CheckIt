//
//  CategoryViewController.swift
//  CheckIt
//
//  Created by Taylor Patterson on 5/9/20.
//  Copyright © 2020 Taylor Patterson. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
//   initalizes the Realm entity Category object
//   var categories = [Category]()

//   initalizes the Realm entity Categegory object as a Results object for loading and appeneding data
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // nil coalescing operator
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // sets the cell from the super class.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.selectionStyle = .none
            
            cell.textLabel?.text = category.name
            
            cell.backgroundColor = HexColor(category.cellColor)
            
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: HexColor(category.cellColor)!, isFlat: true)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When the button is clicked, takes you to the segue
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // prep work for segue to fetch data corresponding with particular category
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //intializes the controller for where we are going.
        let destinationVC = segue.destination as! TodoListViewController
        
        // intializes the cell at the indexPath of the selected row using selectedCategory from the ToDoListVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New CheckIt Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            if newCategory.name != "" {
                newCategory.cellColor = UIColor.randomFlat().hexValue()
                
                //            Not needed due to Results autoupdating
                //            self.categories.append(newCategory)
                
                self.save(category: newCategory)
            } else {
                let alert = UIAlertController(title: "Sorry, category name cannot be blank!", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        // itializes categories with new saved
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }

    // overridden func from superclass
    override func updateModelWithCellDeletion(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write{
                    //How to delete
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting data:\(error)")
            }
        }
    }
}

