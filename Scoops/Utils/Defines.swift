//
//  Defines.swift
//  Scoops
//
//  Created by Vicente de Miguel on 24/2/16.
//  Copyright © 2016 Vicente de Miguel. All rights reserved.
//
//prueba de la api desde linea comando curl --header X-ZUMO-APPLICATION:"zVKmUAIiFxyqaoNXdFpJltFfvXphJe87" https://scoopsspidvmp.azure-mobile.net/api/subirfoto
//para ver el contenido de la tabla curl --header X-ZUMO-APPLICATION:"zVKmUAIiFxyqaoNXdFpJltFfvXphJe87" https://scoopsspidvmp.azure-mobile.net/tables/Noticias


//definiciones para conexion con Azure
let kEndpointMobileService = "https://scoopsspidvmp.azure-mobile.net/"
let kAppKeyMobileService = "zVKmUAIiFxyqaoNXdFpJltFfvXphJe87"
let kEndpointAzureStorage = "https://scoopsspidvmp.blob.core.windows.net"

let account = AZSCloudStorageAccount(fromConnectionString: "DefaultEndpointsProtocol=https;AccountName=scoopsspidvmp;AccountKey=GACEQRDGcDPiQUtWRAPX9Z/+PiLx08mQwn+KZhVzlFPegW+Ff99Cs5v5j0ENYlrf2gxTTmABINaqlys658cXGw==")

//metodos para obtener el cliente de conexion con Azure
func getMSClient() -> MSClient {
    return MSClient(
        applicationURLString: kEndpointMobileService,
        applicationKey: kAppKeyMobileService
    )
}



//metodos para guardar el login de facebook localmente y poderlo recuperar
func saveAuthInfo (currentUser : MSUser?){
    NSUserDefaults.standardUserDefaults().setObject(currentUser?.userId, forKey: "userId")
    NSUserDefaults.standardUserDefaults().setObject(currentUser?.mobileServiceAuthenticationToken, forKey: "tokenId")
}


func loadUserAuthInfo() -> (usr : String, tok : String)? {
    let user = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String
    let token = NSUserDefaults.standardUserDefaults().objectForKey("tokenId") as? String
    
    return (user!, token!)
}

func isUserloged() -> Bool {
    
    var result = false
    
    let userID = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String
    if let _ = userID {
        result = true
    }
    return result
    
}

//metodos de manejo de la tabla
func deleteRecord(id: String, client: MSClient) {
    let tablaNoticias = client.tableWithName("Noticias")
    tablaNoticias?.delete(["id": id], completion: { (inserted, error: NSError?) -> Void in
        if error != nil {
            print("Error al borrar mi noticia: \(error)")
        } else {
            //no hubo errores, ahora borro la foto, que tiene como nombre el id.jpg
            
        }
    })
}

