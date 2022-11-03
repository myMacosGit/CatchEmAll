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
    @State private var searchText = ""
    
    
    {
        willSet(myNewValue) {
            print("---- New CreaturesViewModel is \(myNewValue)")
        }
    }
    
    var body: some View {
        //let _ = print ("----- NavigationStack")
        NavigationStack {
            ZStack {
                List(searchResults) { creature in
                    LazyVStack {
                        NavigationLink {
                            //let _ = print ("----- call: CreatureDetailViewModel:DetailView = \(index)  ")
                            DetailView(creature: creature)
                        } // NaigationLink
                    label: {
                        Text(creature.name.capitalized)
                            .font(.title2)

                    } // NaigationLink.label
                    } // LazyVStack
                    .onAppear {
                        
                        Task {
                            await creaturesVM.loadNextIfNeeded(creature: creature)
                        }
//                        // Check if last entry in creatures array is not nil and
//                        // that the last entry has a valid url
//                        if let lastCreature =
//
//                            /*
//                             If the collection is empty, the value of this property is nil.
//                             let numbers = [10, 20, 30, 40, 50]
//                             if let lastNumber = numbers.last {
//                                 print(lastNumber)
//                             }
//                             // Prints "50"
//                             */
//
//                            creaturesVM.creaturesArray.last {
//                            if creaturesVM.creaturesArray[index].name == lastCreature.name && creaturesVM.urlString.hasPrefix("http") {
//                                Task {
//                                    //let _ = print("----- found http  \(lastCreature.name)  \(index)  ")
//                                    await creaturesVM.getData()
//                                } // Task
//                            } // if
//                        } // if
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

                .searchable(text: $searchText)
                
                if creaturesVM.isLoading {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }

            }  // ZStack
        } // NavigationStack
        
        .task {
            //let _ = print("CreatureListView:task 1")
            await creaturesVM.getData()
            //let _ = print("CreatureListView:task 2")
        } // task
    } // body
    
    var searchResults: [Creature] {
        if searchText.isEmpty {
            return creaturesVM.creaturesArray
        } else {
            return creaturesVM.creaturesArray.filter {$0.name.capitalized.contains(searchText)}
        }
    }
    
    
} // View

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreatureListView()
    }
}
