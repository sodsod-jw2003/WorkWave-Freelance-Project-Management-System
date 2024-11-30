document.addEventListener("DOMContentLoaded", function() {
    var currentFile = window.location.pathname.split('/').pop();

    console.log("Current file:", currentFile);

    var links = document.querySelectorAll('.nav-link');

    links.forEach(function(link) {
        var linkHref = link.getAttribute('href');

        if (linkHref === currentFile) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });
});

    // JavaScript for toggling heart icon
    document.getElementById("heart-btn").addEventListener("click", function () {
        const icon = document.getElementById("heart-icon"); // Target icon using ID
        icon.classList.toggle("far"); // Outline heart
        icon.classList.toggle("fas"); // Filled heart
    });