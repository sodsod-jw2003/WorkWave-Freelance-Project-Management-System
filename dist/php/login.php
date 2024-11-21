<?php 

require '../../connection.php';

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Login</title>

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../css/custom.css">

    <!-- login.js -->
    <script src="../js/register.js" defer></script>
</head>
<body>
    <section class="container-fluid poppins bg-green-10 vh-100 p-5 d-flex justify-content-center align-items-center">
        <div class="card p-5 rounded-5 shadow w-50">

            <!-- header -->
            <div class="container">
                <h1 class="fs-1 text-center text-green-70 fw-bold">Login</h1>
                <h6 class="fs-6 text-center">Login and Continue with <span class="fw-bold text-green-60">WorkWave</span></h6>
            </div>

            <!-- email -->
            <div class="container mt-4 mb-3">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-envelope text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="email" name="email" id="email" class="form-control rounded-end-5 border px-3 py-2" placeholder="Email" required>
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
                    <input type="password" name="password" id="password" class="form-control rounded-end-0 border px-3 py-2" placeholder="Password" required>
                    <button type="button" id="togglePassword1" class="btn btn rounded-end-5 btn-outline-light border">
                        <span class="fas fa-eye text-green-50"></span>
                    </button>
                </div>
            </div>

            <!-- forgot password -->
            <div class="container my-4">
                <a class="no-deco text-green-50 fw-bold" href="forgot_password.php">I forgot my password</a>
            </div>

            <!-- buttons -->
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-6 d-flex justify-content-center">
                        <a href="register.php" class="btn btn-light-green fw-bold text-green-100 rounded-5 w-100">Register</a>
                    </div>
                    <div class="col-6 d-flex justify-content-center">
                        <input type="submit" name="login" value="Login" class="btn btn-dark-green flex-grow-1 flex-sm-grow-0 col-12 col-sm-5 rounded-5 w-100">
                    </div>
                </div>
            </div>

        </div>
    </section>
</body>
</html>