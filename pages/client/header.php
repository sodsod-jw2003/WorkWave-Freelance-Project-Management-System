<?php 
$mysqli = require ('../../connection.php');
include ('../../misc/modals.php');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <!-- freelancer_profile.js -->
    <script src="../../dist/js/client_profile.js" defer></script>

</head>
<body>
    <header class="container-fluid bg-white poppins shadow-sm sticky-top">
        <nav class="container d-flex flex-wrap justify-content-between align-items-center py-3">
            
            <!-- Logo/Branding -->
            <a href="../../index.php" class="d-flex align-items-center text-decoration-none mb-2 mb-lg-0">
                <img src="../../img/WorkWaveLogo.png" class="nav-logo" alt="WorkWave Logo" style="height: 40px; width: auto;">
                <h5 class="mb-0 ms-2 text-green-60 fw-bold">WorkWave</h5>
            </a>

            <!-- Search Bar -->
            <span class="ms-auto me-3 w-25">
                <div class="input-group me-lg-4 mb-2 mb-lg-0" style="max-width: 600px; flex-grow: 1;">
                    <span class="input-group-text bg-green-10 rounded-start border-0">
                        <i class="fas fa-search text-green-50"></i>
                    </span>
                    <input type="text" name="search" class="form-control no-outline ps-0 border-0 rounded-end bg-green-10"
                        placeholder="Search Freelancers..." aria-label="Search">
                </div>                
            </span>


            <!-- Right Section: Notifications and Profile -->
            <span class="d-flex align-items-center flex-wrap">
                <!-- Notifications -->
                <div class="nav-item dropdown me-3">
                    <a href="#" class="nav-link position-relative" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-bell text-green-60 fa-lg"></i>
                        <span class="badge bg-danger position-absolute top-0 start-100 translate-middle p-1 small">1</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end p-2" style="width: 300px;">
                        <li class="dropdown-header">Notifications</li>
                        <li>
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-comment me-2"></i> New comment on project
                                <span class="text-muted small d-block">2 min ago</span>
                            </a>
                        </li>
                        <li>
                            <a href="#" class="dropdown-item">
                                <i class="fas fa-list-check me-2"></i> New task assigned
                                <span class="text-muted small d-block">30 min ago</span>
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a href="#" class="dropdown-item text-center">View All</a>
                        </li>
                    </ul>
                </div>

                <!-- Profile -->
                <div class="nav-item dropdown">
                <a href="#" class="nav-link" data-bs-toggle="dropdown" aria-expanded="false">
                        <?php if (!empty($user['profile_picture_url'])): ?>
                            <img src="<?php echo $user['profile_picture_url']; ?>" alt="Profile Picture" class="img-fluid" style="max-width: 25px; border-radius: 50%; max-height: 25px;" onerror="this.onerror=null; this.src='../../img/default-profile.png';">
                        <?php else: ?>
                            <img src="../../img/default-profile.png" alt="Profile Picture" class="img-fluid" style="max-width: 25px; border-radius: 50%; max-height: 25px;">
                        <?php endif; ?>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end p-2" style="width: 200px;">
                        <li class="dropdown-header">Account</li>
                        <li>
                            <a href="profile.php" class="dropdown-item">
                                <i class="fas fa-wrench me-2"></i>Profile
                            </a>
                        </li>
                        <li>
                            <a href="#" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#logoutModal">
                                <i class="fas fa-right-from-bracket me-2"></i>Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </span>

        </nav>
    </header>
</body>