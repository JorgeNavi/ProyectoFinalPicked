import SwiftUI
import PhotosUI

//MARK: Vista de crear un nuevo plato para un restaurante
struct CreateMealView: View {
    
    @Environment(AppStateVM.self) private var appState
    
    @Environment(\.dismiss) private var dismiss
    
    //Estado del formulario
    @State var name = ""
    @State var info = ""
    @State var price = ""
    @State var units = ""
    @State var selectedType = ""

    @State private var pickerItem: PhotosPickerItem? = nil
    @State private var selectedPhotoData: Data?

    @State var viewModel: CreateMealViewModel

    //Listado de tipos de comida disponibles
    let foodTypes = ["american", "asian", "indian", "italian", "mediterranean", "mexican", "vegan", "vegetarian", "other"]

    init(viewModel: CreateMealViewModel = CreateMealViewModel(appState: AppStateVM())) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                //Título de la pantalla
                Text("Add dish")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 20)

                //Campo de texto para el nombre del plato
                IconTextFieldView(iconName: "fork.knife", placeholder: "Meal Name", text: $name, keyboardType: .default)

                //Campo de texto para la descripción del plato
                HStack(alignment: .top) {
                    Image(systemName: "note.text")
                        .foregroundStyle(.secondaryColor)
                        .padding(.top, 12)
                    
                    ZStack(alignment: .topLeading) {
                        if info.isEmpty {
                            Text("Description")
                                .foregroundColor(.gray)
                                .padding(.top, 12)
                                .padding(.leading, 8)
                        }
                    }
                    TextEditor(text: $info)
                        .frame(minHeight: 150)
                        .padding(5)
                }
                .padding(.horizontal)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))

                //Selector de tipo de comida
                Menu {
                    ForEach(foodTypes, id: \.self) { type in
                        Button(type.capitalized) {
                            selectedType = type
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedType.isEmpty ? "Food Type" : selectedType.capitalized)
                            .foregroundColor(selectedType.isEmpty ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                //Campo de texto para las unidades
                IconTextFieldView(iconName: "number", placeholder: "Units", text: $units, keyboardType: .numberPad)

                //Campo de texto para el precio
                IconTextFieldView(iconName: "dollarsign.circle.fill", placeholder: "Price", text: $price, keyboardType: .decimalPad)

                //Selector de imagen del plato, si hay imagen porque el usuario ya ha cargado una, la muestra
                VStack {
                    if let imageData = selectedPhotoData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipped()
                            .cornerRadius(8)
                    } else {
                        PhotosPicker(selection: $pickerItem, matching: .images) {
                            VStack {
                                Text("Take a picture or select one from gallery")
                                    .foregroundStyle(.secondaryColor)
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.secondaryColor)
                            }
                        }
                    }
                }
                .padding()
                .frame(width: 200, height: 200)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                //Botón para añadir el plato
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding()
                } else {
                    CustomButtonView(title: "Add", color: .secondaryColor) {
                        Task {
                            viewModel.isLoading = true
                            let result = try await viewModel.createMeal(
                                name: name,
                                info: info,
                                price: price,
                                units: units,
                                type: selectedType,
                                photo: selectedPhotoData
                            )
                            viewModel.isLoading = false
                            if result {
                                viewModel.showSuccessAlert = true
                            }
                        }
                    }
                }

                //Mostrar error si ocurre
                if let error = viewModel.errorMessage {
                    Text("\(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .padding()
        }
        .scrollIndicators(.never)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryColor)
        .toolbarBackground(Color.primaryColor, for: .navigationBar)

        //Actualizar la imagen seleccionada cuando cambie el picker
        .onChange(of: pickerItem) { _, newItem in
            Task {
                if let selectedItem = newItem {
                    do {
                        if let data = try await selectedItem.loadTransferable(type: Data.self) {
                            self.selectedPhotoData = data
                            print("Image loaded with size: \(data.count) bytes")
                        }
                    } catch {
                        print("Error loading image: \(error)")
                    }
                }
            }
        }

        //Mostrar alerta de éxito y regresar al listado de platos
        .alert(viewModel.successMessage, isPresented: $viewModel.showSuccessAlert) {
            Button("OK"){
                dismiss()
            }
        }
    }
}

//MARK: Vista previa
#Preview {
    let appState = AppStateVM()
    let viewModel = CreateMealViewModel(appState: appState)

    return CreateMealView(viewModel: viewModel)
        .environment(appState)
}
