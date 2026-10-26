<?php
// config/Database.php
namespace Config;

class Database {
    // These would typically be loaded from .env securely
    private $host = "your-supabase-db.supabase.co";
    private $port = "5432";
    private $db_name = "postgres";
    private $username = "postgres";
    private $password = "your-secure-password";
    public $conn;

    public function getConnection() {
        $this->conn = null;
        try {
            // PostgreSQL connection string for Supabase
            $dsn = "pgsql:host=" . $this->host . ";port=" . $this->port . ";dbname=" . $this->db_name;
            $this->conn = new \PDO($dsn, $this->username, $this->password);
            $this->conn->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
            $this->conn->setAttribute(\PDO::ATTR_DEFAULT_FETCH_MODE, \PDO::FETCH_ASSOC);
        } catch(\PDOException $exception) {
            // Log securely, don't expose error to the client
            error_log("Connection error: " . $exception->getMessage());
            echo json_encode(["error" => "Database connection failed."]);
            exit;
        }
        return $this->conn;
    }
}
?>
