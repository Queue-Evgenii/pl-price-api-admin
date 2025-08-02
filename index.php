<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

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
    curl_setopt($ch, CURLOPT_HEADER, true); // нужно получить заголовки ответа
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $_SERVER['REQUEST_METHOD']);

    echo ini_get('upload_max_filesize');
    echo ini_get('post_max_size');
    echo json_encode($_FILES);
    $headers = [];
    foreach (getallheaders() as $name => $value) {
        $lname = strtolower($name);
        if ($lname === 'host' || $lname === 'content-length') {
            continue;
        }
        if ($lname === 'content-type') {
            if (!empty($_FILES)) continue;
        }
        $headers[] = "$name: $value";
    }
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    if (in_array($_SERVER['REQUEST_METHOD'], ['POST', 'PUT', 'PATCH'])) {
        if (!empty($_FILES)) {
            // собираем multipart/form-data поля
            $postFields = [];

            foreach ($_FILES as $key => $file) {
                if (is_array($file['tmp_name'])) {
                    // обработка массивов файлов (например multiple)
                    for ($i = 0; $i < count($file['tmp_name']); $i++) {
                        if (is_uploaded_file($file['tmp_name'][$i])) {
                            $postFields["$key[$i]"] = new CURLFile(
                                $file['tmp_name'][$i],
                                $file['type'][$i],
                                $file['name'][$i]
                            );
                        }
                    }
                } else {
                    if (is_uploaded_file($file['tmp_name'])) {
                        $postFields[$key] = new CURLFile(
                            $file['tmp_name'],
                            $file['type'],
                            $file['name']
                        );
                    }
                }
            }

            foreach ($_POST as $key => $value) {
                $postFields[$key] = $value;
            }

            curl_setopt($ch, CURLOPT_POSTFIELDS, $postFields);
        } else {
            // если нет файлов, просто передаём тело запроса (JSON и др.)
            $rawBody = file_get_contents('php://input');
            curl_setopt($ch, CURLOPT_POSTFIELDS, $rawBody);
        }
    } elseif ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
        $rawBody = file_get_contents('php://input');
        if ($rawBody) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, $rawBody);
        }
    }

    $response = curl_exec($ch);

    if (curl_errno($ch)) {
        http_response_code(500);
        echo 'Curl error: ' . curl_error($ch);
        curl_close($ch);
        exit;
    }

    // Разделяем заголовки и тело ответа
    $header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
    $response_headers_raw = substr($response, 0, $header_size);
    $response_body = substr($response, $header_size);

    // Парсим заголовки и отправляем клиенту (кроме некоторых)
    $response_headers = explode("\r\n", $response_headers_raw);
    foreach ($response_headers as $header_line) {
        if (stripos($header_line, 'Transfer-Encoding:') === 0) continue;
        if (stripos($header_line, 'Content-Length:') === 0) continue;
        if (empty(trim($header_line))) continue;
        header($header_line, false);
    }

    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    http_response_code($httpCode);

    echo $response_body;
    curl_close($ch);
    exit;
}


function serveStaticFile(string $filePath)
{
    
    $extension = pathinfo($filePath, PATHINFO_EXTENSION);
    
    $mimeTypes = [
        'js'   => 'application/javascript',
        'css'  => 'text/css',
        'html' => 'text/html',
        'json' => 'application/json',
        'png'  => 'image/png',
        'jpg'  => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'svg'  => 'image/svg+xml',
        'woff' => 'font/woff',
        'woff2'=> 'font/woff2',
        'ttf'  => 'font/ttf',
        'eot'  => 'application/vnd.ms-fontobject',
        'otf'  => 'font/otf',
    ];

    $mimeType = $mimeTypes[$extension] ?? mime_content_type($filePath) ?? 'application/octet-stream';

    header('Content-Type: ' . $mimeType);
    header('Content-Length: ' . filesize($filePath));
    readfile($filePath);
    exit;
}

function str_starts_with($haystack, $needle) {
    return substr($haystack, 0, strlen($needle)) === $needle;
}