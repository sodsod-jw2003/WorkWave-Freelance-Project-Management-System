<?php
require_once('../../../connection.php');

$query = "SELECT DISTINCT skill_category FROM skills ORDER BY skill_category";
$result = $mysqli->query($query);

$categories = [];
while($row = $result->fetch_assoc()) {
    $categories[] = $row;
}

echo json_encode($categories);
