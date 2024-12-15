document.addEventListener('DOMContentLoaded', function() {
    const MAX_FILE_SIZE = 25 * 1024 * 1024;
    const urlParams = new URLSearchParams(window.location.search);
    const projectId = urlParams.get('id');

    const form = document.querySelector('form');

    document.querySelector('#fileInput').addEventListener('change', function() {
        const files = this.files;

        for(let file of files) {
            if(file.size > MAX_FILE_SIZE) {
                Swal.fire({
                    icon: 'error',
                    title: 'File Too Large',
                    text: 'Files must be less than 25MB'
                });
                this.value = '';
                return;
            }
        }

        if (files.length > 0) {
            document.querySelector('button[type="submit"]').disabled = false;
        }
    });

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const formData = new FormData();
        const fileInput = document.querySelector('#fileInput');
        
        for(let file of fileInput.files) {
            formData.append('project_files[]', file);
        }
        formData.append('project_id', projectId);

        fetch('../../dist/php/process/proc_submit_project_file.php', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                Swal.fire({
                    icon: 'success',
                    title: 'Files Uploaded',
                    text: 'Your files have been uploaded successfully'
                });
                
                const fileInput = document.querySelector('#fileInput');
                const submitButton = document.querySelector('button[type="submit"]');
                
                const rejectionAlert = document.querySelector('.alert-danger');
                if (rejectionAlert) {
                    rejectionAlert.remove();
                }
                
                const alertDiv = document.createElement('div');
                alertDiv.className = 'alert alert-info';
                alertDiv.textContent = 'Submitted file: ' + data.files[0].split('/').pop();
                fileInput.parentElement.insertBefore(alertDiv, fileInput);
                
                document.querySelector('.badge.bg-success.mb-2.extra-class').textContent = 'For Review';
                
                fileInput.disabled = true;
                submitButton.disabled = true;
                fileInput.value = '';
            }
        });
    });
});
