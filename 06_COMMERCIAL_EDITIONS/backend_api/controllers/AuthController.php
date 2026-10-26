<?php
// api/controllers/AuthController.php

class AuthController {
    
    public function handleRequest($method, $action) {
        switch ($method) {
            case 'POST':
                if ($action === 'token') {
                    $this->generateToken();
                } else {
                    $this->notFound();
                }
                break;
            case 'GET':
                if ($action === 'verify') {
                    $this->verifyToken();
                } else {
                    $this->notFound();
                }
                break;
            default:
                $this->methodNotAllowed();
                break;
        }
    }

    private function generateToken() {
        // Authenticate commercial client using API Key / Secret, then issue JWT
        $data = json_decode(file_get_contents("php://input"));
        
        if (!isset($data->api_key) || !isset($data->api_secret)) {
            http_response_code(400);
            echo json_encode(["error" => "api_key and api_secret are required."]);
            return;
        }

        // Mock JWT generation
        $response = [
            "status" => "success",
            "data" => [
                "access_token" => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_token",
                "expires_in" => 3600,
                "token_type" => "Bearer"
            ]
        ];
        
        http_response_code(200);
        echo json_encode($response);
    }

    private function verifyToken() {
        http_response_code(200);
        echo json_encode(["status" => "success", "message" => "Token is valid."]);
    }

    private function notFound() {
        http_response_code(404);
        echo json_encode(["error" => "Auth action not found."]);
    }

    private function methodNotAllowed() {
        http_response_code(405);
        echo json_encode(["error" => "Method not allowed."]);
    }
}
?>
