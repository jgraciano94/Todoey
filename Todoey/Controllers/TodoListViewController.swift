//
//  ViewController.swift
//  Todoey
//
//  Created by Joshua Graciano on 12/4/18.
//  Copyright © 2018 Joshua Graciano. All rights reserved.
//

import UIKit
import CoreData // in order to use the custom Item class below, we need to import Core Data

class TodoListViewController: UITableViewController {
    // we are declaring our View Controller as the delegate of the UISearchBar

    var itemArray = [Item]() // we are changing this array to an array of item objects which holds info about the items added to the list in the Table View Controller
    
    var selectedCategory : Category?  {// this is an optional Category because it's going to be nil until we can set it using the line of code in prepare(forSegue) in CategoryViewController
    // but once we do set that selectedCategory, then that's the time point when I want to load up all the items that are relevant to this category
        
        didSet {
            // we can use the special keyword didSet and everything that's between these curly braces is going to happen as soon as selectedCategory gets set with a value
            // when we call loadItems(), we are certain that we've already got a value for our selectedCategory and we are not calling it before we actually have a value which might crash our app.
            loadItems()
        }
    }
    
   // instead of using User Defaults, we are going to create our own p list at the location of our data file path
    

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // here we are tapping into the UIApplication class, we are getting the shared singleton object which corresponds to the current app as an object, tapping into its delegate (which has the data type of an optional UIApplication Delegate), then casting it into our class app delegate. Now we have access to our app delegate as an object. We are now able to tap into its property called persistent Container. We are going to grab the viewContext of that persistent container
    // the UIApplication.shared is a singleton app instance. At the time point when our app is running live inside the user's iPhone, then the shared UI Application will correspond to our live application object.
    // Inside this shared UI Application object is something called delegate and this is the delegate of the app object alternatively known as the app delegate. We are going to downcast it as our class delegate
    
    
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
        
//        context.delete(itemArray[indexPath.row]) // here is the method that we will need to remove our data from our context and we can specify an NSManagedObject to delete. Here we will use the NS Managed Object at the current selected row here
//        
//        itemArray.remove(at: indexPath.row) // here we are tapping into our itemArray and we are going to use the method remove at a particular index. This merely updates our itemArray which is used to populate our Table View so that when we reload the Table View we were able to refresh the latest items.
//        
//        // the order which you call these two methods: one is removing the current item from the itemArray which is used to load up the tableView Data Source (itemArray.remove) and the other one is removing the data from permanent stores (context.delete). You have to call the context.delete method first and delete it from the context before deleting it from the array otherwise the context.delete will not know what to delete.
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        // this means that it sets the done property on the current item in the itemArray to the opposite of itemArray[indexPath.row].done (or what it is right now)
        
        saveItems()
        
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
            
            
        let newItem = Item(context: self.context) // we need to initialize our core data object differently. Item is our Core Data class. Here we can specify the context where this item is going to exist. This context is going to be the viewContext of our persistent container (located in App Delegate.swift file)
            
            
        newItem.title = textField.text! // here we are creating a new Item object and tapping into its title property and setting equal to the text that is entered
            
        newItem.done = false // here we are setting the done property to false for every single Item that we add into our table View.
            
        newItem.parentCategory = self.selectedCategory // this property parentCategory is available to use because we created that relationship that points to the category entity in the Data Model.
            // since we already set the selected category that is pairing the current ToDoListViewController, then we can just simply say the above
            
        self.itemArray.append(newItem) // here we are appending the new Item that is created above into our itemArray that contains Item objects.
            //we are appending whatever the user adds in the textfield to the array itemArray

        self.saveItems()
            
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

    func saveItems() {
        // here we need to be able to commit our context to permanent storage inside our persistent container. In order to do that, we need to call 'try context.save!() '. This basically transfers what's currently in our staging area or our scratchpad that's the context into our permanent data stores
        do {
           try context.save()
            
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData() // this reloads the rows and the sections of the TableView taking into account the new data we've added to our itemArray
    }
    
    // we are going to add another parameter and it's going to be the predicate or whatever search query we want to make in order to load up our items
    // We can set this predicate to have a default value of nil and we can turn this NSPredicate into an optional which means we can still call loadItems without any parameters because both parameters have a default value.
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        // here we can modify this function to take a parameter that is the request. We need to specify the data type and it is an NSFetchRequest and it is going to return an array of items
        // since loadItems(request: request) does not make a lot of sense in English when calling it below in the extension, we can modify loadItems() above to have an external parameter. With is the external parameter and request is the internal parameter. request (the internal parameter) is going to be used inside this block of code for loadItems() and the external parameter (with) is going to be used when we call the function
        // If when we call this function and we don't provide a value for the request (i.e. in viewDidLoad() above), then we can have a default value that simply Item.fetchRequest(). Now up in viewDidLoad(), we can call loadItems() without giving it any parameters
        
        
        // In order for us to load the items that have the Parent Category matching the selectedCategory, we need to query the database for it and we need to filter the result. We need to create a predicate that is an NSPredicate and initialize it with the format that the parent category of all the items that we want back must have its name property matching the current selected category name
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            // this is making sure that predicate is not nil
            // then we are going to say that the predicate for our request is going to be an NSCompoundPredicate created using the sub predicates namely the categoryPredicate and the new unwrapped additionalPredicate
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            request.predicate = categoryPredicate
        } // now we have successfully replaced the two lines of code below using optional binding and making sure whenever unwrapping a nil value
        
//        // here we can create a compound predicate. Set this constant equal to NSCompoundPredicate. We are going to initialize it using sub Predicates which includes the predicate that we get passed in as an argument in loadItems() and also the categoryPredicate which makes sure that we filter and keep only the items where the parentCategory matches the current selected category
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate predicate]) // so then we have an array that contains the category predicate and the predicate that gets passed in
//
//        // then we have to add this predicate to the request. Instead of sending the request.predicate to simply a single predicate, we can set it to the compound predicate
//        request.predicate = compoundPredicate
        
        
        // we don't need this line if we are going to pass in another request through the method. We don't need to re-initialize a new request.
//        let request : NSFetchRequest<Item> = Item.fetchRequest()// here we are creating a constant of data type NSFetchRequest that is going to fetch results in the form of items. There are a few cases where you need to specify the data type. Here we need to specify the data type and the entity which we are trying to request.
//        // Here we are putting an equal sign and tapping into the Item class/entity and make a new fetch request.
        
        // context.fetch() can throw an error so we have to use a do catch block
        do {
            itemArray = try context.fetch(request) // we have to speak to our context before we can do anything with our persistent container. we type context.fetch and the fetch we want to make is our current request which is just a blank request that pulls everything that's currently inside our persistent container
            // this method has an output and returns NSFetchRequestResult which we know to be an array of items that is stored in our persistent container
            // Our context is going to fetch this broad request (variable called request above) which basically asks for everything back and once you do, then you're going to save the results inside our ItemArray which is what we used to load up our Table View Data Source

        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    
    
}


//MARK: - Search Bar Methods

// here we are creating an extension and extend the functionality of our ToDoListViewController with a search bar and some search bar methods and we can set it up to be a UISearchBarDelegate
extension TodoListViewController : UISearchBarDelegate {
    
    // this delegate method tells the delegate that the search button was tapped (this method is triggered when the search button is pressed on the search bar) and that is the point where we want to reload our table View using the text that the user has imported
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // in order to read from the context, we have to create a request and we have to declare the request data type and it's going to return an array of items and we are going to set this equal to Item.fetchRequest()
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // now we have this request above and we need to modify it so that we tag on a query that specifies what we want to get back from the database. In order to query objects using Core Data, we need to use something called an NSPredicate
        // we are going to change this from request.predicate to a create a constant - let predicate = ...
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // we are going to initialize this predicate using a format. For the string, we are going to say title since we are going to look at the title attribute of each of our items in the item array and we are going to check that it contains a value. where it says 'args: CVarArg' (after the comma) is the argument that we're going to substitute into this %a sign. The argument is what we printed out in our print statement which is the searchBar.text!
        // when the user presses the search button then whatever we have entered inside the search bar at that time point is going to passed in to this method into the %@ sign
        // Then our query becomes: for all the items in the item array, look for the ones where the title of the item contains the text that replaces the %@ text
        // this looks different because NSPredicate is basically a foundation class that specifies how data should be fetched or filtered. It's essentially a query language. There are a whole bunch of modifiers and logical conditions that you have access to that you can put inside the format string above
        
        // (refactored) now we have structured our query, we are going to add our query to our request
        // request.predicate = predicate ; this line is deleted for refactoring purposes.
        
        // next, we can sort the data that we get back from the database in any order of our choice. We can create a sortDescriptor that is an NSSortDescriptor and we can say that we want to sort using the key that's the title of each of the items and we can sort it in alphabetical order by saying ascending equals true.
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // NSSortDescriptors expects an array of NSSortDescriptors, so we have to add the square brackets to the right side to make it equivalent to request.sortDescriptors = [sortDescriptor]
        
        // (refactored) we can add the sortDescriptor to our request by saying request.sortDescriptors . Notice that it is plural and that is because it expects an array of NSSortDescriptors, but in our case we want to only specify a single sort rule. We are saying it only contains a single item below and that's a perfectly valid code
        // request.sortDescriptors = [sortDescriptor] ; this line is deleted
        
        
        // (refactored) instead of repeating the do catch block below, we can simply say loadItems() and the request I want to make is this modified request above which contains the query and the sort objectives
        loadItems(with: request, predicate: predicate)
        // since loadItems(request: request) does not make a lot of sense in English, we can modify loadItems() above to have an external parameter. with is only used here to call loadItems
        // we can say loadItems(with:request) and the predicate being this format i.e. the title of the to do list item must contain what's inside the current search bar
    
        
        // now all we have to do is run our request and fetch the results. We can look at our loadItems() method above and see that it does exactly that.
        // here we are going to try using our context to fetch these results from our persistent store that satisfy the rules that we specified for our request which is namely the title should contain whatever is in the search bar and the results should come back with their titles sorted in ascending alphabetical order. Then we assign the results of that  fetch to our item array and we now need to reload our table View so that we retrigger the selfForRow(indexPath) methods and we update our table view with the current item array, which contains the results of the search
        // context.fetch() can throw an error so we have to use a do catch block
//        do {
//            itemArray = try context.fetch(request) // we have to speak to our context before we can do anything with our persistent container. we type context.fetch and the fetch we want to make is our current request which is just a blank request that pulls everything that's currently inside our persistent container
//            // this method has an output and returns NSFetchRequestResult which we know to be an array of items that is stored in our persistent container
//            // Our context is going to fetch this broad request (variable called request above) which basically asks for everything back and once you do, then you're going to save the results inside our ItemArray which is what we used to load up our Table View Data Source
//
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        // tableView.reloadData() ; we can delete this since we are already calling this in loadItems()
        
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

