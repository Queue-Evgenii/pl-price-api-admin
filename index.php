<?php
// URL локального сервера
$nestUrl = 'http://127.0.0.1:3000';

// Получаем полный URI запроса (например, /pl-price-api-admin/api/data)
$path = $_SERVER['REQUEST_URI'];

// Убираем префикс /pl-price-api-admin, чтобы отправить путь локальному серверу
$cleanPath = preg_replace('#^/pl-price-api-admin#', '', $path);

// Финальный адрес, на который отправим запрос
$proxyUrl = $nestUrl . $cleanPath;

// Инициализируем cURL
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $proxyUrl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HEADER, false);

// Проксируем методы и тело запроса (POST, PUT и т.д.)
$method = $_SERVER['REQUEST_METHOD'];
if (in_array($method, ['POST', 'PUT', 'PATCH', 'DELETE'])) {
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    curl_setopt($ch, CURLOPT_POSTFIELDS, file_get_contents('php://input'));
}

// Проксируем заголовки
$headers = [];
foreach (getallheaders() as $name => $value) {
    $headers[] = "$name: $value";
}
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

// Выполняем запрос
$response = curl_exec($ch);

// Получаем код и тип ответа
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$contentType = curl_getinfo($ch, CURLINFO_CONTENT_TYPE);
curl_close($ch);

// Отдаём клиенту
http_response_code($httpCode);
header("Content-Type: " . $contentType);
echo $response;
