<?php

require_once __DIR__ . '/TestRunner.php';

$t = new TestRunner();
$base = getenv('API_BASE') ?: 'http://localhost:8080/sigeru';

function api($method, $url, $body = null)
{
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    curl_setopt($ch, CURLOPT_COOKIEJAR, '/tmp/cookies.txt');
    curl_setopt($ch, CURLOPT_COOKIEFILE, '/tmp/cookies.txt');
    if ($body !== null) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($body));
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
    }
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return ['code' => $httpCode, 'body' => json_decode($response, true)];
}

echo "=== Test: API Usuarios ===\n\n";

// Login admin
echo "-- Login --\n";
$r = api('POST', "$base/api-usuarios/login", ['email' => 'admin@sigeru.uy', 'contrasena' => 'admin123']);
$t->assertEqual(200, $r['code'], 'Login admin retorna 200');
$t->assertArrayHasKey('usuario', $r['body'], 'Login retorna datos de usuario');
$t->assertEqual('administrador', $r['body']['usuario']['rol'], 'Rol es administrador');

// Login con credenciales incorrectas
$r = api('POST', "$base/api-usuarios/login", ['email' => 'admin@sigeru.uy', 'contrasena' => 'wrongpass']);
$t->assertEqual(401, $r['code'], 'Login incorrecto retorna 401');

// Login sin campos
$r = api('POST', "$base/api-usuarios/login", ['email' => '']);
$t->assert($r['code'] >= 400, 'Login sin campos retorna error');

// GET usuarios
echo "\n-- GET Usuarios --\n";
$r = api('GET', "$base/api-usuarios/usuarios");
$t->assertEqual(200, $r['code'], 'GET /usuarios retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de usuarios');
$t->assert(count($r['body']) > 0, 'Hay al menos 1 usuario');

// Verificar que no se expone la contrasena
$firstUser = $r['body'][0];
$t->assert(!isset($firstUser['contrasena']), 'No se expone contrasena en getAll');

// GET usuario por ID
echo "\n-- GET Usuario por ID --\n";
$r = api('GET', "$base/api-usuarios/usuarios/1");
$t->assertEqual(200, $r['code'], 'GET /usuarios/1 retorna 200');
$t->assertEqual('Admin', $r['body']['nombre'], 'Admin es el usuario 1');

// GET usuario inexistente
$r = api('GET', "$base/api-usuarios/usuarios/99999");
$t->assert($r['code'] === 404 || empty($r['body']), 'Usuario inexistente retorna 404 o vacio');

// GET conductores
echo "\n-- GET Conductores --\n";
$r = api('GET', "$base/api-usuarios/conductores");
$t->assertEqual(200, $r['code'], 'GET /conductores retorna 200');
$t->assert(is_array($r['body']), 'Retorna array de conductores');

// POST crear usuario (requiere auth admin)
echo "\n-- POST Crear Usuario --\n";
api('POST', "$base/api-usuarios/login", ['email' => 'admin@sigeru.uy', 'contrasena' => 'admin123']);
$r = api('POST', "$base/api-usuarios/usuarios", [
    'nombre' => 'TestUnit',
    'apellido' => 'PHPTest',
    'email' => 'unittest_' . time() . '@test.com',
    'contrasena' => 'test1234',
    'telefono' => '099111222',
    'rol' => 'peon'
]);
$t->assert($r['code'] === 200 || $r['code'] === 201, 'POST /usuarios crea usuario');
$t->assertArrayHasKey('id', $r['body'], 'Retorna ID del nuevo usuario');
$newUserId = $r['body']['id'];

// PUT actualizar estado
echo "\n-- PUT Estado Usuario --\n";
$r = api('PUT', "$base/api-usuarios/usuarios/$newUserId/estado", ['estado' => 'activo']);
$t->assertEqual(200, $r['code'], 'PUT estado retorna 200');

// DELETE usuario
echo "\n-- DELETE Usuario --\n";
$r = api('DELETE', "$base/api-usuarios/usuarios/$newUserId");
$t->assertEqual(200, $r['code'], 'DELETE usuario retorna 200');

$t->summary();
