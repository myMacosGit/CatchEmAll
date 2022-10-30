//
//  CreaturesViewModel.swift
//  CatchEmAll
//
//  Created by Richard Isaacs on 28.10.22.
//

/*
 
 {
 count: 1154,
 next: https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20,
 previous: null,
 results: [
 {
 name: bulbasaur,
 url: https://pokeapi.co/api/v2/pokemon/1/
 },
 
 -----
 
 {
 count: 1154,
 next: https://pokeapi.co/api/v2/pokemon/?offset=40&limit=20,
 previous: https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20,
 results:
 
 A type alias for the Combine framework’s type for an object with a publisher
 that emits before the object has changed.
 
 */


import Foundation

@MainActor
class CreaturesViewModel : ObservableObject {
    
    private struct Returned: Codable {
        var count: Int
        var next: String // TODO: want to change this to a option
        var results: [Creature]
    }
    
    @Published var urlString = "https://pokeapi.co/api/v2/pokemon/"
    @Published var count = 0
    @Published var creaturesArray: [Creature] = []
    /* {
        willSet(myNewValue) {
            print("---- New name is \(myNewValue)")
        }
    } */
    
    func GetData () async {
        
        print(" We are accessing the url \(urlString)")
        
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
            
            print ("JSON returned! count: \(returned.count), next \(returned.next)")
            // Try to decode JSON data into our data structure
            
            self.count = returned.count
            self.urlString = returned.next
            self.creaturesArray = returned.results
            
            
        } catch {
            print ("ERROR: Could not use URL at \(urlString) to get data and response")
        } // do
        
    } // GetData
    
} // CreaturesViewModel
