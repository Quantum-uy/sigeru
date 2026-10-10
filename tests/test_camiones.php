<?php

require_once __DIR__ . '/TestRunner.php';

$t = new TestRunner();
$base = getenv('API_BASE') ?: 'http://localhost:8080/sigeru';

function api($method, $url, $body = null)
{
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    curl_setopt($ch, CURLOPT_COOKIEJAR, '/tmp/cookies_cam.txt');
    curl_setopt($ch, CURLOPT_COOKIEFILE, '/tmp/cookies_cam.txt');
    if ($body !== null) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($body));
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
    }
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return ['code' => $httpCode, 'body' => json_decode($response, true)];
}

echo "=== Test: API Camiones ===\n\n";

api('POST', "$base/api-usuarios/login", ['email' => 'admin@sigeru.uy', 'contrasena' => 'admin123']);

// GET camiones
echo "-- GET Camiones --\n";
$r = api('GET', "$base/api-camiones/camiones");
$t->assertEqual(200, $r['code'], 'GET /camiones retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de camiones');
$t->assert(count($r['body']) > 0, 'Hay camiones en la BD');

// POST camion
echo "\n-- POST Camion --\n";
$r = api('POST', "$base/api-camiones/camiones", [
    'matricula' => 'TEST' . time(),
    'marca' => 'TestMarca',
    'modelo' => 'TestModelo',
    'anio' => 2024,
    'capacidad_kg' => 5000,
    'tipo' => 'compactador',
    'estado' => 'disponible'
]);
$t->assert($r['code'] === 200 || $r['code'] === 201, 'POST /camiones crea camion');
$camionId = $r['body']['id'] ?? null;

// GET camion por ID
if ($camionId) {
    echo "\n-- GET Camion por ID --\n";
    $r = api('GET', "$base/api-camiones/camiones/$camionId");
    $t->assertEqual(200, $r['code'], 'GET /camiones/{id} retorna 200');
    $t->assertNotEmpty($r['body'], 'Camion retorna datos');

    // PATCH estado
    echo "\n-- PATCH Estado --\n";
    $r = api('PATCH', "$base/api-camiones/camiones/$camionId/estado", ['estado' => 'mantenimiento']);
    $t->assertEqual(200, $r['code'], 'PATCH estado retorna 200');

    // DELETE camion
    echo "\n-- DELETE Camion --\n";
    $r = api('DELETE', "$base/api-camiones/camiones/$camionId");
    $t->assertEqual(200, $r['code'], 'DELETE camion retorna 200');
}

$t->summary();
