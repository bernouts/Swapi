import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService: Decodable {
    
    static private let baseURL = URL(string: "http://swapi.dev/api/")
    static let peopleEndpoint = "people"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        guard let baseURL = baseURL else { return completion(nil) }
        let peopleURL = baseURL.appendingPathComponent(peopleEndpoint)
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error)
                print(error.localizedDescription)
                return completion(nil)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return completion(nil) }
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                return completion(nil)
            }
        }.resume()
    }
} // END OF CLASS

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film)
        }
    }
}
SwapiService.fetchPerson(id: 1) { (person) in
    print("==========================\n")
    if let person = person {
        print(person)
        print("\n==========================")
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}
