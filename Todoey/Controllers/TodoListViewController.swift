//
//  ViewController.swift
//  Todoey
//
//  Created by Joel Combs on 3/27/19.
//  Copyright © 2019 Joel Combs. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

	var todoItems : Results<Item>?
	var realm = try! Realm()
	
	var selectedCategory : Category? {
		didSet {
			loadItems()
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
    }

	
	//MARK: - Tableview Datasource Methods
	
	
	//TODO: Declare cellForRowAtIndexPath here:
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		if let item = todoItems?[indexPath.row] {
			
			cell.textLabel?.text = item.title
			
			//Ternary Operator =>
			// value = condition ? valueIfTrue : valueIfFalse
			cell.accessoryType = item.done ? .checkmark : .none
			
		} else {
			cell.textLabel?.text = "No Items Added"
		}
		
		return cell
		
	}
	
	
	//TODO: Declare numberOfRowsInSection
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return todoItems?.count ?? 1
		
	}
	
	
	//MARK: - Tableview Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//This code sets the opposite of the current state
		//This single line of code repalces the long way of doing it below
		
		//todoItems[indexPath.row].done = !todoItems[indexPath.row].done
		
//		The order matters
//		context.delete(itemArray[indexPath.row])
//		itemArray.remove(at: indexPath.row)
		
		
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
    
    
    //MARK: - Add New Items Section
   
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			
			//What will  happen when the user clicks the add item on our UIAlert
			
			if let currentCategory = self.selectedCategory {
				
				do {
					try self.realm.write {
						let newItem = Item()
						newItem.title = textField.text!
						currentCategory.items.append(newItem)
					}
				} catch {
					print("Error saving items, \(error)")
				}
			}
			
			self.tableView.reloadData()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create New Item"
			textField = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
		
		
	}
    
	
	
	//MARK: - Model Manipulation Methods

	func loadItems() {

		todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

		self.tableView.reloadData()

	}
	
}

//MARK: - Search Bar Methods

//extension TodoListViewController : UISearchBarDelegate {
//
//	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//		let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//		loadItems(with: request, predicate: predicate)
//
//	}
//
//	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//		if searchBar.text?.count == 0 {
//			loadItems()
//
//			DispatchQueue.main.async {
//				searchBar.resignFirstResponder()
//			}
//
//		}
//	}
//
//
//
//}
