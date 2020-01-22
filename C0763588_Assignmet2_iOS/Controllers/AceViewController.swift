

import UIKit

class AceViewController: UITableViewController {
    
    var detailViewController: DetaailsViewController? = nil
    private(set) var changingReallySimpleNote : Zotes?
     var count : Int64  = 0
    var choice : Bool  = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Core data initialization
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            // create alert
            let alert = UIAlertController(
                title: "Could note get app delegate",
                message: "Could note get app delegate, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            // show alert
            self.present(alert, animated: true)
            
            return
        }
        
        // As we know that container is set up in the AppDelegates so we need to refer that container.
        // We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // set context in the storage
        SimpleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext)
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetaailsViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row]
                let object = SimpleNoteStorage.storage.readNote(at: indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetaailsViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        return SimpleNoteStorage.storage.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SampleNoteUITableViewCell
        
        if let object = SimpleNoteStorage.storage.readNote(at: indexPath.row) {
            cell.noteTitleLabel!.text = object.noteTitle
            cell.noteTextLabel!.text = object.noteText
            cell.dayworkedlabel!.text = "\(object.dayworked)"
            cell.totaldayslabel!.text = "\(object.totalday)"
            
            if(object.dayworked == object.totalday)
            {
                cell.backgroundColor = .purple
                cell.statuslabel!.text = "Completed"
        
            }
            else
            {
                
                cell.backgroundColor = .white
            }
        
            cell.noteDateLabel!.text = SimpleNoteDateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            //objects.remove(at: indexPath.row)
    //            ReallySimpleNoteStorage.storage.removeNote(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        } else if editingStyle == .insert {
    //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    //        }
    //    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action1 = UITableViewRowAction(style: .default, title: "Delete", handler: {
            (action, indexPath) in
            print("Delete")
            //objects.remove(at: indexPath.row)
            SimpleNoteStorage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        action1.backgroundColor = UIColor.lightGray
        let action2 = UITableViewRowAction(style: .default, title: "Add day", handler: {
            (action, indexPath) in
            print("Add day")
            
            let object = SimpleNoteStorage.storage.readNote(at: indexPath.row)
               
            let day : Int  = Int(object!.dayworked)
            let total : Int  = Int(object!.totalday)
            if(day == total)
                          {
                                         // create alert
                                          let alert = UIAlertController(
                                              title: "Alert",
                                              message: "Task Already completed",
                                              preferredStyle: .alert)
                                          
                                          // add OK action
                                          alert.addAction(UIAlertAction(title: "OK",
                                                                        style: .default ))
                                         // show alert
                                          self.present(alert, animated: true)
                          }
                          else
                          {
                              self.changeItem(indexPath: indexPath.row)
                          }
            
            
        })
         return [action1, action2]
    }
    
    private func changeItem(indexPath: Int) -> Void {
        
        let object = SimpleNoteStorage.storage.readNote(at: indexPath)
        setChangingReallySimpleNote(changingReallySimpleNote: object!)
        
        // get changed note instance
        if let changingReallySimpleNote = self.changingReallySimpleNote {
            count = object!.dayworked
            count+=1
            // change the note through note storage
            SimpleNoteStorage.storage.changeNote(
                noteToBeChanged: Zotes(
                    noteId:        changingReallySimpleNote.noteId,
                    noteTitle:     object!.noteTitle,
                    noteText:      object!.noteText,
                    noteTimeStamp: object!.noteTimeStamp,
                    dayworked:     count,
                    totalday :     object!.totalday)
            )
            // navigate back to list of notes
//            performSegue(
//                withIdentifier: "backToMasterView",
//                sender: self)
        } else {
            // create alert
            let alert = UIAlertController(
                title: "Unexpected error",
                message: "Cannot change the note, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default ))
//            // show alert
            self.present(alert, animated: true)
        }
        
        tableView.reloadData()
    }
    
    func setChangingReallySimpleNote(changingReallySimpleNote : Zotes?) {
        self.changingReallySimpleNote = changingReallySimpleNote
    }
}

