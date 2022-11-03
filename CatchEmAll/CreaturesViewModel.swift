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
        var next: String?
        var results: [Creature]
    }
    @Published var isLoading = false
    @Published var urlString = "https://pokeapi.co/api/v2/pokemon/"
    @Published var count = 0
    @Published var creaturesArray: [Creature] = []
    {
        willSet(myNewValue) {
            print("---- New CreaturesViewModel:creaturesArray is \(myNewValue)")
        }
    }
    
    func getData () async {
        print(" We are accessing the CreaturesViewModel:url \(urlString)")
        isLoading = true
        
        // Create a URL
        // convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print ("----- ERROR: Could not create a URL from \(urlString)")
            isLoading = false
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
                isLoading = false
                return
            }
            //  We are accessing the url https://pokeapi.co/api/v2/pokemon/
            // JSON returned! count: 1154, next https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20
            
            print ("JSON returned! count: \(returned.count), next \(returned.next ?? "")  ")
            // Try to decode JSON data into our data structure
            
            self.count = returned.count
            self.urlString = returned.next ?? ""
            self.creaturesArray = self.creaturesArray + returned.results
            isLoading = false
            
        } catch {
            print ("ERROR: Could not use URL at \(urlString) to get data and response")
            isLoading = false
            
        } // do
        
    } // getData
    
    // About 57 calls
    func loadAll() async {
        guard urlString.hasPrefix("http") else { return }
        await getData()
        await loadAll() // call loadAll again until next is null
    } // loadAll
    
    
    
    
    func loadNextIfNeeded (creature: Creature) async {
        
        guard let lastCreature = creaturesArray.last else { return }
        
        if creature.id == lastCreature.id && urlString.hasPrefix("http") {
            Task {
                //let _ = print("----- found http  \(lastCreature.name)  \(index)  ")
                await getData()
            } // Task
        } // if
    } // loadNextIfNeeded
    
} // CreaturesViewModel
