<?php
// api/controllers/WebhookController.php

class WebhookController {
    
    public function handleRequest($method, $action) {
        if ($method === 'POST' && $action === 'register') {
            $this->registerWebhook();
        } else {
            http_response_code(404);
            echo json_encode(["error" => "Webhook action not found."]);
        }
    }

    private function registerWebhook() {
        // Registering a commercial client's endpoint to receive callbacks (e.g. Transaction completed)
        $data = json_decode(file_get_contents("php://input"));
        
        if (!isset($data->target_url) || !isset($data->events)) {
            http_response_code(400);
            echo json_encode(["error" => "target_url and events array are required."]);
            return;
        }

        http_response_code(201);
        echo json_encode([
            "status" => "success",
            "message" => "Webhook registered successfully.",
            "data" => [
                "webhook_id" => "WH_" . time(),
                "secret" => bin2hex(random_bytes(16))
            ]
        ]);
    }
}
?>
