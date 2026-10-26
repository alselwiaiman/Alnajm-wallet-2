<?php
// api/controllers/KycController.php

class KycController {
    
    public function handleRequest($method, $action) {
        if ($method === 'GET' && $action === 'status') {
            $this->getStatus();
        } else if ($method === 'POST' && $action === 'submit') {
            $this->submitDocument();
        } else if ($method === 'POST' && $action === 'advanced_submit') {
            $this->submitAdvancedVerification();
        } else {
            $this->notFound();
        }
    }

    private function getStatus() {
        // Returns the KYC/AML status of a user to a commercial client
        http_response_code(200);
        echo json_encode([
            "status" => "success",
            "data" => [
                "user_id" => $_GET['user_id'] ?? 'unknown',
                "kyc_level" => "TIER_2",
                "is_verified" => true,
                "last_checked" => date("c")
            ]
        ]);
    }

    private function submitDocument() {
        http_response_code(202);
        echo json_encode(["status" => "pending", "message" => "KYC documents received and under review."]);
    }

    private function submitAdvancedVerification() {
        // Mocking the receiving of multipart/form-data for advanced KYC
        // In production, this forwards files securely to an AI KYC Provider (Sumsub/Onfido/AWS)
        // Expected payload: 
        // - $_FILES['id_front'], $_FILES['id_back']
        // - $_FILES['liveness_360_video']
        // - $_FILES['selfie_with_id']
        // - $_POST['extracted_ocr_data']
        
        $hasLiveness = isset($_FILES['liveness_360_video']);
        $hasSelfieWithId = isset($_FILES['selfie_with_id']);
        
        http_response_code(202);
        echo json_encode([
            "status" => "pending", 
            "message" => "Advanced Biometric and OCR data safely received. AI processing initiated.",
            "data" => [
                "tracking_id" => "KYC_ADV_" . time(),
                "liveness_submitted" => true,
                "selfie_submitted" => true
            ]
        ]);
    }

    private function notFound() {
        http_response_code(404);
        echo json_encode(["error" => "KYC action not found."]);
    }
}
?>
