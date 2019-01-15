//
//  ViewController.swift
//  Todoey
//
//  Created by Joshua Graciano on 12/4/18.
//  Copyright © 2018 Joshua Graciano. All rights reserved.
//

import UIKit
import RealmSwift // in order to use the custom Item class below, we need to import RealmSwift

class TodoListViewController: UITableViewController {
    // we are declaring our View Controller as the delegate of the UISearchBar

    var todoItems : Results<Item>? // we are changing the data type from an array of Item objects to a data type of Results<Item>, the auto-updating container, containing a whole bunch of Item objects
    
    let realm = try! Realm() // we have to create a new instance of Realm
    
    var selectedCategory : Category?  {// this is an optional Category because it's going to be nil until we can set it using the line of code in prepare(forSegue) in CategoryViewController
    // but once we do set that selectedCategory, then that's the time point when I want to load up all the items that are relevant to this category
        
        didSet {
            // we can use the special keyword didSet and everything that's between these curly braces is going to happen as soon as selectedCategory gets set with a value
            // when we call loadItems(), we are certain that we've already got a value for our selectedCategory and we are not calling it before we actually have a value which might crash our app.
//            loadItems()
        }
    }
    
   // instead of using User Defaults, we are going to create our own p list at the location of our data file path
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // here we are going to print the file path for our Document direcotry under the User Domain Mask; we just want to get a path to where our data is being stored for our current app.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // here we are going to print the file path for our Document directory under the User Domain Mask
        //FileManager is the object that provides an interface to the file system.
        // and then we are going to use the default file manager which is a shared file manager object
        // .default is a singleton and this singleton contains a whole bunch of URLs and they are organized by directory and domain mask
        // The Search path Directory we need to tap into is the Document directory
        // the location where we are going to look for it is inside the user domain mask, this is the user's home directory, the place where we're going to save their personal items associated with this current app

    }
    
    //MARK: - Tableview Datasource Methods
    // there are two methods which allow us to specify what the cells should display and also how many rows we want in our Table View
    
    // first method returns the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // this method expects an output in a return statement that will be the number of rows
        return todoItems?.count ?? 1 // returns the number of items in the array initialized near the class declaration
        // since todoItems is an optional Result<Item>, we will use optional chaining to say, if todoItems is non-nil, then return the count. But if it is nil, then return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // we are going to create a cell in here that is going to be a resuable cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // here we are saying go and find that prototype cell called 'ToDoItemCell' inside main.storyboard and generate a whole bunch of it that we can reuse
        // The identifier is the identifier which we gave to our prototype cell in main.storyboard
        // the indexPath is going to be the current index path that the Table View is looking to populate
        
        if let item = todoItems?[indexPath.row] { // this item is now the item that we're currently trying to set up for the cell
        // here we will use optional binding saying if todoItems is not nil, then grab the item at indexPath.row and if all of this works and it is not nil, then in that case, we're going to change all of our accessories based on the item.title and the item.done properties
            
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
            
        } else {
            // however, if it is nil or if it fails, then we're going to say
            cell.textLabel?.text = "No Items Added"
        }
        
        
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
        
        if let item = todoItems?[indexPath.row] {
        // todoItems is a container that contains a whole bunch of items and it's fetched from our Realm. If this is not nil,then we're going to grab the item at indexPath.row
        // if todoItems?[indexPath.row] is not nil, then we are going to able to access this item object and we can say
            
            // realm.write can throw errors, so we have to wrap it inside a do catch block
            do {
                try realm.write { // realm.write updates our database
                    realm.delete(item) // we are going to call the delete method of our Realm to delete the object that I specify and that object is obviously going to be our item that we picked out
                    // it is going to delete this item from our Realm database
//                    item.done = !item.done // the current done property becomes the opposite
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
        
        tableView.reloadData() // we need this to call cellForAt indexPath method again and to update our cells based on the done property in the method (checkmark if it's done and vice versa)
        
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
            
            if let currentCategory = self.selectedCategory {
                // if self.selectedCategory is not nil, then we try to save our data
                
                
                // here we are saving to our Realm database
                do {
                    try self.realm.write {
                        let newItem = Item() // here we are just initializing a new object of the Item class
                        newItem.title = textField.text! // the title is going to be the current text inside the textfield
                        
                        //            newItem.done = false // this does not need to be specified anymore because it is already in the Item.swift file as a default
                        
                        // this item will also get a new date. This is going to be set to equal the current date at the time when this block gets called. This is a new instance of Date. Now every new item we create gets stamped with the current date and time
                        newItem.dateCreated = Date()
                        
                        // instead of setting the newItem's parentCategory property, we are going to go the other direction . We are going to tap into the 'items' that belong to the currentCategory and we are going to append the newItem we just created to that list
                        currentCategory.items.append(newItem) // currentCategory.items is a list of Item objects
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
                
                self.tableView.reloadData() // we need to call this so we can call thos data source methods again and update our table view with the newItem because we've gotten rid of our save method
                
                
            }
            
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
    
    // we are going to add another parameter and it's going to be the predicate or whatever search query we want to make in order to load up our items
    // We can set this predicate to have a default value of nil and we can turn this NSPredicate into an optional which means we can still call loadItems without any parameters because both parameters have a default value.
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        // .items (remember that relationship we created) so all of the items that belong to the current selected category and we are going to sort it by key path and ascending. The key path is just as we have done before. Sorted by the title of each item and we're going to make it ascending. This replaces all of the Core Data code
        // keypath: "title" is the the title of each of the items that come back into the itemArray
        
        tableView.reloadData() // this reloads the rows and the sections of the TableView taking into account the new data we've added to our itemArray
    }



}


//MARK: - Search Bar Methods

// here we are creating an extension and extend the functionality of our ToDoListViewController with a search bar and some search bar methods and we can set it up to be a UISearchBarDelegate
extension TodoListViewController : UISearchBarDelegate {

    // this delegate method tells the delegate that the search button was tapped (this method is triggered when the search button is pressed on the search bar) and that is the point where we want to reload our table View using the text that the user has imported
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        // when the search bar button gets clicked, we want to filter our to do list items. We have todoItems, which is the array of Results that consists of items, and we're going to set its new value to be equal to its previous value (+ .filter) filtered by its predicate. We can specify the predicate format and arguments that we want to use for our filter
        // the filter method from realm takes an NSPredicate as in input
        // the format is the same as Core Data. The title of the items CONTAINS %a (which is the argument). Add the [cd] to make it case and diacritic insensitive to the argument that we are going to pass in. The argument is going to be the searchBar.text!
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        // we can tag on a sort by simply adding a .sorted(byKeyPath). Keypath is 'title' and that's what we're going to sort our results by and ascending will be set to true, so it's alphabetical order
        // we don't need to call loadItems() because we've already loaded our todoItems from the selected Category and we're now just simply just filtering those items based on our search criteria and sort criteria
        
        tableView.reloadData()
        
    }

    // here we are creating a new delegate method
    // this triggers the delegate method when the text inside the search bar has changed so that means every single letter I type  in here is going to trigger this delegate method but also when I go from a whole bunch of text to no text in the search bar this method is going to be triggered.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // if there are any changes inside the text of the search Bar
        // the searchBar.text.count looks at the number of characters in the string or the search bar text
        // when you start up the app, you are not going to trigger this searchBar method because the text has not changed and only once the text has changed and it's gone down to zero, does this if statement get triggered.
        if searchBar.text?.count == 0 {
            // here we are simply going to call loadItems() which has a default request that just fetches all of the items from my persistent store
            loadItems()

            // While the background tasks are happening, we need to grab the main queue so that we can dismiss our search bar but even if background paths are still being completed. In order to do that we have to tap into the dispatch queue and this is the object that manages the execution of work items
            DispatchQueue.main.async {
                // we are going to ask it to grab us the main thread and this is where we should be updating our UI elements. Then we are going to tap into an async method

                // here we are going to insert our search bar updating code. Now we are asking the dispatcher to get the main queue and run this method on the main queue
                // in order to hide the keyboard and stop our cursor from flashing in our search Bar, we need to call a method called resignFirstResponder(), so telling the searchBar to stop being the first responder.
                // first we are grabbing a reference to the searchBar and we're saying resign first responder which notifies this object, i.e. the search bar, that it has been asked to relinquish its status as the first responder in its window. It sounds complicated, but all it means is that it should no longer be the thing that is currently selected. Go back to the background or to the original state you're in before you were activated.
                searchBar.resignFirstResponder()


            }
        }


    }
}

