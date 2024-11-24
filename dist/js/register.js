// toggle password
const togglePassword1 = document.querySelector("#togglePassword1");
const password = document.querySelector("#password");

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

// Register phasing
let currentPhase = 1;
const totalPhases = 4;
const nextButton = document.getElementById("nextButton");
const backButton = document.getElementById("backButton");
const submitButton = document.getElementById("submitButton");
const agreeToTermsCheckbox = document.getElementById("agree_to_terms_and_conditions");
const form = document.getElementById("registrationForm");
const roleInputs = document.querySelectorAll('input[name="role"]'); // Role radio inputs

// Role validation function
function validateRoleSelection() {
    const selectedRole = document.querySelector('input[name="role"]:checked');
    if (!selectedRole) {
        alert("Please select a role (Client or Freelancer) to proceed.");
        return false;
    }
    return true;
}

nextButton.addEventListener("click", function () {
    if (currentPhase === 1 && !validateRoleSelection()) {
        // Prevent moving to the next phase if role is not selected
        return;
    }

    if (currentPhase < totalPhases) {
        // Hide current phase
        document.getElementById(`phase${currentPhase}`).style.display = "none";

        // Display next phase
        currentPhase++;
        document.getElementById(`phase${currentPhase}`).style.display = "block";

        updateProgressBar();

        // Update button visibility for the last phase
        if (currentPhase === totalPhases) {
            nextButton.style.display = "none";
            submitButton.style.display = "block";
        }
    } else {
        // Submit the form on the last phase
        form.submit();
    }
});

backButton.addEventListener("click", function () {
    if (currentPhase > 1) {
        // Hide current phase
        document.getElementById(`phase${currentPhase}`).style.display = "none";

        // Display previous phase
        currentPhase--;
        document.getElementById(`phase${currentPhase}`).style.display = "block";

        updateProgressBar();

        // Reset button visibility if moving away from the last phase
        if (currentPhase < totalPhases) {
            nextButton.style.display = "block";
            submitButton.style.display = "none";
        }
    } else {
        // If phase is 1, redirect to login.php
        window.location.href = "login.php";
    }
});

function updateProgressBar() {
    const progress = (currentPhase / totalPhases) * 100;
    document.getElementById("progress-bar").style.width = progress + "%";
}

// Enable or disable submit button based on agree-to-terms checkbox
agreeToTermsCheckbox.addEventListener("change", function () {
    submitButton.disabled = !this.checked;
});

// Initialize submit button state
submitButton.disabled = true;

// Add active toggle functionality for role buttons
roleInputs.forEach(input => {
    input.addEventListener("change", function () {
        const clientButton = document.getElementById("clientBtn");
        const freelancerButton = document.getElementById("freelancerBtn");

        if (this.id === "client") {
            clientButton.classList.add("bg-green-50", "border-green-50");

            clientButton.querySelectorAll(".text-green-50, div").forEach(el => {
                el.classList.add("text-white");
                el.classList.remove("text-green-50");
            });

            freelancerButton.classList.remove("bg-green-50", "border-green-50");
            freelancerButton.style.outline = "none";

            freelancerButton.querySelectorAll(".text-white, div").forEach(el => {
                el.classList.remove("text-white");
                el.classList.add("text-green-50");
            });
        } else if (this.id === "freelancer") {
            freelancerButton.classList.add("bg-green-50", "border-green-50");

            freelancerButton.querySelectorAll(".text-green-50, div").forEach(el => {
                el.classList.add("text-white");
                el.classList.remove("text-green-50");
            });

            clientButton.classList.remove("bg-green-50", "border-green-50");
            clientButton.style.outline = "none";

            clientButton.querySelectorAll(".text-white, div").forEach(el => {
                el.classList.remove("text-white");
                el.classList.add("text-green-50");
            });
        }
    });
});

