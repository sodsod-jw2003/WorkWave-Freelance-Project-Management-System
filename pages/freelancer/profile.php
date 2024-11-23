<?php 
session_start();
$mysqli = require ('../../connection.php');
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Freelancer Profile</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">


    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <!-- freelancer_profile.js -->
    <script src="../../dist/js/freelancer_profile.js" defer></script>

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
                        placeholder="Search Projects, Skills, or Clients..." aria-label="Search">
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
                        <i class="fas fa-circle-user text-green-60 fa-lg"></i>
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

    <section class="container-fluid poppins">
        <div class="container">
            <!-- Profile Header -->
            <div class="row mt-4">
                <h2 class="text-start">Profile</h2>
            </div>

            <!-- Profile Content -->
            <div class="row">
                <!-- Sidebar/Profile Card -->
                <div class="col-12 col-md-4 col-lg-3 p-3">
                    <div class="card card-primary card-outline border-top-accent shadow mb-4 position-relative">
                        <div class="container d-flex justify-content-center mt-5 position-relative">
                            <!-- User Icon with Image Upload Trigger -->
                            <!-- temporary profile picture if none is uploaded -->
                            <div class="profile-pic-wrapper">
                                <img src="<?php echo $user['profile_picture_url'] ?>" class="profile-pic rounded-circle" style="width: 100px; height: 100px; object-fit: cover; cursor: pointer;">
                                <form id="profile-pic-form" style="display: none;">
                                    <!-- Hidden File Input -->
                                    <input type="file" id="profile-pic-input" name="profile_picture" accept="image/*">
                                </form>
                            </div>
                        </div>
                        <div class="container fs-5 text-center mt-3"><?php echo htmlspecialchars($full_name); ?></div>
                        <div class="container fs-6 text-center text-muted mb-5"><?php echo htmlspecialchars($job_title); ?></div>
                    </div>

                    <div class="card card-primary card-outline shadow">
                        <div class="card-header bg-green-30 p-3">
                            <i class="fa-solid fa-briefcase text-white ms-1"></i>
                            <div class="text-white p-1 d-inline">Job Experience</div>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <div class="text-muted fw-semibold text-green-60">Manager</div>
                                <div class="text-muted small">Krusty Krabs</div>
                                <div class="text-muted small d-inline fst-italic">2010-2013</div>
                            </div>
                            <hr class="divider">
                            <div class="mb-3">
                                <div class="text-muted fw-semibold text-green-60">Tambay Lang</div>
                                <div class="text-muted small">eD1 s4 puS0 mUoHH :P</div>
                                <div class="text-muted small d-inline fst-italic">2015-2021</div>
                            </div>
                            <hr class="divider">
                            <div class="">
                                <div class="text-muted fw-semibold text-green-60">Yapper</div>
                                <div class="text-muted small">Sa Tabi-Tabi</div>
                                <div class="text-muted small d-inline fst-italic">2022-Present</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Content Area -->
                <div class="col-12 col-md-8 col-lg-9 p-3">
                    <div class="card shadow h-100">
                        <div class="card-body">
                            <!-- Nav Pills -->
                            <ul class="nav nav-pills mb-3 m-2" id="pills-tab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="pills-experience-tab" data-bs-toggle="pill" data-bs-target="#pills-experience" type="button" role="tab" aria-controls="pills-experience" aria-selected="true">
                                        Experience
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="pills-skills-tab" data-bs-toggle="pill" data-bs-target="#pills-skills" type="button" role="tab" aria-controls="pills-skills" aria-selected="false">
                                        Skills
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="pills-personal-tab" data-bs-toggle="pill" data-bs-target="#pills-personal" type="button" role="tab" aria-controls="pills-personal" aria-selected="false">
                                        Personal Information
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="pills-account-tab" data-bs-toggle="pill" data-bs-target="#pills-account" type="button" role="tab" aria-controls="pills-account" aria-selected="false">
                                        Account Settings
                                    </button>
                                </li>
                            </ul>

                            <!-- Tab Content -->
                            <div class="tab-content m-2" id="pills-tabContent">
                                <!-- Experience Tab Pane -->
                                <div class="tab-pane slide show active" id="pills-experience" role="tabpanel" aria-labelledby="pills-experience-tab">
                                    <div class="container pt-4 pb-2 mb-3">
                                        <h5 class="">Experience</h5>
                                        <h6 class="text-muted">List all of your <span class="fw-semibold text-green-50">Job Experience</span> including Job Title, Company, and Duration.</h6>
                                    </div>
                                    <div class="card p-3 mx-2 bg-light border-start-accent card-outline">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-4 mb-1">
                                                    <label for="job_title" class="text-muted small mb-2 ms-1">Job Title</label>
                                                    <input type="text" name="job_title" class="form-control bg-white-100 no-outline-green-focus border-1 w-100" placeholder="Content Writer">
                                                </div>
                                                <div class="col-md-4 mb-1">
                                                    <label for="company" class="text-muted small mb-2 ms-1">Company</label>
                                                    <input type="text" name="company" class="form-control bg-white-100 no-outline-green-focus border-1 w-100" placeholder="SMDC Inc.">
                                                </div>
                                                <div class="col-md-4 mb-1">
                                                    <label for="duration" class="text-muted small mb-2 ms-1">Duration</label>
                                                    <input type="text" name="duration" class="form-control bg-white-100 no-outline-green-focus border-1 w-100" placeholder="2009-2011">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card-footer border-0 bg-transparent mb-2">
                                            <button class="btn btn-danger">
                                                <i class="fas fa-trash text-white me-2"></i><span>Remove</span>
                                            </button>
                                            <button class="btn btn-primary">
                                                <i class="fas fa-plus text-white me-2"></i><span>Add</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <!-- Skills Tab Pane -->
                                <div class="tab-pane slide" id="pills-skills" role="tabpanel" aria-labelledby="pills-skills-tab">
                                    <div class="container pt-4 pb-2 mb-3">
                                        <h5 class="">Skills</h5>
                                        <h6 class="text-muted">Select and tick all the <span class="fw-semibold text-green-50">Skills</span> that you possess.</h6>
                                    </div>
                                </div>

                                <!-- Personal Information Tab Pane -->
                                <div class="tab-pane slide" id="pills-personal" role="tabpanel" aria-labelledby="pills-personal-tab">
                                    <div class="container pt-4 pb-2 mb-3">
                                        <h5 class="">Personal Information</h5>
                                        <h6 class="text-muted">Provide all the <span class="fw-semibold text-green-50">Personal Information</span> necessary for your account setup.</h6>
                                    </div>
                                </div>

                                <!-- Account Settings Tab Pane -->
                                <div class="tab-pane slide" id="pills-account" role="tabpanel" aria-labelledby="pills-account-tab">
                                    <div class="container pt-4 pb-2 mb-3">
                                        <h5 class="">Account Settings</h5>
                                        <h6 class="text-muted">Having trouble about security? Modify your account or Take a Break.</h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


            </div>
        </div>
    </section>


</body>
</html>