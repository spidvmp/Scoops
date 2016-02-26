//
//  ReportVC.swift
//  Scoops
//
//  Created by Vicente de Miguel on 24/2/16.
//  Copyright © 2016 Vicente de Miguel. All rights reserved.
//

import UIKit

class ReportVC: UIViewController {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var tituloTF: UITextField!
    @IBOutlet weak var textoTV: UITextView!
    @IBOutlet weak var boton: UIButton!
    
    //conexion con azure
    let client = getMSClient()
    
    //modelo de noticia que se ha seleccionado
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
        }
        updateUI()
    }
    
    func updateUI(){
        if isEditingNews {
        self.tituloTF!.text = model!["titulo"] as? String
        self.textoTV!.text = model!["texto"] as? String
        } else {
            self.tituloTF!.placeholder = "Titulo"
            
        }
    }

    @IBAction func clickButton(sender: AnyObject) {
        //compruebo si tengo que insertar o actualizar
        if isEditingNews {
            //tengo que actualizar
        } else {
            //es nuevo, inserto
            
        }
    }
    
    
    //MARK: - Acceso a Azure
    
}
