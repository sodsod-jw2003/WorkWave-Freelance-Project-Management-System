<?php 

$is_invalid_status = false;
$is_invalid = false;

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $mysqli = require "../../connection.php";

    $stmt = $mysqli->prepare("CALL sp_get_user_by_email(?)");
    $stmt->bind_param("s", $_POST["email"]);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    if ($user) {
        // First, check if password is correct
        if (password_verify($_POST["password"], $user["password_hash"])) {
            // If password is correct, then check if the account is activated
            if ($user["activation_token_hash"] === null) {
                //Last login
                
                // Start session and redirect based on role
                if (session_status() === PHP_SESSION_NONE) {
                    session_start();
                }

                session_regenerate_id(); 
                $_SESSION["user_id"] = $user["user_id"];
                $_SESSION["role"] = $user["role"];

                if ($user["role"] === "Client") {
                    header("Location: ../../pages/client/dashboard.php");
                } elseif ($user["role"] === "Freelancer") {
                    header("Location: ../../pages/freelancer/dashboard.php");
                }
                exit;
            } else {
                // Account not activated
                $is_invalid_status = true;
                $error_message = "Account not activated";
            }
        } else {
            // Incorrect password
            $is_invalid = true;
            $error_message = "Wrong email or password";
        }
    } else {
        // User not found
        $is_invalid = true;
        $error_message = "Wrong email or password";
    }
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Login</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">
    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../css/custom.css">
</head>
<body>
    <section class="container-fluid poppins vh-100 p-5 d-flex justify-content-center align-items-center">
        <div class="card p-5 rounded-5 shadow w-50">
            <!-- header -->
            <div class="container">
                <h1 class="fs-1 text-center text-green-70 fw-bold">Login</h1>
                <h6 class="fs-6 text-center">Login and Continue with <span class="fw-bold text-green-60">WorkWave</span></h6>
            </div>

            <!--form-->
            <form method="POST" id="loginForm">
                <!-- email -->
                <div class="container mt-4 mb-3">
                    <div class="input-group my-1">
                        <div class="input-group-prepend d-flex align-items-stretch">
                            <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                                <span class="fas fa-envelope text-green-50 ps-1"></span>
                            </div>
                        </div>
                        <input type="email" name="email" id="email" class="form-control no-outline-green-focus rounded-end-5 border px-3 py-2 no-outline" placeholder="Email" required>
                    </div>
                </div>

                <!-- password -->
                <div class="container mb-1">
                    <div class="input-group my-1">
                        <div class="input-group-prepend d-flex align-items-stretch">
                            <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                                <span class="fas fa-lock text-green-50 ps-1"></span>
                            </div>
                        </div>
                        <input type="password" name="password" id="password" class="form-control no-outline-green-focus rounded-end-0 border px-3 py-2 no-outline" placeholder="Password" required>
                        <button type="button" id="togglePassword1" class="btn btn rounded-end-5 btn-outline-light border">
                            <span class="fas fa-eye text-green-50"></span>
                        </button>
                    </div>
                </div>

                <!--login status-->
                <?php if ($is_invalid_status): ?>
                   <div class=text-end text-danger>
                        <em> <?= $error_message; ?> </em>
                   </div>
                   <?php elseif ($is_invalid): ?>
                        <div class="text-end text-danger">
                           <em> <?= $error_message; ?> </em>
                        </div>
                   <?php endif; ?>

                <!-- forgot password -->
                <div class="container my-4">
                    <a class="no-deco text-green-50 fw-bold" href="forgot_password.php">I forgot my password</a>
                </div>

                <!-- buttons -->
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-6 d-flex justify-content-center">
                            <a href="register.php" class="btn btn-light-green fw-medium text-green-100 rounded-5 w-100">Register</a>
                        </div>
                        <div class="col-6 d-flex justify-content-center">
                            <input type="submit" name="login" value="Login" class="btn btn-dark-green flex-grow-1 flex-sm-grow-0 col-12 col-sm-5 rounded-5 w-100">
                        </div>
                    </div>
                </div>
            </div>
            <!--end form-->
        </form>
    </section>

    <!-- eye toggle -->
    <script src="../js/login.js"></script>
</body>
</html>
