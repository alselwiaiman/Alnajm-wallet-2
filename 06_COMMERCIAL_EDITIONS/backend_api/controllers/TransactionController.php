<?php
// api/controllers/TransactionController.php

class TransactionController {
    
    public function handleRequest($method, $action) {
        switch ($method) {
            case 'POST':
                if ($action === 'transfer') {
                    $this->processB2BTransfer();
                } else {
                    $this->notFound();
                }
                break;
            case 'GET':
                if ($action === 'history') {
                    $this->getHistory();
                } else {
                    $this->notFound();
                }
                break;
            default:
                $this->methodNotAllowed();
                break;
        }
    }

    private function processB2BTransfer() {
        // In a real scenario, validate input strictly, begin DB transaction, lock row, deduct, add, commit.
        $data = json_decode(file_get_contents("php://input"));

        if (!isset($data->amount) || !isset($data->recipient_id)) {
            http_response_code(400);
            echo json_encode(["error" => "Missing required fields: amount, recipient_id"]);
            return;
        }

        // Mocking a successful B2B transaction via API
        $response = [
            "status" => "success",
            "message" => "Transfer processed successfully via Commercial API.",
            "data" => [
                "transaction_id" => "TXN_" . time(),
                "amount" => $data->amount,
                "recipient_id" => $data->recipient_id,
                "status" => "COMPLETED",
                "timestamp" => date("c")
            ]
        ];
        
        http_response_code(201);
        echo json_encode($response);
    }

    private function getHistory() {
        $response = [
            "status" => "success",
            "data" => [
                [
                    "transaction_id" => "TXN_8849201",
                    "type" => "B2B_SETTLEMENT",
                    "amount" => 15000.00,
                    "currency" => "USD",
                    "status" => "COMPLETED",
                    "timestamp" => date("c")
                ]
            ]
        ];
        
        http_response_code(200);
        echo json_encode($response);
    }

    private function notFound() {
        http_response_code(404);
        echo json_encode(["error" => "Transaction action not found."]);
    }

    private function methodNotAllowed() {
        http_response_code(405);
        echo json_encode(["error" => "Method not allowed for Transaction endpoint."]);
    }
}
?>
