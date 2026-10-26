<?php
// api/Router.php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri = explode('/', $uri);

// Basic routing for commercial APIs
// Example endpoint: /api/v1/wallet/balance

$version = $uri[2] ?? null;
$resource = $uri[3] ?? null;
$action = $uri[4] ?? null;

if ($version !== 'v1') {
    http_response_code(404);
    echo json_encode(["error" => "API version not supported."]);
    exit();
}

// Authentication Middleware Check (Mocked for now)
$headers = apache_request_headers();
$token = $headers['Authorization'] ?? '';
if (empty($token)) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized access. API token required."]);
    exit();
}

switch ($resource) {
    case 'auth':
        require 'controllers/AuthController.php';
        $controller = new AuthController();
        $controller->handleRequest($_SERVER['REQUEST_METHOD'], $action);
        break;
    case 'wallet':
        require 'controllers/WalletController.php';
        $controller = new WalletController();
        $controller->handleRequest($_SERVER['REQUEST_METHOD'], $action);
        break;
    case 'transactions':
        require 'controllers/TransactionController.php';
        $controller = new TransactionController();
        $controller->handleRequest($_SERVER['REQUEST_METHOD'], $action);
        break;
    case 'exchange':
        require 'controllers/ExchangeController.php';
        $controller = new ExchangeController();
        $controller->handleRequest($_SERVER['REQUEST_METHOD'], $action);
        break;
    case 'kyc':
        require 'controllers/KycController.php';
        $controller = new KycController();
        $controller->handleRequest($_SERVER['REQUEST_METHOD'], $action);
        break;
    case 'webhooks':
        require 'controllers/WebhookController.php';
        $controller = new WebhookController();
        $controller->handleRequest($_SERVER['REQUEST_METHOD'], $action);
        break;
    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint not found."]);
        break;
}
?>
