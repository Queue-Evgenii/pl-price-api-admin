<?php
$nestUrl = 'http://localhost:3000';

$basePath = '/pl-price-api-admin';
$path = $_SERVER['REQUEST_URI'];
$cleanPath = preg_replace('#^' . preg_quote($basePath, '#') . '#', '', $path);

if (preg_match('#^/(api|swagger)/?#', $cleanPath)) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $nestUrl . $cleanPath);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, false);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $_SERVER['REQUEST_METHOD']);

    if (in_array($_SERVER['REQUEST_METHOD'], ['POST', 'PUT', 'PATCH'])) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, file_get_contents('php://input'));
    }

    $headers = [];
    foreach (getallheaders() as $name => $value) {
        if (strtolower($name) !== 'host') {
            $headers[] = "$name: $value";
        }
    }
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    $response = curl_exec($ch);

    if(curl_errno($ch)) {
        http_response_code(500);
        echo 'Curl error: ' . curl_error($ch);
        curl_close($ch);
        exit;
    }

    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $contentType = curl_getinfo($ch, CURLINFO_CONTENT_TYPE);
    curl_close($ch);

    http_response_code($httpCode);
    header("Content-Type: " . $contentType);
    echo $response;
    exit;
}

$distPath = __DIR__ . '/frontend/dist';
$requestedFile = realpath($distPath . $cleanPath);

if ($requestedFile && str_starts_with($requestedFile, realpath($distPath)) && is_file($requestedFile)) {
    return false; 
} else {
    echo file_get_contents($distPath . '/index.html');
    exit;
}
