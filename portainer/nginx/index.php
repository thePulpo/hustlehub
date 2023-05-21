<?php
session_start();

// Step 1: Check if the user clicked the login button
if (isset($_GET['login'])) {
    // Step 2: Redirect the user to the OpenID provider's authentication page
    $openIdUrl = 'http://keycloak:8080/auth/realms/user/protocol/openid-connect/auth'; // Replace with your Keycloak realm URL
    $clientId = 'web'; // Replace with your Keycloak client ID
    $redirectUri = 'http://web/'; // Replace with your redirect URI
    $scope = 'openid email profile'; // Replace with the desired scope
    $state = bin2hex(random_bytes(16)); // Generate a random state value

    $_SESSION['openid_state'] = $state; // Store the state value in the session
    $authUrl = sprintf('%s?response_type=code&client_id=%s&redirect_uri=%s&scope=%s&state=%s',
        $openIdUrl,
        $clientId,
        $redirectUri,
        $scope,
        $state
    );

    header('Location: ' . $authUrl);
    exit;
}

// Step 3: Handle the callback from the OpenID provider
if (isset($_GET['code']) && isset($_GET['state'])) {
    // Verify the state value to prevent CSRF attacks
    if ($_GET['state'] === $_SESSION['openid_state']) {
        // Step 4: Exchange the authorization code for an access token
        $tokenUrl = 'http://keycloak:8080/auth/realms/user/protocol/openid-connect/token'; // Replace with your Keycloak realm token URL
        $clientId = 'web'; // Replace with your Keycloak client ID
        $clientSecret = 'c6915f5a-3224-49ee-b9ad-bd0dc9bc1306'; // Replace with your Keycloak client secret
        $redirectUri = 'http://web/'; // Replace with your redirect URI

        $postData = [
            'code' => $_GET['code'],
            'client_id' => $clientId,
            'client_secret' => $clientSecret,
            'redirect_uri' => $redirectUri,
            'grant_type' => 'authorization_code'
        ];

        $ch = curl_init($tokenUrl);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($postData));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($ch);
        curl_close($ch);

        // Step 5: Process the response and retrieve user information
        $accessToken = json_decode($response, true)['access_token'];

        $userInfoUrl = 'http://keycloak:8080/auth/realms/user/protocol/openid-connect/userinfo'; // Replace with your Keycloak realm user info endpoint

        $ch = curl_init($userInfoUrl);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Bearer ' . $accessToken]);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $userInfo = curl_exec($ch);
        curl_close($ch);

        // Step 6: Store and utilize the user information as needed
        $user = json_decode($userInfo, true);

        // Example: Display user information
        echo 'Welcome, ' . $user['name'] . '! Your email is ' . $user['email'];
    } else {
        echo 'Invalid state value. Possible CSRF attack.';
    }
} else {
    // Step 7: Display the login button if the user is not authenticated
    echo '<a href="?login">Login with OpenID</a>';
}
?>
