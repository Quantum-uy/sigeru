<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

function getUsuarioSesion() {
    return isset($_SESSION['usuario']) ? $_SESSION['usuario'] : null;
}

function getRol() {
    $u = getUsuarioSesion();
    return $u ? $u['rol'] : null;
}

function requiereRol($rolesPermitidos) {
    $rol = getRol();
    if (!$rol) {
        http_response_code(401);
        echo json_encode(["error" => "No autenticado"]);
        exit();
    }
    if (!in_array($rol, $rolesPermitidos)) {
        http_response_code(403);
        echo json_encode(["error" => "No tenés permisos para esta acción"]);
        exit();
    }
}
