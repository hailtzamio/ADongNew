//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class FileChildListViewController: BaseViewController {
    
    var data = [DesignFile]()
    
    var item = DesignFile()
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setupHeader() {
        header.title = "Chi Tiết"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
        
        popupHandle()
    }
}

extension FileChildListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
        cell.setDataFileChild(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        downloadFile(fileUrl: data[indexPath.row].downloadUrl ?? "")
        item = data[indexPath.row]
        showYesNoPopup(title: "Xác nhận", message: "Tải file này?")
        
        
    }
    
    func downloadFile(fileUrl : String) {
        let url = URL(string: fileUrl)!
        
        //        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
        //            if let localURL = localURL {
        //                if let string = try? String(contentsOf: localURL) {
        //                    print(string)
        //                }
        //            }
        //        }
        //
        //        task.resume()
        
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    func popupHandle() {
        okAction = {
            self.downloadTest(data: self.item)
        }
    }
}


extension FileChildListViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
    
    func downloadTest(data: DesignFile) {
        // Create destination URL
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent(data.fileName!)
        
        //Create URL to the source file you want to download
        let fileURL = URL(string: data.downloadUrl!)
        
        let sessionConfig = URLSessionConfiguration.default
        let session =  URLSession(configuration: sessionConfig, delegate: self, delegateQueue: OperationQueue())
        
        let request = URLRequest(url:fileURL!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    print(destinationFileUrl)
                    self.showToast(content: "Tải thành công")
                } catch (let writeError) {
                           self.showToast(content: "Đã tồn tại file")
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
            }
        }
        task.resume()
        
        
        
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownloaded = totalBytesWritten / totalBytesExpectedToWrite
        
        // update the percentage label
        DispatchQueue.main.async {
            print("hailpt \(percentDownloaded * 100)%")
        }
    }
}
