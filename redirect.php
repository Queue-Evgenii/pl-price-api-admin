<?php
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Redirecting...</title>
    <script>
        // Clear the hash first, then redirect
        window.location.hash = '';
        setTimeout(function() {
            window.location.href = 'https://polandgroup.pl/#/pl/categories';
        }, 100);
    </script>
</head>
<body>
    <p>Redirecting...</p>
</body>
</html>
