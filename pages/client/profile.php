<?php
session_start();
$mysqli1 = require ('../../connection.php');
$mysqli2 = require ('../../connection.php');
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

//jobs query
$query = "CALL sp_get_job";
$result = mysqli_query($mysqli1, $query);

//skills query
$skills_query = "CALL sp_get_skills";
$skills_result = mysqli_query($mysqli2, $skills_query);

$skills_by_category = [];
while ($row = mysqli_fetch_assoc($skills_result)) {
    $skills_by_category[$row['skill_category']][] = $row;
}

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

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- maps API -->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA8ps9u4llkxJ9vymRLuIFHt0t-Z8eF76U&libraries=places"></script>
</head>
<body>
    
    <section class="container-fluid poppins">
        <div class="container">
            <!-- profile header -->
            <div class="row mt-4 align-items-center bg-danger">
                <!-- profile title -->
                <div class="col-12 col-md-6">
                    
                </div>

                <!-- breadcrumb navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Profile</li>
                        </ol>
                    </nav>
                </div>
                <!-- /breadcrumb navigation -->
            </div>
            <!-- /profile header -->

            <!-- Profile Content -->
            <div class="row">
                <!-- Sidebar/Profile Card -->
                <div class="col-12 col-md-4 col-lg-3 p-3 bg-danger">
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

                    <!-- sidebar: project history -->
                    <div class="card card-primary card-outline shadow border-0 mb-4">
                        <!-- project history: collapsible header -->
                        <div class="card-header bg-green-30 p-3">
                            <a class="d-flex align-items-center text-decoration-none toggle-icon"
                            data-bs-toggle="collapse" 
                            href="#projectHistoryCollapse" 
                            role="button" 
                            aria-expanded="true" 
                            aria-controls="projectHistoryCollapse">

                                <i class="fa-solid fa-briefcase text-white mx-1"></i>
                                <div class="text-white p-1 d-inline">Project History</div>
                                <i class="fa-solid fa-chevron-down text-white ms-auto pe-1 icon-toggle"></i>
                            </a>
                        </div>
                        <!-- project history: collapsible content -->
                        <div id="projectHistoryCollapse" class="collapse-section collapse show">
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="text-muted fw-semibold text-green-60">Project Title</div>
                                    <div class="text-muted small">Project Category</div>
                                    <div class="text-muted small d-inline ">Project Status</div>
                                </div>
                                <hr class="divider">
                            </div>
                        </div>
                    </div>

                    <!-- sidebar: freelancers -->
                    <div class="card card-primary card-outline shadow border-0 mb-4">
                        <!-- freelancers: collapsible header -->
                        <div class="card-header bg-green-30 p-3">
                            <a  class="d-flex align-items-center text-decoration-none"
                                data-bs-toggle="collapse" 
                                href="#freelancersCollapse" 
                                role="button" 
                                aria-expanded="true" 
                                aria-controls="freelancersCollapse">

                                <i class="fa-solid fa-user text-white mx-1"></i>
                                <div class="text-white p-1 d-inline">Freelancers</div>
                                <i class="fa-solid fa-chevron-down text-white ms-auto pe-1"></i>
                            </a>
                        </div>
                        <!-- skills: collapsible content -->
                        <div id="freelancersCollapse" class="collapse-section collapse show">
                            <div class="card-body">

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
                                    <div class="text-muted small"><?php echo $user['nationality'] ?></div>
                                </div>
                                <hr class="divider">
                                <div class="">
                                    <span class="fas fa-language me-1 text-green-60"></span>
                                    <span class="text-muted fw-semibold text-green-60">Language</span>
                                    <div class="text-muted small"><?php echo $user['language'] ?></div>
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
                                    <div class="container d-flex justify-content-end align-items-end mb-3 pe-2">
                                        <button id="addProject" class="btn btn-dark-green">
                                            <i class="fas fa-plus me-2"></i>Add Project
                                        </button>
                                    </div>

                                    <div id="projectContainer" class="mb-0">
                                        <!-- projects will be loaded here dynamically -->
                                    </div>
                                    
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
                                        <form id="personalInfoForm">
                                            <!-- fname, lname, and job title -->
                                            <form id="personalInfoForm">
                                                <div class="row">
                                                    <div class="col-md-4 mb-1">
                                                        <label for="first_name" class="text-muted small mb-2 ms-1">First Name</label>
                                                        <input type="text" name="first_name" id="first_name" class="form-control bg-white-100 no-outline-green-focus border-1" value="<?php echo htmlspecialchars($user['first_name']); ?>">
                                                    </div>
                                                    <div class="col-md-4 mb-1">
                                                        <label for="last_name" class="text-muted small mb-2 ms-1">Last Name</label>
                                                        <input type="text" name="last_name" id="last_name" class="form-control bg-white-100 no-outline-green-focus border-1" value="<?php echo htmlspecialchars($user['last_name']); ?>">
                                                    </div>
                                                    <div class="col-md-4 mb-1">
                                                        <label for="job_title" class="text-muted small mb-2 ms-1">Job Title</label>
                                                        <select 
                                                        name="job_title" 
                                                        id="job_title" 
                                                        class="form-select bg-white-100 no-outline-green-focus border-1 w-100">
                                                        <!-- Show the current selected job title as selected -->
                                                        <?php
                                                        echo '<option value="' . $user['job_title_id'] . '" selected>' . $user['job_title'] . '</option>'; // Default selected
                                                        // Populate dropdown with other job titles from the database
                                                        while ($row = mysqli_fetch_assoc($result)) {
                                                            if ($row['job_title_id'] !== $user['job_title_id']) { // Skip the already selected job title
                                                                echo '<option value="' . $row['job_title_id'] . '">' . $row['job_title'] . '</option>';
                                                            }
                                                        }
                                                        ?>
                                                    </select>
                                                    </div>
                                                </div>

                                                <div class="row mt-3">
                                                    <div class="col-md-4 mb-1">
                                                        <label for="gender" class="text-muted small mb-2 ms-1">Gender</label>
                                                        <select name="gender" id="gender" class="form-select bg-white-100 no-outline-green-focus border-1">
                                                            <option value="Male" <?php echo $user['gender'] == 'Male' ? 'selected' : ''; ?>>Male</option>
                                                            <option value="Female" <?php echo $user['gender'] == 'Female' ? 'selected' : ''; ?>>Female</option>
                                                            <option value="Prefer not to say" <?php echo $user['gender'] == 'Prefer not to say' ? 'selected' : ''; ?>>Prefer not to say</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-4 mb-1">
                                                        <label for="mobile_number" class="text-muted small mb-2 ms-1">Mobile Number</label>
                                                        <div class="input-group">
                                                        <span class="input-group-text bg-white-100 no-outline-green-focus border-1">+63</span>
                                                        <input type="text" name="mobile_number" id="mobile_number" class="form-control bg-white-100 no-outline-green-focus border-1" value="<?php echo htmlspecialchars($user['mobile_number']); ?>">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4 mb-1">
                                                        <label for="email" class="text-muted small mb-2 ms-1">Email</label>
                                                        <input type="email" name="email" id="email" class="form-control bg-white-100 no-outline-green-focus border-1" value="<?php echo htmlspecialchars($user['email']); ?>">
                                                    </div>
                                                </div>

                                                <div class="row mt-3">
                                                    <div class="col-md-4 mb-1">
                                                        <label for="city" class="text-muted small mb-2 ms-1">Location</label>
                                                        <input type="text" name="city" id="city" class="form-control bg-white-100 no-outline-green-focus border-1" value="<?php echo htmlspecialchars($user['city']); ?>">
                                                    </div>
                                                    <div class="col-md-4 mb-1">
                                                        <label for="nationality" class="text-muted small mb-2 ms-1">Nationality</label>
                                                        <input 
                                                            id="nationality" 
                                                            type="text"
                                                            name="nationality"
                                                            class="form-control bg-white-100 no-outline-green-focus border-1 w-100"
                                                            placeholder="Enter your Nationality"
                                                            value="<?php echo $user['nationality'] ?>"
                                                            list="nationalities">
                                                        <datalist id="nationalities"></datalist>
                                                    </div>
                                                    <div class="col-md-4 mb-1">
                                                        <label for="language" class="text-muted small mb-2 ms-1">Language</label>
                                                        <input 
                                                            id="language" 
                                                            type="text" 
                                                            name="language" 
                                                            class="form-control bg-white-100 no-outline-green-focus border-1 w-100" 
                                                            placeholder="Enter your Primary Language"
                                                            value="<?php echo $user['language'] ?>"
                                                            list="languages">
                                                        <datalist id="languages"></datalist>
                                                    </div>
                                                </div>
                                                <div class="mt-3 mb-3">
                                                    <button type="submit" class="btn btn-dark-green">
                                                        <i class="fas fa-floppy-disk text-white me-2"></i>Save Changes
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
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
                                        <form id="passwordChangeForm">
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
                                            </form>
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