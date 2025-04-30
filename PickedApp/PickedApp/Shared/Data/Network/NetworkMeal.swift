import Foundation

//MARK: NetworkProtocol de Meals
protocol NetworkMealProtocol {
    func fetchMyMeals() async throws -> [Meal]
    func createMeal(requestData: MealCreateRequest) async throws -> Meal
}

//MARK: Network de Meals
final class NetworkMeal: NetworkMealProtocol {
    
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    //Método para obtener todos los platos del restaurante autenticado
    func fetchMyMeals() async throws -> [Meal] {
        var meals = [Meal]()
        
        //Construir la URL para obtener los platos del restaurante
        let urlCad = "\(ConstantsApp.CONS_API_URL)\(EndPoints.myMeals.rawValue)"
        guard let url = URL(string: urlCad) else {
            throw PKError.badUrl  //Error si la URL no es válida
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.get
        
        //Añadir token JWT para autenticación
        let jwtToken = KeyChainPK().loadPK(key: ConstantsApp.CONS_TOKEN_ID_KEYCHAIN)
        request.addValue("\(HttpMethods.bearer) \(jwtToken)", forHTTPHeaderField: HttpMethods.authorization)
        
        do {
            //Realizar la solicitud
            let (data, response) = try await session.data(for: request)
            
            //Validar la respuesta
            guard let httpResponse = response as? HTTPURLResponse else {
                throw PKError.errorFromApi(statusCode: -1)
            }
            
            //Mostrar respuesta en consola
            if let responseString = String(data: data, encoding: .utf8) {
                print("Respuesta: \(responseString)")
            }
            
            //Verificar código de éxito HTTP
            guard httpResponse.statusCode == HttpResponseCodes.SUCESS else {
                throw PKError.errorFromApi(statusCode: httpResponse.statusCode)
            }
            
            //Decodificar los datos en un array de platos
            let result = try JSONDecoder().decode([Meal].self, from: data)
            meals = result
            
        } catch {
            //Capturar y mostrar errores
            print("Error fetching plates: \(error)")
            throw error
        }
        
        return meals
    }
    
    //Método para crear un nuevo plato
    func createMeal(requestData: MealCreateRequest) async throws -> Meal {
        
        //Construir la URL para crear un plato
        guard let url = URL(string: "\(ConstantsApp.CONS_API_URL)\(EndPoints.createMeal.rawValue)") else {
            throw PKError.badUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.post

        //Configurar el boundary para multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        //Añadir token JWT para autenticación
        let jwtToken = KeyChainPK().loadPK(key: ConstantsApp.CONS_TOKEN_ID_KEYCHAIN)
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")

        //Preparar los campos de texto para la solicitud
        let fields: [String: String] = [
            "name": requestData.name,
            "info": requestData.info,
            "price": String(requestData.price),
            "units": String(requestData.units),
            "type": requestData.type
        ]

        //Construir el body multipart con los campos y la imagen
        let body = createMultipartBody(from: fields, imageData: requestData.photo, imageFieldName: "photo", boundary: boundary)
        request.httpBody = body

        //Enviar la solicitud
        let (data, response) = try await session.data(for: request)

        //Validar la respuesta HTTP
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PKError.errorFromApi(statusCode: -1)
        }

        //Verificar código de éxito HTTP
        guard httpResponse.statusCode == HttpResponseCodes.SUCESS else {
            throw PKError.errorFromApi(statusCode: httpResponse.statusCode)
        }

        //Decodificar la respuesta
        let createdMeal = try JSONDecoder().decode(Meal.self, from: data)
        return createdMeal
    }
}


//MARK: Mock de éxito para NetworkMealProtocol
final class NetworkMealSuccessMock: NetworkMealProtocol {
    
    //Devuelve una lista simulada de platos
    func fetchMyMeals() async throws -> [Meal] {
        return [
            Meal(
                id: UUID(),
                name: "Pizza Margherita",
                info: "Classic Italian pizza with fresh tomatoes and mozzarella",
                units: 5,
                price: 12.99,
                photo: "/images/pizza.jpg"
            ),
            Meal(
                id: UUID(),
                name: "Vegan Burger",
                info: "Delicious plant-based burger",
                units: 10,
                price: 9.5,
                photo: "/images/burger.jpg"
            )
        ]
    }
    
    //Devuelve un plato creado de forma simulada
    func createMeal(requestData: MealCreateRequest) async throws -> Meal {
        return Meal(
            id: UUID(),
            name: requestData.name,
            info: requestData.info,
            units: requestData.units,
            price: requestData.price,
            photo: "/images/\(UUID().uuidString).jpg"
        )
    }
}

//MARK: Mock de fallo para NetworkMealProtocol
final class NetworkMealFailureMock: NetworkMealProtocol {
    
    //Lanza un error simulado al intentar obtener platos
    func fetchMyMeals() async throws -> [Meal] {
        throw PKError.errorFromApi(statusCode: 500)
    }
    
    //Lanza un error simulado al intentar crear un plato
    func createMeal(requestData: MealCreateRequest) async throws -> Meal {
        throw PKError.badUrl
    }
}
