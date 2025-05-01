# 🥘 Picked App – Picked meals, cheap deals!!

**Picked App** es una aplicación iOS que conecta a restaurantes con consumidores para dar salida a platos de comida próximos a vencer, ofreciendo precios reducidos y reduciendo el desperdicio alimentario. La app permite a los usuarios localizar platos disponibles en su zona mediante geolocalización y ofrece herramientas completas de gestión para los restaurantes.

---

## 🚀 Funcionalidades principales

- Registro y login para consumidores y restaurantes, con flujos personalizados
- Subida de platos con foto, descripción, precio, tipo y unidades disponibles
- Visualización de restaurantes cercanos mediante la ubicación del consumidor
- Mapa interactivo con los puntos de venta
- Compra de platos y control de stock
- Gestión de cuentas, edición y eliminación de platos y restaurantes
- Sistema de roles: consumidor, restaurante y administrador
- Auditoría completa de las acciones (creación, edición y timestamps)

---

## 📱 App iOS (Frontend)

La aplicación está desarrollada con **Swift** y **SwiftUI**, adoptando una arquitectura **MVVM** para una gestión limpia del estado y una separación clara de responsabilidades.

### Tecnologías utilizadas

- **SwiftUI** – Framework declarativo para interfaces dinámicas y fluidas
- **MVVM** – Cada vista tiene su ViewModel conectado a casos de uso y repositorios
- **KeyChain** – Almacenamiento seguro del token JWT
- **CoreLocation** – Obtención de ubicación del usuario en tiempo real
- **MapKit** – Visualización de restaurantes cercanos en un mapa interactivo
- **PhotosUI** – Selección de imágenes nativas desde la galería
- **MultipartBody (Content-Type)** – Envío de imágenes al backend como `multipart/form-data`
- **XCTest** – Pruebas unitarias del ViewModel y validación de comportamientos

---

## 🌐 Backend (Vapor)

El backend ha sido desarrollado en **Swift** con el framework **Vapor**, garantizando coherencia con el frontend y alto rendimiento. Está estructurado para manejar seguridad, geolocalización y persistencia de datos de forma eficiente.

### Tecnologías utilizadas

- **Vapor** – Framework web en Swift para APIs REST
- **Fluent** – ORM para modelos y migraciones
- **PostgreSQL** – Base de datos relacional
- **JWT** – Autenticación y protección de rutas
- **Sistema de roles** – Control de acceso según tipo de usuario
- **Subida de imágenes** – Mediante `multipart/form-data`, almacenadas localmente
- **Fórmula de Haversine** – Cálculo de distancia entre coordenadas para mostrar restaurantes cercanos
- **MealCleanUp()** – Limpieza automática de platos expirados tras 24h
- **Auditoría** – Campos `created_by`, `updated_by`, `created_at`, `updated_at`
