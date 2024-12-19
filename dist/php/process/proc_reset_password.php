<?php
$mysqli = require "../../../connection.php";

//password hashing
$password_hash = password_hash($_POST["password"], PASSWORD_DEFAULT);

//updating password
$stmt = $mysqli->prepare("CALL sp_update_user_password(?, ?)");
$stmt->bind_param("ss", $password_hash, $user["id"]);
$stmt->execute();

header("Location: ../login.php");
exit();