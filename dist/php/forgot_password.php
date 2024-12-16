<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Forgot Password</title>

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../css/custom.css">

    <!-- login.js -->
    <!-- <script src="../js/login.js" defer></script> -->
</head>
<body>
<section class="container-fluid poppins vh-100 p-5 d-flex justify-content-center align-items-center position-relative">
    <!-- Video Background -->
    <div class="hero-video position-absolute top-0 start-0 w-100 h-100 z-index-0">
        <video autoplay loop muted playsinline class="w-100 h-100 object-fit-cover">
            <source src="uploads/vid/hero_vid.mp4" type="video/mp4">
            Your browser does not support the video tag.
        </video>
    </div>

    <div class="card p-5 rounded-5 shadow w-50 z-index-1">
        <!-- header -->
        <div class="container">
            <h1 class="fs-1 text-center text-green-70 fw-bold">Forgot Password</h1>
            <h6 class="fs-6 text-center">Provide your Email to Reset your Password</h6>
        </div>

        <!-- form -->
        <form action="process/proc_forgot_password.php" method="post">

            <!-- email -->
            <div class="container mt-4 mb-4">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-envelope text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="email" name="email" id="email" class="form-control rounded-end-5 border px-3 py-2" placeholder="Email" required>
                </div>
            </div>

            <!-- buttons -->
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-6 d-flex justify-content-center">
                        <a href="login.php" class="btn btn-light-green fw-bold text-green-100 rounded-5 w-100">Back to Login</a>
                    </div>
                    <div class="col-6 d-flex justify-content-center">
                        <input type="submit" name="forgot_password" value="Recover Password" class="btn btn-dark-green flex-grow-1 flex-sm-grow-0 col-12 col-sm-5 rounded-5 w-100">
                    </div>
                </div>
            </div>

        </form> 
    </div>
</section>

</body>
</html>