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
    var isEditingNews : Bool! = false
    //genero un boton que usare para subior la noticia o publicarla o borrarla
    var menuItemButton : UIBarButtonItem?

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
            
            //compruebo si es editable, por lo que hay que poner el boton
            if self.isEditingNews == true {
                self.menuItemButton = UIBarButtonItem(title: "Publicar", style: .Plain , target: self, action: "clickPublicar:" )
                self.navigationItem.rightBarButtonItem = self.menuItemButton!
                
            }
        } else {
            //es nueva noticia
            //he de poner el boon para subir, solo cuando es noticia mia
            self.menuItemButton = UIBarButtonItem(title: "Subir Noticia", style: .Plain , target: self, action: "subirNoticia:" )
            self.navigationItem.rightBarButtonItem = self.menuItemButton!
            self.isEditingNews = true
        }
        updateUI()
    }
    
    func updateUI(){
        //si no tengo datos, es que es nueva noticia a redactar
        if let model = model {
            //tengo datos, los muestro
            
            self.tituloTF!.text = model["titulo"] as? String
            self.textoTV!.text = model["texto"] as? String
            self.autorLbl!.text = model["autor"] as? String
            self.puntuacionLbl!.text = model["validacion"] as? String
            
            if let fotoName = model["fotoname"] {
                //tengo imagen, me la tengo que bajar
            }
            
            //si estoy editando mi noticia:
            if self.isEditingNews == true {
                //es mi noticia y la estoy editando
                //no me puedo votar
                self.likeButton.enabled = false
                self.disslikeButton.enabled = false
                //si paso por aqui es que la noticia ya esta subida, compruebo si esta publicada o no para dar opcion a borrarla
                //es posible que cuando se esta acargando, todavia no tengamos estado, asi que hay que comprobarlo

                
                if let estado = model["estado"]!  {
                    if estado as! String == "NP" {
                        //no esta publicada, asi que boton con opcion a publicar
                        //se ha subido la noticia, ahora queda la opcion de publicarla o no
                        self.menuItemButton!.title = "Publicar"
                        self.menuItemButton!.action = "clickPublicar:"
                    } else {
                        //esta publicada, asi que boton con opcion a borrar
                        //se ha subido la noticia, ahora queda la opcion de publicarla o no
                        self.menuItemButton!.title = "Borrar"
                        self.menuItemButton!.action = "deleteNoticia:"
                    }
                }
            } else {
                //estoy viendo la noticia de otro, la puedo votar
                self.likeButton.enabled = true
                self.disslikeButton.enabled = true
            }
            
        } else {
            //es nuevo
            self.tituloTF!.placeholder = "Titulo"
            self.textoTV!.text = ""
            self.puntuacionLbl!.text = ""
            self.autorLbl!.text = ""
            self.likeButton.enabled = false
            self.disslikeButton.enabled = false
            
            
        }
    }

    
    //MARK: - Actions
    func subirNoticia(sender: AnyObject) {
        //primero compruebo si esta logado, ay que hemos cambiado que el insert solo acepta logados
        if isUserloged() {
            
            //cargamos los datos del usuario
            if let usrlogin = loadUserAuthInfo() {
                //guardamos las cerdenciales de logado en client.currentUser
                client.currentUser = MSUser(userId: usrlogin.usr)
                client.currentUser.mobileServiceAuthenticationToken = usrlogin.tok
                
                //es nuevo, inserto
                let tablaNoticias = client.tableWithName("Noticias")
                //estoy logado por cojones, asi que el numero de user lo grabo para saber cuales son mis publicaciones
                //no inseeto nada ane validacion, ya que siempre inicio con 0, asi que lo hago en el script de insertar
                //queda el script preparado para que si envio el autor no lo vuelva a buscar, de momento no lo implemento por tiempo
                tablaNoticias?.insert(["titulo": tituloTF.text!, "texto": textoTV.text, "estado": "NP", "user":usrlogin.usr], completion: { (inserted, error: NSError?) -> Void in
                    if error != nil {
                        print ("Error al insertar noticia: \(error)")
                    }
                })
                //se ha subido la noticia, ahora queda la opcion de publicarla o no
                self.menuItemButton!.title = "Publicar"
                self.menuItemButton!.action = "clickPublicar:"
                
            }
            
        } else {
            //no estamos logados
            
        }
        
        
        

    }
    
    func clickPublicar(sender: AnyObject) {
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
    
    func deleteNoticia(sender: AnyObject) {
        
        print("Elimino \(self.model)")
        //se borra, ya no pinto nada aqui
        deleteRecord(model!["id"] as! String, client: client)
//        let tablaNoticias = client.tableWithName("Noticias")
//        tablaNoticias?.delete(["id": model!["id"] as! String], completion: { (inserted, error: NSError?) -> Void in
//            if error != nil {
//                print("Error al borrar mi noticia: \(error)")
//            }
//        })
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - Acceso a Azure
    
    @IBAction func likeAction(sender: AnyObject) {
        print ("Like")
    }
    
    @IBAction func disslikeAction(sender: AnyObject) {
        print("Disslike")
    }
}
