//
//  ViewController.swift
//  Todoey
//
//  Created by Joel Combs on 3/27/19.
//  Copyright © 2019 Joel Combs. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	var itemArray = [Item]()
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		loadItems()
		
    }

	//MARK - Tableview Datasource Methods
	
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
	
	//MARK - Tableview Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//This code sets the opposite of the current state
		//This single line of code repalces the long way of doing it below
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		saveItems()
		
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
    
    
    //MARK:  Add New Items Section
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//What will  happen when the user clicks the add item on our UIAlert
			
			let newItem = Item()
			newItem.title = textField.text!
			
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
    
    //MARK - Model Manipulation Methods
	
	func saveItems() {
		
		let encoder = PropertyListEncoder()
		
		do {
			let data = try encoder.encode(itemArray)
			try data.write(to: dataFilePath!)
		} catch {
			print("Error encoding item array, \(error)")
		}
		
		self.tableView.reloadData()
		
	}
	
	func loadItems() {
		
		if let data = try? Data(contentsOf: dataFilePath!) {
			
			let decoder = PropertyListDecoder()
			
			do {
				itemArray = try decoder.decode([Item].self, from: data)
			} catch {
				print("Error decoding item array, \(error)")
			}
			
		}
		
	}
    
}




