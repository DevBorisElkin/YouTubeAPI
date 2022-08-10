//
//  NetworkingHelpers.swift
//  JSONParsingPlayground
//
//  Created by test on 23.07.2022.
//

import Foundation

public class NetworkingHelpers{
    
    // MARK: Classic simple example
    public static func decodeData<T: Decodable>(from url: String, type: T.Type, printJSON: Bool, completion: @escaping (T) -> ()){
        loadDataFromURL(from: url, printJSON: printJSON) { data in
            do{
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(result)
            }catch{
                print("\(#function) Couldn't decode data properly, error: \(error.localizedDescription)")
            }
        }
    }
    /// Completion is called on UI thread
    public static func loadDataFromURL(from url: String, printJSON: Bool, completion: @escaping (Data) -> ()){
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                print("\(#function) Couldn't load data from URL")
                if let error = error {
                    print(error)
                }
                return
            }
            
            if printJSON, let json = try? JSONSerialization.jsonObject(with: data, options: []){
                print("-----JSON Retrieved-----\n\(json)\n-----JSON Ended-----")
            }
            
            DispatchQueue.main.async{
                completion(data)
            }
        }
        task.resume()
    }
    // MARK: Example code - can either successfully return value or error
    public static func decodeDataWithResult<T: Decodable>(from url: String, type: T.Type, printJSON: Bool, completion: @escaping (Result<T, Error>) -> ()){
        
        loadDataFromURLWithResult(from: url, printJSON: printJSON) { result in
            switch(result){
            case .success(let data):
                do{
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public static func loadDataFromURLWithResult(from url: String, printJSON: Bool, completion: @escaping (Result<Data, Error>) -> ()){
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                print("\(#function) Couldn't load data from URL")
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            if printJSON, let json = try? JSONSerialization.jsonObject(with: data, options: []){
                print("-----JSON Retrieved-----\n\(json)\n-----JSON Ended-----")
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
