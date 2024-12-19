<?php
    //PHPMailer library
    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\Exception;

    require '../../../vendor/autoload.php';

    $mysqli = require "../../../connection.php";

    //reset token generation
    $reset_token = random_int(100000, 999999);

    $stmt = $mysqli->prepare("CALL sp_update_reset_token(?, ?)");
    $stmt->bind_param("ss", $reset_token, $_POST["email"]);
    $stmt->execute();

    //sending email
    $mail = new PHPMailer(true);

    try {
        $mail->isHTML(true);                                 
        
        $mail->isSMTP();                                           
        $mail->Host       = 'smtp.gmail.com';                    
        $mail->SMTPAuth   = true;                                   
        $mail->Username   = 'workwavefpms@gmail.com';                     
        $mail->Password   = 'ohhc ilhr vcjw hcfu';                         
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;           
        $mail->Port       = 465;
    
        $mail->setFrom('workwavefpms@gmail.com', 'no-reply');
        $mail->addAddress($_POST["email"]);
        $mail->addReplyTo('no-reply@gmail.com', 'No Reply');
        $mail->Subject = 'Reset Password';
        
        session_start();
        $_SESSION['reset_email'] = $_POST["email"];
        $_SESSION['reset_token'] = $reset_token;

        $mail->Body = <<<END
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>WorkWave | Reset Password</title>
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
                    <p>You have requested to reset your password. Your OTP is: $reset_token</p>
                    <p>If you didn’t request a password reset, you can ignore this email.</p>
                    <p>Thank you,<br>WorkWave Team</p>
                </div>
                <div class="footer">
                    <p>WorkWave &copy; 2024</p>
                </div>
            </div>
        END;
    
        $mail->send();
        
        // Redirect to OTP verification
        header("Location: ../otp_verification.php");
        exit;
    } catch (mysqli_sql_exception $e) {
        die($e->getMessage());
    }