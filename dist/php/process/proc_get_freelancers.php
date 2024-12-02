<?php
session_start();
$mysqli = require '../../../connection.php';

// may view na
$query = "CALL sp_get_freelancers_from_v_freelancers()";

$result = $mysqli->query($query);

// Fetch all accepted applications and prepare an array
$applications = [];
while ($row = $result->fetch_assoc()) {
    $applications[] = $row;
}

header('Content-Type: application/json');
echo json_encode($applications);
exit;
