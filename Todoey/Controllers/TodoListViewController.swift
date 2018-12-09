//
//  ViewController.swift
//  Todoey
//
//  Created by Joshua Graciano on 12/4/18.
//  Copyright © 2018 Joshua Graciano. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]() // we are changing this array to an array of item objects which hold info about the items added to the list in the Table View Controller
    
    let defaults = UserDefaults.standard // in order to use defaults, we have to create a new defaults object
    // User Defaults is an interface to the user's default database where you store key value pairs persistently across launches of your app. Here we are setting up a standard user default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Find Mike" // changing the title property of the Item class
        itemArray.append(newItem) // we are going to append the new element
        
        let newItem2 = Item()
        newItem2.title = "Buy eggos" // changing the title property of the Item class
        itemArray.append(newItem2) // we are going to append the new element
        
        let newItem3 = Item()
        newItem3.title = "Buy dog food" // changing the title property of the Item class
        itemArray.append(newItem3) // we are going to append the new element
        
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] { // here we are trying to pull out our array from User Defaults as an array of items.
            // here we are also checking to see if there is an array called TodoListArray to avoid the app crash if there isn't any array, then perform the following:
            itemArray = items // we need to use the array saved in User defaults to retrieve the data. All we need to do to retrieve the data is we can go to viewDidLoad and we can set our itemArray to equal the array inside our User Default
        } // here we are retrieving the data that was saved in an array in our User defaults
        // here we are reactivating our defaults to try and retrieve our items out of our item Array
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
        // here we are saying go and find that prototype cell called 'ToDoItemCell' inside main.storyboard and generate a whole bunch of it that we can reuse
        // The identifier is the identifier which we gave to our prototype cell in main.storyboard
        // the indexPath is going to be the current index path that the Table View is looking to populate
        
        let item = itemArray[indexPath.row] // this item is now the item that we're currently trying to set up for the cell
        
        //Once we got our cell dequeued, the next step is to set the text label. This is the label that's in every single cell and we're going to set its text property and we're going to set it to equal the items in our item array
        cell.textLabel?.text = item.title // this is the current row of the current index that we are populating. We need to tap into the title property using the dot notation since this will return an Item object
        
        // here we are using a ternary operator
        // Value = condition ? valueIfTrue : valueIfFalse
        // We have this condition and we check to see if it is true or it is false. If its true, then we set this value to a particular value if its true and if it's not true then we set it to something else
        
        //        cell.accessoryType = item.done == true ? .checkmark :.none
        // the above is the format for the ternary operator, however, you can go one step further and remove the '== true'
        cell.accessoryType = item.done ? .checkmark : .none
        // this expression is a smaller format that does the exact thing as the 5 lines below
        // this cell now reads: set the cell's accessory type depending on whether the item.done is true. If it is true, then set it to checkmark. If it's not true, set it to .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        //final step is to return the cell
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // this method gets triggered whenever we click on any cell in our Table View
    // this method tells the delegate that the specified row has been selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row]) // this is going to print the element in the itemArray into the debug console when we select one of the cells which corresponds to the number of the cell which we selected.
//         // this is going to print the element in the array that corresponds to the specific cell that is selected
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // this means that it sets the done property on the current item in the itemArray to the opposite of itemArray[indexPath.row].done (or what it is right now)
        
        tableView.reloadData() // it forces the Table View cell to call its data source methods again so that it reloads the data that's meant to be inside. The above checkpoint operation simply updates the data in the itemArray
        
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
            
        let newItem = Item()
        newItem.title = textField.text! // here we are creating a new Item object and tapping into its title property and setting equal to the text that is entered
            
        self.itemArray.append(newItem) // here we are appending the new Item that is created above into our itemArray that contains Item objects.
            //we are appending whatever the user adds in the textfield to the array itemArray
            
        self.defaults.set(self.itemArray, forKey: "TodoListArray") // here we can save the updated item array and set it into User Defaults
            // the key is going to identify this array inside our UserDefaults
            
        self.tableView.reloadData() // this reloads the rows and the sections of the TableView taking into account the new data we've added to our itemArray
            
        print(textField.text!) // to check if it the reference we created in the closure below works and is accessible globally. Prints everything that is added to the textfield after the Add Item button is pressed
        

        } // press enter on the last parameter to create a completion handler or a closure. This is the completion block that gets called once that "Add Item" gets pressed
        
        // in order to add a textfield to our alert (very similar to adding an action)
        // hit enter on the placeholder parameter to insert closure
        // we are going to call the textfield that we create 'alertTextField
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item" // this is the string that is going to show up in gray and is going to disappear when the user clicks on that textfield
            
            textField = alertTextField  // here we want to set the textField variable with a wider scope equal to the alertTextfield which has a narrower scope. We are extending the scope of this alertTextField to the addButtonPressed method.
            
            // the alertTextfield has the scope of this closure only (only available in here)
        }
        
        alert.addAction(action) // now let's add our action to our alert
        
        present(alert, animated: true, completion: nil)// now we want to show our alert
        
    }
    
}

