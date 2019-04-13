//
//  ViewController.swift
//  Todoey
//
//  Created by Joel Combs on 3/27/19.
//  Copyright © 2019 Joel Combs. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

	var itemArray = [Item]()

	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
		
		loadItems()
		
    }

	
	//MARK: - Tableview Datasource Methods
	
	
	//TODO: Declare cellForRowAtIndexPath here:
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		let item = itemArray[indexPath.row]
		
		cell.textLabel?.text = item.title
		
		//Ternary Operator =>
		// value = condition ? valueIfTrue : valueIfFalse
		cell.accessoryType = item.done ? .checkmark : .none
	
		return cell
		
	}
	
	
	//TODO: Declare numberOfRowsInSection
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return itemArray.count
		
	}
	
	
	//MARK: - Tableview Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//This code sets the opposite of the current state
		//This single line of code repalces the long way of doing it below
		
		//itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		
		//The order matters
		context.delete(itemArray[indexPath.row])
		itemArray.remove(at: indexPath.row)
		
		saveItems()
		
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
    
    
    //MARK: - Add New Items Section
   
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			
			
			//What will  happen when the user clicks the add item on our UIAlert
			let newItem = Item(context: self.context)
			newItem.title = textField.text!
			newItem.done = false
			
			self.itemArray.append(newItem)
			
			self.saveItems()
			
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create New Item"
			textField = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
		
		
	}
    
	
	
	//MARK: - Model Manipulation Methods
	
	func saveItems() {
	
		
		do {
			try context.save()
		} catch {
			print("Error saving context, \(error) ")
		}
		
		self.tableView.reloadData()
		
	}

	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {

	//	let request : NSFetchRequest<Item> = Item.fetchRequest()
		
		do {
			itemArray = try context.fetch(request)
		} catch {
			print ("Error fetching data from conetxt, \(error)")
		}

		self.tableView.reloadData()
		
	}
	
}

//MARK: - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		let request : NSFetchRequest<Item> = Item.fetchRequest()
		
		request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		
		loadItems(with: request)
		
	}
	
}
