//
//  ReportVC.swift
//  Scoops
//
//  Created by Vicente de Miguel on 24/2/16.
//  Copyright © 2016 Vicente de Miguel. All rights reserved.
//
//https://azure.microsoft.com/es-es/documentation/articles/mobile-services-ios-how-to-use-client-library/
import UIKit

class ReportVC: UIViewController {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var tituloTF: UITextField!
    @IBOutlet weak var textoTV: UITextView!
    @IBOutlet weak var autorLbl: UILabel!
    @IBOutlet weak var puntuacionLbl: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var disslikeButton: UIButton!
  
    
    //conexion con azure
    let client = getMSClient()
    
    //modelo de noticia que se ha seleccionado, pero viene capado, hay que volver a consultar todo el modelo completo
    var model : AnyObject?
    
    //me quedo con un bool para saber si es edicion o es uno mnuevo
    var isEditingNews : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("seleccionado el \(model)")
        //solo muestro los datos si me han llegado
        if let _ = model {
            //hay contenido
            isEditingNews = true

            //hay que recargar el modelo completo
            let tablaNoticias = client.tableWithName("Noticias")
            let query = MSQuery(table: tablaNoticias)
            if let i = model!["id"] {
                query.predicate = NSPredicate(format: "id == '\(i!)'")
                query.readWithCompletion { (result:MSQueryResult?, error:NSError?) -> Void in
                    if error == nil {
                        self.model?.removeAllObjects()
                        //esto me dvuelve un array de elementos, solo deberia haber 1, me quedo con el en un objeto, no en un array
                        let r = result?.items
                        self.model = r![0]
                        
                    } else {
                        print("Error al recuperar el dato")
                    }
                    print(self.model)
                    self.updateUI()
                }
            }
        } else {
            //es nueva noticia

        }
        updateUI()
    }
    
    func updateUI(){
        if isEditingNews {
            self.tituloTF!.text = model!["titulo"] as? String
            self.textoTV!.text = model!["texto"] as? String
            if let fotoName = model!["fotoname"] {
                //tengo imagen, me la tengo que bajar
            }
        } else {
            self.tituloTF!.placeholder = "Titulo"
            self.textoTV!.text = ""
            
        }
    }

    
    //MARK: - Actions
    @IBAction func clickButton(sender: AnyObject) {
        //compruebo si tengo que insertar o actualizar
            //es nuevo, inserto
            let tablaNoticias = client.tableWithName("Noticias")
            
            tablaNoticias?.insert(["titulo": tituloTF.text!, "texto": textoTV.text, "estado": "NP"], completion: { (inserted, error: NSError?) -> Void in
                if error != nil {
                    print ("Error al insertar noticia: \(error)")
                }
            })
        


    }
    
    @IBAction func clickPublicar(sender: AnyObject) {
        //he de poner la notcia como publicar, he de modificar el estado de NP a P para el id xxxxx
        let tablaNoticias = client.tableWithName("Noticias")
        //modifico lo que hay que cambiar, que es el estado a "P"

        tablaNoticias?.update(["id": model!["id"] as! String, "estado": "P"], completion: { (inserted, error: NSError?) -> Void in
            if error != nil {
                print ("Error al update noticia: \(error)")
            }
        })
        
        //ya eh puvlicado, ya no hago nada aqui, me piro
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    //MARK: - Acceso a Azure
    
    @IBAction func likeAction(sender: AnyObject) {
    }
    
    @IBAction func disslikeAction(sender: AnyObject) {
    }
}
