//
//  ViewController.swift
//  Todoey
//
//  Created by Joel Combs on 3/27/19.
//  Copyright © 2019 Joel Combs. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

	var todoItems : Results<Item>?
	var realm = try! Realm()
	
	var selectedCategory : Category? {
		didSet {
			
			loadItems()
			
		}
	}
	

	@IBOutlet weak var searchBar: UISearchBar!
	
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		tableView.separatorStyle = .none
		
    }

	//MARK: - SET VIEW APPEARANCE PROPERTIES (viewWillAppear)
	
	override func viewWillAppear(_ animated: Bool) {
		
		title = selectedCategory?.name
		
		guard let colorHex = selectedCategory?.cellColor else {fatalError("No Color Set")}
		
		updateNavBar(withHexCode: colorHex)
		
	}
	
	//MARK: - SET VIEW DISAPPEARANCE PROPERTIES (viewWillDisappear)
	
	override func viewWillDisappear(_ animated: Bool) {
		
		updateNavBar(withHexCode: "1D9BF6")
		
	}
	
	//MARK: - NavBar Setup Methods
	
	func updateNavBar(withHexCode colorHexCode:String) {
	
		guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controlloer Does Not Exist.")}
		
		guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError("No Color Set For Navigation Text Elements")}
		
		navBar.barTintColor = navBarColor
		searchBar.barTintColor = navBarColor
		navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
		navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
		
	}
	//MARK: - Tableview Datasource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return todoItems?.count ?? 1
		
	}

	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		if let item = todoItems?[indexPath.row] {
			
			cell.textLabel?.text = item.title
			
			if let color = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
				
				cell.backgroundColor = color
				cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
				
			}
			
			//Ternary Operator =>
			// value = condition ? valueIfTrue : valueIfFalse
			cell.accessoryType = item.done ? .checkmark : .none
			
		} else {
			cell.textLabel?.text = "No Items Added"
		}
		
		return cell
		
	}

	//MARK: - Tableview Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		
		if let item = todoItems?[indexPath.row] {
			do {
				try realm.write {
					
					//realm.delete(item)
					item.done = !item.done
				}
			} catch {
				print("Error setting done status, \(error)")
			}
			
			tableView.reloadData()
			
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
    //MARK: - Add New Items (addButtonPressed)
   
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
						newItem.dateCreated = Date()
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

	}
	

	//MARK: - Delete Data When Swipe
	
	override func updateModel(at indexPath: IndexPath) {
		if let deleteItem = todoItems?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(deleteItem)
				}
			} catch {
				print("Error deleting item, \(error)")
			}
			
		}
	}
	


    
}

//MARK: - Search Bar Delegate Methods

extension TodoListViewController : UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
		self.tableView.reloadData()
		
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		let char = searchText.cString(using: String.Encoding.utf8)
		let isBackSpace = strcmp(char, "\\b")
		
		if searchBar.text?.count == 0 {
			
			loadItems()
			self.tableView.reloadData()
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
			
		} else if isBackSpace == -92 {
			
			loadItems()
			self.tableView.reloadData()
			
		} else {
			
			loadItems()
			todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
			self.tableView.reloadData()
			
		}
		
	}
		
}


