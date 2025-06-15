<?php
$nestUrl = 'http://127.0.0.1:3000';

// Убираем "/price-api.polandgroups.pl" из пути
$path = $_SERVER['REQUEST_URI'];
$cleanPath = preg_replace('#^/pl-price-api-admin/backend\.polandgroups\.pl#', '', $path);

// Проксируем запрос
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $nestUrl . $cleanPath);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HEADER, false);
$response = curl_exec($ch);

$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$contentType = curl_getinfo($ch, CURLINFO_CONTENT_TYPE);
curl_close($ch);

http_response_code($httpCode);
header("Content-Type: " . $contentType);
echo $response;
