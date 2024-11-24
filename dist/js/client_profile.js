// toggle change password
const togglePassword1 = document.querySelector("#togglePassword1");
const password = document.querySelector("#change_password");

togglePassword1.addEventListener("click", function () {
    const type = password.getAttribute("type") === "password" ? "text" : "password";
    password.setAttribute("type", type);
    this.querySelector("span").classList.toggle("fa-eye");
    this.querySelector("span").classList.toggle("fa-eye-slash");
});

// toggle confirm password
const togglePassword2 = document.querySelector("#togglePassword2");
const confirmPassword = document.querySelector("#confirm_password");

togglePassword2.addEventListener("click", function () {
    const type = confirmPassword.getAttribute("type") === "password" ? "text" : "password";
    confirmPassword.setAttribute("type", type);
    this.querySelector("span").classList.toggle("fa-eye");
    this.querySelector("span").classList.toggle("fa-eye-slash");
});

document.addEventListener('DOMContentLoaded', function() {
    const profilePicInput = document.getElementById('profile-pic-input');
    const profilePicForm = document.getElementById('profile-pic-form');

    //event listenner for profile picture click
    document.querySelector('.profile-pic-wrapper').addEventListener('click', function() {
        profilePicInput.click();
    });

    //file input change event
    profilePicInput.addEventListener('change', function() {
        if (this.files && this.files[0]) {
            const formData = new FormData(profilePicForm);
            
            fetch('../../dist/php/process/update_profile_picture.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update profile picture preview
                    document.querySelector('.profile-pic').src = data.image_url;
                }
            });
        }
    });
});

// dynamic chev direction on collapse or expand
document.addEventListener("DOMContentLoaded", function () {
    const collapseElements = document.querySelectorAll(".collapse-section");

    collapseElements.forEach(collapseElement => {
        const toggleIcon = document.querySelector(`.icon-toggle[data-target="#${collapseElement.id}"]`);

        collapseElement.addEventListener("shown.bs.collapse", function () {
            toggleIcon.classList.remove("fa-chevron-down");
            toggleIcon.classList.add("fa-chevron-up");
        });

        collapseElement.addEventListener("hidden.bs.collapse", function () {
            toggleIcon.classList.remove("fa-chevron-up");
            toggleIcon.classList.add("fa-chevron-down");
        });
    });
});

// tooltio initializatiob
document.addEventListener("DOMContentLoaded", function () {
    // Initialize all tooltips on the page
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.forEach(function (tooltipTriggerEl) {
        new bootstrap.Tooltip(tooltipTriggerEl);
    });
});
