<?php
session_start();
require_once '../../../connection.php';

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['notification_id'])) {
    $query = "CALL sp_update_notification(?)";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("i", $data['notification_id']);
    $stmt->execute();
}
