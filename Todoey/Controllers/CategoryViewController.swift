//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joshua Graciano on 12/27/18.
//  Copyright © 2018 Joshua Graciano. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // initialize a new realm
    // the try! is what you would call a code smell or a bad smell. It is something that indicates or hints at possibly bad code and maybe a deeper problem but not always
    // the Reason this Realm() initialization throws an error is because according to Realm, the first time when you are creating a new Realm instance, it can fail if your resources are constrained. In practice, this can only happen the first time a Realm instance is created on a given thread
    let realm = try! Realm()

    var categoryArray : Results<Category>? // Results is just an auto-updating container type (container types are things like arrays, dictionaries, results, lists) and it comes from Realm and it gets returned from object Queries. So that means whenever you try to query your Realm database, the results you get back are in the form of a Results object. This is going to contain a whole bunch of Category objects
    // we are making this an optional not force unwrapping it with an ! mark because if we forget to load up our categories below and this line was in fact nil, when we force unwrap it and try to use it to populate our Table View, we will have an issue
    

    
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
        return categoryArray?.count ?? 1// returns the number of categories in the array initialized near the class declaration
        // here we are saying if categoryArray is not nil, then return categories.count but if it is nil, then just return 1
        // the '??' is called the Nil Coalescing operator. What this means is that the left side can be nil because categoryArray is an optional and we're only saying get the count of categoryArray if it is not nil, but if it is nil, then 'categoryArray?.count' is going to be nil and the nil coalescing operator will say use the value on the right side aka 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // we are going to create a cell in here that is going to be a reusuable cell and add it to the table at the index path
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        // here we are saying go and find that prototype cell called 'CategoryCell' inside main.storyboard and generate a whole bunch of it that we can reuse
        // The identifier is the identifier which we gave to our prototype cell in main.storyboard
        // the indexPath is going to be the current index path that the Table View is looking to populate
      
        
        //Once we got our cell dequeued, the next step is to set the text label. This is the label that's in every single cell and we're going to set its text property and we're going to set it to equal the category in our category array
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No New Categories Added Yet" // this is the current row of the current index that we are populating. We need to tap into the name property using the dot notation since this will return a Categories object.
          // here we are saying if the categoryArray is not nil, then we're going to get the item at the indexPath.row and grab the name property. If it is nil, then we're going to say the text is just going to be equal to no categories
        
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
            
            
            let newCategory = Category() // we need to initialize our Realm object differently. Now our Category is going to be a straight up object from the Category Data Model
            
            
            newCategory.name = textField.text! // here we are creating a new Category object and tapping into its name property and setting equal to the text that is entered
            
            // since the Result<Element> data type is an auto updating container, we don't need to append things to it anymore. It will simply auto-update and monitor for those changes
            
            self.save(category: newCategory)
            
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
    
    func save(category : Category) {
        do {
            try realm.write {// here we need to try to write to our Realm database
                realm.add(category) // we are going to add our new category that is passed in to our function and save it into our Realm container
            }
            
        } catch {
            print("Error adding data \(error)")
        }
        
        self.tableView.reloadData() // this reloads the rows and the sections of the TableView taking into account the new data we've added to our categoryArray. This is done so our table view updates with our latest data.
    }
    
    // this is where we read from our database
    func loadCategories() {
        
        // here we are specifying the type which is all of the Category type objects.
        // this will pull out all of the items inside our Realm that are of Category objects
        // the data type that we get back here is Results containing a whole bunch of Categories as the element inside the results and the categoryArray is also the same data type
        categoryArray = realm.objects(Category.self)

//        tableView.reloadData() // we have to tell our table view to reload the data using our latest version of categories after fetching all of the category objects.
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
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            // we are adding a ? to say that the selectedCategory of the destination VC will be set to the category if it is not nil at the indexPath.row that was selected.
        }
    }
}
