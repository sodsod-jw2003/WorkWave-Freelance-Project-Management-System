<?php 
session_start();
$mysqli = require ('../../connection.php');
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Client Profile</title>
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
    <script src="../../dist/js/client_profile.js" defer></script>

</head>
<body>
    
    <section class="container-fluid poppins">
        <div class="container">
            <!-- Profile Header -->
            <div class="row mt-4 align-items-center">
                <!-- Profile Title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start">Client Profile</h2>
                </div>

                <!-- Breadcrumb Navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Profile</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <!-- Profile Content -->
            <div class="row">
                <!-- Sidebar/Profile Card -->
                <div class="col-12 col-md-4 col-lg-3 p-3">
                    <div class="card card-primary card-outline border-top-accent shadow border-0 mb-4 position-relative">
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

                    <!-- sidebar: job experience -->
                    <div class="card card-primary card-outline shadow border-0 mb-4">
                        <!-- job experience: collapsible header -->
                        <div class="card-header bg-green-30 p-3">
                            <a class="d-flex align-items-center text-decoration-none toggle-icon"
                            data-bs-toggle="collapse" 
                            href="#jobExperienceCollapse" 
                            role="button" 
                            aria-expanded="true" 
                            aria-controls="jobExperienceCollapse">

                                <i class="fa-solid fa-briefcase text-white mx-1"></i>
                                <div class="text-white p-1 d-inline">Job Experience</div>
                                <i class="fa-solid fa-chevron-down text-white ms-auto pe-1 icon-toggle"></i>
                            </a>
                        </div>
                        <!-- job experience: collapsible content -->
                        <div id="jobExperienceCollapse" class="collapse-section collapse show">
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="text-muted fw-semibold text-green-60">Job Title 1</div>
                                    <div class="text-muted small">Company 1</div>
                                    <div class="text-muted small d-inline fst-italic">Duraton 1</div>
                                </div>
                                <hr class="divider">
                                <div class="mb-3">
                                    <div class="text-muted fw-semibold text-green-60">Job Title 2</div>
                                    <div class="text-muted small">Company 2</div>
                                    <div class="text-muted small d-inline fst-italic">Duraton 2</div>
                                </div>
                                <hr class="divider">
                                <div class="">
                                    <div class="text-muted fw-semibold text-green-60">Job Title 3</div>
                                    <div class="text-muted small">Company 3</div>
                                    <div class="text-muted small d-inline fst-italic">Duraton 3</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- sidebar: skills -->
                    <div class="card card-primary card-outline shadow border-0 mb-4">
                        <!-- skills: collapsible header -->
                        <div class="card-header bg-green-30 p-3">
                            <a  class="d-flex align-items-center text-decoration-none"
                                data-bs-toggle="collapse" 
                                href="#skillsCollapse" 
                                role="button" 
                                aria-expanded="true" 
                                aria-controls="skillsCollapse">

                                <i class="fa-solid fa-lightbulb text-white mx-1"></i>
                                <div class="text-white p-1 d-inline">Skills</div>
                                <i class="fa-solid fa-chevron-down text-white ms-auto pe-1"></i>
                            </a>
                        </div>
                        <!-- skills: collapsible content -->
                        <div id="skillsCollapse" class="collapse-section collapse show">
                            <div class="card-body">
                                <div class="container d-flex justify-content-center">
                                    <div class="mb-1 text-secondary fa-2x d-inline">
                                        <span class="fas fa-camera" data-bs-toggle="tooltip" title="Photo Editing"></span>
                                        <span class="fas fa-pencil-alt" data-bs-toggle="tooltip" title="Graphic Design"></span>
                                        <span class="fas fa-code" data-bs-toggle="tooltip" title="Web Development"></span>
                                        <span class="fas fa-microphone" data-bs-toggle="tooltip" title="Voice Over"></span>
                                        <span class="fas fa-chart-line" data-bs-toggle="tooltip" title="Digital Marketing"></span>
                                        <span class="fas fa-keyboard" data-bs-toggle="tooltip" title="Content Writing"></span>
                                        <span class="fas fa-video" data-bs-toggle="tooltip" title="Video Editing"></span>
                                        <span class="fas fa-database" data-bs-toggle="tooltip" title="Data Analysis"></span>
                                    </div>
                                </div>
                                <div class="mb-1">
                                <hr class="divider">
                                    <div class="text-muted fw-semibold text-green-60">Category</div>
                                    <div class="text-muted small">Skill</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- sidebar: personal information -->
                    <div class="card card-primary card-outline shadow border-0 mb-4">

                        <!-- personal info: collapsible header -->
                        <div class="card-header bg-green-30 p-3">
                            <a  class="d-flex align-items-center text-decoration-none"
                                data-bs-toggle="collapse" 
                                href="#personalInformationCollapse" 
                                role="button" 
                                aria-expanded="true" 
                                aria-controls="personalInformationCollapse">

                                <i class="fa-solid fa-user text-white mx-1"></i>
                                <div class="text-white p-1 d-inline">Personal Information</div>
                                <i class="fa-solid fa-chevron-down text-white ms-auto pe-1"></i>
                            </a>
                        </div>

                        <!-- personal info: collapsible content -->
                        <div id="personalInformationCollapse" class="collapse-section collapse show">
                            <div class="card-body">
                                <div class="mb-3">
                                    <span class="fas fa-mars-and-venus me-1 text-green-60"></span>
                                    <span class="text-muted fw-semibold text-green-60">Gender</span>
                                    <div class="text-muted small"><?php echo $user['gender'] ?></div>
                                </div>
                                <hr class="divider">
                                <div class="mb-3">
                                    <span class="fas fa-phone me-1 text-green-60"></span>
                                    <span class="text-muted fw-semibold text-green-60">Mobile Number</span>
                                    <div class="text-muted small"><?php echo $user['first_name'] ?></div>
                                </div>
                                <hr class="divider">
                                <div class="mb-3">
                                    <span class="fas fa-envelope me-1 text-green-60"></span>
                                    <span class="text-muted fw-semibold text-green-60">Email</span>
                                    <div class="text-muted small"><?php echo $user['email'] ?></div>
                                </div>
                                <hr class="divider">
                                <div class="mb-3">
                                    <span class="fas fa-location-dot me-1 text-green-60"></span>
                                    <span class="text-muted fw-semibold text-green-60">Location</span>
                                    <div class="text-muted small"><?php echo $user['city'] ?></div>
                                </div>
                                <hr class="divider">
                                <div class="mb-3">
                                    <span class="fas fa-flag me-1 text-green-60"></span>
                                    <span class="text-muted fw-semibold text-green-60">Nationality</span>
                                    <div class="text-muted small"><?php echo $user['first_name'] ?></div>
                                </div>
                                <hr class="divider">
                                <div class="">
                                    <span class="fas fa-language me-1 text-green-60"></span>
                                    <span class="text-muted fw-semibold text-green-60">Language</span>
                                    <div class="text-muted small"><?php echo $user['first_name'] ?></div>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>

                <!-- Main Content Area -->
                <div class="col-12 col-md-8 col-lg-9 p-3">
                    <div class="card shadow border-0">
                        <div class="card-body">
                            <!-- Nav Pills -->
                            <ul class="nav nav-pills mb-3 m-2" id="pills-tab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" 
                                        id="pills-projects-tab" 
                                        data-bs-toggle="pill" 
                                        data-bs-target="#pills-projects" 
                                        type="button" role="tab" 
                                        aria-controls="pills-projects" 
                                        aria-selected="true">
                                        Projects
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" 
                                        id="pills-freelancers-tab" 
                                        data-bs-toggle="pill" 
                                        data-bs-target="#pills-freelancers" 
                                        type="button" role="tab" 
                                        aria-controls="pills-freelancers" 
                                        aria-selected="false">
                                        Freelancers
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" 
                                        id="pills-personal-tab" 
                                        data-bs-toggle="pill" 
                                        data-bs-target="#pills-personal" 
                                        type="button" role="tab" 
                                        aria-controls="pills-personal" 
                                        aria-selected="false">
                                        Personal Information
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" 
                                        id="pills-account-tab" 
                                        data-bs-toggle="pill" 
                                        data-bs-target="#pills-account" 
                                        type="button" role="tab" 
                                        aria-controls="pills-account" 
                                        aria-selected="false">
                                        Account Settings
                                    </button>
                                </li>
                            </ul>

                            <!-- Tab Content -->
                            <div class="tab-content m-2" id="pills-tabContent">

                                <!-- projects: tab pane -->
                                <div class="tab-pane slide show active"
                                    id="pills-projects"
                                    role="tabpanel"
                                    aria-labelledby="pill=projects-tab">
                                    <div class="container pt-4 pb-2 mb-3">
                                        <h5 class="">Projects</h5>
                                        <h6 class="text-muted">Listed below are your <span class="fw-semibold text-green-50">Projects</span>. Click the project title to view <span class="fw-semibold text-green-50">Project Details</span></h6>
                                    </div>
                                    <!-- project card -->
                                    <div class="card px-3 pt-3 pb-1 mx-2 mb-3 bg-light border-start-accent">
                                        <div class="card-header bg-transparent d-flex justify-content-between align-items-center">
                                            <h5 class="">
                                                <a href="#" class="text-dark">Project Title</a>
                                            </h5>
                                            <span class="badge bg-success mb-2">Project Status</span>
                                        </div>
                                        <div class="card-body bg-">
                                            <h6 class="fw-bold">Project Category</h6>
                                            <h6 class="text-muted small">Project Description Bla Bla Bla</h6>
                                        </div>
                                    </div>
                                    <!-- end project card -->
                                </div>
                                <!-- end projects: tab pane -->
                                
                                <!-- freelancers: tab pane -->
                                <div class="tab-pane slide show"
                                    id="pills-freelancers"
                                    role="tabpanel"
                                    aria-labelledby="pill=freelancers-tab">
                                    <div class="container pt-4 pb-2 mb-3">
                                        <h5 class="">Freelancers</h5>
                                        <h6 class="text-muted">Shown below are your <span class="fw-semibold text-green-50">Freelancers</span>. You can manage your <span class="fw-semibold text-green-50">Freelancers</span></h6>
                                    </div>
                                    <div class="col-12">
                                        <!-- Freelancer Cards Wrapper -->
                                        <div class="row row-cols-1 row-cols-md-2 g-3">
                                            <!-- Freelancer Card -->
                                            <div class="col mb-3">
                                                <div class="card px-3 pt-3 pb-2 mx-2 bg-light border-start-accent shadow-sm" style="border-radius: 10px;">
                                                    <div class="card-body d-flex justify-content-between align-items-center">
                                                        <div class="">
                                                            <h6 class="text-muted">Job Title</h6>
                                                            <h5 class="fw-bold text-accent mb-2">Freelancer Name</h5>
                                                            <p class="small text-muted mb-4">Project Working On</p>
                                                            <p class="mb-1 text-muted"><i class="fas fa-envelope me-2"></i> Email</p>
                                                            <p class="mb-0 text-muted"><i class="fas fa-phone me-2"></i> Mobile Number</p>
                                                        </div>
                                                        <div class="profile">
                                                            <img src="<?php echo $user['profile_picture_url'] ?>" 
                                                                alt="" 
                                                                class="rounded-circle border border-accent shadow-sm" 
                                                                style="width: 100px; height: 100px;">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- End Freelancer Card -->

                                            <!-- Freelancer Card -->
                                            <div class="col mb-3">
                                                <div class="card px-3 pt-3 pb-2 mx-2 bg-light border-start-accent shadow-sm" style="border-radius: 10px;">
                                                    <div class="card-body d-flex justify-content-between align-items-center">
                                                        <div class="">
                                                            <h6 class="text-muted">Job Title</h6>
                                                            <h5 class="fw-bold text-accent mb-2">Freelancer Name</h5>
                                                            <p class="small text-muted mb-4">Project Working On</p>
                                                            <p class="mb-1 text-muted"><i class="fas fa-envelope me-2"></i> Email</p>
                                                            <p class="mb-0 text-muted"><i class="fas fa-phone me-2"></i> Mobile Number</p>
                                                        </div>
                                                        <div class="profile">
                                                            <img src="<?php echo $user['profile_picture_url'] ?>" 
                                                                alt="" 
                                                                class="rounded-circle border border-accent shadow-sm" 
                                                                style="width: 100px; height: 100px;">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- End Freelancer Card -->
                                        </div>
                                    </div>


                                </div>
                                <!-- end freelancers: tab pane -->

                                <!-- personal information: tab pane -->
                                <div class="tab-pane slide" id="pills-personal" role="tabpanel" aria-labelledby="pills-personal-tab">
                                    <div class="container pt-4 pb-2 mb-3">
                                        <h5 class="">Personal Information</h5>
                                        <h6 class="text-muted">Provide all the <span class="fw-semibold text-green-50">Personal Information</span> necessary for your account setup.</h6>
                                    </div>
                                    <div class="card p-3 mx-2 bg-light border-start-accent card-outline">
                                        <div class="card-body">

                                            <!-- fname, lname, and job title -->
                                            <div class="row">
                                                <div class="col-md-4 mb-1"> <!-- fetch lang -->
                                                    <label for="first_name" class="text-muted small mb-2 ms-1">First Name</label>
                                                    <input 
                                                        type="text" 
                                                        name="first_name" 
                                                        class="form-control bg-white-100 no-outline-green-focus border-1 w-100" 
                                                        placeholder="<?php echo $user['first_name'] ?>">
                                                </div>
                                                <div class="col-md-4 mb-1"> <!-- fetch lang -->
                                                    <label for="last_name" class="text-muted small mb-2 ms-1">Last Name</label>
                                                    <input 
                                                        type="text" 
                                                        name="last_name" 
                                                        class="form-control bg-white-100 no-outline-green-focus border-1 w-100" 
                                                        placeholder="<?php echo $user['last_name'] ?>">
                                                </div>
                                                <div class="col-md-4 mb-1"> <!-- fetch lang -->
                                                    <label for="job_title" class="text-muted small mb-2 ms-1">Job Title</label>
                                                    <select 
                                                        name="job_title" 
                                                        id="job_title" 
                                                        class="form-select bg-white-100 no-outline-green-focus border-1 w-100">
                                                        <option value="" selected><?php echo $user['job_title'] ?></option>
                                                        <option value="Sample_Job_Title_1">Sample Job Title 1</option>
                                                        <option value="Sample_Job_Title_2">Sample Job Title 2</option>
                                                        <option value="Sample_Job_Title_3">Sample Job Title 3</option>
                                                        <option value="Sample_Job_Title_4">Sample Job Title 4</option>
                                                        <option value="Sample_Job_Title_5">Sample Job Title 5</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <!-- gender, mobile num, and email -->
                                            <div class="row mt-3">
                                                <div class="col-md-4 mb-1"> <!-- fetch lang -->
                                                    <label for="gender" class="text-muted small mb-2 ms-1">Gender</label>
                                                    <select 
                                                        name="gender" 
                                                        id="gender" class="form-select bg-white-100 no-outline-green-focus border-1 w-100" 
                                                        required>
                                                        <option value="" disabled selected><?php echo $user['gender'] ?></option>
                                                        <option value="Male">Male</option>
                                                        <option value="Female">Female</option>
                                                        <option value="Prefer not to say">Prefer not to say</option>
                                                    </select>
                                                </div>

                                                <div class="col-md-4 mb-1">
                                                    <label for="mobile_number" class="text-muted small mb-2 ms-1">Mobile Number</label>
                                                    <div class="input-group">
                                                        <span class="input-group-text bg-white-100 no-outline-green-focus border-1">+63</span>
                                                        <input 
                                                            type="text" 
                                                            id="mobile_number" 
                                                            name="mobile_number" 
                                                            class="form-control bg-white-100 no-outline-green-focus border-1" 
                                                            placeholder="Enter mobile number" 
                                                            maxlength="10"
                                                            pattern="[0-9]{10}" 
                                                            title="Enter your 10-digit Mobile Number" 
                                                            required
                                                            oninput="this.value = this.value.replace(/[^0-9]/g, '');">
                                                    </div>
                                                </div>

                                                <div class="col-md-4 mb-1"> <!-- fetch lang -->
                                                    <label for="email" class="text-muted small mb-2 ms-1">Email</label>
                                                    <input 
                                                        type="email" 
                                                        name="email" 
                                                        class="form-control bg-white-100 no-outline-green-focus border-1 w-100" 
                                                        placeholder="<?php echo $user['email'] ?>">
                                                </div>
                                            </div>

                                            <!-- location, nationality, and language -->
                                            <div class="row mt-3">
                                                <div class="col-md-4 mb-1"> <!-- fetch lang -->
                                                    <label for="city" class="text-muted small mb-2 ms-1">Location</label>
                                                    <input 
                                                        type="text" 
                                                        name="city" 
                                                        class="form-control bg-white-100 no-outline-green-focus border-1 w-100" 
                                                        placeholder="<?php echo $user['city'] ?>">
                                                </div>
                                                <div class="col-md-4 mb-1"> <!-- what if gamit API? -->
                                                    <label for="nationaility" class="text-muted small mb-2 ms-1">Nationality</label>
                                                    <input 
                                                        type="text" 
                                                        name="nationaility" 
                                                        class="form-control bg-white-100 no-outline-green-focus border-1 w-100" 
                                                        placeholder="Enter your Nationality">
                                                </div>
                                                <div class="col-md-4 mb-1"> <!-- what if gamit API? -->
                                                    <label for="language" class="text-muted small mb-2 ms-1">Language</label>
                                                    <input 
                                                        type="text"
                                                        name="language"
                                                        class="form-control bg-white-100 no-outline-green-focus border-1 w-100"
                                                        placeholder="Enter your Primary Language">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mt-3 ms-2 mb-3">
                                        <button class="btn btn-dark-green">
                                            <i class="fas fa-floppy-disk text-white me-2"></i><span>Save</span>
                                        </button>
                                    </div>
                                </div>

                                <!-- account settings: tab pane -->
                                <div class="tab-pane slide" id="pills-account" role="tabpanel" aria-labelledby="pills-account-tab">
                                    <div class="container pt-4 pb-2 mb-3">
                                        <h5 class="">Account Settings</h5>
                                        <h6 class="text-muted">Having trouble about security? Modify your account or Take a Break.</h6>
                                    </div>
                                    <div class="card p-3 mx-2 mb-3 bg-light border-start-accent card-outline">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6 mb-1"> 
                                                    <label for="change_password" class="text-muted small mb-2 ms-1">Change Password</label>
                                                    <div class="input-group">
                                                        <input 
                                                            type="password" 
                                                            name="change_password" 
                                                            id="change_password" 
                                                            class="form-control bg-white-100 no-outline-green-focus border-1">
                                                        <button 
                                                            type="button" 
                                                            id="togglePassword1" 
                                                            class="btn btn-white border rounded">
                                                            <span class="fas fa-eye text-green-50"></span>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="col-md-6 mb-1"> 
                                                    <label for="confirm_password" class="text-muted small mb-2 ms-1">Confirm Password</label>
                                                    <div class="input-group">
                                                        <input 
                                                            type="password" 
                                                            name="confirm_password" 
                                                            id="confirm_password" 
                                                            class="form-control bg-white-100 no-outline-green-focus border-1">
                                                        <button 
                                                            type="button" 
                                                            id="togglePassword2" 
                                                            class="btn btn-white border rounded">
                                                            <span class="fas fa-eye text-green-50"></span>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="mt-4 mb-4">
                                                <button class="btn btn-dark-green">
                                                    <i class="fas fa-floppy-disk text-white me-2"></i><span>Submit</span>
                                                </button>
                                            </div>
                                            <hr class="divider mt-4">
                                            <div class="mt-4">Thinking of leaving WorkWave? 
                                                <a href="deactivate_account.php" class="no-deco text-green-50 fw-bold">Take a Break</a> instead.
                                            </div>
                                        </div>
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