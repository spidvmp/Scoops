//
//  NewsTVC.swift
//  Scoops
//
//  Created by Vicente de Miguel on 24/2/16.
//  Copyright © 2016 Vicente de Miguel. All rights reserved.
//

import UIKit

class NewsTVC: UITableViewController {
    
    @IBOutlet weak var readerButton: UIBarButtonItem!
    
    //utilizo esta tabla para mostrar las publicaciones de todos y mis publicaciones. Eso lo selecciono segun tenga este bool y se cargan los datos del modelo con unos valores u otros y se reload la tabla, por defecto se muestran las noticias, asi que soy lector
    var iAmReader : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //compruebo el valor de iAmReader para poner el texto que corresponda
        if iAmReader {
            //pongo la opcion para irse a escritor
            self.readerButton.title = "Escribir"
        } else {
            self.readerButton.title = "Noticias"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath)

        cell.textLabel!.text = "Noticia \(indexPath.row)"
        cell.detailTextLabel!.text = "by Me"

        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("seleccionan el \(indexPath.row)")
//        performSegueWithIdentifier("showNewsDetail", sender: indexPath.row)
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //MARK: - Actions
    
    @IBAction func SwapBetweenReaderAndWriter(sender: AnyObject) {
        
        
        
        //cambio el valor del lector
        iAmReader = !iAmReader
        
        //compruebo el valor de iAmReader para poner el texto que corresponda
        if iAmReader {
            //pongo la opcion para irse a escritor
            self.readerButton.title = "Escribir"
        } else {
            self.readerButton.title = "Noticias"
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showNewsDetail" {
            
            let detail = segue.destinationViewController as? ReportVC
            let ip = self.tableView.indexPathForSelectedRow!.row
            detail?.model = ip
        }

    }
    

}
