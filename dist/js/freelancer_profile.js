// pfp setting in freelancer profile
document.getElementById('uploadImage').addEventListener('change', function (event) {
    const reader = new FileReader();
    reader.onload = function () {
        const userIcon = document.getElementById('userIcon');
        userIcon.style.backgroundImage = `url(${reader.result})`;
        userIcon.style.backgroundSize = 'cover';
        userIcon.style.backgroundPosition = 'center';
        userIcon.style.width = '100px';  
        userIcon.style.height = '100px'; 
        userIcon.style.borderRadius = '50%';  
        userIcon.classList.remove('fa-circle-user');  
    };
    reader.readAsDataURL(event.target.files[0]);
});
