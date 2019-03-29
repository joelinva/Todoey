//
//  ViewController.swift
//  Todoey
//
//  Created by Joel Combs on 3/27/19.
//  Copyright © 2019 Joel Combs. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
	
	let defaults = UserDefaults.standard
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		if let items = defaults.array(forKey: "TodoListArray") as? [String] {
			itemArray = items
		}
		
		
		// Do any additional setup after loading the view.
    }

	//MARK - Tableview Datasource Methods
	
	
	//TODO: Declare cellForRowAtIndexPath here:
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		cell.textLabel?.text = itemArray[indexPath.row]
		
		return cell
		
	}
	
	//TODO: Declare numberOfRowsInSection
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return itemArray.count
		
	}
	
	//MARK - Tableview Delegate Methods
	
	//TODO: Create when click cell here
	
	//TODO: Declare didSelectRow here:
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//print(itemArray[indexPath.row])
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		if self.tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			
			self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
		
		} else {
			
			self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
			
		}
		
	}
    
    
    //MARK:  Add New Items Section
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//What will  happen when the user clicks the add item on our UIAlert
			
			self.itemArray.append(textField.text!)
			
			self.defaults.set(self.itemArray, forKey: "ToDoListArray")
			
			self.tableView.reloadData()
			
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create New Item"
			textField = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
		
    }
    
    
    
}





