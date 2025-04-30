import Foundation

/// Protocolo de red simulado para interceptar y personalizar solicitudes durante pruebas unitarias.
class URLProtocolMock: URLProtocol {
    
    /// Datos de respuesta simulada que se devolverán en lugar de una respuesta real de red.
    static var stubResponseData: Data?
    
    /// Error simulado que se lanzará durante una prueba para representar fallos de red.
    static var error: Error?
    
    /// Código de estado HTTP simulado que se devolverá con la respuesta.
    static var statusCode: Int = 200
    
    /// Indica si esta clase puede manejar la solicitud dada (siempre retorna `true` para interceptar todas las solicitudes).
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    /// Retorna la versión canónica de la solicitud. En este caso, simplemente se retorna tal cual.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /// Comienza la carga simulada de la solicitud interceptada.
    override func startLoading() {
        // Simula un error si se ha definido
        if let error = URLProtocolMock.error {
            self.client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        // Crea y envía una respuesta HTTP con el código de estado simulado
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: URLProtocolMock.statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        // Envía los datos simulados si existen
        if let data = URLProtocolMock.stubResponseData {
            self.client?.urlProtocol(self, didLoad: data)
        }
        
        // Indica que la carga ha terminado
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    /// Detiene la carga de datos simulados (no se requiere implementación en este mock).
    override func stopLoading() {
        // No se necesita lógica para detener en el mock.
    }
}
