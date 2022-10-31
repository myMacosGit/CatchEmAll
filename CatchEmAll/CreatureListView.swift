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
        let _ = print ("----- NavigationStack")
        NavigationStack {
            
            //            List (creaturesVM.creaturesArray, id: \.self, rowContent:  {  // can clean up later
            //                creature in
            //                Text(creature.name)
            //                    .font(.title2)
            //        }) // List
            
            // Shorter form, trailing closure
            
            List(0..<creaturesVM.creaturesArray.count, id: \.self) { index in
                LazyVStack {
                    NavigationLink {
                        let _ = print ("----- call: CreatureDetailViewModel:DetailView = \(index)  ")
                        DetailView(creature: creaturesVM.creaturesArray[index])
                    } // NaigationLink
                label: {
                    Text("\(index+1).\(creaturesVM.creaturesArray[index].name.capitalized)")
                        .font(.title2)
                } // NaigationLink.label
                } // LazyVStack
                .onAppear {
                    if let lastCreature =
                        creaturesVM.creaturesArray.last {
                        if creaturesVM.creaturesArray[index].name == lastCreature.name && creaturesVM.urlString.hasPrefix("http") {
                            Task {
                                await creaturesVM.GetData()
                            }
                        } // if
                    } // if
                } // onAppear
                .listStyle(.plain)
                .navigationTitle("Pokemon")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Text ("\(creaturesVM.creaturesArray.count) of \(creaturesVM.count) creatures")
                    }
                } // toolbar
            } // List
        } // NavigationStack
        
        .task {
            let _ = print("CreatureListView:task 1")
            await creaturesVM.GetData()
            let _ = print("CreatureListView:task 2")
        } // task
    } // body
} // View

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreatureListView()
    }
}
