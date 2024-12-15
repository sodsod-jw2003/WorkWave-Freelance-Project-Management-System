<?php
// include ('/misc/modals.php');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">
</head>
<body class="poppins">
    <header class="bg-none">
        <?php include ('header.php') ?>
    </header>
    <main class="bg-green-20">
        <!-- Hero Section -->
        <section class="hero-section">

            <div class="hero-content">
                <h1 class="hero-title text-start">WorkWave</h1>
                <p class="hero-text text-start"> </p>
                <a href="#learn-more" class="hero-btn">Learn More</a>
            </div>
            <div class="hero-video">
                <video autoplay loop muted playsinline>
                    <source src="/dist/php/uploads/vid/hero_vid.mp4" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
            </div>
        </section>
    </main>
    <footer class="bg-green-10">
        .
    </footer>
</body>
</html>