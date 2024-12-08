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