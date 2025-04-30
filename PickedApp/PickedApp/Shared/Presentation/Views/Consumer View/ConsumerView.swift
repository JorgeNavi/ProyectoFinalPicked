//
//  ConsumerView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 27/4/25.
//


//
//  ConsumerPruebaView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 25/4/25.
//

import SwiftUI

struct ConsumerView: View {
    
    @State private var viewModel = GetNearbyRestaurantViewModel()
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var filterText = ""
    
    let columns = [
        GridItem(.adaptive(minimum: 180))
    ]
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Text("All")
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.restaurantFilter) { restaurant in
                        NavigationLink {
                            RestaurantDetail(restaurantID: restaurant.id)
                        } label: {
                            RestaurantRowView(restaurant: restaurant)
                        }
                    }
                }
            }
            .navigationTitle("Restaurants")
            .searchable(text: $viewModel.search, prompt: "Search")
            .onAppear {
                Task {
                  try await viewModel.loadData()
                }
            }
        }
    }
}

#Preview {
    ConsumerView()
}
