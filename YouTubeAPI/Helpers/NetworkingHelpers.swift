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
        
        guard let requestUrl = URL(string: url) else {print("Something is wrong with url for string: \(url)"); return }
        
        let task = URLSession.shared.dataTask(with: requestUrl) { data, response, error in
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
    
    // MARK: Better content loading with async await
    
    enum NetworkRequestError: Error {
        case badUrlString
        case networkRequestFailed
        case cannotDecodeType
        case timedOut
        case youTubeQuotaExceeded
        case undefined
    }
    
    /// Call it from Task{} or Task.detached{}
    public static func loadDataFromUrl<T : Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    public static func loadDataFromUrlString<T : Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw NetworkRequestError.badUrlString }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    public static func loadDataFromUrl<T : Decodable>(from url: URL, printJsonAndRequestString: Bool = false) async -> Result<T, Error> {

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if printJsonAndRequestString, let json = try? JSONSerialization.jsonObject(with: data, options: []){
                print(">>>>>Making request for url string: [\(url.absoluteString)]\n-----JSON Retrieved-----\n\(json)\n-----JSON Ended-----")
            }
            
            if let httpURLResponse = response as? HTTPURLResponse, let status = httpURLResponse.status {
                switch status.responseType {
                    
                case .clientError:
                    return .failure(NetworkRequestError.youTubeQuotaExceeded)
                default:
                    break
                }
            }
            
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch {
            print("failure for request:\n\(url.absoluteString)")
            return .failure(error)
        }
    }
    
    public static func loadDataFromUrlString<T : Decodable>(from urlString: String, printJsonAndRequestString: Bool = false) async -> Result<T, Error> {
        guard let url = URL(string: urlString) else { return .failure(NetworkRequestError.badUrlString) }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if printJsonAndRequestString, let json = try? JSONSerialization.jsonObject(with: data, options: []){
                print(">>>>>Making request for url string: [\(urlString)]\n-----JSON Retrieved-----\n\(json)\n-----JSON Ended-----")
            }
            
            if let httpURLResponse = response as? HTTPURLResponse, let status = httpURLResponse.status {
                switch status.responseType {
                    
                case .clientError:
                    return .failure(NetworkRequestError.youTubeQuotaExceeded)
                default:
                    break
                }
            }
            
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch {
            print("failure for request:\n\(url.absoluteString)")
            return .failure(error)
        }
    }
}
