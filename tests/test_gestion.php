<?php

require_once __DIR__ . '/TestRunner.php';

$t = new TestRunner();
$base = getenv('API_BASE') ?: 'http://localhost:8080/sigeru';

function api($method, $url, $body = null)
{
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    curl_setopt($ch, CURLOPT_COOKIEJAR, '/tmp/cookies_gestion.txt');
    curl_setopt($ch, CURLOPT_COOKIEFILE, '/tmp/cookies_gestion.txt');
    if ($body !== null) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($body));
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
    }
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return ['code' => $httpCode, 'body' => json_decode($response, true)];
}

echo "=== Test: API Gestion ===\n\n";

// Login admin para endpoints protegidos
api('POST', "$base/api-usuarios/login", ['email' => 'admin@sigeru.uy', 'contrasena' => 'admin123']);

// --- Incidencias ---
echo "-- Incidencias --\n";
$r = api('GET', "$base/api-gestion/incidencias");
$t->assertEqual(200, $r['code'], 'GET /incidencias retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de incidencias');
$countBefore = count($r['body']);

// POST incidencia (sin auth - vecino)
$r = api('POST', "$base/api-gestion/incidencias", [
    'tipo' => 'desborde',
    'ubicacion' => 'Test Unitario Calle 123',
    'zona' => 'Centro',
    'descripcion' => 'Incidencia de prueba unitaria'
]);
$t->assert($r['code'] === 200 || $r['code'] === 201, 'POST /incidencias crea sin auth');
$t->assertArrayHasKey('id', $r['body'], 'Retorna ID de incidencia');
$incId = $r['body']['id'];

// PUT cambiar estado
$r = api('PUT', "$base/api-gestion/incidencias/$incId", ['estado' => 'en_proceso']);
$t->assertEqual(200, $r['code'], 'PUT /incidencias cambia estado a en_proceso');

// PUT asignar conductor
$r = api('PUT', "$base/api-gestion/incidencias/$incId", ['estado' => 'en_proceso', 'id_conductor_asignado' => 3]);
$t->assertEqual(200, $r['code'], 'PUT /incidencias asigna conductor');

// PUT resolver
$r = api('PUT', "$base/api-gestion/incidencias/$incId", ['estado' => 'resuelta']);
$t->assertEqual(200, $r['code'], 'PUT /incidencias resuelve incidencia');

// --- Contenedores ---
echo "\n-- Contenedores --\n";
$r = api('GET', "$base/api-gestion/contenedores");
$t->assertEqual(200, $r['code'], 'GET /contenedores retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de contenedores');
$t->assert(count($r['body']) > 0, 'Hay contenedores en la BD');

// POST contenedor
$r = api('POST', "$base/api-gestion/contenedores", [
    'ubicacion' => 'Test Unit Av. Test',
    'zona' => 'Centro',
    'capacidad' => 1000,
    'tipo_residuo' => 'organico',
    'estado' => 'funcional'
]);
$t->assert($r['code'] === 200 || $r['code'] === 201, 'POST /contenedores crea contenedor');

// --- Rutas ---
echo "\n-- Rutas --\n";
$r = api('GET', "$base/api-gestion/rutas");
$t->assertEqual(200, $r['code'], 'GET /rutas retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de rutas');

// --- Centros de Acopio ---
echo "\n-- Centros de Acopio --\n";
$r = api('GET', "$base/api-gestion/centros-acopio");
$t->assertEqual(200, $r['code'], 'GET /centros-acopio retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de centros');

// --- Maquinaria ---
echo "\n-- Maquinaria --\n";
$r = api('GET', "$base/api-gestion/maquinaria");
$t->assertEqual(200, $r['code'], 'GET /maquinaria retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de maquinaria');

// --- Tipos de Residuo ---
echo "\n-- Tipos de Residuo --\n";
$r = api('GET', "$base/api-gestion/tipos-residuo");
$t->assertEqual(200, $r['code'], 'GET /tipos-residuo retorna 200');

$t->summary();
