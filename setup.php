<?php
$hostname = 'localhost';
$username = 'root';
$password = '';

$conn = mysqli_connect($hostname, $username, $password);
if (!$conn) {
    die("<h2 style='color:red'>Error: No se pudo conectar a MySQL. Asegurate de que XAMPP esté corriendo.</h2>");
}

mysqli_set_charset($conn, "utf8mb4");

$sqlFile = __DIR__ . '/database/sigeru.sql';
if (!file_exists($sqlFile)) {
    die("<h2 style='color:red'>Error: No se encontró el archivo database/sigeru.sql</h2>");
}

$sql = file_get_contents($sqlFile);

$adminHash = password_hash('admin123', PASSWORD_DEFAULT);
$sql = str_replace('$2y$10$YourHashedPasswordHere1234567890abcdefghij', $adminHash, $sql);

mysqli_multi_query($conn, $sql);

do {
    if ($result = mysqli_store_result($conn)) {
        mysqli_free_result($result);
    }
} while (mysqli_next_result($conn));

if (mysqli_errno($conn)) {
    echo "<h2 style='color:orange'>Advertencia MySQL: " . htmlspecialchars(mysqli_error($conn)) . "</h2>";
    echo "<p>Si dice 'Duplicate entry' es porque los datos ya existian. El sistema funciona igual.</p>";
}

mysqli_close($conn);
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SiGeRU - Setup</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f0f2f0; padding: 40px; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 40px; border-radius: 12px; border: 2px solid #1a5c52; }
        h1 { color: #1a5c52; }
        .success { color: #1a5c52; font-size: 18px; }
        .info { background: #e8f0ef; padding: 16px; border-radius: 8px; margin: 16px 0; }
        a { color: #1a5c52; font-weight: 600; }
        code { background: #f0f2f0; padding: 2px 6px; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>SiGeRU - Setup completado</h1>
        <p class="success">La base de datos <strong>sigeru</strong> fue creada con todas las tablas y datos de prueba.</p>

        <div class="info">
            <strong>Credenciales del administrador:</strong><br>
            Email: <code>admin@sigeru.uy</code><br>
            Password: <code>admin123</code>
        </div>

        <div class="info">
            <strong>Datos de prueba cargados:</strong><br>
            - 3 rutas con 5 contenedores cada una<br>
            - 5 incidencias de ejemplo<br>
            - 6 tipos de residuo<br>
            - 1 usuario administrador
        </div>

        <h3>Links del sistema:</h3>
        <ul>
            <li><a href="/sigeru/landing-page/">Landing Page (publico)</a></li>
            <li><a href="/sigeru/frontend-backoffice/login.html">Backoffice (login funcionarios)</a></li>
        </ul>
    </div>
</body>
</html>
