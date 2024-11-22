    <?php
    //PHPMailer library
    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\Exception;

    require '../../../vendor/autoload.php';

    $mysqli = require "../../../connection.php";

    //email validation
    $email = $_POST["email"];

    $stmt = $mysqli->prepare("CALL get_user_by_email(?)");
    $stmt->bind_param("s", $email);
    $stmt->execute();

    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    if ($user >0){
        die("This Email is already registered. Please use a different email.");
    }
    
    // Backend validation for the age
    if (empty($_POST["birthdate"])) {
    die("Birthdate is required");
    }

    $birthdate = $_POST["birthdate"];
    $birthdate = new DateTime($birthdate);
    $currentDate = new DateTime();

    // Calculate the age by finding the difference between the current date and the birthdate
    $age = $currentDate->diff($birthdate)->y;

    // If the user is under 18, show an error
    if ($age < 18 || ($age == 18 && $currentDate->format('m-d') < $birthdate->format('m-d'))) {
        die("You must be at least 18 years old to register.");
    }

    //validations backend

    $stmt = $mysqli->prepare("CALL get_user_by_email(?)");
    $stmt->bind_param("s", $email);
    $stmt->execute();

    $result = $stmt->get_result();
    $user = $result->fetch_assoc();
    
    if ($user > 0) {
        die("This email is already registered. Please use a different email.");
    }
    
    //validations backend
    if (empty($_POST["role"])) {
        die("role is required");
    }

    if (empty($_POST["first_name"])) {
        die("Firstname is required");
    }
    if (empty($_POST["last_name"])) {
        die("Lastname is required");
    }

    if (empty($_POST["birthdate"])) {
        die("Birthdate is required");
    }

    if (empty($_POST["gender"])) {
        die("gender is required");
    }

    if (empty($_POST["city"])) {
        die("city is required");
    }
    

    if ( ! filter_var($_POST["email"], FILTER_VALIDATE_EMAIL)) {
        die("Valid email is required");
    }

    if (strlen($_POST["password"]) < 8) {
        die("Password must be at least 8 characters");
    }

    if ( ! preg_match("/[a-z]/i", $_POST["password"])) {
        die("Password must contain at least one letter");
    }

    if ( ! preg_match("/[0-9]/", $_POST["password"])) {
        die("Password must contain at least one number");
    }

    if ($_POST["password"] !== $_POST["confirm_password"]) {
        die("Passwords must match");
    }

    //password hashing
    $password_hash = password_hash($_POST["password"], PASSWORD_DEFAULT);

    //activation token
    $activation_token = bin2hex(random_bytes(16));
    $activation_token_hash = password_hash($activation_token, PASSWORD_DEFAULT);

    //inserting users to database
    $sql = "CALL signup_users(?, ?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt = $mysqli->stmt_init();

    if ( ! $stmt->prepare($sql)) {
        die("SQL error: " . $mysqli->error);
    }

    $stmt->bind_param("sssssssss",
                    $_POST["first_name"],
                    $_POST["last_name"],
                    $_POST["birthdate"],
                    $_POST["gender"],
                    $_POST["city"],
                    $_POST["email"],
                    $password_hash,
                    $activation_token_hash,
                    $_POST["role"]);
                    
    $stmt->execute();

    //sending email
    $mail = new PHPMailer(true);
    try {
        $mail->isHTML(true);                                  //Set email format to HTML;
        
        $mail->isSMTP();                                            //Send using SMTP
        $mail->Host       = 'smtp.gmail.com';                     //Set the SMTP server to send through
        $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
        $mail->Username   = 'workwavefpms@gmail.com';                     //SMTP username
        $mail->Password   = 'ohhc ilhr vcjw hcfu';                               //SMTP password
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
        $mail->Port       = 465;
    
        $mail->setFrom('workwavefpms@gmail.com', 'no-reply');
        $mail->addAddress($_POST["email"]);
        $mail->addReplyTo('no-reply@gmail.com', 'No Reply');
        $mail->Subject = 'Activation Link';
        $mail->Body    = <<<END
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>WorkWave | Activate Activate Account</title>
            <style>         
                body {
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 0;
                    background-color: #f4f7f6;
                    color: #212529;
                }
                .container {
                    max-width: 600px;
                    margin: 50px auto;
                    padding: 20px;
                    background: #ffffff;
                    border-radius: 10px;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                    border: 2px solid #e3e6e5;
                }
                .header {
                    text-align: center;
                    margin-bottom: 20px;
                }
                .header h1 {
                    color: #3a743a;
                    font-weight: 600;
                }
                .content {
                    text-align: center;
                    line-height: 1.5;
                    font-size: 16px;
                    color: #495057;
                }
                .content p {
                    color: #495057;
                    margin: 10px 0;
                }
                .btn {
                    display: inline-block;
                    margin-top: 20px;
                    padding: 12px 24px;
                    font-size: 16px;
                    font-weight: 600;
                    color: #ffffff;
                    background-color: #3a743a;
                    text-decoration: none;
                    border-radius: 6px;
                    border: none;
                }
                .btn:hover {
                    background-color: #2c5b2c;
                }
                .footer {
                    text-align: center;
                    margin-top: 30px;
                    font-size: 14px;
                    color: #adb5bd;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>Reset Your Password</h1>
                </div>
                <div class="content">
                    <p>Hello,</p>
                    <p>To Activate your account. Click the button below.</p>
                    <form action="http://localhost/workwave/dist/php/process/proc_account_activation.php" method="GET">
                        <input type="hidden" name="token" value="$activation_token_hash">
                        <input type="submit" value="Activate Account" class="btn">
                    </form>
                    <p>If you didn’t register, you can ignore this email.</p>
                    <p>Thank you,<br>WorkWave Team</p>
                </div>
                <div class="footer">
                    <p>WorkWave &copy; 2024</p>
                </div>
            </div>
        </body>
        </html>
        END;
    
        $mail->send();
        echo "<script type='text/javascript'>
        alert('A activation link has been sent to your email. Please check your inbox.');
        window.location.href = '../login.php';  // Redirect to login page
        </script>";
        exit;
    } catch (mysqli_sql_exception $e) {
        die($e->getMessage());
    }