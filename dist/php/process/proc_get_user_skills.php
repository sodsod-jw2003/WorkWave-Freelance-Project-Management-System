<?php
session_start();
$mysqli = require '../../../connection.php';

$user_id = $_SESSION['user_id'];

$query = "CALL sp_get_user_skills(?)";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$skills = [];
while($row = $result->fetch_assoc()) {
    $skills[] = $row;
}

echo json_encode($skills);
