//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Joshua Graciano on 1/15/19.
//  Copyright © 2019 Joshua Graciano. All rights reserved.
//

import UIKit
import SwipeCellKit

// we are creating a superclass here to hold all our swipe cell code so the other two view controllers can inherit from here
// this is going to be the section where we deal with all the Swipe Cell Delegate Methods
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0 // here we are going to increase the size of our cell to see if our swipe delete option is fully visible.
        
    }
    
    //TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // here is where we want to initialize the Swipe Table View Cell as the default cell for all of the table views that inherit this class
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        // here we are saying go and find that prototype cell called 'Cell' inside main.storyboard and generate a whole bunch of it that we can reuse
        // The identifier is the identifier which we gave to our prototype cell in main.storyboard
        // the indexPath is going to be the current index path that the Table View is looking to populate
        // here we are downcasting this as a SwipeTableViewCell following the documentation for SwipeCellKit
        // Both the CategoryViewController and the ToDoListViewController have a cell called 'Cell'
        
        // set the cell's delegate as self according to the documentation for SwipeCellKit
        // we will keep this as cell.delegate = self because this is the place that has all of those delegate mtheods that will deal with the deletions
        cell.delegate = self
        
        //final step is to return the cell
        return cell
    }

    // this is the only required delegate method
    // this method is responsible for handling what should happen when a user actually swipes on the cells
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        // the first thing it does is to check and make sure that the orientation of the swipe is from the right
        guard orientation == .right else { return nil }
        
        // this closure handles what should happen when the cell gets swiped
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath) // the IndexPath here will be the same one that triggered this delete delegate method
            
        }
        
        // customize the action appearance
        // finally we add an image to that part of the cell that's going to show when we swipe on the cell
        deleteAction.image = UIImage(named: "delete-icon")
        
        // here we return this delete action as the response to a user swiping on the cell
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive // you can view the expansion styles in the Github page for SwipeCellKit. This option will try to remove the last row from your table view, so before you can run your app, you must delete tableView.reloadData() above in editActionsForRowAt()

        return options
    }
    
    
    // the external parameter will be 'at:' Inside the function, it will just be called indexPath
    func updateModel(at indexPath: IndexPath) {
        // update our Data Model
        
    }
}
