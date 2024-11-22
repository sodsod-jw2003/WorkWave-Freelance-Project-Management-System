<?php
    $token = $_GET["token"];

    $mysqli = require "../../../connection.php";

    $stmt = $mysqli->prepare("CALL activate_account(?)");
    $stmt->bind_param("s", $token);
    $stmt->execute();

    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    if ($user === null) {
        die("Token not found. Debug info: " . htmlspecialchars($token));
    }

    $stmt->free_result();
    $mysqli->next_result();

    $stmt = $mysqli->prepare("CALL update_activation_token(?)");
    $stmt->bind_param("i", $user["user_id"]);
    $stmt->execute();
    ?>
    <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>WorkWave | Account Activation</title>

            <!-- Bootstrap CSS from CDN -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            
            <!-- Bootstrap JS from CDN -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            
            <!-- Font Awesome -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
            
            <!-- Custom CSS -->
            <link rel="stylesheet" href="../../css/custom.css">
        </head>
        <body>
            <section class="container-fluid poppins bg-green-10 vh-100 p-5 d-flex justify-content-center align-items-center">
                    <div class="card p-5 rounded-5 shadow w-50">
                        <div class="container">
                            <h1 class="fs-1 text-center text-green-70 fw-bold">Account Activated</h1>
                            <h6 class="fs-6 text-center">Account activated. You can now <a href="../login.php">login</a></h6>
                        </div>
                    </div>
            </section>
        </body>
        </html>