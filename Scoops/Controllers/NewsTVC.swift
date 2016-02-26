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
    
    //como voy con la mierda del storyboard, no puedo pasar el cliente, lo vuelvo a generar, deberia dar lo mismo
    var client = getMSClient()
    
    //array del modelo de datos
    var model: [AnyObject]?
    
    
    //activity indicator
    let activityIndicator = UIActivityIndicatorView()

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
            self.readerButton.title = "Mis Noticias"
        } else {
            self.readerButton.title = "Noticias"
        }
        
        //cargo los datos par ala primera vez, no es la mejor forma de hacerlo, pero eso ahroa no importa
        populateModel()
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
        if let model = model {
            return model.count
        } else {
            return 0
        }
        //return (model?.count)!
        //return 20
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath)

        //obtengo la noticia
        let news = model![indexPath.row]
        //cell.textLabel!.text = "Noticia \(indexPath.row)"
        cell.textLabel!.text = news["titulo"] as? String
        cell.detailTextLabel!.text = news["autor"] as? String

        return cell
    }
    
    //MARK: - Obtencion de datos
    func populateModel(){
        
        print("hay que ordenar el POPULATE")
        self.activityIndicator.startAnimating()
        self.navigationController?.navigationItem.titleView = self.activityIndicator
        let tablaNoticias = client.tableWithName("Noticias")
        let query = MSQuery(table: tablaNoticias)
        //query.selectFields = ["titulo","autor","foto"]

        
        //segun sea iAmReader hace una busqueda o hace otra diferente
        if iAmReader {
            //soy lector, muestra todas la noticias que esten publicadas sea de quien sea
            
            
            // Incluir predicados, constrains para filtrar, para limitar el numero de filas o delimitar el numero de columnas
            query.predicate = NSPredicate(format: "estado == 'P'")
            query.orderByDescending("__createdAt")
//            query.readWithCompletion { (result:MSQueryResult?, error:NSError?) -> Void in
//                if error == nil {
//                    self.model = result?.items
//                    self.tableView.reloadData()
//                }
//            }
        } else {
            
            // Incluir predicados, constrains para filtrar, para limitar el numero de filas o delimitar el numero de columnas
            query.orderByAscending("titulo")
            query.predicate = NSPredicate(format: "estado == 'NP'")
        }
        
        
        query.readWithCompletion { (result:MSQueryResult?, error:NSError?) -> Void in
            if error == nil {
                self.model = result?.items
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }

        
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

    
    // MARK: - Borrar celdas
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        //si estoy en modo lector no puedo borrar cledas, ya que no son mias, es lo que esta publicado
        if iAmReader {
            return false
        } else {
            return true
        }
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //solo se puede eliminar si la noticia es mia y estoy en modo escritor, solo aparecen mis noticias
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            model!.removeAtIndex(indexPath.row)
            tableView.endUpdates()
        }
//        else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
    }


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
        //He de recargar la tabla xq hay que cambiar los datos, sera o las noticias o mis noticas escritas
        populateModel()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showNewsDetail" {
            
            let detail = segue.destinationViewController as? ReportVC
            let ip = self.tableView.indexPathForSelectedRow!.row
            detail?.model = model![ip] as AnyObject
        } else if segue.identifier == "addNewNews" {
            let detail = segue.destinationViewController as? ReportVC
            detail?.model = nil
        }

    }
    

}
