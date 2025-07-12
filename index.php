<?php

$nestUrl = 'http://localhost:3000';
$basePath = '/pl-price-api-admin';

$uri = $_SERVER['REQUEST_URI'];

// Убираем базовый префикс
if (str_starts_with($uri, $basePath)) {
    $cleanPath = substr($uri, strlen($basePath));
} else {
    // Запрос не в /pl-price-api-admin — можно вернуть 404 или что-то другое
    http_response_code(404);
    echo "Not Found";
    exit;
}

// 1) Проксируем swagger
if ($cleanPath === '/swagger' || str_starts_with($cleanPath, '/swagger/')) {
    proxyRequest($nestUrl . $cleanPath);
}

// 2) Проксируем api
if (str_starts_with($cleanPath, '/api/')) {
    proxyRequest($nestUrl . $cleanPath);
}

// 3) Отдаём статику из frontend/dist для /web
if (str_starts_with($cleanPath, '/web')) {
    $distPath = __DIR__ . '/frontend/dist' . substr($cleanPath, strlen('/web'));
    if (is_file($distPath)) {
        serveStaticFile($distPath);
    } elseif (is_dir($distPath)) {
        // Если директория, можно отдавать index.html из неё
        $indexFile = rtrim($distPath, '/') . '/index.html';
        if (is_file($indexFile)) {
            serveStaticFile($indexFile);
        } else {
            http_response_code(404);
            echo "Not Found";
        }
    } else {
        http_response_code(404);
        echo "Not Found";
    }
    exit;
}

// 4) Отдаём статику из backend/uploads
if (str_starts_with($cleanPath, '/backend/uploads')) {
    $uploadsPath = __DIR__ . $cleanPath;
    if (is_file($uploadsPath)) {
        serveStaticFile($uploadsPath);
    } else {
        http_response_code(404);
        echo "Not Found";
    }
    exit;
}

http_response_code(404);
exit;


// --- Функции ---

function proxyRequest(string $url)
{
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, false);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $_SERVER['REQUEST_METHOD']);

    if (in_array($_SERVER['REQUEST_METHOD'], ['POST', 'PUT', 'PATCH', 'DELETE'])) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, file_get_contents('php://input'));
    }

    // Заголовки, кроме Host
    $headers = [];
    foreach (getallheaders() as $name => $value) {
        if (strtolower($name) !== 'host') {
            $headers[] = "$name: $value";
        }
    }
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    $response = curl_exec($ch);

    if (curl_errno($ch)) {
        http_response_code(500);
        echo 'Curl error: ' . curl_error($ch);
        curl_close($ch);
        exit;
    }

    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $contentType = curl_getinfo($ch, CURLINFO_CONTENT_TYPE);
    curl_close($ch);

    http_response_code($httpCode);
    if ($contentType) {
        header("Content-Type: $contentType");
    }
    echo $response;
    exit;
}

function serveStaticFile(string $filePath)
{
    $mimeType = mime_content_type($filePath) ?: 'application/octet-stream';
    header('Content-Type: ' . $mimeType);
    header('Content-Length: ' . filesize($filePath));
    readfile($filePath);
    exit;
}
