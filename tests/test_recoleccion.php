<?php

require_once __DIR__ . '/TestRunner.php';

$t = new TestRunner();
$base = getenv('API_BASE') ?: 'http://localhost:8080/sigeru';

function api($method, $url, $body = null)
{
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    curl_setopt($ch, CURLOPT_COOKIEJAR, '/tmp/cookies_rec.txt');
    curl_setopt($ch, CURLOPT_COOKIEFILE, '/tmp/cookies_rec.txt');
    if ($body !== null) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($body));
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
    }
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return ['code' => $httpCode, 'body' => json_decode($response, true)];
}

echo "=== Test: API Recoleccion ===\n\n";

api('POST', "$base/api-usuarios/login", ['email' => 'admin@sigeru.uy', 'contrasena' => 'admin123']);

// --- Flota ---
echo "-- Flota --\n";
$r = api('GET', "$base/api-recoleccion/flota");
$t->assertEqual(200, $r['code'], 'GET /flota retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de flota');

// --- Asignaciones ---
echo "\n-- Asignaciones --\n";
$r = api('GET', "$base/api-recoleccion/asignaciones");
$t->assertEqual(200, $r['code'], 'GET /asignaciones retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de asignaciones');

// --- Mantenimiento ---
echo "\n-- Mantenimiento --\n";
$r = api('GET', "$base/api-recoleccion/mantenimiento");
$t->assertEqual(200, $r['code'], 'GET /mantenimiento retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de mantenimiento');

// POST mantenimiento
$r = api('POST', "$base/api-recoleccion/mantenimiento", [
    'id_camion' => 1,
    'tipo' => 'preventivo',
    'descripcion' => 'Test unitario - revision general',
    'fecha_programada' => '2026-12-01'
]);
$t->assert($r['code'] === 200 || $r['code'] === 201, 'POST /mantenimiento crea registro');
$mantId = $r['body']['id'] ?? null;

if ($mantId) {
    // PUT actualizar estado mantenimiento
    $r = api('PUT', "$base/api-recoleccion/mantenimiento/$mantId", ['estado' => 'completado']);
    $t->assertEqual(200, $r['code'], 'PUT /mantenimiento actualiza estado');
}

$t->summary();
