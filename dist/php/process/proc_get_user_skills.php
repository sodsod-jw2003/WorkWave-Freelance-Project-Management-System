<?php
session_start();
$mysqli = require '../../../connection.php';

$user_id = $_SESSION['user_id'];

$query = "	SELECT skill_id FROM v_user_skills WHERE user_id = ?;";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$skills = [];
while($row = $result->fetch_assoc()) {
    $skills[] = $row;
}

echo json_encode($skills);
