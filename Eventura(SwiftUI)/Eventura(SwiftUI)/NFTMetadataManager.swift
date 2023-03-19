import Foundation

class NFTMetadataManager {
    
    // The Infura API endpoint for the NFT metadata
    let apiEndpoint = "https://ipfs.infura.io:5001/api/v0/cat"
    
    // The Infura API key (assuming it's been added to the app's Info.plist file)
    let infuraAPIKey = ProcessInfo.processInfo.environment["INFURA_API_KEY"] ?? ""
    
    // Retrieves the metadata for an NFT with the given CID
    func fetchMetadata(forCID cid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
        // Construct the URL for the API call
        let url = URL(string: "\(apiEndpoint)/\(cid)")!
        
        // Create a URL request object
        var request = URLRequest(url: url)
        
        // Set the HTTP method to GET
        request.httpMethod = "GET"
        
        // Add the Infura API key to the request headers
        request.addValue(infuraAPIKey, forHTTPHeaderField: "Authorization")
        
        // Send the API request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completion(.failure(NSError(domain: "NFTMetadataManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                      return
            }
            
            guard let data = data,
                  let metadata = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                      completion(.failure(NSError(domain: "NFTMetadataManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])))
                      return
            }
            
            // The NFT metadata is now available as a dictionary in the 'metadata' variable
            completion(.success(metadata))
        }
        
        task.resume()
    }
}
