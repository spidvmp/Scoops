//
//  NewsTVC.swift
//  Scoops
//
//  Created by Vicente de Miguel on 24/2/16.
//  Copyright © 2016 Vicente de Miguel. All rights reserved.
//

import UIKit


class NewsTVC: UITableViewController {
    
    //storage, cuenta scoopsspidvmp.core.windows.net
    //primary GACEQRDGcDPiQUtWRAPX9Z/+PiLx08mQwn+KZhVzlFPegW+Ff99Cs5v5j0ENYlrf2gxTTmABINaqlys658cXGw==
    //let account = AZSCloudStorageAccount(fromConnectionString: "DefaultEndpointsProtocol=https;AccountName=scoopsspidvmp;AccountKey=GACEQRDGcDPiQUtWRAPX9Z/+PiLx08mQwn+KZhVzlFPegW+Ff99Cs5v5j0ENYlrf2gxTTmABINaqlys658cXGw==")
    
    @IBOutlet weak var readerButton: UIBarButtonItem!
    
    //utilizo esta tabla para mostrar las publicaciones de todos y mis publicaciones. Eso lo selecciono segun tenga este bool y se cargan los datos del modelo con unos valores u otros y se reload la tabla, por defecto se muestran las noticias, asi que soy lector
    var iAmReader : Bool = true
    
    //como voy con la mierda del storyboard, no puedo pasar el cliente, lo vuelvo a generar, deberia dar lo mismo
    var client = getMSClient()
    var imageContainer : AZSCloudBlobContainer?
    
    //array del modelo de datos
    var model: [AnyObject]?
    var modelblob : [AZSCloudBlob]?
    


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
        //si soy lector o estoy con mis noticias pongo el detalle diferente, o el autor, o el estado de la noticia
        if iAmReader  {
            cell.detailTextLabel!.text = news["autor"] as? String
        } else {
            //son mis noticias, asi que pongo el estado
            if let estado = news["estado"] as? String {
                switch estado {
                    case "P":
                        cell.detailTextLabel!.text = "Publicado"
                    case "WP":
                        cell.detailTextLabel!.text = "Publicado en espera de ser visible"
                    case "NP":
                        cell.detailTextLabel!.text = "No Publicado"
                    default:
                        cell.detailTextLabel!.text = "No Publicado"
                }
            }
        }
        

        return cell
    }
    
    //MARK: - Obtencion de datos
    func populateModel(){
        


        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let tablaNoticias = client.tableWithName("Noticias")
//        let blobClient : AZSCloudBlobClient = account.getBlobClient()
//        imageContainer.lis
        
        let query = MSQuery(table: tablaNoticias)
        

        
        //segun sea iAmReader hace una busqueda o hace otra diferente
        if iAmReader {
            //indico el autor
            query.selectFields = ["id","titulo","autor"]
            //soy lector, muestra todas la noticias que esten publicadas sea de quien sea
            query.predicate = NSPredicate(format: "estado == 'P'")
            query.orderByDescending("__createdAt")

        } else {
            //somo solo son mis noticias, no me intersa el autor y si el estado
            query.selectFields = ["id","titulo","estado"]
            // Soy escrito, asi que tengo que estar logado para que muestre solo mis articulos
            query.orderByAscending("titulo")
            query.predicate = NSPredicate(format: "user == '" + client.currentUser.userId + "'")
        }
        
        
        query.readWithCompletion { (result:MSQueryResult?, error:NSError?) -> Void in
            if error == nil {
                self.model = result?.items
                //me recorro todos los elementos bajados
                
                self.tableView.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
            
            //lo elimino de Azure
            let n = model![indexPath.row]
            deleteRecord(n["id"] as! String, client: client)
            
            
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


    //MARK: - Actions
    
    func logarse() {
        //si soy escritor, tengo que estar logado, asi que lo compruebo y si no lo pido
        if iAmReader == false {
            //tengo que estar logadopara mostrar la tabla de mis noticias
            if  isUserloged() {
                if let usrlogin = loadUserAuthInfo() {
                    //guardamos las cerdenciales de logado en client.currentUser
                    client.currentUser = MSUser(userId: usrlogin.usr)
                    client.currentUser.mobileServiceAuthenticationToken = usrlogin.tok
                    
                }
                
            } else {
                
                client.loginWithProvider("facebook", controller: self, animated: true, completion: { (user: MSUser?, error: NSError?) -> Void in
                    
                    if (error != nil){
                        print("Tenemos Problemas")
                    } else{
                        // Persistimos los credenciales del usuario
                        saveAuthInfo(user)
                        
                    }
                })
                
            }
        }
    }
    
    @IBAction func SwapBetweenReaderAndWriter(sender: AnyObject) {
        
        
        
        //cambio el valor del lector
        iAmReader = !iAmReader
        
        //compruebo el valor de iAmReader para poner el texto que corresponda
        if iAmReader {
            //pongo la opcion para irse a escritor
            self.readerButton.title = "Mis Noticias"
        } else {
            logarse()
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
            //compruebo si estaba en la tabla de noticias o de escritor, para dar opcion a modificar o no
            if iAmReader {
                //son las noticias, solo puedo votar y no puedo editar
                detail?.isEditingNews = false
            } else {
                //son mis noticias, las puedo modificar
                detail?.isEditingNews = true
            }
        } else if segue.identifier == "addNewNews" {
            let detail = segue.destinationViewController as? ReportVC
            detail?.model = nil
        }

    }
    

}
