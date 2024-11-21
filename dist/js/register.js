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


// register phasing
let currentPhase = 1;
const totalPhases = 3;

document.getElementById("nextButton").addEventListener("click", function() {
    if (currentPhase < totalPhases) {
        // hide current phase
        document.getElementById(`phase${currentPhase}`).style.display = "none";
        
        // display next phasr
        currentPhase++;
        document.getElementById(`phase${currentPhase}`).style.display = "block";

        updateProgressBar();
    }
});

document.getElementById("backButton").addEventListener("click", function() {
    if (currentPhase > 1) {
        // hide current phase
        document.getElementById(`phase${currentPhase}`).style.display = "none";
        
        // display prev phase
        currentPhase--;
        document.getElementById(`phase${currentPhase}`).style.display = "block";

        updateProgressBar();
    }
});

function updateProgressBar() {
    const progress = (currentPhase / totalPhases) * 100;
    document.getElementById("progress-bar").style.width = progress + "%";
}
