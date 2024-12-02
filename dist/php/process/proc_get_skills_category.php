<?php
require_once('../../../connection.php');

$query = "CALL sp_get_skills_category()";
$result = $mysqli->query($query);

$categories = [];
while($row = $result->fetch_assoc()) {
    $categories[] = $row;
}

echo json_encode($categories);
