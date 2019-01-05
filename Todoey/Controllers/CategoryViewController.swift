//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joshua Graciano on 12/27/18.
//  Copyright © 2018 Joshua Graciano. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]() // we are changing this array to an array of Category objects which hold info about the categories added to the list in the Category View Controller
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // here we are tapping into the UIApplication class, we are getting the shared singleton object which corresponds to the current app as an object, tapping into its delegate (which has the data type of an optional UIApplication Delegate), then casting it into our class app delegate. Now we have access to our app delegate as an object. We are now able to tap into its property called persistent Container. We are going to grab the viewContext of that persistent container
    // the UIApplication.shared is a singleton app instance. At the time point when our app is running live inside the user's iPhone, then the shared UI Application will correspond to our live application object.
    // Inside this shared UI Application object is something called delegate and this is the delegate of the app object alternatively known as the app delegate. We are going to downcast it as our class delegate
    // here we are grabbing a reference to the context that we are going to be using in order to CRUD our data and this is going to be the thing that's going to communicate with our persistent container
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    //MARK: - TableView Datasource Methods
    
    // Setup the datasource so that we can display all the categories that are inside our persistent container
    
    // there are two methods which allow us to specify what the cells should display and also how many rows we want in our Table View
    
    // first method returns the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // this method expects an output in a return statement that will be the number of rows
        return categoryArray.count // returns the number of categories in the array initialized near the class declaration
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // we are going to create a cell in here that is going to be a reusuable cell and add it to the table at the index path
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        // here we are saying go and find that prototype cell called 'CategoryCell' inside main.storyboard and generate a whole bunch of it that we can reuse
        // The identifier is the identifier which we gave to our prototype cell in main.storyboard
        // the indexPath is going to be the current index path that the Table View is looking to populate
        
        let category = categoryArray[indexPath.row] // this category is now the category that we're currently trying to set up for the cell
        
        //Once we got our cell dequeued, the next step is to set the text label. This is the label that's in every single cell and we're going to set its text property and we're going to set it to equal the category in our category array
        cell.textLabel?.text = category.name // this is the current row of the current index that we are populating. We need to tap into the name property using the dot notation since this will return a Categories object
        
        //final step is to return the cell
        return cell
    }
    
    //MARK: - Add New Categories
    
    // Finally, set up the add button pressed IB Action in order to add new categories using our categories entity

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // here we want a pop up or a UI Alert Controller to show when we press the add button and we have a textfield in that UI Alert Controller so that we can write a quick to do list category and then append it to the end of our categoryArray
        
        var textField = UITextField() // this textfield has the scope of the entire addButtonPressed IB action and is going to be accessible to everything in this method.
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // this is the button that you are going to press once you're done with writing your new To Do list category
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once the user clicks the Add Category button on our UIAlert
            
            
            let newCategory = Category(context: self.context) // we need to initialize our core data object differently. Category is our Core Data class. Here we can specify the context where this category is going to exist. This context is going to be the viewContext of our persistent container (located in App Delegate.swift file)
            
            
            newCategory.name = textField.text! // here we are creating a new Category object and tapping into its name property and setting equal to the text that is entered
            
            self.categoryArray.append(newCategory) // here we are appending the new Category that is created above into our categoryArray that contains category objects.
            //we are appending whatever the user adds in the textfield to the array categoryArray
            
            self.saveCategories()
            
            print(textField.text!) // to check if it the reference we created in the closure below works and is accessible globally. Prints everything that is added to the textfield after the Add Item button is pressed
            
            
        } // press enter on the last parameter to create a completion handler or a closure. This is the completion block that gets called once that "Add Category" gets pressed
        
        // in order to add a textfield to our alert (very similar to adding an action)
        // hit enter on the placeholder parameter to insert closure
        // we are going to call the textfield that we create 'alertTextField
        alert.addTextField { (alertTextField) in
            
            textField = alertTextField  // here we want to set the textField variable with a wider scope equal to the alertTextfield which has a narrower scope. We are extending the scope of this alertTextField to the addButtonPressed method.
            
            // the alertTextfield has the scope of this closure only (only available in here)
            
            alertTextField.placeholder = "Add a new category" // this is the string that is going to show up in gray and is going to disappear when the user clicks on that textfield
        }
        
        alert.addAction(action) // now let's add our action to our alert
        
        present(alert, animated: true, completion: nil)// now we want to show our alert. The view controller to present is the alert view controller
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    //Setup the data manipulation methods namely save data and load data so that we can use CRUD
    
    func saveCategories() {
        // here we need to be able to commit our context to permanent storage inside our persistent container. In order to do that, we need to call 'try context.save!() '. This basically transfers what's currently in our staging area or our scratchpad, that's the context, into our permanent data stores
        do {
            try context.save()
            
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData() // this reloads the rows and the sections of the TableView taking into account the new data we've added to our categoryArray. This is done so our table view updates with our latest data.
    }
    
    // inside here we need to read data from our context
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        // here we can modify this function to take a parameter that is the request. We need to specify the data type and it is an NSFetchRequest and it is going to return an array of categories
        // since loadItems(request: request) does not make a lot of sense in English when calling it below in the extension, we can modify loadItems() above to have an external parameter. With is the external parameter and request is the internal parameter. request (the internal parameter) is going to be used inside this block of code for loadItems() and the external parameter (with) is going to be used when we call the function
        // If when we call this function and we don't provide a value for the request (i.e. in viewDidLoad() above), then we can have a default value that is simply Category.fetchRequest(). Now up in viewDidLoad(), we can call loadItems() without giving it any parameters
        
        // we don't need this line if we are going to pass in another request through the method. We don't need to re-initialize a new request.
        //        let request : NSFetchRequest<Category> = Category.fetchRequest()// here we are creating a constant of data type NSFetchRequest that is going to fetch results in the form of categories. There are a few cases where you need to specify the data type. Here we need to specify the data type and the entity which we are trying to request.
        //        // Here we are putting an equal sign and tapping into the Category class/entity and make a new fetch request.
        
        // context.fetch() can throw an error so we have to use a do catch block
        do {
            categoryArray = try context.fetch(request) // we have to speak to our context before we can do anything with our persistent container. we type context.fetch and the fetch we want to make is our current request which is just a blank request that pulls everything that's currently inside our persistent container
            // this method has an output and returns NSFetchRequestResult which we know to be an array of items that is stored in our persistent container
            // Our context is going to fetch this broad request (variable called request above) which basically asks for everything back and once you do, then you're going to save the results inside our ItemArray which is what we used to load up our Table View Data Source
            
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData() // we have to tell our table view to reload the data using our latest version of categories after fetching all of the category objects.
    }
    
    
    //MARK: - TableView Delegate Methods
    
    // leave this part alone for now. This refers to what should happen when we click on one of the cells inside the category table view
    
    // this will trigger when we select one of the cells; when this delegate method gets triggered, we probably want to trigger the segue we set up earlier that takes the user from the Category View Controller to the ToDoListViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // this is going to be triggered just before we perform that segue
        // here we are going to create a new constant that is going to store a reference to the destination View Controller and we can grab this by using the segue.destination property. We are going to downcast this as a ToDoListViewController  because we know where that segue is going to take us
        let destinationVC = segue.destination as! TodoListViewController
        
        // next, we need to grab the category that corresponds to the selected cell
        if let indexPath = tableView.indexPathForSelectedRow { // this is the index path that is going to identify the current row that is selected
        // .indexPathForSelectedRow is an optional index path so we are going to wrap it with an if let and if the index path is not nil, then we are going to tap into the destination view controller and we're going to set a property in the destination view controller called selectedCategory (which we will create in our ToDoListViewController) and we're going to set it equal to our array of categories at our index path
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}
