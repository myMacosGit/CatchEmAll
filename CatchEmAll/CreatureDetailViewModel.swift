//
//  CreatureDetailViewModel.swift
//  CatchEmAll
//
//  Created by Richard Isaacs on 30.10.22.
//

import Foundation

@MainActor
class CreatureDetailViewModel : ObservableObject {
    
    private struct Returned: Codable {
        var height: Double
        var weight: Double
        var sprites: Sprite
    }
    
    struct Sprite: Codable {
        var front_default: String?  // last entry null
        var other: Other
    }
    
    struct Other : Codable{
        var officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
        
    }
    
    struct OfficialArtwork : Codable {
        var front_default: String
    }
    
    var urlString = ""
    @Published var height = 0.0
    @Published var weight = 0.0
    @Published var imageURL = ""
    {
        willSet(myNewValue) {
            print("---- New CreatureDetailViewModel:imageURL is \(myNewValue)")
        }
    }


    
    func getData () async {
        
        print("----- We are accessing the CreatureDetailViewModel:url \(urlString) CreatureDetailViewModel")
        
        // Create a URL
        // convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print ("----- ERROR: Could not create a URL from \(urlString)")
            return
        }
        
        do {
            // data, response
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode JSON data into our own data structures, ignore error
            /*
            Parameters

            type
            The type of the value to decode from the supplied JSON object.
             
            data
            The JSON object to decode.
             
             
             SomeClass.self returns SomeClass itself, not an instance of SomeClass
             
             */
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print ("----- JSON ERROR: Could not decode returned JSON data")
                return
            }
            //  We are accessing the url https://pokeapi.co/api/v2/pokemon/
            // JSON returned! count: 1154, next https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20
            
            self.height = returned.height
            self.weight = returned.weight
            //self.imageURL = returned.sprites.front_default ?? ""
            self.imageURL = returned.sprites.other.officialArtwork.front_default
            
        } catch {
            print ("----- ERROR: Could not use URL at \(urlString) to get data and response")
        } // do
        
    } // GetData
    
} // CreaturesViewModel
