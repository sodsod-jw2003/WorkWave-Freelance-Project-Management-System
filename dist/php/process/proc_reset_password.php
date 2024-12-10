<?php
$token = $_POST["token"];

$mysqli = require "../../../connection.php";

//checking of token
$stmt = $mysqli->prepare("SELECT * FROM v_users_with_reset_tokens WHERE reset_token_hash = ?");
$stmt->bind_param("s", $token);
$stmt->execute();

$result = $stmt->get_result();
$user = $result->fetch_assoc();

$stmt->free_result();
$mysqli->next_result();

if ($user === null) {
    die("token not found");
}

//password hashing
$password_hash = password_hash($_POST["password"], PASSWORD_DEFAULT);

//updating password
$stmt = $mysqli->prepare("CALL sp_update_user_password(?, ?)");
$stmt->bind_param("ss", $password_hash, $user["id"]);
$stmt->execute();

header("Location: ../login.php");
exit();