# Interrapidisimo iOS

Aplicativo móvil de Interrapidísimo construido con Clean Architecture + MVVM en Swift 6.

---

## Persistencia local

### Librería elegida: GRDB (`groue/GRDB.swift`)

**Motivo de la elección sobre las alternativas:**

En mi opinión, prefiero no usar librerías de terceros por mantenibilidad y seguridad. Si fuera por decisión propia, intentaría elegir **SwiftData** sobre SQLite.

Sin embargo, en caso de elegir SQLite por una decisión técnica, tener sentencias SQL crudas en el código no solo reduce mantenibilidad, también puede abrir puertas a errores de seguridad (por ejemplo, SQL Injection si no se parametriza correctamente).  
Por esa razón, para esta prueba técnica que menciona el uso de SQLite opté por **GRDB**, porque permite trabajar con una API más segura y mantenible sobre SQLite.

| Criterio                | GRDB                            | SQLite.swift                | CoreData                         |
| ----------------------- | ------------------------------- | --------------------------- | -------------------------------- |
| API Swift nativa        | ✅ Sin strings SQL sueltos      | ⚠️ SQL como strings tipados | ✅                               |
| `async/await` nativo    | ✅ `DatabaseQueue.write/read`   | ❌ Solo sync                | ✅ NSAsynchronousFetchRequest    |
| Migraciones versionadas | ✅ `DatabaseMigrator` integrado | ❌ Manual                   | ✅ Versioned model               |
| Peso / complejidad      | Ligero                          | Ligero                      | Pesado, genera mucho boilerplate |
| Compatibilidad Swift 6  | ✅ Mantenimiento activo         | ⚠️ Menos activo             | ✅                               |

**GRDB** ofrece la combinación óptima de API idiomática Swift, soporte first-class para concurrencia estricta (Swift 6) y gestión de migraciones sin necesidad de manejar SQL crudo ni el overhead de CoreData.

### Schema

```sql
CREATE TABLE user_session (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario        TEXT    NOT NULL,
    identificacion TEXT,
    nombre         TEXT
);
```

Una sola fila representa la sesión activa. Al guardar una nueva sesión se eliminan las anteriores (`DELETE` + `INSERT`).

### Agregar GRDB al proyecto (SPM)

En Xcode: **File → Add Package Dependencies**

- URL: `https://github.com/groue/GRDB.swift`
- Version: `from: "6.0.0"`
- Target: `Interrapidisimo-iOS`

---

## Logging

### Sistema elegido: `Logger` (OSLog)

Se utiliza `Logger` del framework `OSLog` de Apple en lugar de alternativas como `print` o un wrapper personalizado con `#if DEBUG`.

**Motivo de la elección:**

| Criterio                | `Logger` (OSLog)                                 | `print` / `#if DEBUG`        |
| ----------------------- | ------------------------------------------------ | ---------------------------- |
| Logs en producción      | ✅ `error`/`fault` persisten en el sistema       | ❌ Ninguno — desaparecen     |
| Diagnóstico en campo    | ✅ Recuperable vía `log collect` del dispositivo | ❌ Imposible                 |
| Privacidad de datos     | ✅ `.public` / `.private` por valor              | ❌ Todo visible siempre      |
| Niveles de severidad    | ✅ debug / info / error / fault                  | ❌ Un solo nivel             |
| Filtrado en Console.app | ✅ Por subsistema y categoría                    | ❌ Solo búsqueda de texto    |
| Impacto en release      | ✅ `.debug` se compila fuera del binario         | ⚠️ `print` siempre ejecuta   |
| Thread safety           | ✅ Nativo                                        | ⚠️ Output puede intercalarse |

### Convención de niveles

```swift
logger.debug(...)   // Trazas de desarrollo — se eliminan del binario en release
logger.info(...)    // Eventos informativos no críticos
logger.error(...)   // Errores recuperables — persisten en el log del sistema
logger.fault(...)   // Errores irrecuperables / invariantes rotos
```

### Convención de privacidad

```swift
// Datos técnicos sin PII → .public (visible en Console.app)
logger.debug("Request URL: \(url, privacy: .public)")

// Datos del usuario → .private (aparece como <private> fuera de debug)
logger.debug("Session usuario: \(usuario, privacy: .private)")
```

### Instancias por capa

Cada capa declara su propio logger con una `category` específica para facilitar el filtrado:

```swift
private let networkLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.interrapidisimo",
    category: "network"
)
```

Las categorías actuales son `"network"`, `"version-check"` y `"app"`. Se agregarán `"persistence"`, `"auth"`, etc. a medida que crezcan las capas que requieran logging.

---

## Manejo de errores sin crash

La app está diseñada para no crashear ante fallas de red, base de datos o recursos de UI.

### Red

Los ViewModels capturan `NetworkError` con un `catch` tipado y un `catch` genérico de respaldo, actualizando el estado de UI a `.failed(mensaje)`. El crash ante errores de red es imposible.

### Base de datos — factories

Las factories que construyen vistas de forma síncrona no usan `async throws`. El patrón adoptado es `@ViewBuilder` + `Result(catching:)`:

```swift
@ViewBuilder
static func getTablesView(session: UserSession) -> some View {
    switch Result(catching: { try AppDatabase() }) {
    case .success(let appDatabase):
        TablesView(viewModel: ...)        // flujo normal
    case .failure:
        ContentUnavailableView(...)       // degradación sin crash
    }
}
```

Esto permite mostrar un `ContentUnavailableView` en lugar de crashear si la DB no puede inicializarse, sin forzar un `try!`.

### Base de datos — `AppDatabaseError`

`AppDatabase.init()` declara throws sin tipo. Se añadió `AppDatabaseError.documentsDirectoryUnavailable` para el caso (raro en iOS pero no imposible) en que `FileManager` no devuelva la carpeta de documentos. La inicialización usa `guard let .first` en lugar de `[0]` para evitar el riesgo de crash.

### Version check (degradación silenciosa)

Si el check de versión falla (sin red, API caída), la app **no muestra error al usuario** — simplemente continúa. El error se registra con `logger.warning` para diagnóstico en campo, sin interrumpir el flujo de arranque.

### Permisos e imágenes

La app no solicita permisos del sistema (cámara, ubicación, notificaciones, biometría). Todos los recursos de imagen usan SF Symbols (`Image(systemName:)`), que en SwiftUI fallan silenciosamente si el símbolo no existe — sin crash.

---

## Arquitectura (resumen)

La app está organizada por features y capas con enfoque **Clean Architecture + MVVM**:

- `Data`: DTOs, mapeos y repositorios.
- `Domain`: entidades, contratos de repositorio y casos de uso.
- `Presentation`: ViewModels y vistas SwiftUI.
- `Core`: infraestructura compartida (networking, persistencia, utilidades).

## Convenciones (resumen)

- Inyección de dependencias por constructor.
- Un tipo principal por archivo.
- `final class` por defecto cuando se usan clases.
- Reglas de concurrencia con `@MainActor` aplicadas con alcance mínimo necesario.

## Networking

La capa de red está centralizada en `Core/Networking` y contempla:

- Manejo de errores tipados (`NetworkError`) para respuestas inválidas, códigos HTTP no esperados y errores de serialización.
- Timeout configurado en requests para evitar bloqueos indefinidos.
- Parseo tipado con `Codable` (`Decodable`/`Encodable`) para mantener contratos de datos claros y seguros.

## APIs modernas de Swift/SwiftUI

El proyecto usa APIs recientes del ecosistema Apple, incluyendo:

- `NavigationStack` para navegación moderna en SwiftUI.
- `async/await` para operaciones asíncronas.
- Macros de testing (`@Suite`, `@Test`, `#expect`) en pruebas.
- `SwiftData` como opción preferida cuando el contexto técnico lo permite (aunque en esta prueba se usa GRDB por decisión técnica).

## Principios SOLID

La implementación sigue principios SOLID en la práctica:

- Responsabilidad única por capa/tipo.
- Dependencia de abstracciones (protocolos) en repositorios, casos de uso y ViewModels.
- Inversión de dependencias mediante factories e inyección por constructor.

## Estado en ViewModel

El estado de UI se concentra en el ViewModel (MVVM), evitando lógica de negocio en la vista:

- Uso de `@Observable` y propiedades de estado para representar carga, éxito y error.
- Las vistas renderizan estado y delegan acciones al ViewModel.
- El `state` de pantalla completa se usa principalmente en vistas con listados o carga remota.
- En `Login` y `Home`, normalmente no se requiere ese `state` de listado; se prefieren propiedades simples orientadas a interacción.

## Comentarios como documentación

Los comentarios de documentación (`///`) se usan principalmente en métodos y propiedades compartidas de `Core`/`Common`, porque actúan como contrato reutilizable para toda la app.  
En código de features se evitan comentarios redundantes y solo se documenta lógica no obvia.

## Resumen de tests

La cobertura de pruebas está enfocada en lógica de negocio y contratos de datos:

- **DTO tests**: validan decodificación/parsing de respuestas.
- **UseCase tests**: validan reglas de negocio y delegación a repositorios.
- **ViewModel tests**: validan estados y comportamiento observable.
- **Feature-first**: los tests se organizan por feature, con mocks locales por feature.
- **Concurrencia**: se aplican reglas de actor isolation (`@MainActor`) con alcance mínimo para evitar ruido y mantener claridad.
