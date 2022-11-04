//
//  CreatureListView.swift
//  CatchEmAll
//
//  Created by Richard Isaacs on 28.10.22.
//

import SwiftUI


// List all the creatures in a list

struct CreatureListView: View {
    //var creatures = ["Pikachu", "Squirtle"]
    
    @StateObject var creaturesVM = CreaturesViewModel()
    @State private var searchText = ""
    
    // Will update view, computed property, called by search during updates
    var searchResults: [Creature] {
        let _ = print("----- CreatureListView: searchResults   \(searchText.isEmpty) ")
        if searchText.isEmpty {
            return creaturesVM.creaturesArray   // if no search text, then return all creatures
        } else {
            // Search each array element for name that has search text e.g. e.g.snor
            return creaturesVM.creaturesArray.filter {$0.name.capitalized.contains(searchText)}
        }
    }
    
    var body: some View {
        let _ = print ("----- CreatureListView: NavigationStack \(Thread.current)")
        NavigationStack {
            ZStack {
                List(searchResults) { creature in
                    LazyVStack {
                        NavigationLink {
                            //let _ = print ("----- call: CreatureDetailViewModel:DetailView = \(index)  ")
                            DetailView(creature: creature)  // get detail of a creature
                            //let _ = creature.prt()
                        } // NaigationLink
                    label: {
                        Text(creature.name.capitalized)  // list creatures
                            .font(.title2)
                        
                    } // NaigationLink.label
                    } // LazyVStack
                    .onAppear {
                        
                        Task {
                            //let _ = print ("----- creaturesVM.loadNextIfNeeded")
                            await creaturesVM.loadNextIfNeeded(creature: creature)
                        }
                    } // onAppear
                } // List
                .listStyle(.plain)
                .navigationTitle("Pokemon")
                .toolbar {
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button("Load All") {
                            Task {
                                await creaturesVM.loadAll()
                            }
                        }
                    } // toolbaritem
                    
                    ToolbarItem(placement: .status) {
                        Text ("\(creaturesVM.creaturesArray.count) of \(creaturesVM.count) creatures")
                    } // toolbaritem
                } // toolbar
                
                //    .searchable(text: $searchText)  // search text box and cancel
                .searchable(text: $searchText, prompt: "search for a Pokemon")
                
                if creaturesVM.isLoading {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }
                
            }  // ZStack
        } // NavigationStack
        
        .task {
            let _ = print("---- CreatureListView: call creaturesVM.getData")
            await creaturesVM.getData()
        } // task
    } // body
    
} // View

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreatureListView()
    }
}
