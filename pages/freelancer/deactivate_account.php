<?php 
session_start();
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Deactivate Account</title>
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
    <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
    <script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>
</head>
<body>
    <!-- modify ko pa to into something more useful like survey as to bakit sha maga leave or take ng break si freelancer
    pero ganto2 muna sa ngayon since di naman to main function HAHAHAHAHAHA -->
    <section class="container-fluid poppins">
        <div class="container">
            <!-- Profile Header -->
            <div class="row mt-4 align-items-center">
                <!-- Profile Title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start">Deactivate Account</h2>
                </div>

                <!-- Breadcrumb Navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Deactivate Account</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <!-- Deactivate Account Module -->
            <div class="col-12 pt-3">
                <div class="card shadow pt-2 pb-4 border-0">
                    <div class="card-body">
                        <div class="container d-flex flex-column align-items-center text-center">
                            <h4 class="text-green-40 mt-2 fw-bold">We're sad to see you go</h4>
                            <p class="text-muted mb-4">Let us know how long you will be gone</p>
                            <!-- Deactivation Duration Selection -->
                            <div class="mb-3 w-50">
                            <form action="../../dist/php/process/proc_deactivate_account.php" method="POST">
                                <select 
                                    name="deactivationDuration" 
                                    id="deactivationDuration" 
                                    class="form-select bg-white-100 no-outline-green-focus border-1" 
                                    required>
                                    <option value="" disabled selected>Select Duration</option>
                                    <option value="1_week">1 Week</option>
                                    <option value="1_month">1 Month</option>
                                    <option value="indefinite">Indefinite</option>
                                </select>
                            </div>

                            <p class="text-muted small fst-italic mb-4">Logging back in will automatically activate your account</p>

                            <button 
                                type="submit" 
                                class="btn btn-dark-green px-4 py-2">
                                Confirm Deactivation
                            </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>


        </div>
    </section>
</body>