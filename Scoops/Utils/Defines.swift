//
//  Defines.swift
//  Scoops
//
//  Created by Vicente de Miguel on 24/2/16.
//  Copyright © 2016 Vicente de Miguel. All rights reserved.
//



//definiciones para conexion con Azure
let kEndpointMobileService = "https://scoopsspidvmp.azure-mobile.net/"
let kAppKeyMobileService = "zVKmUAIiFxyqaoNXdFpJltFfvXphJe87"
//let kEndpointAzureStorage = "https://videoblogapp.blob.core.windows.net"

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

