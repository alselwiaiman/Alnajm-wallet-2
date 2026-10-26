<?php
// api/controllers/WalletController.php

class WalletController {
    
    public function handleRequest($method, $action) {
        switch ($method) {
            case 'GET':
                if ($action === 'balance') {
                    $this->getBalance();
                } else {
                    $this->notFound();
                }
                break;
            default:
                $this->methodNotAllowed();
                break;
        }
    }

    private function getBalance() {
        // Here we would interact with the Database class and Wallet model
        // For now, we return a standardized commercial API response
        
        $response = [
            "status" => "success",
            "data" => [
                "wallet_id" => "COMM_WALLET_88392",
                "company_id" => "COMP_1001",
                "balance" => 250000.00,
                "currency" => "USD",
                "last_updated" => date("c")
            ]
        ];
        
        http_response_code(200);
        echo json_encode($response);
    }

    private function notFound() {
        http_response_code(404);
        echo json_encode(["error" => "Wallet action not found."]);
    }

    private function methodNotAllowed() {
        http_response_code(405);
        echo json_encode(["error" => "Method not allowed for Wallet endpoint."]);
    }
}
?>
