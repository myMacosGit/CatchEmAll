//
//  CreatureListView.swift
//  CatchEmAll
//
//  Created by Richard Isaacs on 28.10.22.
//

import SwiftUI

struct CreatureListView: View {
    //var creatures = ["Pikachu", "Squirtle"]
    
    @StateObject var creaturesVM = CreaturesViewModel()
    
    var body: some View {
        NavigationStack {
            
//            List (creaturesVM.creaturesArray, id: \.self, rowContent:  {  // can clean up later
//                creature in
//                Text(creature.name)
//                    .font(.title2)
//        }) // List

            // Shorter form, trailing closure
            
            List(creaturesVM.creaturesArray, id: \.self) { creature in
                NavigationLink {
                    DetailView(creature: creature)
                } label: {
                    Text(creature.name.capitalized)
                        .font(.title2)
                } // NavigationLink
            } // List
            .listStyle(.plain)
            .navigationTitle("Pokemon")
            
        } // NavigationStack
        
        .task {
            await creaturesVM.GetData()
        } // task
    } // body
} // View

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreatureListView()
    }
}
