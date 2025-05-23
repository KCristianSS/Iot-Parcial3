<?php
// Script: feria.php
// Propósito: Insertar y leer datos desde la tabla 'sensores' en la BD 'feria'

// Configuración de la conexión
$servername = "localhost";
$username = "root";
$password = "";
$database = "feria";  // ← aquí está el cambio importante
$port = 3306;

// Crear conexión
$conn = new mysqli($servername, $username, $password, $database, $port);

// Verificar conexión
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Error de conexión: " . $conn->connect_error]));
}

// Obtener acción
$accion = isset($_GET['accion']) ? $_GET['accion'] : null;

if ($accion === 'insertar') {
    // --- Inserción de datos ---
    $datos = json_decode(file_get_contents('php://input'), true);

$temperatura     = isset($datos['temperatura']) ? floatval($datos['temperatura']) : null;
$humedad_tierra  = isset($datos['humedad_tierra']) ? floatval($datos['humedad_tierra']) : null;
$humedad_aire    = isset($datos['humedad_aire']) ? floatval($datos['humedad_aire']) : null;
$agua            = isset($datos['agua']) ? floatval($datos['agua']) : null;
$id_planta       = isset($datos['id_planta']) ? intval($datos['id_planta']) : null;


    // Validar parámetros
    if ($temperatura === null || $humedad_tierra === null || $humedad_aire === null || $agua === null || $id_planta === null) {
        echo json_encode(["status" => "error", "message" => "Faltan parámetros en la solicitud."]);
        exit;
    }

    // Preparar consulta
    $stmt = $conn->prepare("INSERT INTO sensores (temperatura, humedad_tierra, humedad_aire, agua, id_planta) VALUES (?, ?, ?, ?, ?)");
    if (!$stmt) {
        echo json_encode(["status" => "error", "message" => "Error preparando la consulta: " . $conn->error]);
        exit;
    }

    // Enlazar parámetros
    $stmt->bind_param("ddddi", $temperatura, $humedad_tierra, $humedad_aire, $agua, $id_planta);

    // Ejecutar consulta
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Datos insertados correctamente."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error al insertar datos: " . $stmt->error]);
    }

    $stmt->close();

} elseif ($accion === 'leer') {
    // --- Lectura de datos ---
    $resultado = $conn->query("SELECT id, hora_fecha, temperatura, humedad_tierra, humedad_aire, agua, id_planta FROM sensores ORDER BY id DESC");

    if ($resultado) {
        $datos = [];
        while ($fila = $resultado->fetch_assoc()) {
            $datos[] = $fila;
        }
        echo json_encode(["status" => "success", "datos" => $datos]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error al leer datos: " . $conn->error]);
    }

} else {
    echo json_encode(["status" => "error", "message" => "Acción no válida. Usa 'accion=insertar' o 'accion=leer'."]);
}

// Cerrar conexión
$conn->close();
?>
