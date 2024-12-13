<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Register</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../css/custom.css">

    <!-- City Autocomplete js API-->
    <script src="../js/city_autocomplete.js"></script>

    <!-- register.js -->
    <script src="../js/register.js" defer></script>
</head>
<body>
<section class="container-fluid poppins vh-100 p-5 d-flex justify-content-center align-items-center">
    <div class="card p-5 rounded-5 shadow w-50">
        <!-- header -->
        <div class="container">
            <h1 class="fs-1 text-center text-green-70 fw-bold">Account Registration</h1>
            <h6 class="fs-6 text-center">Register to Continue with <span class="fw-bold text-green-60">WorkWave</span></h6>
        </div>

        <!-- form -->
        <form action="process/proc_register.php" method="POST" id="registrationForm">
        
        <!-- phase 1 -->
        <div id="phase1" class="mb-4">
            <!-- role -->
            <div class="container mt-4 mb-3">
                <div class="container text-center mb-3">Continue as...</div>
                <div class="d-flex justify-content-center align-items-center">
                    <label class="btn flex-grow-1 w-100 h-100 mx-1" id="clientBtn">
                        <input type="radio" name="role" value="1" id="client" required hidden>
                        <div class="fas fa-user-tie fa-2x me-2 mt-3 text-green-50"></div>
                        <div class="container mt-2 mb-3">Client</div>
                    </label>
                    <label class="btn flex-grow-1 w-100 h-100 mx-1" id="freelancerBtn">
                        <input type="radio" name="role" value="2" id="freelancer" required hidden>
                        <div class="fas fa-briefcase fa-2x me-2 mt-3 text-green-50"></div>
                        <div class="container mt-2 mb-3">Freelancer</div>
                    </label>
                </div>
            </div>
        </div>

        <!-- phase 2-->
        <div id="phase2" class="mb-4" style="display: none;">
            <!-- first name -->
            <div class="container mt-4 mb-3 ">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-user text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="text" name="first_name" id="first_name" class="form-control rounded-end-5 border px-3 py-2 no-outline" placeholder="First Name" required>
                </div>
            </div>
            <!-- last name -->
            <div class="container mb-2">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-user text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="text" name="last_name" id="last_name" class="form-control rounded-end-5 border px-3 py-2 no-outline" placeholder="Last Name" required>
                </div>
            </div>
        </div>

        <!-- phase 3 -->
        <div id="phase3" class="mb-4" style="display: none;">
            <!-- birthdate -->
            <div class="container mt-4 mb-3">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-calendar-alt text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="date" name="birthdate" id="birthdate" class="form-control rounded-end-5 border px-3 py-2 no-outline" required>
                </div>
            </div>
            <!-- gender -->
            <div class="container mb-3">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-mars-and-venus text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <select name="gender" id="gender" class="form-control rounded-end-5 border px-3 py-2 no-outline" required>
                        <option value="" disabled selected>Select Gender</option>
                        <option value="1">Male</option>
                        <option value="2">Female</option>
                        <option value="3">Prefer not to say</option>
                    </select>
                </div>
            </div>
            <!-- city -->
            <div class="container mb-2">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-location-dot text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="text" name="city" id="city" class="form-control rounded-end-5 border px-3 py-2 no-outline" placeholder="City" required>
                </div>
            </div>
        </div>

        <!-- phase 4 -->
        <div id="phase4" class="mb-4" style="display: none;">
            <!-- email -->
            <div class="container mt-4 mb-3">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-envelope text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="email" name="email" id="email" class="form-control rounded-end-5 border px-3 py-2 no-outline" placeholder="Email" required>
                </div>
            </div>
            <!-- password -->
            <div class="container mb-3">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-lock text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="password" name="password" id="password" class="form-control rounded-end-0 border px-3 py-2 no-outline" placeholder="Password" required>
                    <button type="button" id="togglePassword1" class="btn btn rounded-end-5 btn-outline-light border">
                        <span class="fas fa-eye text-green-50"></span>
                    </button>
                </div>
            </div>
            <!-- confirm password -->
            <div class="container mb-4">
                <div class="input-group my-1">
                    <div class="input-group-prepend d-flex align-items-stretch">
                        <div class="input-group-text bg-white rounded-start-5 d-flex justify-content-center align-items-center">
                            <span class="fas fa-lock text-green-50 ps-1"></span>
                        </div>
                    </div>
                    <input type="password" name="confirm_password" id="confirm_password" class="form-control rounded-end-0 border px-3 py-2 no-outline" placeholder="Confirm Password" required>
                    <button type="button" id="togglePassword2" class="btn btn rounded-end-5 btn-outline-light border">
                        <span class="fas fa-eye text-green-50"></span>
                    </button>
                </div>
            </div>
            <!-- terms and conditions -->
            <div class="container mb-4">
                <div class="form-check">
                    <input class="form-check-input custom-checkbox" type="checkbox" value="" id="agree_to_terms_and_conditions">
                    <label class="form-check-label" for="agree_to_terms_and_conditions">I agree to
                        <!-- trigger ng tc -->
                        <span type="button" class="text-green-60 fw-bold" data-bs-toggle="modal" data-bs-target="#exampleModal">Terms and Conditions</span>
                    </label>
                </div>
            </div>
            <!-- modal ng tc -->
            <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="tc_modal" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header bg-green-40 text-white">
                            <h5 class="modal-title" id="tc_modal">Terms and Conditions</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p class="container">terms and conditions bla bla bla</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- buttons -->
        <div class="container mb-4">
            <div class="row justify-content-center">
                <div class="col-6 d-flex justify-content-center">
                    <button type="button" id="backButton" class="btn btn-light-green fw-medium text-green-100 rounded-5 w-100">Back</button>
                </div>
                <div class="col-6 d-flex justify-content-center">
                    <button type="button" id="nextButton" class="btn btn-dark-green fw-medium flex-grow-1 flex-sm-grow-0 col-12 col-sm-5 rounded-5 w-100">Next</button>
                    <button type="submit" id="submitButton" class="btn btn-dark-green flex-grow-1 flex-sm-grow-0 col-12 col-sm-5 rounded-5 w-100" style="display:none">Submit</button>
                </div>
            </div>
        </div>

        <!-- progress bar -->
        <div class="progress mx-3">
            <div id="progress-bar" class="progress-bar bg-green-30" role="progressbar" style="width: 25%;" aria-valuemin="0" aria-valuemax="100"></div>
        </div>
    </div>

    <!-- end of form -->
    </form>

</section>

    <!-- google autocomplete api -->
    <script
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA8ps9u4llkxJ9vymRLuIFHt0t-Z8eF76U&libraries=places&callback=initAutocomplete"
        async
        defer>

<script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
<script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>
    </script>

</body>
</html>