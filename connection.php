<?php
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

$HOST = "localhost";
$USERNAME = "root";
$PASSWORD = "";
$DBNAME = "workwave_db";

try {
    
    $mysqli = new mysqli($HOST, $USERNAME, $PASSWORD, $DBNAME);
    
    if ($mysqli->connect_errno) {
        die ("Connection error: " . $mysqli->connect_error);
    }
    
    return $mysqli;
    
    } catch (Exception $e) {
        die("Connection error: " . $e->getMessage());
}

echo "Connected successfully";