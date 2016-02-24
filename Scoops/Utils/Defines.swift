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

