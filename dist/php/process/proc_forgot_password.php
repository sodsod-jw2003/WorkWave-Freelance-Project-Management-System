<?php
    //PHPMailer library
    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\Exception;

    require '../../../vendor/autoload.php';

    $mysqli = require "../../../connection.php";

    //reset token generation
    $reset_token = bin2hex(random_bytes(16));
    $reset_token_hash = hash("sha256", $reset_token);

    $stmt = $mysqli->prepare("CALL sp_update_reset_token(?, ?)");
    $stmt->bind_param("ss", $reset_token_hash, $_POST["email"]);
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
        $mail->Subject = 'Reset Password';
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
                    <p>You have requested to reset your password. Click the button below to reset it:</p>
                    <form action="http://localhost/workwave/dist/php/reset_password.php" method="GET">
                        <input type="hidden" name="token" value="$reset_token_hash">
                        <input type="submit" value="Reset Password" class="btn">
                    </form>
                    <p>If you didn’t request a password reset, you can ignore this email.</p>
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
        alert('A reset link has been sent to your email. Please check your inbox.');
        window.location.href = '../login.php';  // Redirect to login page
        </script>";
        exit;
    } catch (mysqli_sql_exception $e) {
        die($e->getMessage());
    }