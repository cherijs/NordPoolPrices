//
//  Fetcher.swift
//  NordPool
//
//  Created by Arturs Cirsis on 16/09/2022.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
}

class Fetcher {
    
    func getNordPoolStocks(url: String) async throws -> NordPoolResponse {
        let url_with_date = url + "&endDate=" + Date().getFormattedDate(format: "dd-MM-Y")
        print(url_with_date)
        let (data, response) = try await URLSession.shared.data(from: URL(string: url_with_date)!) //17-09-2022

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        let res = try JSONDecoder().decode(NordPoolResponse.self, from: data) //Data(data.utf8)
        return res
    }
    
}
