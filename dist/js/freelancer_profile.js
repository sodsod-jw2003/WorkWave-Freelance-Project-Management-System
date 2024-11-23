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