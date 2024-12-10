<?php
require_once('../../../connection.php');

$query = "SELECT * FROM v_available_skills_category;";
$result = $mysqli->query($query);

$categories = [];
while($row = $result->fetch_assoc()) {
    $categories[] = $row;
}

echo json_encode($categories);
