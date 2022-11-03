//
//  DetailView.swift
//  CatchEmAll
//
//  Created by Richard Isaacs on 28.10.22.
//

import SwiftUI

struct DetailView: View {
    @StateObject var creatureDetailVM = CreatureDetailViewModel()
    {
        willSet(myNewValue) {
            print("---- New creatureDetailVM is \(myNewValue)")
        }
    }


    
    var creature: Creature
    
    var body: some View {
        let _ = print ("----- Detail View:creatureDetailVM")
        VStack(alignment: .leading, spacing: 3) {
            Text(creature.name.capitalized)
                .font(Font.custom("Avenir Net Condensed", size: 60))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.bottom)
            
            HStack {
                AsyncImage(url: URL(string: creatureDetailVM.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .background(.white)
                        .frame(width: 96, height: 96)
                        .cornerRadius(16)
                        .shadow(radius:8, x:5, y:5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                        }
                        .padding(.trailing)
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.clear)
                    .frame(width: 96, height: 96)  // make frame overlay
                    .padding(.trailing)
                    
                }
                //                Image(systemName: "figure.run.circle")
                //                    .resizable()
                //                    .scaledToFit()
                //                    .backgroundStyle(.white)
                //                    .frame(maxHeight: 96)
                //                 //   .cornerRadius(16)
                //                 //   .shadow(radius:8, x:5, y:5)
                //                    .overlay {
                //                        RoundedRectangle(cornerRadius: 16)
                //                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                //                    }
                //                    .padding(.trailing)
                
                VStack (alignment: .leading) {
                    HStack (alignment: .top) {
                        Text("Height:")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                        
                        Text(String(format: "%.1f", creatureDetailVM.height))
                            .font(.largeTitle)
                            .bold()
                        
                    } // HStack
                    
                    HStack (alignment: .top) {
                        Text("Weight:")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                        
                        Text(String(format: "%.1f", creatureDetailVM.weight))
                            .font(.largeTitle)
                            .bold()
                        
                    } // HStack
                } // VStack
            } // HStack
            
            Spacer()
        } // VStack
        .padding()
        .task  {
            let _ = print("creatureDetailVM:task 1")

            let _ = print ("---- creatureDetailVM  url \(creature.url)")

            creatureDetailVM.urlString = creature.url
            await creatureDetailVM.getData()
            let _ = print("creatureDetailVM:task 2")
        }
        
    } // body
} // DetailView

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(creature: Creature(name: "bulbasaur",
                                      url: "https://pokeapi.co/api/v2/ability/65/"))
    }
}
