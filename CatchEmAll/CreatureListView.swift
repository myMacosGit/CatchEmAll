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
    {
        willSet(myNewValue) {
            print("---- New CreaturesViewModel is \(myNewValue)")
        }
    }
    
    var body: some View {
        //let _ = print ("----- NavigationStack")
        NavigationStack {
            ZStack {
                List(0..<creaturesVM.creaturesArray.count, id: \.self) { index in
                    LazyVStack {
                        NavigationLink {
                            //let _ = print ("----- call: CreatureDetailViewModel:DetailView = \(index)  ")
                            DetailView(creature: creaturesVM.creaturesArray[index])
                        } // NaigationLink
                    label: {
                        Text("\(index+1).\(creaturesVM.creaturesArray[index].name.capitalized)")
                            .font(.title2)

                    } // NaigationLink.label
                    } // LazyVStack
                    .onAppear {
                        // Check if last entry in creatures array is not nil and
                        // that the last entry has a valid url
                        if let lastCreature =
                            
                            /*
                             If the collection is empty, the value of this property is nil.
                             let numbers = [10, 20, 30, 40, 50]
                             if let lastNumber = numbers.last {
                                 print(lastNumber)
                             }
                             // Prints "50"
                             */
                            
                            creaturesVM.creaturesArray.last {
                            if creaturesVM.creaturesArray[index].name == lastCreature.name && creaturesVM.urlString.hasPrefix("http") {
                                Task {
                                    //let _ = print("----- found http  \(lastCreature.name)  \(index)  ")
                                    await creaturesVM.getData()
                                } // Task
                            } // if
        
                        } // if
                    }
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
} // View

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreatureListView()
    }
}
