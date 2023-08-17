//
//  AzureBlobImage.swift
//  LogVieApp
//
//  Created by a0000 on 2021/12/06.
//

import Foundation
import AZSClient
import UIKit

class AZBlobImage{
    let connectionString:String = "DefaultEndpointsProtocol=https;AccountName=logvieoblobimgs;AccountKey=LmiLJOBXGakx9UodRVLenmDyg8aoRDWabfKIyO28rTOHMRptZVH2oooHj0TEOGKQwwxDWrmcaa2/N/apD3e2wg==;EndpointSuffix=core.windows.net"
    let blobContainer:AZSCloudBlobContainer
    
    init(containerName:String) {
        guard let account = try? AZSCloudStorageAccount(fromConnectionString: connectionString) else {
            blobContainer = AZSCloudBlobContainer()
            return
        }
        let blobClient = account.getBlobClient()
        self.blobContainer = blobClient.containerReference(fromName: containerName)
    }
    
    func uploadImage(image:UIImage, blobName:String){
        self.blobContainer.createContainerIfNotExists { error, isExist in
            if let error = error{
                print(error.localizedDescription)
            } else {
                let blockBlob = self.blobContainer.blockBlobReference(fromName: blobName)
                if let data = image.pngData(){
                    blockBlob.upload(from: data) { error in
                        if let error = error{
                            print(error.localizedDescription.description)
                        }
                    }
                }
            }
        }
    }
    
    func uploadData(data:Data, blobName:String){
        self.blobContainer.createContainerIfNotExists { error, isExist in
            if let error = error{
                print(error.localizedDescription)
            } else {
                let blockBlob = self.blobContainer.blockBlobReference(fromName: blobName)
                
                blockBlob.upload(from: data) { error in
                    if let error = error{
                        print(error.localizedDescription.description)
                    }
                }
                
            }
        }
    }
    
    func downloadImage(blobName:String, imageView:UIImageView, handler:@escaping (UIImage?)->()){
        let blockBlob = blobContainer.blockBlobReference(fromName: blobName)
        blockBlob.downloadToData { error, data in
            if let error=error{
                print(error.localizedDescription)
            }
            print(error?.localizedDescription)
            if let data = data{
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
                
                handler(image)
            }
        }
    }
    
    func deleteImage(blobName:String, handler:@escaping ()->()){
        let blockBlob = blobContainer.blockBlobReference(fromName: blobName)
        blockBlob.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                handler()
            }
        }
    }
}
