<?php

echo "╔══════════════════════════════════════╗\n";
echo "║   SiGeRU - Tests Unitarios          ║\n";
echo "╚══════════════════════════════════════╝\n\n";

$base = getenv('API_BASE') ?: 'http://localhost:8080/sigeru';
$tests = ['test_usuarios.php', 'test_gestion.php', 'test_camiones.php', 'test_recoleccion.php'];

foreach ($tests as $test) {
    echo "\n" . str_repeat('─', 50) . "\n";
    $cmd = "API_BASE=$base php /tmp/tests/$test 2>&1";
    passthru($cmd);
}
