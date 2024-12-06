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
    document.addEventListener("DOMContentLoaded", function() {
        // Get all heart buttons
        const heartButtons = document.querySelectorAll('.heart-btn');
        
        // Add click handler to each button
        heartButtons.forEach(button => {
            button.addEventListener("click", function() {
                const icon = this.querySelector('.heart-icon');
                icon.classList.toggle("far");
                icon.classList.toggle("fas");
            });
        });
    });