//
//  ViewController.swift
//  Todoey
//
//  Created by Joshua Graciano on 12/4/18.
//  Copyright © 2018 Joshua Graciano. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"] // these are just hard coded to be the text for the first 3 cells in the Table View. By changing the data type to var it becomes mutable.
    
    let defaults = UserDefaults.standard // in order to use defaults, we have to create a new defaults object
    // User Defaults is an interface to the user's default database where you store key value pairs persistently across launches of your app. Here we are setting up a standard user default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }// here we are retrieving the data that was saved in an array in our User defaults
    }
    
    //MARK: - Tableview Datasource Methods
    // there are two methods which allow us to specify what the cells should display and also how many rows we want in our Table View
    
    // first method returns the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // this method expects an output in a return statement that will be the number of rows
        return itemArray.count // returns the number of items in the array initialized near the class declaration
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // we are going to create a cell in here that is going to be a resuable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // The identifier is the identifier which we gave to our prototype cell in main.storyboard
        // the indexPath is going to be the current index path that the Table View is looking to populate
        
        //Once we got our cell dequeued, the next step is to set the text label. This is the label that's in every single cell and we're going to set its text property and we're going to set it to equal the items in our item array
        cell.textLabel?.text = itemArray[indexPath.row] // this is the current row of the current index that we are populating
        
        //final step is to return the cell
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // this method gets triggered whenever we click on any cell in our Table View
    // this method tells the delegate that the specified row has been selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row]) // this is going to print the element in the itemArray into the debug console when we select one of the cells which corresponds to the number of the cell which we selected.
//         // this is going to print the element in the array that corresponds to the specific cell that is selected
        
        // this method removes the checkmark when it's already been selected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark // this is grabbing a reference to the cell that is at a particular index path
            // the cell at this index path in our table is going to have an accessory type of .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true) // now when you select a cell, it flashes gray briefly but then it goes back to being de-selected and goes back to be white which looks a lot nicer
        
        // here is a method inside this method so that we give the cell that was selected a checkmark as an accessory
    }
    
    // MARK: Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // here we want a pop up or a UI Alert Controller to show when we press the add button and we have a textfield in that UI Alert Controller so that we can write a quick to do list item and then append it to the end of our itemsArray
        
        var textField = UITextField() // this textfield has the scope of the entire addButtonPressed IB action and is going to be accessible to everything in this method.
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // this is the button that you are going to press once you're done with writing your new To Do list item
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
        self.itemArray.append(textField.text!) // we are going to force unwrap this because the text property of the textField is never going to equal nil even if its empty it's going to be set to an empty string
            //we are appending whatever the user adds in the textfield to the array itemArray
            
        self.defaults.set(self.itemArray, forKey: "TodoListArray") // here we can save the updated item array to User Defaults
            // the key is going to identify this array inside our UserDefaults
            
        self.tableView.reloadData() // this reloads the rows and the sections of the TableView taking into account the new data we've added to our itemArray
            
        print(textField.text) // to check if it the reference we created in the closure below works and is accessible globally. Prints everything that is added to the textfield after the Add Item button is pressed
        

        } // press enter on the last parameter to create a completion handler or a closure. This is the completion block that gets called once that "Add Item" gets pressed
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item" // this is the string that is going to show up in gray and is going to disappear when the user clicks on that textfield
            
            textField = alertTextField  // here we want to set the textField variable with a wider scope equal to the alertTextfield which has a narrower scope. We are extending the scope of this alertTextField to the addButtonPressed method.
            
            // the alertTextfield has the scope of this closure only (only available in here)
        }// in order to add a textfield to our alert (very similar to adding an action)
        // hit enter on the placeholder parameter to insert closure
        // we are going to call the textfield that we create 'alertTextField
        
        alert.addAction(action) // now let's add our action to our alert
        
        present(alert, animated: true, completion: nil)// now we want to show our alert
        
    }
    
}

