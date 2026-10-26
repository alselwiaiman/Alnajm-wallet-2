<?php
// api/controllers/ExchangeController.php

class ExchangeController {
    
    public function handleRequest($method, $action) {
        switch ($method) {
            case 'GET':
                if ($action === 'rates') {
                    $this->getRates();
                } else {
                    $this->notFound();
                }
                break;
            case 'POST':
                if ($action === 'order') {
                    $this->placeOrder();
                } else {
                    $this->notFound();
                }
                break;
            default:
                $this->methodNotAllowed();
                break;
        }
    }

    private function getRates() {
        // Fetch current exchange rates (could be from external providers eventually)
        $response = [
            "status" => "success",
            "data" => [
                "base" => "USD",
                "rates" => [
                    "EUR" => 0.92,
                    "GBP" => 0.79,
                    "SAR" => 3.75,
                    "AED" => 3.67
                ],
                "timestamp" => date("c")
            ]
        ];
        http_response_code(200);
        echo json_encode($response);
    }

    private function placeOrder() {
        // Mock processing an exchange order
        http_response_code(201);
        echo json_encode([
            "status" => "success",
            "message" => "Exchange order processed.",
            "data" => [
                "order_id" => "EX_" . time(),
                "status" => "EXECUTED"
            ]
        ]);
    }

    private function notFound() {
        http_response_code(404);
        echo json_encode(["error" => "Exchange action not found."]);
    }

    private function methodNotAllowed() {
        http_response_code(405);
        echo json_encode(["error" => "Method not allowed."]);
    }
}
?>
