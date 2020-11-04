import Foundation
import Firebase

class StorageManager {
    static let shared = StorageManager()
    
    private let reference = Storage.storage().reference()
    
    public typealias UploadResult = (Result<String, Error>) -> Void
    public func uploadProfileImage(uploadData: Data, fileName: String, completion: @escaping UploadResult) {
        reference.child("profileImages").child(fileName).putData(uploadData, metadata: nil) { (_, error) in
            guard error == nil else {
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            self.reference.child("profileImages").child(fileName).downloadURL { (url, error) in
                guard let urlString = url?.absoluteString, error == nil else {
                    completion(.failure(StorageError.failedToDownload))
                    return
                }
                completion(.success(urlString))
            }
        }
    }
    
    public func uploadMessagePhoto(uploadData: Data, fileName: String, completion: @escaping UploadResult) {
        reference.child("messageImages").child(fileName).putData(uploadData, metadata: nil) { (_, error) in
            guard error == nil else {
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            self.reference.child("messageImages").child(fileName).downloadURL { (url, error) in
                guard let urlString = url?.absoluteString, error == nil else {
                    completion(.failure(StorageError.failedToDownload))
                    return
                }
                completion(.success(urlString))
            }
        }
    }
    
    public enum StorageError: Error {
        case failedToUpload, failedToDownload
    }
}
